/*******************************************************************************
 * Copyright (c) 2020 CEA
 * This program and the accompanying materials are made available under the 
 * terms of the Eclipse Public License 2.0 which is available at
 * http://www.eclipse.org/legal/epl-2.0.
 *
 * SPDX-License-Identifier: EPL-2.0
 * Contributors: see AUTHORS file
 *******************************************************************************/
package fr.cea.nabla

import java.awt.Color
import java.awt.image.BufferedImage
import java.io.ByteArrayOutputStream
import java.util.regex.Pattern
import javax.imageio.ImageIO
import org.scilab.forge.jlatexmath.TeXConstants
import org.scilab.forge.jlatexmath.TeXFormula

class LatexImageServices
{
	/** Extract LaTeX formula (between '$') from the documentation and replace them by images */
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

	/** Return an HTML image from a LaTeX formula between '$' characters */
	static def String createHtmlBase64Image(String texFormula)
	{
		val output = new ByteArrayOutputStream
		ImageIO::write(texFormula.createImage(15, null), "png", output)
		val outputString = new String(output.toByteArray, "UTF-8");
		outputString.addHtmlTags
	}

	/** Build a png image from a LaTeX formula between '$' characters */
	static def byte[] createPngImage(String texFormula, float size, Color color)
	{
		val output = new ByteArrayOutputStream
		ImageIO::write(texFormula.createImage(size, color), "png", output)
		output.toByteArray
	}

	/** Remove '$' chars around LaTeX formula */
	private static def String removeDollars(String texFormulaWithDollars)
	{
		val l = texFormulaWithDollars.length
		if (texFormulaWithDollars.startsWith('$') && texFormulaWithDollars.endsWith('$') && l > 1)
			texFormulaWithDollars.substring(1, l-1)
	}

	/** Retuen a BufferedImage instance from a LaTeX (without '$' characters) */
	private static def BufferedImage createImage(String texFormula, float size, Color color)
	{
		val formula = new TeXFormula(texFormula)
		val icon = formula.createTeXIcon(TeXConstants::STYLE_DISPLAY, size)
		if (color !== null) icon.foreground = color
		val b = new BufferedImage(icon.iconWidth, icon.iconHeight, BufferedImage::TYPE_4BYTE_ABGR)
		icon.paintIcon(null, b.graphics, 0, 0)
		return b
	}

	private static def String addHtmlTags(String base64Encoding)
	'''<img src="data:image/png;base64,«base64Encoding»"/>'''
}