/*******************************************************************************
 * Copyright (c) 2018 CEA
 * This program and the accompanying materials are made available under the 
 * terms of the Eclipse Public License 2.0 which is available at
 * http://www.eclipse.org/legal/epl-2.0.
 *
 * SPDX-License-Identifier: EPL-2.0
 * Contributors: see AUTHORS file
 *******************************************************************************/
package fr.cea.nabla.ui

import org.eclipse.xtext.ui.editor.XtextEditor

class NablaDslEditor extends XtextEditor 
{
//	val listener = new NablaDslListener(this)
//	
//	override createPartControl(Composite parent)
//	{
//		super.createPartControl(parent)
//		site.page.addPostSelectionListener(listener)
//	}
//	
//	override dispose()
//	{
//		site.page.removePostSelectionListener(listener)
//	}
}

//class NablaDslListener implements ISelectionListener
//{
//	val locationProvider = new DefaultLocationInFileProvider
//	val NablaDslEditor editor
//	
//	new(NablaDslEditor editor) { this.editor = editor }
//	
//	override selectionChanged(IWorkbenchPart part, ISelection selection) 
//	{
//		val modelObject = selection.modelObject
//		
//		//println("  MODEL OBJECT : " + modelObject.class.name + " - " + modelObject)
//		if (modelObject !== null && modelObject instanceof EObject) 
//			openInDslEditor(modelObject as EObject)
//	}
//	
//	private def getModelObject(ISelection selection)
//	{
//		//println("selection : " + selection.class.name)
//		if (selection instanceof IStructuredSelection)
//		{
//			val firstElement = (selection as IStructuredSelection).firstElement
//			if (firstElement instanceof IGraphicalEditPart)
//			{
//				val se = (firstElement as IGraphicalEditPart).resolveSemanticElement
//				if (se instanceof DRepresentationElement)
//					return (se as DRepresentationElement).semanticElements.head
//			} 
//		}
//		return null
//	}
//
//	/** 
//	 * Cette m�thode ne doit pas ouvrir un nouvel �diteur ; cette action est laiss�e au double clic.
//	 * L'objectif est juste de s�lectionner l'EObject param�tre s'il se trouve dans le fichier.
//	 */
//	private def void openInDslEditor(EObject any) 
//	{
//		val anyUri = any.eResource.URI.toPlatformString(true)
//		val editorResourceUri = editor.resource.fullPath.toString
//		if (any !== null && anyUri == editorResourceUri)
//		{
//			val region = locationProvider.getFullTextRegion(any)
//			// On pr�f�re ne pas s�lectionner l'objet mais seulement se mettre au d�but.
//			//editor.selectAndReveal(region.offset, region.length)	
//			editor.selectAndReveal(region.offset, 0)	
//		}
//		else
//			editor.selectAndReveal(0,0)
//	}
//}