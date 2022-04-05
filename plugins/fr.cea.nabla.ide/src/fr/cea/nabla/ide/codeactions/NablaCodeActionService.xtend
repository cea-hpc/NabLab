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

import fr.cea.nabla.nabla.SimpleVar
import fr.cea.nabla.validation.UnusedValidator
import java.util.ArrayList
import javax.inject.Inject
import org.eclipse.emf.common.util.URI
import org.eclipse.lsp4j.CodeAction
import org.eclipse.lsp4j.CodeActionKind
import org.eclipse.lsp4j.Diagnostic
import org.eclipse.lsp4j.Range
import org.eclipse.lsp4j.TextEdit
import org.eclipse.lsp4j.WorkspaceEdit
import org.eclipse.lsp4j.jsonrpc.messages.Either
import org.eclipse.xtext.ide.server.Document
import org.eclipse.xtext.ide.server.codeActions.ICodeActionService2
import org.eclipse.xtext.ide.server.codeActions.ICodeActionService2.Options
import org.eclipse.xtext.resource.EObjectAtOffsetHelper
import org.eclipse.xtext.resource.ILocationInFileProvider
import org.eclipse.xtext.util.ITextRegion

class NablaCodeActionService implements ICodeActionService2
{

	static val EMPTY = ""

	@Inject protected EObjectAtOffsetHelper eObjectAtOffsetHelper
	@Inject protected ILocationInFileProvider locationProvider

	override getCodeActions(Options options)
	{

		val result = <CodeAction>newArrayList
		for (d : options.codeActionParams.context.diagnostics)
		{
			if(d.code.getLeft == UnusedValidator.UNUSED)
			{
				handleUnusedVariableWarning(options, d, result)

			}
		}
		return result.map[Either.forRight(it)]
	}

	private def void handleUnusedVariableWarning(Options options, Diagnostic d, ArrayList<CodeAction> result)
	{
		val resource = options.resource
		val document = options.document
		val target = eObjectAtOffsetHelper.resolveContainedElementAt(options.resource,
			document.getOffSet(d.range.start))

		if(target instanceof SimpleVar)
		{
			val containerLocation = locationProvider.getFullTextRegion(target.eContainer)
			val resourceURI = resource.URI
			result += d.createDeleteUnusedVariableAction(resourceURI, document, containerLocation)
		}
	}

	protected def CodeAction createDeleteUnusedVariableAction(Diagnostic d, URI resourceURI, Document document,
		ITextRegion containerLocation)
	{
		return new CodeAction => [
			kind = CodeActionKind.QuickFix
			title = "Delete unused variable"
			diagnostics = #[d]
			edit = new WorkspaceEdit() => [
				addTextEdit(resourceURI, new TextEdit => [
					range = new Range(document.getPosition(containerLocation.offset),
						document.getPosition(containerLocation.offset + containerLocation.length))
					newText = EMPTY
				])
			]

		]
	}

	private def void addTextEdit(WorkspaceEdit edit, URI uri, TextEdit... textEdit)
	{
		edit.changes.put(uri.toString, textEdit)
	}

}
