/*******************************************************************************
 * Copyright (c) 2021 CEA
 * This program and the accompanying materials are made available under the
 * terms of the Eclipse Public License 2.0 which is available at
 * http://www.eclipse.org/legal/epl-2.0.
 *
 * SPDX-License-Identifier: EPL-2.0
 * Contributors: see AUTHORS file
 *******************************************************************************/
package fr.cea.nabla.ui.hovers

import org.eclipse.emf.ecore.EObject
import org.eclipse.xtext.documentation.impl.MultiLineCommentDocumentationProvider

import static extension fr.cea.nabla.LatexImageServices.*

class NablaEObjectDocumentationProvider extends MultiLineCommentDocumentationProvider
{
	override getDocumentation(EObject o)
	{
		super.getDocumentation(o).interpretLatexInsertions
	}
}