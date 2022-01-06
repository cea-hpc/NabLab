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

import fr.cea.nabla.ir.ir.IrFactory;
import fr.cea.nabla.ir.ir.IrRoot;
import fr.cea.nablab.sirius.web.app.services.api.IEditingContextService;
import fr.cea.nablab.sirius.web.app.services.api.IModelService;
import fr.cea.nablab.sirius.web.app.services.api.UploadModelInput;
import fr.cea.nablab.sirius.web.app.services.api.UploadModelSuccessPayload;

import java.util.Map;
import java.util.Objects;
import java.util.Optional;
import java.util.UUID;
import java.util.concurrent.ConcurrentHashMap;

import org.eclipse.sirius.web.core.api.ErrorPayload;
import org.eclipse.sirius.web.core.api.IEditingContext;
import org.eclipse.sirius.web.core.api.IPayload;
import org.eclipse.sirius.web.core.api.IRepresentationDescriptionSearchService;
import org.eclipse.sirius.web.diagrams.Diagram;
import org.eclipse.sirius.web.diagrams.description.DiagramDescription;
import org.eclipse.sirius.web.emf.services.EObjectIDManager;
import org.eclipse.sirius.web.spring.collaborative.api.IRepresentationPersistenceService;
import org.eclipse.sirius.web.spring.collaborative.diagrams.api.IDiagramCreationService;
import org.eclipse.sirius.web.spring.collaborative.diagrams.messages.ICollaborativeDiagramMessageService;
import org.eclipse.sirius.web.spring.collaborative.dto.CreateRepresentationInput;
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

    private final Map<String, IrRoot> models = new ConcurrentHashMap<>();

    private IEditingContextService editingContextService;

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
        String message = this.messageService.invalidInput(input.getClass().getSimpleName(), CreateRepresentationInput.class.getSimpleName());
        IPayload payload = new ErrorPayload(input.getId(), message);

        EObjectIDManager idManager = new EObjectIDManager();
        var irRoot = IrFactory.eINSTANCE.createIrRoot();
        irRoot.setName("ExplicitHeatEquation"); //$NON-NLS-1$
        idManager.setId(irRoot, idManager.getOrCreateId(irRoot));
        var irModule = IrFactory.eINSTANCE.createIrModule();
        idManager.setId(irModule, idManager.getOrCreateId(irModule));
        irModule.setName("explicitHeatEquation"); //$NON-NLS-1$
        irModule.setMain(true);
        var job = IrFactory.eINSTANCE.createJob();
        idManager.setId(job, idManager.getOrCreateId(job));
        job.setName("ComputeFaceLength"); //$NON-NLS-1$
        job.setAt(1.0);
        var jobCaller = IrFactory.eINSTANCE.createJobCaller();
        idManager.setId(jobCaller, idManager.getOrCreateId(jobCaller));

        irModule.getJobs().add(job);
        jobCaller.getCalls().add(job);
        irRoot.getModules().add(irModule);
        irRoot.setMain(jobCaller);

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

            Diagram diagram = this.diagramCreationService.create("explicitHeatEquation", jobCaller, diagramDescription, editingContext); //$NON-NLS-1$

            this.representationPersistenceService.save(editingContext, diagram);

            payload = new UploadModelSuccessPayload(input.getId(), diagram);
        }

        return payload;
    }
}
