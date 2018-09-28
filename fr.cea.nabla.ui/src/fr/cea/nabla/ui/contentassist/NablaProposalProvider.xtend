/*******************************************************************************
 * Copyright (c) 2018 CEA
 * This program and the accompanying materials are made available under the 
 * terms of the Eclipse Public License 2.0 which is available at
 * http://www.eclipse.org/legal/epl-2.0.
 *
 * SPDX-License-Identifier: EPL-2.0
 *
 * Contributors:
 * 	Benoit Lelandais - initial implementation
 * 	Marie-Pierre Oudot - initial implementation
 * 	Jean-Sylvain Camier - Nabla generation support
 *******************************************************************************/
package fr.cea.nabla.ui.contentassist

import com.google.inject.Inject
import fr.cea.nabla.nabla.VarRef
import fr.cea.nabla.typing.ExpressionTypeProvider
import fr.cea.nabla.typing.NablaType
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
	@Inject extension ExpressionTypeProvider
	
	// alpha, beta, gamma, delta, epsilon, lambda, rho, omega
	static val GreekLetters = #['\u03B1', '\u03B2', '\u03B3', '\u03B4', '\u03F5', '\u03BB', '\u03C1', '\u2126', '\u03A9']
	
	override completeScalarVar_Name(EObject model, Assignment assignment, ContentAssistContext context, ICompletionProposalAcceptor acceptor)
	{
		proposeCompletion(acceptor, GreekLetters, context)
	}
	
	override completeArrayVar_Name(EObject model, Assignment assignment, ContentAssistContext context, ICompletionProposalAcceptor acceptor)
	{
		proposeCompletion(acceptor, GreekLetters, context)
	}

	override completeVarRef_Fields(EObject model, Assignment assignment, ContentAssistContext context, ICompletionProposalAcceptor acceptor) 
	{
		if (model !== null && model instanceof VarRef)
		{
			val vRefType = (model as VarRef).typeForWithoutFields
			if (NablaType::isBasicType(vRefType))
				switch vRefType.base
				{
					case REAL2: proposeCompletion(acceptor, #['x','y'], context)
					case REAL3: proposeCompletion(acceptor, #['x','y','z'], context)
					case REAL2X2: proposeCompletion(acceptor, #['x.x','x.y','y.x','y.y'], context)
					case REAL3X3: proposeCompletion(acceptor, #['x.x','x.y','x.z','y.x','y.y','y.z','z.x','z.y','z.z'], context)
					default: super.completeVarRef_Fields(model, assignment, context, acceptor)
				}
		}
	}
	
	private def proposeCompletion(ICompletionProposalAcceptor acceptor, Iterable<String> proposals, ContentAssistContext context)
	{
		for (proposal : proposals) acceptor.accept(createCompletionProposal(proposal, context))
	}
}
