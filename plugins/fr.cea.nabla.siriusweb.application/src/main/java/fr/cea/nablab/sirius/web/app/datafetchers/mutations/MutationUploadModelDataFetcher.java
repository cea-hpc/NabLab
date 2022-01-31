/*******************************************************************************
 * Copyright (c) 2022 CEA
 * This program and the accompanying materials are made available under the
 * terms of the Eclipse Public License 2.0 which is available at
 * http://www.eclipse.org/legal/epl-2.0.
 *
 * SPDX-License-Identifier: EPL-2.0
 * Contributors: see AUTHORS file
 *******************************************************************************/
package fr.cea.nablab.sirius.web.app.datafetchers.mutations;

import com.fasterxml.jackson.databind.ObjectMapper;

import fr.cea.nablab.sirius.web.app.services.api.IModelService;
import fr.cea.nablab.sirius.web.app.services.api.UploadModelInput;

import java.util.Objects;

import org.eclipse.sirius.components.annotations.spring.graphql.MutationDataFetcher;
import org.eclipse.sirius.components.core.api.IPayload;
import org.eclipse.sirius.components.graphql.api.IDataFetcherWithFieldCoordinates;

import graphql.schema.DataFetchingEnvironment;

/**
 * @author arichard
 */
@MutationDataFetcher(type = "Mutation", field = "uploadModel")
public class MutationUploadModelDataFetcher implements IDataFetcherWithFieldCoordinates<IPayload> {

    private static final String INPUT_ARGUMENT = "input"; //$NON-NLS-1$

    private final ObjectMapper objectMapper;

    private final IModelService modelService;

    public MutationUploadModelDataFetcher(ObjectMapper objectMapper, IModelService modelService) {
        this.objectMapper = Objects.requireNonNull(objectMapper);
        this.modelService = Objects.requireNonNull(modelService);
    }

    @Override
    public IPayload get(DataFetchingEnvironment environment) throws Exception {
        Object argument = environment.getArgument(INPUT_ARGUMENT);
        var input = this.objectMapper.convertValue(argument, UploadModelInput.class);
        return this.modelService.uploadModel(input);
    }

}
