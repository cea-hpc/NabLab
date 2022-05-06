/*******************************************************************************
 * Copyright (c) 2021, 2022 CEA
 * This program and the accompanying materials are made available under the
 * terms of the Eclipse Public License 2.0 which is available at
 * http://www.eclipse.org/legal/epl-2.0.
 *
 * SPDX-License-Identifier: EPL-2.0
 * Contributors: see AUTHORS file
 *******************************************************************************/
package fr.cea.nabla.ide.web

import fr.cea.nabla.ide.web.semantictokens.SemanticTokenComputer
import java.util.concurrent.CompletableFuture
import org.eclipse.emf.common.util.URI
import org.eclipse.lsp4j.InitializeParams
import org.eclipse.lsp4j.SemanticTokens
import org.eclipse.lsp4j.SemanticTokensParams
import org.eclipse.lsp4j.SemanticTokensWithRegistrationOptions
import org.eclipse.lsp4j.ServerCapabilities
import org.eclipse.xtext.ide.server.LanguageServerImpl
import org.eclipse.xtext.ide.server.WorkspaceManager

class NabLabLanguageServer extends LanguageServerImpl
{
	override WorkspaceManager getWorkspaceManager()
	{
		super.workspaceManager
	}

	override protected getLanguageClient()
	{
		super.languageClient
	}

	override protected createServerCapabilities(InitializeParams params)
	{
		val ServerCapabilities capabilities = super.createServerCapabilities(params)

		// Add semantic token capacities
		val SemanticTokensWithRegistrationOptions options = new SemanticTokensWithRegistrationOptions()

		options.setLegend(SemanticTokenComputer.legend())
		options.setRange(false)
		options.setFull(true)
		capabilities.setSemanticTokensProvider(options)

		return capabilities
	}

	override CompletableFuture<SemanticTokens> semanticTokensFull(SemanticTokensParams params)
	{
		return requestManager.runRead [ cancelIndicator |
			workspaceManager.doRead(URI.createURI(URI.decode(params.textDocument.uri)), [ doc, resource |
				return new SemanticTokenComputer(doc, resource).computeTokens
			])
		];
	}

}
