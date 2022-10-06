/*******************************************************************************
 * Copyright (c) 2022 CEA
 * This program and the accompanying materials are made available under the
 * terms of the Eclipse Public License 2.0 which is available at
 * http://www.eclipse.org/legal/epl-2.0.
 *
 * SPDX-License-Identifier: EPL-2.0
 * Contributors: see AUTHORS file
 *******************************************************************************/
package fr.cea.nabla.ide.contentassist

import com.google.inject.Inject
import fr.cea.nabla.services.NablaGrammarAccess
import org.eclipse.xtext.RuleCall
import org.eclipse.xtext.ide.editor.contentassist.ContentAssistContext
import org.eclipse.xtext.ide.editor.contentassist.IIdeContentProposalAcceptor
import org.eclipse.xtext.ide.editor.contentassist.IdeContentProposalProvider

class NablaIdeContentProposalProvider extends IdeContentProposalProvider
{
	@Inject extension NablaGrammarAccess

	override dispatch createProposals(RuleCall ruleCall, ContentAssistContext context,
		IIdeContentProposalAcceptor acceptor)
	{
		switch ruleCall.rule
		{
			case simpleVarRule,
			case connectivityVarRule:
			{
			}
			default:
				super._createProposals(ruleCall, context, acceptor)
		}
	}

}
