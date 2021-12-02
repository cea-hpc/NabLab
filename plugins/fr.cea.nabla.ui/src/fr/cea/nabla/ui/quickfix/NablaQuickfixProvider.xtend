/*******************************************************************************
 * Copyright (c) 2021 CEA
 * This program and the accompanying materials are made available under the
 * terms of the Eclipse Public License 2.0 which is available at
 * http://www.eclipse.org/legal/epl-2.0.
 *
 * SPDX-License-Identifier: EPL-2.0
 * Contributors: see AUTHORS file
 *******************************************************************************/
package fr.cea.nabla.ui.quickfix

import org.eclipse.xtext.ui.editor.quickfix.DefaultQuickfixProvider

/**
 * Custom quickfixes.
 *
 * See https://www.eclipse.org/Xtext/documentation/304_ide_concepts.html#quick-fixes
 */
class NablaQuickfixProvider extends DefaultQuickfixProvider
{
//	@Fix(NablaValidator.INVALID_NAME)
//	def capitalizeName(Issue issue, IssueResolutionAcceptor acceptor) {
//		acceptor.accept(issue, 'Capitalize name', 'Capitalize the name.', 'upcase.png') [
//			context |
//			val xtextDocument = context.xtextDocument
//			val firstLetter = xtextDocument.get(issue.offset, 1)
//			xtextDocument.replace(issue.offset, 1, firstLetter.toUpperCase)
//		]
//	}

// todo : A finir
//	@Fix(NablaValidator.MISSING_MANDATORY_OPTION)
//	def addMandatoryOptions(Issue issue, IssueResolutionAcceptor acceptor) {
//		acceptor.accept(issue, 'Add mandatory options', 'Add mandatory options.', null) 
//		[element, context |
//		]
//	}
}
