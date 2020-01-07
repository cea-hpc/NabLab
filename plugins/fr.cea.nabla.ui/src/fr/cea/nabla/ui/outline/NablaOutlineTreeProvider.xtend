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

import fr.cea.nabla.nabla.If
import fr.cea.nabla.nabla.Instruction
import fr.cea.nabla.nabla.InstructionBlock
import fr.cea.nabla.nabla.Job
import fr.cea.nabla.nabla.Loop
import fr.cea.nabla.nabla.NablaModule
import java.util.List
import org.eclipse.xtext.ui.editor.outline.IOutlineNode
import org.eclipse.xtext.ui.editor.outline.impl.DefaultOutlineTreeProvider
import org.eclipse.xtext.ui.editor.outline.impl.DocumentRootNode

import static extension fr.cea.nabla.LabelServices.*
import fr.cea.nabla.nabla.Function
import fr.cea.nabla.nabla.Reduction

/**
 * Customization of the default outline structure.
 *
 * See https://www.eclipse.org/Xtext/documentation/304_ide_concepts.html#outline
 */
class NablaOutlineTreeProvider extends DefaultOutlineTreeProvider 
{
	def _isLeaf(Instruction it) 
	{ 
		switch it
		{
			InstructionBlock, If : false
			Loop : !eAllContents.exists[x|x instanceof InstructionBlock || x instanceof If]
			default : true
		}
	}

	def _isLeaf(Function it) { body === null }
	def _isLeaf(Reduction it) { true }

	/** 
	 * Des essais int ete realises pour afficher une image SWT de la formule 
	 * Latex mais le rendu dans l'outline n'est pas satisfaisant.
	 */
	def _image(Instruction it) { null }
	def _image(Job it) { null }
	def _image(Function it) { null }
	def _image(Reduction it) { null }

	/** 
	 * La police de l'outline a des problemes d'affichage.
	 * Des essais ont ete realises avec des TextStyle. Aucun effet...
	 */
	def _text(Instruction it) 
	{ 
		if (it === null) return null // ca arrive !
		
		val c = eContainer
		switch c
		{
			If case c.then == it : 'then ' + label
			If case c.^else == it : 'else ' + label
			default: label
		}
	}

	def _text(Function it) { label }
	def _text(Reduction it) { label }

	def _createChildren(DocumentRootNode parentNode, NablaModule it) 
	{
		functions.forEach[x | createNode(parentNode, x)]
		reductions.forEach[x | createNode(parentNode, x)]
		jobs.forEach[x | createNode(parentNode, x)]
	}

	def _createChildren(IOutlineNode parentNode, Function it) 
	{
		if (body !== null) body.findChildren.forEach[x | createNode(parentNode, x)]
	}

	def _createChildren(IOutlineNode parentNode, Instruction it) 
	{
		findChildren.forEach[x | createNode(parentNode, x)]
	}

	private def List<Instruction> findChildren(Instruction it)
	{
		switch(it)
		{
			If : #[then, ^else]
			InstructionBlock: instructions
			Loop: body.findChildren
			default: #[]
		}
	}
}
