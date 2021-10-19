/*******************************************************************************
 * Copyright (c) 2021 CEA
 * This program and the accompanying materials are made available under the
 * terms of the Eclipse Public License 2.0 which is available at
 * http://www.eclipse.org/legal/epl-2.0.
 *
 * SPDX-License-Identifier: EPL-2.0
 * Contributors: see AUTHORS file
 *******************************************************************************/
package fr.cea.nabla.ui.outline

import fr.cea.nabla.nabla.Connectivity
import fr.cea.nabla.nabla.DefaultExtension
import fr.cea.nabla.nabla.Function
import fr.cea.nabla.nabla.Job
import fr.cea.nabla.nabla.MeshExtension
import fr.cea.nabla.nabla.NablaExtension
import fr.cea.nabla.nabla.NablaModule
import fr.cea.nabla.nabla.NablaRoot
import fr.cea.nabla.nabla.Reduction
import fr.cea.nabla.ui.NablaUiUtils
import org.eclipse.xtext.ui.editor.outline.impl.DefaultOutlineTreeProvider
import org.eclipse.xtext.ui.editor.outline.impl.DocumentRootNode

/**
 * Customization of the default outline structure.
 *
 * See https://www.eclipse.org/Xtext/documentation/304_ide_concepts.html#outline
 */
class NablaOutlineTreeProvider extends DefaultOutlineTreeProvider
{
	def _isLeaf(NablaRoot it) { true }
	def _isLeaf(Function it) { true }
	def _isLeaf(Reduction it) { true }
	def _isLeaf(Job it) { true }
	def _isLeaf(Connectivity it) { true }

	def _image(NablaRoot it) { NablaUiUtils.createImage('icons/NabLab.gif') }
	def _image(Function it) { null }
	def _image(Reduction it) { null }
	def _image(Job it) { null }
	def _image(Connectivity it) { null }

	def _text(NablaModule it) { 'Module ' + name }
	def _text(NablaExtension it) { 'Extension ' + name }
	def _text(Function it) { 'Function ' + name }
	def _text(Reduction it) { 'Reduction ' + name }
	def _text(Job it) { 'Job ' + name }
	def _text(Connectivity it) { 'Connectivity ' + name }

	def _createChildren(DocumentRootNode parentNode, NablaRoot it)
	{
		createNode(parentNode, it)
		switch it
		{
			NablaModule:
			{
				functions.forEach[x | createNode(parentNode, x)]
				reductions.forEach[x | createNode(parentNode, x)]
				jobs.forEach[x | createNode(parentNode, x)]
			}
			DefaultExtension:
			{
				functions.forEach[x | createNode(parentNode, x)]
				reductions.forEach[x | createNode(parentNode, x)]
			}
			MeshExtension:
			{
				connectivities.forEach[x | createNode(parentNode, x)]
			}
		}
	}
}
