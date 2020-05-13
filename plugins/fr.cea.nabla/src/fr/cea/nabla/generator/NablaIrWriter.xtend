/*******************************************************************************
 * Copyright (c) 2020 CEA
 * This program and the accompanying materials are made available under the 
 * terms of the Eclipse Public License 2.0 which is available at
 * http://www.eclipse.org/legal/epl-2.0.
 *
 * SPDX-License-Identifier: EPL-2.0
 * Contributors: see AUTHORS file
 *******************************************************************************/
package fr.cea.nabla.generator

import com.google.inject.Inject
import fr.cea.nabla.ir.ir.IrModule
import org.eclipse.emf.ecore.resource.impl.ResourceSetImpl
import org.eclipse.emf.ecore.xmi.XMLResource
import org.eclipse.emf.ecore.xmi.impl.XMIResourceFactoryImpl
import org.eclipse.xtext.generator.IFileSystemAccess2
import org.eclipse.xtext.resource.SaveOptions

class NablaIrWriter
{
	static val IrExtension = 'nablair'
	@Inject NablaGeneratorMessageDispatcher dispatcher

	def createAndSaveResource(IFileSystemAccess2 fsa, IrModule irModule)
	{
		dispatcher.post('Writing nablair file')
		val fileName = irModule.name.toLowerCase + '/' + irModule.name + '.' + IrExtension
		val uri =  fsa.getURI(fileName)
		val rSet = new ResourceSetImpl
		rSet.resourceFactoryRegistry.extensionToFactoryMap.put(IrExtension, new XMIResourceFactoryImpl)

		val resource = rSet.createResource(uri)
		resource.contents += irModule
		resource.save(xmlSaveOptions)
		dispatcher.post('... ok\n')
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