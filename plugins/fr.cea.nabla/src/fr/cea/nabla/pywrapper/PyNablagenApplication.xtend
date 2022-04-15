/*******************************************************************************
 * Copyright (c) 2022 CEA
 * This program and the accompanying materials are made available under the
 * terms of the Eclipse Public License 2.0 which is available at
 * http://www.eclipse.org/legal/epl-2.0.
 *
 * SPDX-License-Identifier: EPL-2.0
 * Contributors: see AUTHORS file
 *******************************************************************************/
package fr.cea.nabla.pywrapper

import com.google.inject.Inject
import com.google.inject.Provider
import fr.cea.nabla.NablagenStandaloneSetup
import fr.cea.nabla.generator.CodeGenerator
import fr.cea.nabla.generator.NablaGeneratorMessageDispatcher.MessageType
import fr.cea.nabla.ir.IrUtils
import fr.cea.nabla.nablagen.NablagenApplication
import java.util.ArrayList
import org.eclipse.emf.common.util.URI
import org.eclipse.emf.ecore.resource.ResourceSet
import org.eclipse.emf.ecore.util.EcoreUtil

class PyNablagenApplication
{
	@Inject Provider<ResourceSet> resourceSetProvider;
	@Inject Provider<CodeGenerator> applicationGeneratorProvider

	String wsPath
	String ngenUri
	val neededURI = new ArrayList<String>

	val (MessageType, String)=>void traceFunction = [MessageType type, String msg |
		switch type
		{
			case MessageType.Start: println(msg)
			case MessageType.End: println(msg)
			case MessageType.Exec: println(msg)
			default: System.err.println(msg)
		}
	]

	static def PyNablagenApplication create(String wsPath, String ngenUri)
	{
		val injector = NablagenStandaloneSetup.doSetup
		val app = injector.getInstance(PyNablagenApplication)
		app.wsPath = wsPath
		app.ngenUri = ngenUri
		return app
	}

	def void addNeededUri(String uriValue)
	{
		neededURI += uriValue
	}

	def void generate(String projectName)
	{
		val rs = resourceSetProvider.get

		// Configuring resource set
		println("Starting generation process for: " + ngenUri)
		println("Loading resources (.n and .ngen)")
		val ngenResource = rs.createResource(URI.createURI(ngenUri))
		for (d : neededURI.filter[x | x.toString != ngenUri])
		{
			val resource = rs.createResource(URI.createURI(d))
			println("   Loading resource: " + d)
			resource.load(null)
		}
		EcoreUtil.resolveAll(rs)
		ngenResource.load(null)
		val ngen = ngenResource.contents.filter(NablagenApplication).head

		// Generating
		val generator = applicationGeneratorProvider.get

		try
		{
			generator.dispatcher.traceListeners += traceFunction
			generator.generateCode(ngen, wsPath, projectName)
			println("Generation ended successfully for: " + ngenUri)
		}
		catch (Exception e)
		{
			System.err.println("Generation failed for: " + ngenUri)
			System.err.println(e.message)
			System.err.println(IrUtils.getStackTrace(e))
		}
		finally
		{
			generator.dispatcher.traceListeners -= traceFunction
		}
	}
}