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

import java.util.Objects;

import org.eclipse.sirius.web.annotations.spring.graphql.QueryDataFetcher;
import org.eclipse.sirius.web.representations.IRepresentation;
import org.eclipse.sirius.web.spring.collaborative.api.IRepresentationSearchService;
import org.eclipse.sirius.web.spring.graphql.api.IDataFetcherWithFieldCoordinates;

import graphql.schema.DataFetchingEnvironment;

/**
 * @author arichard
 */
@QueryDataFetcher(type = "EditingContext", field = "representation")
public class EditingContextRepresentationDataFetcher implements IDataFetcherWithFieldCoordinates<IRepresentation> {

    private final IRepresentationSearchService representationService;

    public EditingContextRepresentationDataFetcher(IRepresentationSearchService representationService) {
        this.representationService = Objects.requireNonNull(representationService);
    }

    @Override
    public IRepresentation get(DataFetchingEnvironment environment) throws Exception {
        String representationId = environment.getArgument("representationId"); //$NON-NLS-1$
        return this.representationService.findById(null, representationId, IRepresentation.class).orElse(null);
    }

}
