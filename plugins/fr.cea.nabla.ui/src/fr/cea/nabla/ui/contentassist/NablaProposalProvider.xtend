/*******************************************************************************
 * Copyright (c) 2021 CEA
 * This program and the accompanying materials are made available under the
 * terms of the Eclipse Public License 2.0 which is available at
 * http://www.eclipse.org/legal/epl-2.0.
 *
 * SPDX-License-Identifier: EPL-2.0
 * Contributors: see AUTHORS file
 *******************************************************************************/
package fr.cea.nabla.ui.contentassist

import org.eclipse.emf.ecore.EObject
import org.eclipse.xtext.Assignment
import org.eclipse.xtext.ui.editor.contentassist.ContentAssistContext
import org.eclipse.xtext.ui.editor.contentassist.ICompletionProposalAcceptor
import fr.cea.nabla.ir.transformers.ReplaceUtf8Chars

/**
 * See https://www.eclipse.org/Xtext/documentation/304_ide_concepts.html#content-assist
 * on how to customize the content assistant.
 */
class NablaProposalProvider extends AbstractNablaProposalProvider
{
	override completeSimpleVar_Name(EObject model, Assignment assignment, ContentAssistContext context, ICompletionProposalAcceptor acceptor)
	{
		proposeCompletion(acceptor, ReplaceUtf8Chars.UTF8Chars.keySet, context)
	}

	override completeConnectivityVar_Name(EObject model, Assignment assignment, ContentAssistContext context, ICompletionProposalAcceptor acceptor)
	{
		proposeCompletion(acceptor, ReplaceUtf8Chars.UTF8Chars.keySet, context)
	}

	private def proposeCompletion(ICompletionProposalAcceptor acceptor, Iterable<String> proposals, ContentAssistContext context)
	{
		for (proposal : proposals) acceptor.accept(createCompletionProposal(proposal, context))
	}
}
