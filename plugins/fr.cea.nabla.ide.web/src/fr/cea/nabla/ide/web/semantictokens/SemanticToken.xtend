/*******************************************************************************
 * Copyright (c) 2020, 2022 Microsoft Corporation and others.
 * This program and the accompanying materials are made available under the
 * terms of the Eclipse Public License 2.0 which is available at
 * http://www.eclipse.org/legal/epl-2.0.
 *
 * SPDX-License-Identifier: EPL-2.0
 * Contributors: see AUTHORS file
 *******************************************************************************/
package fr.cea.nabla.ide.web.semantictokens

import org.eclipse.lsp4j.Position

/**
 * Greatly inspired from org.eclipse.jdt.ls.core.internal.semantictokens.SemanticTokensVisitor.SemanticToken
 * Contributors:
 *     Microsoft Corporation - initial API and implementation
 *     0dinD - Semantic highlighting improvements - https://github.com/eclipse/eclipse.jdt.ls/pull/1501
 *     CEA - Adaptation for Nablab
 */
class SemanticToken {
	
	val TokenType type
	
	/**
	 * Mask of TokenModifier#bitmask
	 */
	val int modifiers
	
	val Position startPosition
	
	val int length
	
	new(Position startPosition,int length, TokenType type , int modifiers){
		this.startPosition = startPosition
		this.length = length
		this.type = type
		this.modifiers = modifiers
	}
	
	def int getLength(){
		return length
	}
	
	def TokenType getType(){
		return type
	}
	
	def int getModifiers(){
		return modifiers
	}
	
	
	def Position getPosition(){
		return startPosition
	}
	
}