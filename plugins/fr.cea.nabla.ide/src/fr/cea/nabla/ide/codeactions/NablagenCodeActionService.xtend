/*******************************************************************************
 * Copyright (c) 2022 CEA
 * This program and the accompanying materials are made available under the
 * terms of the Eclipse Public License 2.0 which is available at
 * http://www.eclipse.org/legal/epl-2.0.
 *
 * SPDX-License-Identifier: EPL-2.0
 * Contributors: see AUTHORS file
 *******************************************************************************/
package fr.cea.nabla.ide.codeactions

import fr.cea.nabla.nablagen.MainModule
import fr.cea.nabla.validation.NablagenValidator
import java.util.ArrayList
import javax.inject.Inject
import org.eclipse.emf.common.util.URI
import org.eclipse.lsp4j.CodeAction
import org.eclipse.lsp4j.CodeActionKind
import org.eclipse.lsp4j.Diagnostic
import org.eclipse.lsp4j.Position
import org.eclipse.lsp4j.Range
import org.eclipse.lsp4j.TextEdit
import org.eclipse.lsp4j.WorkspaceEdit
import org.eclipse.lsp4j.jsonrpc.messages.Either
import org.eclipse.xtext.ide.server.Document
import org.eclipse.xtext.ide.server.codeActions.ICodeActionService2
import org.eclipse.xtext.ide.server.codeActions.ICodeActionService2.Options
import org.eclipse.xtext.resource.EObjectAtOffsetHelper
import org.eclipse.xtext.resource.XtextResource

class NablagenCodeActionService implements ICodeActionService2
{

	static val TAB = "\t"
	static val ITERATION_MAX_ATTR = "iterationMax"
	static val TIME_MAX_ATTR = "timeMax"

	@Inject
	EObjectAtOffsetHelper eObjectAtOffsetHelper

	override getCodeActions(Options options)
	{

		val result = <CodeAction>newArrayList
		for (d : options.codeActionParams.context.diagnostics)
		{
			if(d.code.getLeft == NablagenValidator.CPP_MANDATORY_VARIABLES)
			{
				handleCPPMandatoryVariableError(options, d, result)

			}
		}
		return result.map[Either.forRight(it)]
	}

	private def void handleCPPMandatoryVariableError(Options options, Diagnostic d, ArrayList<CodeAction> result)
	{
		val resource = options.resource
		val document = options.document
		val target = eObjectAtOffsetHelper.resolveContainedElementAt(options.resource,
			document.getOffSet(d.range.start))

		if(target instanceof MainModule)
		{
			result += createMissingCppMandatatoryVariablesAction(resource, d, document)

		}
	}

	private def CodeAction createMissingCppMandatatoryVariablesAction(XtextResource resource, Diagnostic d,
		Document document)
	{
		val resourceURI = resource.URI
		val start = d.range.start
		val end = d.range.end
		var inserPosition = new Position(end.line, end.character - 1)
		val content = document.getSubstring(d.range)
		val iterationMaxIndex = content.indexOf(ITERATION_MAX_ATTR)
		var boolean insertTimeMax
		var boolean insertIterationMax
		if(iterationMaxIndex === -1)
		{
			insertIterationMax = true
			// Missing iterationMaxIndex
			// Search for timeMaxIdex
			val timeMaxIndex = content.indexOf(TIME_MAX_ATTR)
			if(timeMaxIndex === -1)
			{
				// Missing timeMax
				insertTimeMax = true
				// Add new content at the end
				inserPosition = new Position(end.line, end.character - 1)
			}
			else
			{
				insertTimeMax = false
				inserPosition = document.getPosition(document.getOffSet(start) + timeMaxIndex)
			}
		}
		else
		{
			// Missing timeMaxOnly
			insertTimeMax = true
			inserPosition = new Position(end.line, end.character - 1)

		}
		return d.createAddMadatoryCppElementAction(resourceURI, document, inserPosition, insertIterationMax,
			insertTimeMax)
	}

	private def CodeAction createAddMadatoryCppElementAction(Diagnostic d, URI resourceURI, Document document,
		Position insertPosition, boolean addIterationMax, boolean addTimeMax)
	{
		return new CodeAction => [
			kind = CodeActionKind.QuickFix
			title = "Add mandatory CPP variables"
			diagnostics = #[d]
			edit = new WorkspaceEdit() => [
				addTextEdit(resourceURI, new TextEdit => [
					range = new Range(insertPosition, insertPosition)

					if(addIterationMax && addTimeMax)
					{
						newText = TAB + ITERATION_MAX_ATTR + " = maxIterations;" + System.lineSeparator + TAB +
							TIME_MAX_ATTR + " = stopTime;" + System.lineSeparator
					}
					else if(addIterationMax && !addTimeMax)
					{
						newText = TAB + ITERATION_MAX_ATTR + " = maxIterations;" + System.lineSeparator
					}
					else
					{
						newText = TAB + TIME_MAX_ATTR + " = stopTime;" + System.lineSeparator
					}

				])
			]

		]
	}

	private def void addTextEdit(WorkspaceEdit edit, URI uri, TextEdit... textEdit)
	{
		edit.changes.put(uri.toString, textEdit)
	}

}
