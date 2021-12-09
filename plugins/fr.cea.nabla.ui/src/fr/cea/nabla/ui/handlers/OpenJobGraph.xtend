/*******************************************************************************
 * Copyright (c) 2022 CEA
 * This program and the accompanying materials are made available under the
 * terms of the Eclipse Public License 2.0 which is available at
 * http://www.eclipse.org/legal/epl-2.0.
 *
 * SPDX-License-Identifier: EPL-2.0
 * Contributors: see AUTHORS file
 *******************************************************************************/
package fr.cea.nabla.ui.handlers

import com.google.inject.Inject
import com.google.inject.Provider
import fr.cea.nabla.generator.NablaGeneratorMessageDispatcher.MessageType
import fr.cea.nabla.generator.ir.IrRootBuilder
import fr.cea.nabla.ir.ir.IrRoot
import fr.cea.nabla.nablagen.NablagenApplication
import fr.cea.nabla.ui.console.NabLabConsoleFactory
import fr.cea.nabla.ui.internal.NablaActivator
import java.util.Collections
import org.eclipse.core.commands.AbstractHandler
import org.eclipse.core.commands.ExecutionEvent
import org.eclipse.core.commands.ExecutionException
import org.eclipse.emf.common.util.URI
import org.eclipse.emf.ecore.resource.ResourceSet
import org.eclipse.emf.ecore.util.EcoreUtil
import org.eclipse.jface.text.TextSelection
import org.eclipse.ui.PlatformUI
import org.eclipse.xtext.EcoreUtil2
import org.eclipse.xtext.resource.EObjectAtOffsetHelper
import org.eclipse.xtext.ui.editor.XtextEditor

abstract class OpenJobGraph extends AbstractHandler
{
	@Inject NabLabConsoleFactory consoleFactory
	@Inject IrRootBuilder irRootBuilder
	@Inject Provider<ResourceSet> resourceSetProvider
	@Inject EObjectAtOffsetHelper eObjectAtOffsetHelper

	override execute(ExecutionEvent event) throws ExecutionException
	{
		val window = PlatformUI.workbench.activeWorkbenchWindow
		if (window !== null && window.activePage !== null)
		{
			val editor = window.activePage.activeEditor
			if (editor !== null && editor instanceof XtextEditor)
			{
				val xtextEditor = editor as XtextEditor
				if (xtextEditor.languageName == NablaActivator.FR_CEA_NABLA_NABLAGEN)
				{
					val selection = xtextEditor.selectionProvider.selection
					if (selection !== null && selection instanceof TextSelection)
					{
						val textSelection = selection as TextSelection
						val selectedNablagenObject = xtextEditor.document.readOnly([state | eObjectAtOffsetHelper.resolveContainedElementAt(state, textSelection.offset)])
						if (selectedNablagenObject !== null)
						{
							val ngenApp = EcoreUtil2.getContainerOfType(selectedNablagenObject, NablagenApplication)
							if (ngenApp !== null)
							{
								// object is reloaded in a private resourceSet to ensure a complete creation
								val resourceSet = resourceSetProvider.get
								val uriMap = resourceSet.URIConverter.URIMap
								uriMap.put(	URI::createURI('platform:/resource/fr.cea.nabla/'), URI::createURI('platform:/plugin/fr.cea.nabla/'))
								val emfResource = resourceSet.createResource(ngenApp.eResource.URI)
								EcoreUtil::resolveAll(resourceSet)
								emfResource.load(null)
								val ngen = emfResource.contents.filter(NablagenApplication).head
								val ir = buildIrFrom(ngen)
								var resource = resourceSet.createResource(URI.createFileURI("/Users/arichard/tmp/ExplicitHeatEquation.ir"));
								resource.getContents().add(ir);
								resource.save(Collections.EMPTY_MAP);
								displayIr(ir)
							}
						}
					}
				}
			}
		}
		return null
	}

	private def IrRoot buildIrFrom(NablagenApplication ngenApp)
	{
		val start = System.nanoTime()
		var IrRoot ir = null
		consoleFactory.printConsole(MessageType.Start, "Building IR to initialize job graph editor")

		try
		{
			ir = irRootBuilder.buildGeneratorGenericIr(ngenApp)
		}
		catch (Exception e)
		{
			consoleFactory.printConsole(MessageType.Error, e.message)
			// An exception can occured during IR building if environment is not configured,
			// for example compilation not done, or during transformation step. Whatever... 
			// irModule stays null. Error message printed below.
		}

		val stop = System.nanoTime()
		consoleFactory.printConsole(MessageType.End, "IR converted (" + ((stop - start) / 1000000) + " ms)")

		if (ir === null)
			consoleFactory.printConsole(MessageType.Error, "IR module can not be built. Try to clean and rebuild all projects and start again.")

		return ir
	}

	protected def getConsoleFactory() { consoleFactory }
	protected abstract def void displayIr(IrRoot ir)
}

