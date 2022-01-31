/*******************************************************************************
 * Copyright (c) 2022 CEA
 * This program and the accompanying materials are made available under the
 * terms of the Eclipse Public License 2.0 which is available at
 * http://www.eclipse.org/legal/epl-2.0.
 *
 * SPDX-License-Identifier: EPL-2.0
 * Contributors: see AUTHORS file
 *******************************************************************************/
package fr.cea.nablab.sirius.web.app.services;

import fr.cea.nabla.ir.ir.IrModule;
import fr.cea.nabla.ir.ir.IrRoot;
import fr.cea.nabla.ir.ir.JobCaller;
import fr.cea.nabla.ir.ir.util.IrResourceImpl;
import fr.cea.nablab.sirius.web.app.services.api.IEditingContextService;
import fr.cea.nablab.sirius.web.app.services.api.IModelService;
import fr.cea.nablab.sirius.web.app.services.api.UploadModelInput;
import fr.cea.nablab.sirius.web.app.services.api.UploadModelSuccessPayload;

import java.io.ByteArrayInputStream;
import java.io.IOException;
import java.util.Map;
import java.util.Objects;
import java.util.Optional;
import java.util.UUID;
import java.util.concurrent.ConcurrentHashMap;

import org.eclipse.emf.common.util.URI;
import org.eclipse.emf.ecore.EObject;
import org.eclipse.sirius.components.collaborative.api.IRepresentationPersistenceService;
import org.eclipse.sirius.components.collaborative.diagrams.api.IDiagramCreationService;
import org.eclipse.sirius.components.collaborative.diagrams.messages.ICollaborativeDiagramMessageService;
import org.eclipse.sirius.components.core.api.ErrorPayload;
import org.eclipse.sirius.components.core.api.IEditingContext;
import org.eclipse.sirius.components.core.api.IPayload;
import org.eclipse.sirius.components.core.api.IRepresentationDescriptionSearchService;
import org.eclipse.sirius.components.diagrams.Diagram;
import org.eclipse.sirius.components.diagrams.description.DiagramDescription;
import org.eclipse.sirius.components.emf.services.EObjectIDManager;
import org.springframework.stereotype.Service;

/**
 * @author arichard
 */
@Service
public class ModelService implements IModelService {

    private final IRepresentationDescriptionSearchService representationDescriptionSearchService;

    private final IRepresentationPersistenceService representationPersistenceService;

    private final IDiagramCreationService diagramCreationService;

    private final ICollaborativeDiagramMessageService messageService;

    private final Map<String, EObject> models = new ConcurrentHashMap<>();

    private final IEditingContextService editingContextService;

    public ModelService(IRepresentationDescriptionSearchService representationDescriptionSearchService, IRepresentationPersistenceService representationPersistenceService,
            IDiagramCreationService diagramCreationService, IEditingContextService editingContextService, ICollaborativeDiagramMessageService messageService) {
        this.representationDescriptionSearchService = Objects.requireNonNull(representationDescriptionSearchService);
        this.representationPersistenceService = Objects.requireNonNull(representationPersistenceService);
        this.diagramCreationService = Objects.requireNonNull(diagramCreationService);
        this.editingContextService = Objects.requireNonNull(editingContextService);
        this.messageService = Objects.requireNonNull(messageService);
    }

    @Override
    public boolean existsById(String modelId) {
        return this.models.containsKey(modelId);
    }

    @Override
    public IPayload uploadModel(UploadModelInput input) {
        String message = this.messageService.invalidInput(input.getClass().getSimpleName(), UploadModelInput.class.getSimpleName());
        IPayload payload = new ErrorPayload(input.getId(), message);

        EObjectIDManager idManager = new EObjectIDManager();
        var modelAsString = input.getModel();
        byte[] decode = java.util.Base64.getDecoder().decode(modelAsString);
        ByteArrayInputStream inputStream = new ByteArrayInputStream(decode);
        var irResource = new IrResourceImpl(URI.createURI("inmemory")); //$NON-NLS-1$
        try {
            irResource.doLoad(inputStream, Map.of());
        } catch (IOException e) {
            e.printStackTrace();
        }

        var irRoot = (IrRoot) irResource.getContents().get(0);
        idManager.setId(irRoot, idManager.getOrCreateId(irRoot));
        irRoot.eAllContents().forEachRemaining(eObject -> idManager.setId(eObject, idManager.getOrCreateId(eObject)));

        IEditingContext editingContext = this.editingContextService.createEditingContext(input.getId().toString());
        this.models.put(editingContext.getId(), irRoot);
        this.editingContextService.addModel(editingContext.getId(), irRoot);

        // @formatter:off
        Optional<DiagramDescription> optionalDiagramDescription = this.representationDescriptionSearchService.findById(editingContext, UUID.fromString("7a08b478-2284-36b2-8e00-b5d3cdeaaaa5")) //$NON-NLS-1$
                .filter(DiagramDescription.class::isInstance)
                .map(DiagramDescription.class::cast);
        // @formatter:on

        if (optionalDiagramDescription.isPresent()) {
            DiagramDescription diagramDescription = optionalDiagramDescription.get();

            JobCaller jobCaller = irRoot.getMain();
            String diagramLabel = "Jobs Graph"; //$NON-NLS-1$
            if (jobCaller instanceof IrModule) {
                diagramLabel = ((IrModule) jobCaller).getName();
            }

            Diagram diagram = this.diagramCreationService.create(diagramLabel, jobCaller, diagramDescription, editingContext);

            this.representationPersistenceService.save(editingContext, diagram);

            payload = new UploadModelSuccessPayload(input.getId(), diagram);
        }

        return payload;
    }
}
