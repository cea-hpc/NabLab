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

import java.util.Objects;
import java.util.concurrent.CompletableFuture;

import org.eclipse.sirius.components.annotations.spring.graphql.MutationDataFetcher;
import org.eclipse.sirius.components.collaborative.api.IEditingContextEventProcessorRegistry;
import org.eclipse.sirius.components.collaborative.diagrams.dto.InvokeNodeToolOnDiagramInput;
import org.eclipse.sirius.components.core.api.ErrorPayload;
import org.eclipse.sirius.components.core.api.IPayload;
import org.eclipse.sirius.components.graphql.api.IDataFetcherWithFieldCoordinates;

import graphql.schema.DataFetchingEnvironment;

/**
 * The data fetcher used to invoke a node tool on a diagram.
 * <p>
 * It will be used to handle the following GraphQL field:
 * </p>
 *
 * <pre>
 * type Mutation {
 *   invokeNodeToolOnDiagram(input: InvokeNodeToolOnDiagramInput!): InvokeNodeDiagamToolPayload!
 * }
 * </pre>
 *
 * @author arichard
 */
@MutationDataFetcher(type = "Mutation", field = MutationInvokeNodeToolOnDiagramDataFetcher.INVOKE_NODE_TOOL_ON_DIAGRAM_FIELD)
public class MutationInvokeNodeToolOnDiagramDataFetcher implements IDataFetcherWithFieldCoordinates<CompletableFuture<IPayload>> {

    public static final String INVOKE_NODE_TOOL_ON_DIAGRAM_FIELD = "invokeNodeToolOnDiagram"; //$NON-NLS-1$

    private final ObjectMapper objectMapper;

    private final IEditingContextEventProcessorRegistry editingContextEventProcessorRegistry;

    public MutationInvokeNodeToolOnDiagramDataFetcher(ObjectMapper objectMapper, IEditingContextEventProcessorRegistry editingContextEventProcessorRegistry) {
        this.objectMapper = Objects.requireNonNull(objectMapper);
        this.editingContextEventProcessorRegistry = Objects.requireNonNull(editingContextEventProcessorRegistry);
    }

    @Override
    public CompletableFuture<IPayload> get(DataFetchingEnvironment environment) throws Exception {
        Object argument = environment.getArgument("input"); //$NON-NLS-1$
        var input = this.objectMapper.convertValue(argument, InvokeNodeToolOnDiagramInput.class);

        // @formatter:off
        return this.editingContextEventProcessorRegistry.dispatchEvent(input.getEditingContextId(), input)
                .defaultIfEmpty(new ErrorPayload(input.getId(), "Error while executing MutationInvokeNodeToolOnDiagramDataFetcher")) //$NON-NLS-1$
                .toFuture();
        // @formatter:on
    }

}
