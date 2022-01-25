/*******************************************************************************
 * Copyright (c) 2022 CEA
 * This program and the accompanying materials are made available under the
 * terms of the Eclipse Public License 2.0 which is available at
 * http://www.eclipse.org/legal/epl-2.0.
 *
 * SPDX-License-Identifier: EPL-2.0
 * Contributors: see AUTHORS file
 *******************************************************************************/
package fr.cea.nabla.generator

import fr.cea.nabla.ir.ir.IrRoot
import org.eclipse.emf.ecore.resource.impl.ResourceSetImpl
import org.eclipse.emf.ecore.xmi.XMLResource
import org.eclipse.emf.ecore.xmi.impl.XMIResourceFactoryImpl
import org.eclipse.xtext.generator.IFileSystemAccess2
import org.eclipse.xtext.resource.SaveOptions

class NablaIrWriter
{
	public static val IrExtension = 'nir'

	def createAndSaveResource(IFileSystemAccess2 fsa, IrRoot ir)
	{
		val fileName = ir.name.toLowerCase + '/' + ir.name + '.' + IrExtension
		val uri =  fsa.getURI(fileName)
		val rSet = new ResourceSetImpl
		rSet.resourceFactoryRegistry.extensionToFactoryMap.put(IrExtension, new XMIResourceFactoryImpl)

		val resource = rSet.createResource(uri)
		resource.contents += ir
		resource.save(xmlSaveOptions)
		return fileName
	}

	private def getXmlSaveOptions()
	{
		val builder = SaveOptions::newBuilder
		builder.format
		val so = builder.options.toOptionsMap
		so.put(XMLResource::OPTION_LINE_WIDTH, 160)
		return so
	}
}