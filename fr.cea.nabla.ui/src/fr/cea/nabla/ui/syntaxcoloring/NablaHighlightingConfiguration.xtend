package fr.cea.nabla.ui.syntaxcoloring

import org.eclipse.swt.SWT
import org.eclipse.swt.graphics.FontData
import org.eclipse.swt.graphics.RGB
import org.eclipse.xtext.ui.editor.syntaxcoloring.DefaultHighlightingConfiguration
import org.eclipse.xtext.ui.editor.syntaxcoloring.IHighlightingConfigurationAcceptor
import org.eclipse.xtext.ui.editor.utils.TextStyle

class NablaHighlightingConfiguration extends DefaultHighlightingConfiguration 
{
	public static val ID_ID = "ID"
	public static val REAL_ID = "REAL"
	public static val ITERATOR_ID = "Iterator"
	 
	override configure(IHighlightingConfigurationAcceptor acceptor)
	{
		super.configure(acceptor)
		acceptor.acceptDefaultHighlighting(ID_ID, ID_ID, IDTextStyle)
		acceptor.acceptDefaultHighlighting(REAL_ID, REAL_ID, numberTextStyle)
		acceptor.acceptDefaultHighlighting(ITERATOR_ID, ITERATOR_ID, setIteratorTextStyle)
	}
	
	def TextStyle getIDTextStyle()
	{
		val textStyle = new TextStyle
		textStyle.style = SWT::BOLD
		textStyle
	}
	
	def TextStyle getSetIteratorTextStyle()
	{
		val textStyle = new TextStyle
		textStyle.color = new RGB(65,106,203)
		textStyle
	}
	
	override TextStyle keywordTextStyle()
	{
		val textStyle = super.keywordTextStyle
		textStyle.fontData = #[new FontData('Segoe_UI_Symbol', 10, SWT.BOLD)]
		textStyle
	}
}