package fr.cea.nabla

import java.awt.image.BufferedImage
import java.io.ByteArrayOutputStream
import java.util.regex.Pattern
import javax.imageio.ImageIO
import javax.xml.bind.DatatypeConverter
import org.scilab.forge.jlatexmath.TeXConstants
import org.scilab.forge.jlatexmath.TeXFormula

class LatexImageServices 
{
	/** Extrait les formules Latex (entourées de '$') de la documentation et les remplaces par des images */
	static def String interpretLatexInsertions(String documentation)
	{
		var transformedDoc = documentation
		if (!documentation.nullOrEmpty)
		{
			val texPattern = Pattern::compile("\\$([^\\$.]*)\\$")
			val texMatcher = texPattern.matcher(documentation)
			while (texMatcher.find())
			{
				val texFormula = removeDollars(texMatcher.group)
				transformedDoc = transformedDoc.replace(texMatcher.group, texFormula.createHtmlBase64Image)
			}
		}
		return transformedDoc	
	}
	
	/** Retourne une image HTML à partir d'une formule Latex (sans les '$') */
	static def String createHtmlBase64Image(String texFormula)
	{
		val output = new ByteArrayOutputStream
		ImageIO::write(texFormula.createImage(15), "png", output)
		DatatypeConverter.printBase64Binary(output.toByteArray).addHtmlTags
	}
	
	/** Fabrique une image png à partir d'une formule Latex */
	static def byte[] createPngImage(String texFormula, float size)
	{
		val output = new ByteArrayOutputStream
		ImageIO::write(texFormula.createImage(size), "png", output)
		output.toByteArray
	}
	
	/** Enlève les '$' autour d'une formule Latex */
	private static def String removeDollars(String texFormulaWithDollars)
	{
		val l = texFormulaWithDollars.length
		if (texFormulaWithDollars.startsWith('$') && texFormulaWithDollars.endsWith('$') && l > 1)
			texFormulaWithDollars.substring(1, l-1)
	}
	
	/** Retourne une instance de BufferedImage à partir d'une formule Latex (sans les '$') */
	private static def BufferedImage createImage(String texFormula, float size)
	{
		val formula = new TeXFormula(texFormula)
		val icon = formula.createTeXIcon(TeXConstants::STYLE_DISPLAY, size)
		val b = new BufferedImage(icon.iconWidth, icon.iconHeight, BufferedImage::TYPE_4BYTE_ABGR)
		icon.paintIcon(null, b.graphics, 0, 0)
		return b
	}
	
	private static def String addHtmlTags(String base64Encoding)
	'''<img src="data:image/png;base64,«base64Encoding»"/>'''
}