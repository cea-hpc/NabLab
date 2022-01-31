/*******************************************************************************
 * Copyright (c) 2022 CEA
 * This program and the accompanying materials are made available under the
 * terms of the Eclipse Public License 2.0 which is available at
 * http://www.eclipse.org/legal/epl-2.0.
 *
 * SPDX-License-Identifier: EPL-2.0
 * Contributors: see AUTHORS file
 *******************************************************************************/
package fr.cea.nablab.sirius.web.app.services.representations;

import fr.cea.nabla.ir.ir.Job;
import fr.cea.nablab.sirius.web.app.services.IDParser;
import fr.cea.nablab.sirius.web.app.services.api.IEditingContextService;
import fr.cea.nablab.sirius.web.app.services.api.IRepresentationService;

import java.util.List;
import java.util.Map;
import java.util.Objects;
import java.util.Optional;
import java.util.UUID;
import java.util.concurrent.ConcurrentHashMap;

import org.eclipse.sirius.components.collaborative.api.IRepresentationPersistenceService;
import org.eclipse.sirius.components.collaborative.api.IRepresentationSearchService;
import org.eclipse.sirius.components.core.api.IEditingContext;
import org.eclipse.sirius.components.core.api.IObjectService;
import org.eclipse.sirius.components.core.api.IRepresentationDescriptionSearchService;
import org.eclipse.sirius.components.diagrams.Diagram;
import org.eclipse.sirius.components.diagrams.Position;
import org.eclipse.sirius.components.diagrams.Size;
import org.eclipse.sirius.components.diagrams.description.DiagramDescription;
import org.eclipse.sirius.components.representations.IRepresentation;
import org.eclipse.sirius.components.representations.ISemanticRepresentation;
import org.springframework.stereotype.Service;

/**
 * Mandatory service. Do not remove.
 *
 * @author arichard
 */
@Service
public class RepresentationService implements IRepresentationPersistenceService, IRepresentationSearchService, IRepresentationService {

    private final IRepresentationDescriptionSearchService representationDescriptionSearchService;

    private final IEditingContextService editingContextService;

    private final IObjectService objectService;

    private final Map<String, IRepresentation> representations = new ConcurrentHashMap<>();

    public RepresentationService(IRepresentationDescriptionSearchService representationDescriptionSearchService, IEditingContextService editingContextService, IObjectService objectService) {
        this.representationDescriptionSearchService = Objects.requireNonNull(representationDescriptionSearchService);
        this.editingContextService = Objects.requireNonNull(editingContextService);
        this.objectService = Objects.requireNonNull(objectService);
    }

    @Override
    public void save(IEditingContext editingContext, ISemanticRepresentation representation) {
        this.representations.put(representation.getId(), representation);
    }

    @Override
    public <T extends IRepresentation> Optional<T> findById(IEditingContext editingContext, String representationId, Class<T> representationClass) {
        String volatileRepresentation = "volatileRepresentation"; //$NON-NLS-1$
        if (representationId.startsWith(volatileRepresentation)) {
            String targetObjectId = representationId.substring(23);

            // @formatter:off
            Optional<T> existingDiagram =  this.representations.values().stream()
                .filter(Diagram.class::isInstance)
                .map(Diagram.class::cast)
                .filter(d -> d.getTargetObjectId().equals(targetObjectId))
                .filter(representationClass::isInstance)
                .map(representationClass::cast)
                .findFirst();
            if (existingDiagram.isPresent()) {
                return existingDiagram;
            }

            Optional<Object> optionalTargetObject = this.objectService.getObject(editingContext, targetObjectId);
            Optional<DiagramDescription> optionalDiagramDescription = this.representationDescriptionSearchService.findById(editingContext, UUID.fromString("7a08b478-2284-36b2-8e00-b5d3cdeaaaa5")) //$NON-NLS-1$
                    .filter(DiagramDescription.class::isInstance)
                    .map(DiagramDescription.class::cast);
            // @formatter:on

            if (optionalTargetObject.isPresent() && optionalDiagramDescription.isPresent()) {
                DiagramDescription diagramDescription = optionalDiagramDescription.get();

                String diagramLabel = "Jobs Graph"; //$NON-NLS-1$
                if (optionalTargetObject.get() instanceof Job) {
                    diagramLabel = ((Job) optionalTargetObject.get()).getName();
                }

                // @formatter:off
                representationId = UUID.randomUUID().toString();
                Diagram diagram = Diagram.newDiagram(representationId)
                    .label(diagramLabel)
                    .targetObjectId(targetObjectId)
                    .descriptionId(diagramDescription.getId())
                    .position(Position.UNDEFINED)
                    .size(Size.UNDEFINED)
                    .nodes(List.of())
                    .edges(List.of())
                    .build();
                // @formatter:on

                this.save(editingContext, diagram);
            }
        }
        return Optional.ofNullable(this.representations.get(representationId)).filter(representationClass::isInstance).map(representationClass::cast);
    }

    @Override
    public Optional<RepresentationDescriptor> getRepresentationDescriptorForEditingContextId(String editingContextId, String representationId) {
        var editingContextIdUUID = new IDParser().parse(editingContextId);
        if (editingContextIdUUID.isPresent()) {
            IEditingContext editingContext = this.editingContextService.getEditingContext(editingContextId);
            var optRepresentation = this.findById(editingContext, representationId, Diagram.class);
            if (optRepresentation.isPresent()) {
                var representation = optRepresentation.get();
                // @formatter:off
                RepresentationDescriptor rd = RepresentationDescriptor.newRepresentationDescriptor(UUID.fromString(representation.getId()))
                        .label(representation.getLabel())
                        .descriptionId(representation.getDescriptionId())
                        .targetObjectId(representation.getTargetObjectId())
                        .projectId(editingContextIdUUID.get())
                        .representation(representation)
                        .build();
                // @formatter:on
                return Optional.of(rd);
            }
        }
        return Optional.empty();
    }

}
