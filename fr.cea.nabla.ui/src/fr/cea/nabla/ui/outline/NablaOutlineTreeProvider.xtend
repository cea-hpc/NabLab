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
package fr.cea.nabla.ui.outline

import fr.cea.nabla.nabla.If
import fr.cea.nabla.nabla.Instruction
import fr.cea.nabla.nabla.InstructionBlock
import fr.cea.nabla.nabla.Job
import fr.cea.nabla.nabla.Loop
import fr.cea.nabla.nabla.NablaModule
import fr.cea.nabla.nabla.TimeLoopJob
import java.util.List
import org.eclipse.xtext.ui.editor.outline.IOutlineNode
import org.eclipse.xtext.ui.editor.outline.impl.DefaultOutlineTreeProvider
import org.eclipse.xtext.ui.editor.outline.impl.DocumentRootNode

import static extension fr.cea.nabla.LabelServices.*

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
	
	/** 
	 * Des essais int �t� r�alis�s pour afficher une image SWT de la formule 
	 * Latex mais le rendu dans l'outline n'est pas satisfaisant.
	 */
	def _image(Instruction it) { null }
	def _image(Job it) { null }
	
	/** 
	 * La police de l'outline a des probl�mes d'affichage.
	 * Des essais ont �t� r�alis�s avec des TextStyle. Aucun effet...
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

	def _createChildren(DocumentRootNode parentNode, NablaModule it) 
	{
		jobs.forEach[x | createNode(parentNode, x)]
	}

	def _createChildren(IOutlineNode parentNode, Instruction it) 
	{
		findChildren.forEach[x | createNode(parentNode, x)]
	}
	
	// Evite d'avoir le n qui s'affiche...
	def _createChildren(IOutlineNode parentNode, TimeLoopJob it) 
	{
		createNode(parentNode, initialization)
		createNode(parentNode, body)
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
