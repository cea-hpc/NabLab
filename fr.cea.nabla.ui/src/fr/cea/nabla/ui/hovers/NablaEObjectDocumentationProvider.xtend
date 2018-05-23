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