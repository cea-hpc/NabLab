/*******************************************************************************
 * Copyright (c) 2020,2022 Microsoft Corporation and others.
 * All rights reserved. This program and the accompanying materials
 * are made available under the terms of the Eclipse Public License 2.0
 * which accompanies this distribution, and is available at
 * https://www.eclipse.org/legal/epl-2.0/
 *
 * SPDX-License-Identifier: EPL-2.0
 *
 * Contributors:
 *     Microsoft Corporation - initial API and implementation
 *     0dinD - Semantic highlighting improvements - https://github.com/eclipse/eclipse.jdt.ls/pull/1501
 *     CEA - Adaptation for Nablab
 *******************************************************************************/
package fr.cea.nabla.ide.web.semantictokens;

import org.eclipse.lsp4j.SemanticTokenTypes;

/**
 * Greatly inspired from org.eclipse.jdt.ls.core.internal.semantictokens.SemanticTokensVisitor.SemanticToken
 */
public enum TokenType {
	
	// Standard LSP token types, see https://microsoft.github.io/language-server-protocol/specifications/specification-current/#textDocument_semanticTokens
	NUMBER(SemanticTokenTypes.Number),
	VARIABLE(SemanticTokenTypes.Variable),
	
	//Custom types
	TIME_ITERATOR("timeIterator")
	;


	/**
	 * This is the name of the token type given to the client, so it
	 * should be as generic as possible and follow the standard LSP (see below)
	 * token type names where applicable. For example, the generic name of the
	 * {@link #PACKAGE} type is "namespace", since it has similar meaning.
	 * Using standardized names makes life easier for theme authors, since
	 * they don't need to know about language-specific terminology.
	 *
	 * @see https://microsoft.github.io/language-server-protocol/specifications/specification-current/#textDocument_semanticTokens
	 */
	private String genericName;

	TokenType(String genericName) {
		this.genericName = genericName;
	}

	@Override
	public String toString() {
		return genericName;
	}

}
