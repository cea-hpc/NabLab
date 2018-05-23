package fr.cea.nabla.ui.views

import com.google.inject.Inject
import fr.cea.nabla.LatexImageServices
import fr.cea.nabla.LatexLabelServices
import java.io.ByteArrayInputStream
import org.eclipse.emf.ecore.EObject
import org.eclipse.swt.SWT
import org.eclipse.swt.graphics.Image
import org.eclipse.swt.widgets.Composite
import org.eclipse.swt.widgets.Display
import org.eclipse.swt.widgets.Label
import org.eclipse.ui.part.ViewPart

class LatexView extends ViewPart
{
	@Inject LatexViewListener listener
	Label label
	
	override createPartControl(Composite parent) 
	{
		label = new Label(parent, SWT.NONE)
		
		// reaction a la selection dans l'editeur ou dans l'outline 
		listener.addNablaTextListener([x | label.image = x.latexImage])
		site.page.addPostSelectionListener(listener)
	}
	
	override setFocus() 
	{
		label.setFocus
	}
	
	private def getLatexImage(EObject element)
	{
		val latexLabel = LatexLabelServices.getLatex(element)
		if (latexLabel !== null) 
		{
			val image = LatexImageServices.createPngImage(latexLabel, 25)
			val swtImage = new Image(Display.^default, new ByteArrayInputStream(image))
			return swtImage
		}
		else return null
	}
}