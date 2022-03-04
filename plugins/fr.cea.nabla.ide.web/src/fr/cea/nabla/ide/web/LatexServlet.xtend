/*******************************************************************************
 * Copyright (c) 2021 CEA
 * This program and the accompanying materials are made available under the
 * terms of the Eclipse Public License 2.0 which is available at
 * http://www.eclipse.org/legal/epl-2.0.
 *
 * SPDX-License-Identifier: EPL-2.0
 * Contributors: see AUTHORS file
 *******************************************************************************/
package fr.cea.nabla.ide.web

import com.google.gson.GsonBuilder
import fr.cea.nabla.LatexImageServices
import fr.cea.nabla.LatexLabelServices
import java.awt.Color
import java.io.BufferedInputStream
import java.io.BufferedOutputStream
import java.io.ByteArrayInputStream
import java.io.Closeable
import java.io.IOException
import java.io.InputStream
import java.util.stream.Collectors
import javax.servlet.ServletException
import javax.servlet.http.HttpServlet
import javax.servlet.http.HttpServletRequest
import javax.servlet.http.HttpServletResponse
import org.eclipse.emf.common.util.URI
import org.eclipse.xtext.resource.EObjectAtOffsetHelper
import org.eclipse.xtext.resource.XtextResource
import org.eclipse.emf.ecore.EObject

class LatexServlet extends HttpServlet
{
	static final long serialVersionUID = 1L
	static final int DEFAULT_BUFFER_SIZE = 10240
	EObjectAtOffsetHelper eObjectAtOffsetHelper
	NabLabLanguageServer languageServer

	new(EObjectAtOffsetHelper eObjectAtOffsetHelper, NabLabLanguageServer languageServer)
	{
		this.eObjectAtOffsetHelper = eObjectAtOffsetHelper
		this.languageServer = languageServer
	}

	override protected void doPost(HttpServletRequest request,
		HttpServletResponse response) throws ServletException, IOException
	{
		val requestBody = request.reader.lines().collect(Collectors.joining(System.lineSeparator()))
		val gson = new GsonBuilder().create()
		val latexObject = gson.fromJson(requestBody, LatexHttpObject)
		if (latexObject !== null)
		{
			val uri = URI.createURI(URI.decode(latexObject.nablaModelPath))
			val displayableObject = languageServer.workspaceManager.<EObject>doRead(uri, 
				[document, resource | getObjectAtPosition(resource, latexObject.offset)])
			if (displayableObject !== null)
			{
				val latexFormula = LatexLabelServices.getLatex(displayableObject)
				val formulaColor = Color.decode(latexObject.formulaColor);
				val bufferedImage = LatexImageServices.createPngImage(latexFormula, 30, formulaColor)
				response.reset()
				response.setStatus(HttpServletResponse.SC_OK)
				response.setBufferSize(DEFAULT_BUFFER_SIZE)
				response.setContentType("image/png")
				response.setHeader("Access-Control-Allow-Origin", "*")
				var BufferedInputStream input = null
				var BufferedOutputStream output = null
				try
				{
					var InputStream is = new ByteArrayInputStream(bufferedImage)
					input = new BufferedInputStream(is, DEFAULT_BUFFER_SIZE)
					output = new BufferedOutputStream(response.outputStream, DEFAULT_BUFFER_SIZE)
					var byte[] buffer = newByteArrayOfSize(DEFAULT_BUFFER_SIZE)
					var int length
					while ((length = input.read(buffer)) > 0)
					{
						output.write(buffer, 0, length)
					}
				}
				finally
				{
					close(output)
					close(input)
				}
			}
		}
	}

	def private static void close(Closeable resource)
	{
		if (resource !== null)
		{
			try
			{
				resource.close()
			}
			catch (IOException e)
			{
				e.printStackTrace()
			}
		}
	}
	
	def private EObject getObjectAtPosition(XtextResource resource, int offset)
	{
		val selectedObject = this.eObjectAtOffsetHelper.resolveContainedElementAt(resource, offset)
		if (selectedObject !== null)
		{
			return LatexLabelServices.getClosestDisplayableNablaElt(selectedObject)
		}
		return null
	}
}
