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

import java.util.List;
import java.util.Map;
import java.util.Objects;
import java.util.UUID;
import java.util.concurrent.CompletableFuture;

import org.eclipse.sirius.components.annotations.spring.graphql.QueryDataFetcher;
import org.eclipse.sirius.components.collaborative.api.IEditingContextEventProcessorRegistry;
import org.eclipse.sirius.components.collaborative.diagrams.dto.GetToolSectionSuccessPayload;
import org.eclipse.sirius.components.collaborative.diagrams.dto.GetToolSectionsInput;
import org.eclipse.sirius.components.diagrams.tools.ToolSection;
import org.eclipse.sirius.components.graphql.api.IDataFetcherWithFieldCoordinates;

import graphql.schema.DataFetchingEnvironment;
import reactor.core.publisher.Mono;

/**
 * The data fetcher used to retrieve the toolSections from the diagram description.
 *
 * @author arichard
 */
@QueryDataFetcher(type = "DiagramDescription", field = "toolSections")
public class GetToolSectionsDataFetcher implements IDataFetcherWithFieldCoordinates<CompletableFuture<List<ToolSection>>> {

    private static final String DIAGRAM_ELEMENT_ID = "diagramElementId"; //$NON-NLS-1$

    private static final String DIAGRAM_ID = "diagramId"; //$NON-NLS-1$

    private static final String EDITING_CONTEXT_ID = "editingContextId"; //$NON-NLS-1$

    private final IEditingContextEventProcessorRegistry editingContextEventProcessorRegistry;

    public GetToolSectionsDataFetcher(IEditingContextEventProcessorRegistry editingContextEventProcessorRegistry) {
        this.editingContextEventProcessorRegistry = Objects.requireNonNull(editingContextEventProcessorRegistry);
    }

    @Override
    public CompletableFuture<List<ToolSection>> get(DataFetchingEnvironment environment) throws Exception {
        Map<String, Object> variables = environment.getVariables();
        Object editingContextId = variables.get(EDITING_CONTEXT_ID);
        Object diagramId = variables.get(DIAGRAM_ID);
        Object diagramElementId = variables.get(DIAGRAM_ELEMENT_ID);

        if (editingContextId instanceof String && diagramId instanceof String && diagramElementId instanceof String) {
            GetToolSectionsInput input = new GetToolSectionsInput(UUID.randomUUID(), (String) editingContextId, (String) diagramId, (String) diagramElementId);

            // @formatter:off
            return this.editingContextEventProcessorRegistry.dispatchEvent(input.getEditingContextId(), input)
                    .filter(GetToolSectionSuccessPayload.class::isInstance)
                    .map(GetToolSectionSuccessPayload.class::cast)
                    .map(GetToolSectionSuccessPayload::getToolSections)
                    .toFuture();
            // @formatter:on
        }
        return Mono.<List<ToolSection>> empty().toFuture();
    }

}
