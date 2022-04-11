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

import java.util.ArrayList
import java.util.Arrays
import java.util.Collections
import java.util.Comparator
import java.util.List
import java.util.stream.Collectors
import org.eclipse.emf.ecore.EObject
import org.eclipse.lsp4j.SemanticTokens
import org.eclipse.lsp4j.SemanticTokensLegend
import org.eclipse.xtext.ParserRule
import org.eclipse.xtext.RuleCall
import org.eclipse.xtext.TerminalRule
import org.eclipse.xtext.ide.server.Document
import org.eclipse.xtext.nodemodel.INode
import org.eclipse.xtext.resource.XtextResource

/**
 * Greatly inspired from org.eclipse.jdt.ls.core.internal.semantictokens.SemanticTokensVisitor
 * Contributors:
 *     Microsoft Corporation - initial API and implementation
 *     0dinD - Semantic highlighting improvements - https://github.com/eclipse/eclipse.jdt.ls/pull/1501
 *     CEA - Adaptation for NabLab
 */
class SemanticTokenComputer
{

	public static val ID_ID = "ID"
	public static val INT_ID = "INT"
	public static val REAL_ID = "REAL"
	public static val SPACE_ITERATOR = "SpaceIteratorRef"
	public static val VAR_REF = "VarRef"

	static val Comparator<SemanticToken> POSITION_COMPARATOR = Comparator.<SemanticToken>comparingInt[position.line].
		thenComparingInt[position.character]

	val Document document

	val XtextResource resource

	new(Document document, XtextResource resource)
	{
		this.document = document
		this.resource = resource
	}

	static def SemanticTokensLegend legend()
	{
		return new SemanticTokensLegend(
			Arrays.stream(TokenType.values()).map[toString].collect(Collectors.toList()),
			Arrays.stream(TokenModifier.values()).map[toString].collect(Collectors.toList())
		)
	}

	def SemanticTokens computeTokens()
	{
		val node = resource.parseResult.rootNode

		val List<SemanticToken> tokens = new ArrayList<SemanticToken>()
		for (v : node.asTreeIterable)
		{
			if (v.grammarElement !== null)
			{
				accept(tokens, v, v.grammarElement)
			}
		}
		// Needs to be sorted to properly compute the delta position of each tokens
		Collections.sort(tokens, fr.cea.nabla.ide.web.semantictokens.SemanticTokenComputer.POSITION_COMPARATOR)
		return new SemanticTokens(encodedTokens(tokens))
	}

	/*
	 * To be kept synchronized with fr.cea.nabla.ui.syntaxcoloring.NablaSemanticHighlightingCalculator
	 */
	private def void accept(List<SemanticToken> tokens, INode n, EObject elt)
	{
		switch elt
		{
			TerminalRule:
			{
				switch elt.name
				{
					case INT_ID: tokens.addTokenFromNode(n, TokenType.NUMBER, TokenModifier.DECLARATION)
					case REAL_ID: tokens.addTokenFromNode(n, TokenType.NUMBER, TokenModifier.DECLARATION)
					case ID_ID: tokens.addTokenFromNode(n, TokenType.VARIABLE, TokenModifier.DECLARATION)
				}
			}
			RuleCall:
				accept(tokens, n, elt.rule)
			ParserRule:
			{
				switch elt.name
				{
					case VAR_REF:
						colorizeTimeIterator(tokens, n)
					case SPACE_ITERATOR:
						tokens.addTokenFromNode(n, TokenType.TIME_ITERATOR, TokenModifier.DECLARATION)
				}
			}
			default:
			{
			}
		}
	}

	private def void colorizeTimeIterator(List<SemanticToken> tokens, INode node)
	{
		val s = node.text.trim
		val offset = s.indexOf('^{')
		val lastIndex = s.indexOf('}')
		val length = lastIndex - offset - 2
		if (offset != -1 && lastIndex != -1 && length > 0)
		{
			tokens.add(
				new SemanticToken(document.getPosition(node.offset + offset + 2), length, TokenType.TIME_ITERATOR,
					TokenModifier.DECLARATION.bitmask))
		}
	}

	private def void addTokenFromNode(List<SemanticToken> tokens, INode node, TokenType type, TokenModifier modifier)
	{
		tokens.add(new SemanticToken(document.getPosition(node.offset), node.length, type, modifier.bitmask))
	}


	// Same as org.eclipse.jdt.ls.core.internal.semantictokens.SemanticTokensVisitor.encodedTokens()
	private def List<Integer> encodedTokens(List<SemanticToken> tokens)
	{
		val int numTokens = tokens.size()
		val List<Integer> data = new ArrayList<Integer>(numTokens * 5)
		var int currentLine = 0
		var int currentColumn = 0
		for (var i = 0; i < numTokens; i++)
		{
			val SemanticToken token = tokens.get(i)
			val position = token.position
			val line = position.line
			val int column = position.character
			val int deltaLine = line - currentLine
			if (deltaLine != 0)
			{
				currentLine = line
				currentColumn = 0
			}
			val int deltaColumn = column - currentColumn
			currentColumn = column
			// Disallow duplicate/conflict token (if exists)
			if (deltaLine != 0 || deltaColumn != 0)
			{
				val int tokenTypeIndex = token.type.ordinal()
				val int tokenModifiers = token.modifiers

				data.add(deltaLine)
				data.add(deltaColumn)
				data.add(token.getLength())
				data.add(tokenTypeIndex)
				data.add(tokenModifiers)
			}
		}
		return data
	}

}
