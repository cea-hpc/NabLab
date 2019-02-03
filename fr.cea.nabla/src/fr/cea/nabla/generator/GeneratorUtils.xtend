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
package fr.cea.nabla.generator

import java.io.IOException
import java.io.InputStreamReader
import java.net.URL
import java.nio.charset.Charset
import java.util.Properties
import org.eclipse.emf.ecore.xmi.XMLResource
import org.eclipse.xtext.resource.SaveOptions

class GeneratorUtils 
{
	def getXmlSaveOptions()
	{
		val builder = SaveOptions::newBuilder 
		builder.format
		val so = builder.options.toOptionsMap
		so.put(XMLResource::OPTION_LINE_WIDTH, 160)
		return so
	}
	
	def getProperties(String uri)
	{
		val props = new Properties
		val url = new URL(uri)
		try 
		{
			val inputStream = url.openConnection().getInputStream()
			props.load(new InputStreamReader(inputStream, Charset.forName('UTF-8')))
			inputStream.close		
		}
		catch (IOException e)
		{
			// pas de fichier => rien à faire
		}
		return props		
	}
}