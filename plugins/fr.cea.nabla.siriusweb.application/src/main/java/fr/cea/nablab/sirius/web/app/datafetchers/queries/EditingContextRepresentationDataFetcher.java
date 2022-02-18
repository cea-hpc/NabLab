/*******************************************************************************
 * Copyright (c) 2022 CEA
 * This program and the accompanying materials are made available under the
 * terms of the Eclipse Public License 2.0 which is available at
 * http://www.eclipse.org/legal/epl-2.0.
 *
 * SPDX-License-Identifier: EPL-2.0
 * Contributors: see AUTHORS file
 *******************************************************************************/
package fr.cea.nablab.sirius.web.app.datafetchers.queries;

import fr.cea.nablab.sirius.web.app.services.api.IRepresentationService;
import fr.cea.nablab.sirius.web.app.services.representations.RepresentationDescriptor;

import java.util.Objects;
import java.util.Optional;

import org.eclipse.sirius.components.annotations.spring.graphql.QueryDataFetcher;
import org.eclipse.sirius.components.core.RepresentationMetadata;
import org.eclipse.sirius.components.graphql.api.IDataFetcherWithFieldCoordinates;
import org.eclipse.sirius.components.representations.IRepresentation;
import org.eclipse.sirius.components.representations.ISemanticRepresentation;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

import graphql.schema.DataFetchingEnvironment;

/**
 * @author arichard
 */
@QueryDataFetcher(type = "EditingContext", field = "representation")
public class EditingContextRepresentationDataFetcher implements IDataFetcherWithFieldCoordinates<RepresentationMetadata> {

    private final IRepresentationService representationService;

    private final Logger logger = LoggerFactory.getLogger(EditingContextRepresentationDataFetcher.class);

    public EditingContextRepresentationDataFetcher(IRepresentationService representationService) {
        this.representationService = Objects.requireNonNull(representationService);
    }

    @Override
    public RepresentationMetadata get(DataFetchingEnvironment environment) throws Exception {
        String editingContextId = environment.getSource();
        String representationId = environment.getArgument("representationId"); //$NON-NLS-1$
        try {
            // @formatter:off
            return this.representationService.getRepresentationDescriptorForEditingContextId(editingContextId, representationId)
                    .map(RepresentationDescriptor::getRepresentation)
                    .map(this::toRepresentationMetadata)
                    .orElse(null);
            // @formatter:on
        } catch (IllegalArgumentException exception) {
            this.logger.warn(exception.getMessage(), exception);
        }
        return null;
    }

    private RepresentationMetadata toRepresentationMetadata(IRepresentation representation) {
        // @formatter:off
        String targetObjectId = Optional.of(representation)
                .filter(ISemanticRepresentation.class::isInstance)
                .map(ISemanticRepresentation.class::cast)
                .map(ISemanticRepresentation::getTargetObjectId)
                .orElse(null);
        // @formatter:on
        return new RepresentationMetadata(representation.getId(), representation.getKind(), representation.getLabel(), representation.getDescriptionId(), targetObjectId);
    }

}
