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

import java.util.HashMap;
import java.util.Map;
import java.util.Objects;
import java.util.Optional;

import org.eclipse.sirius.components.annotations.spring.graphql.QueryDataFetcher;
import org.eclipse.sirius.components.core.RepresentationMetadata;
import org.eclipse.sirius.components.graphql.api.IDataFetcherWithFieldCoordinates;
import org.eclipse.sirius.components.representations.IRepresentation;
import org.eclipse.sirius.components.representations.ISemanticRepresentation;

import graphql.execution.DataFetcherResult;
import graphql.schema.DataFetchingEnvironment;

/**
 * @author arichard
 */
@QueryDataFetcher(type = "EditingContext", field = "representation")
public class EditingContextRepresentationDataFetcher implements IDataFetcherWithFieldCoordinates<DataFetcherResult<RepresentationMetadata>> {

    private static final String REPRESENTATION_ID = "representationId"; //$NON-NLS-1$

    private final IRepresentationService representationService;

    public EditingContextRepresentationDataFetcher(IRepresentationService representationService) {
        this.representationService = Objects.requireNonNull(representationService);
    }

    @Override
    public DataFetcherResult<RepresentationMetadata> get(DataFetchingEnvironment environment) throws Exception {
        String editingContextId = environment.getSource();
        String representationId = environment.getArgument(REPRESENTATION_ID);

        Map<String, Object> localContext = new HashMap<>(environment.getLocalContext());
        localContext.put(REPRESENTATION_ID, representationId);

        // @formatter:off
        var representationMetadata = this.representationService.getRepresentationDescriptorForEditingContextId(editingContextId, representationId)
                .map(RepresentationDescriptor::getRepresentation)
                .map(this::toRepresentationMetadata)
                .orElse(null);

        return DataFetcherResult.<RepresentationMetadata>newResult()
                .data(representationMetadata)
                .localContext(localContext)
                .build();
        // @formatter:on
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
