/*******************************************************************************
 * Copyright (c) 2021 CEA
 * This program and the accompanying materials are made available under the
 * terms of the Eclipse Public License 2.0 which is available at
 * http://www.eclipse.org/legal/epl-2.0.
 *
 * SPDX-License-Identifier: EPL-2.0
 * Contributors: see AUTHORS file
 *******************************************************************************/
package fr.cea.nabla.ui

import org.eclipse.xtext.ui.editor.autoedit.DefaultAutoEditStrategyProvider

/**
 * Just to stop the bracket completion in case of a loop with a range like [n;m[
 */
class NablaAutoEditStrategyProvider extends DefaultAutoEditStrategyProvider
{
	protected override configure(IEditStrategyAcceptor acceptor)
	{
		configureIndentationEditStrategy(acceptor)
		configureStringLiteral(acceptor)
		configureParenthesis(acceptor)
		configureSquareBrackets(acceptor)
		configureCurlyBracesBlock(acceptor)
		configureMultilineComments(acceptor)
//		configureCompoundBracesBlocks(acceptor)
	}
}