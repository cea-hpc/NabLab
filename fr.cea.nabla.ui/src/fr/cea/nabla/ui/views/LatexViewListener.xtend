package fr.cea.nabla.ui.views

import com.google.inject.Inject
import fr.cea.nabla.generator.ir.IrAnnotationHelper
import fr.cea.nabla.ir.ir.IrAnnotable
import fr.cea.nabla.nabla.Instruction
import fr.cea.nabla.nabla.Job
import fr.cea.nabla.ui.NablaDslEditor
import fr.cea.nabla.ui.internal.NablaActivator
import java.util.ArrayList
import org.eclipse.emf.ecore.EObject
import org.eclipse.gmf.runtime.diagram.ui.editparts.GraphicalEditPart
import org.eclipse.jface.text.TextSelection
import org.eclipse.jface.viewers.ISelection
import org.eclipse.jface.viewers.StructuredSelection
import org.eclipse.sirius.diagram.DDiagramElement
import org.eclipse.sirius.diagram.ui.tools.api.editor.DDiagramEditor
import org.eclipse.ui.ISelectionListener
import org.eclipse.ui.IWorkbenchPart
import org.eclipse.ui.PlatformUI
import org.eclipse.xtext.resource.EObjectAtOffsetHelper
import org.eclipse.xtext.ui.editor.XtextEditor

class LatexViewListener implements ISelectionListener
{
	@Inject EObjectAtOffsetHelper eObjectAtOffsetHelper
	@Inject extension IrAnnotationHelper
	
	val modelListeners = new ArrayList<(EObject)=>void> 

	def void addNablaTextListener((EObject)=>void f)
	{
		modelListeners += f
	}
	
	/**
	 * Si la selection a lieu dans l'editeur Nabla, on recupere le modele associe
	 * et on l'affecte au viewer de la vue si ce modele est de type Diagram
	 * et que ce n'est pas deja  le diagramme affichee dans la vue.
	 * Attention : on compare les noms des diagrammes et pas les objets car Xtext
	 * peut recreer les objets avec la compilation et il faut eviter de recreer 
	 * la vue graphique.
	 */
	override selectionChanged(IWorkbenchPart part, ISelection selection) 
	{
		if (selection instanceof StructuredSelection && part instanceof DDiagramEditor)
		{
			val structuredSelection = selection as StructuredSelection
			if (structuredSelection.firstElement instanceof GraphicalEditPart)
			{
				val gep = structuredSelection.firstElement as GraphicalEditPart
				val semanticElement = gep.resolveSemanticElement
				
				if (semanticElement instanceof DDiagramElement)
				{
					val irElement = (semanticElement as DDiagramElement).target
					if (irElement instanceof IrAnnotable)
					{
						val annotable = irElement as IrAnnotable
						val annotation = annotable.annotations.findFirst[x | x.source == IrAnnotationHelper::ANNOTATION_NABLA_ORIGIN_SOURCE]
						if (annotation !== null)
						{
							val offset = Integer::parseInt(annotation.details.get(IrAnnotationHelper::ANNOTATION_OFFSET_DETAIL))
							val length = Integer::parseInt(annotation.details.get(IrAnnotationHelper::ANNOTATION_LENGTH_DETAIL))
							val uri = irElement.uriDetail
							val w = PlatformUI::workbench.activeWorkbenchWindow
							if (uri !== null && w!==null && w.activePage!==null)
							{
								for (er : w.activePage.editorReferences)
								{
									val editor = er.getEditor(false)
									if (editor!==null && editor instanceof NablaDslEditor && uri.endsWith(er.name))
									{
										val nablaEditor = editor as NablaDslEditor
										nablaEditor.selectAndReveal(offset, length)
										getObjectAndFireNotification(nablaEditor, offset)
									}
								}
							}
						}
					}
				}
			}
		}
		else if (selection instanceof TextSelection && part instanceof XtextEditor)
		{
			val xtextEditor = part as XtextEditor
			val textSelection = selection as TextSelection
			if (xtextEditor.languageName == NablaActivator::FR_CEA_NABLA_NABLA)
				getObjectAndFireNotification(xtextEditor, textSelection.offset)
		}
	}
	
	private def getObjectAndFireNotification(XtextEditor editor, int offset)
	{
		val obj = editor.document.readOnly([state | eObjectAtOffsetHelper.resolveContainedElementAt(state, offset)])
		val nablaElt = obj.jobOrInstruction
		if (nablaElt !== null) modelListeners.forEach[x | x.apply(nablaElt)]
	}
	
	private def EObject getJobOrInstruction(EObject elt)
	{
		switch elt
		{
			Job : elt
			Instruction : elt
			default : if (elt.eContainer === null) null else elt.eContainer.jobOrInstruction
		}
	}
}