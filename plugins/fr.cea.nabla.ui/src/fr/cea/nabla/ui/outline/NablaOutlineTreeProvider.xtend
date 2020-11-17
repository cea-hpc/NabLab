/*******************************************************************************
 * Copyright (c) 2020 CEA
 * This program and the accompanying materials are made available under the 
 * terms of the Eclipse Public License 2.0 which is available at
 * http://www.eclipse.org/legal/epl-2.0.
 *
 * SPDX-License-Identifier: EPL-2.0
 * Contributors: see AUTHORS file
 *******************************************************************************/
package fr.cea.nabla.ui.outline

import fr.cea.nabla.nabla.Function
import fr.cea.nabla.nabla.Job
import fr.cea.nabla.nabla.NablaModule
import fr.cea.nabla.nabla.Reduction
import org.eclipse.xtext.ui.editor.outline.impl.DefaultOutlineTreeProvider
import org.eclipse.xtext.ui.editor.outline.impl.DocumentRootNode

/**
 * Customization of the default outline structure.
 *
 * See https://www.eclipse.org/Xtext/documentation/304_ide_concepts.html#outline
 */
class NablaOutlineTreeProvider extends DefaultOutlineTreeProvider
{
	def _isLeaf(NablaModule it) { true }
	def _isLeaf(Function it) { true }
	def _isLeaf(Reduction it) { true }
	def _isLeaf(Job it) { true }

	def _image(Function it) { null }
	def _image(Reduction it) { null }
	def _image(Job it) { null }

	def _text(NablaModule it) { 'Module ' + name }
	def _text(Function it) { 'Function ' + name }
	def _text(Reduction it) { 'Reduction ' + name }
	def _text(Job it) { 'Job ' + name }

	def _createChildren(DocumentRootNode parentNode, NablaModule it)
	{
		createNode(parentNode, it)
		functions.forEach[x | createNode(parentNode, x)]
		reductions.forEach[x | createNode(parentNode, x)]
		jobs.forEach[x | createNode(parentNode, x)]
	}
}
