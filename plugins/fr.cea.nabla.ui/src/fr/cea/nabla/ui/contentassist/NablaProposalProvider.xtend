/*******************************************************************************
 * Copyright (c) 2020 CEA
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

/**
 * See https://www.eclipse.org/Xtext/documentation/304_ide_concepts.html#content-assist
 * on how to customize the content assistant.
 */
class NablaProposalProvider extends AbstractNablaProposalProvider
{
	// alpha, beta, gamma, delta, epsilon, lambda, rho, omega
	static val GreekLetters = #['\u03B1', '\u03B2', '\u03B3', '\u03B4', '\u03B5', '\u03BB', '\u03C1', '\u03A9']

	override completeSimpleVar_Name(EObject model, Assignment assignment, ContentAssistContext context, ICompletionProposalAcceptor acceptor)
	{
		proposeCompletion(acceptor, GreekLetters, context)
	}

	override completeConnectivityVar_Name(EObject model, Assignment assignment, ContentAssistContext context, ICompletionProposalAcceptor acceptor)
	{
		proposeCompletion(acceptor, GreekLetters, context)
	}

	private def proposeCompletion(ICompletionProposalAcceptor acceptor, Iterable<String> proposals, ContentAssistContext context)
	{
		for (proposal : proposals) acceptor.accept(createCompletionProposal(proposal, context))
	}
}
