/*******************************************************************************
 * Copyright (c) 2020 CEA
 * This program and the accompanying materials are made available under the
 * terms of the Eclipse Public License 2.0 which is available at
 * http://www.eclipse.org/legal/epl-2.0.
 *
 * SPDX-License-Identifier: EPL-2.0
 * Contributors: see AUTHORS file
 *******************************************************************************/
package fr.cea.nabla.ui.views

import com.google.inject.Inject
import com.google.inject.Singleton
import fr.cea.nabla.generator.NablaGeneratorMessageDispatcher.MessageType
import fr.cea.nabla.generator.NablaIrWriter
import fr.cea.nabla.generator.ir.NablagenApplication2Ir
import fr.cea.nabla.ir.ir.IrRoot
import fr.cea.nabla.ir.transformers.CompositeTransformationStep
import fr.cea.nabla.ir.transformers.FillJobHLTs
import fr.cea.nabla.ir.transformers.ReplaceReductions
import fr.cea.nabla.nablagen.NablagenApplication
import fr.cea.nabla.ui.console.NabLabConsoleFactory
import fr.cea.nabla.ui.internal.NablaActivator
import java.io.IOException
import java.util.ArrayList
import java.util.Collections
import javax.inject.Provider
import org.eclipse.core.commands.AbstractHandler
import org.eclipse.core.commands.ExecutionEvent
import org.eclipse.core.commands.ExecutionException
import org.eclipse.core.runtime.NullProgressMonitor
import org.eclipse.emf.common.util.URI
import org.eclipse.emf.ecore.EObject
import org.eclipse.emf.transaction.RecordingCommand
import org.eclipse.jface.text.TextSelection
import org.eclipse.sirius.business.api.componentization.ViewpointRegistry
import org.eclipse.sirius.business.api.dialect.DialectManager
import org.eclipse.sirius.business.api.dialect.command.CreateRepresentationCommand
import org.eclipse.sirius.business.api.query.URIQuery
import org.eclipse.sirius.business.api.session.Session
import org.eclipse.sirius.business.api.session.SessionManager
import org.eclipse.sirius.business.api.session.factory.SessionFactory
import org.eclipse.sirius.ui.business.api.dialect.DialectEditor
import org.eclipse.sirius.ui.business.api.dialect.DialectUIManager
import org.eclipse.sirius.ui.business.api.session.SessionUIManager
import org.eclipse.sirius.ui.business.api.viewpoint.ViewpointSelectionCallback
import org.eclipse.sirius.viewpoint.DRepresentation
import org.eclipse.sirius.viewpoint.description.Viewpoint
import org.eclipse.sirius.viewpoint.provider.SiriusEditPlugin
import org.eclipse.ui.PlatformUI
import org.eclipse.xtext.EcoreUtil2
import org.eclipse.xtext.resource.EObjectAtOffsetHelper
import org.eclipse.xtext.ui.editor.XtextEditor

@Singleton
class OpenSiriusJobsGraph extends AbstractHandler
{
	static val INSTRUCTION_VP = "InstructionViewpoint"
	static val NABLA_IR_DIAGRAM_ID = "NablaIrDiagram"

	@Inject NabLabConsoleFactory consoleFactory
	@Inject EObjectAtOffsetHelper eObjectAtOffsetHelper
	@Inject Provider<NablagenApplication2Ir> ngenApplicationToIrProvider

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
							if (ngenApp !== null) displayIrModuleFrom(ngenApp)
						}
					}
				}
			}
		}
		return null
	}

	def protected void displayIrModuleFrom(NablagenApplication ngenApp)
	{
		val IrRoot irRoot = convertIrModuleFrom(ngenApp)
		if (irRoot !== null)
		{
			val start = System.nanoTime()
			var compactName = irRoot.name.replaceAll("\\s+", "")
			val session = getOrCreateSession(compactName)
			val isNewResource = addOrUpdateResource(session, irRoot, compactName)
			val irRootFromSession = getSemanticRoot(session)
			if (isNewResource)
			{
				selectViewpoint(session, INSTRUCTION_VP)
				createAndOpenRepresentation(session, NABLA_IR_DIAGRAM_ID, irRoot.name, irRootFromSession)
			}
			else
			{
				updateOpenedRepresentation(session, irRootFromSession, irRoot.name)
			}
			val stop = System.nanoTime()
			consoleFactory.printConsole(MessageType.Start,"IR displayed (" + ((stop - start) / 1000000) + " ms)")
		}
	}

	def protected IrRoot convertIrModuleFrom(NablagenApplication ngenApp)
	{
		val start = System.nanoTime()
		var IrRoot ir = null
		consoleFactory.printConsole(MessageType.Start, "Building IR to initialize job graph editor")

		try
		{
			val nablagen2Ir = ngenApplicationToIrProvider.get // force a new instance to ensure a new IR
			ir = nablagen2Ir.toIrRoot(ngenApp)
			val description = 'Minimal IR->IR transformations to check job cycles'
			val t = new CompositeTransformationStep(description, #[new ReplaceReductions(false), new FillJobHLTs])
			t.transformIr(ir, [msg | consoleFactory.printConsole(MessageType.Exec, msg)])
		}
		catch (Exception e)
		{
			// An exception can occured during IR building if environment is not configured,
			// for example compilation not done, or during transformation step. Whatever... 
			// irModule stays null. Error message printed below.
		}

		val stop = System.nanoTime()
		consoleFactory.printConsole(MessageType.End, "IR converted (" + ((stop - start) / 1000000) + " ms)")

		if (ir === null)
		{
			consoleFactory.printConsole(MessageType.Error, "IR module can not be built. Try to clean and rebuild all projects and start again.")
			return null
		}
		else
		{
			return ir
		}
	}

	def protected Session getOrCreateSession(String projectSessionName)
	{
		var airdResourceURI = URI.createURI(URIQuery.INMEMORY_URI_SCHEME + ":/" + projectSessionName + "/representations.aird")
		var session = SessionManager.INSTANCE.getExistingSession(airdResourceURI)
		if (session === null)
		{
			session = SessionFactory.INSTANCE.createSession(airdResourceURI, new NullProgressMonitor)
		}
		if (!session.open)
		{
			return SessionManager.INSTANCE.openSession(airdResourceURI, new NullProgressMonitor, SiriusEditPlugin.plugin.uiCallback)
		}
		return session
	}

	def protected boolean addOrUpdateResource(Session session, IrRoot irRoot, String projectSessionName)
	{
		val irResourceURI = URI.createURI(URIQuery.INMEMORY_URI_SCHEME + ":/" + projectSessionName + "/" + projectSessionName + "." + NablaIrWriter.IrExtension)

		var isNewResource = false
		val irResource = session.transactionalEditingDomain.resourceSet.getResource(irResourceURI, false)
		if (irResource === null)
		{
			isNewResource = true
			val newIrResource = session.transactionalEditingDomain.resourceSet.createResource(irResourceURI)

			// Remove notifications delivering to avoid "cannot modify resource set without write transaction" exception
			newIrResource.eSetDeliver(false)
			newIrResource.contents.add(irRoot)
			try
			{
				newIrResource.save(Collections.emptyMap)
			} catch (IOException e)
			{
			}
			newIrResource.eSetDeliver(true)

			session.transactionalEditingDomain.commandStack.execute(
				new RecordingCommand(session.transactionalEditingDomain)
				{
					override protected doExecute()
					{
						session.addSemanticResource(irResourceURI, new NullProgressMonitor)
					}
				}
			)
		}
		else
		{
			session.transactionalEditingDomain.commandStack.execute(
				new RecordingCommand(session.transactionalEditingDomain)
				{
					override protected doExecute()
					{
						var root = irResource.contents.get(0) as IrRoot
						var NablaIrCopier copier = new NablaIrCopier
						// keep only root element, clean all elements under root before copy new elements
						copier.nablaIrCopy(irRoot, root)
						copier.copyReferences
						irResource.save(Collections.emptyMap)
					}
				}
			)
		}
		return isNewResource
	}

	def protected void selectViewpoint(Session session, String vpName)
	{
		session.transactionalEditingDomain.commandStack.execute(
			new RecordingCommand(session.transactionalEditingDomain)
			{
				override protected doExecute()
				{
					var Viewpoint nablaIrVP
					for (existingViewpoint : ViewpointRegistry.instance.viewpoints)
					{
						if (vpName.equals(existingViewpoint.name))
						{
							nablaIrVP = existingViewpoint
						}
					}
					if (nablaIrVP === null)
					{
						consoleFactory.printConsole(MessageType.Error, "Nabla IR Viewpoint is not available.")
						return
					}
					new ViewpointSelectionCallback().selectViewpoint(nablaIrVP, session, new NullProgressMonitor)
				}
			}
		)
	}

	def protected void createAndOpenRepresentation(Session session, String representationName, String diagramName, EObject rootElement)
	{
		val representationDescriptions = DialectManager.INSTANCE.getAvailableRepresentationDescriptions(session.getSelectedViewpoints(false), rootElement)

		var DRepresentation representation = null
		for (representationDescription : representationDescriptions)
		{
			if (representationName.equals(representationDescription.name))
			{
				var cmd = new CreateRepresentationCommand(session, representationDescription, rootElement, diagramName, new NullProgressMonitor)
				session.transactionalEditingDomain.commandStack.execute(cmd)
				representation = cmd.createdRepresentation
			}
		}

		if (representation !== null)
		{
			DialectUIManager.INSTANCE.openEditor(session, representation, new NullProgressMonitor)
			saveSession(session)
		}
	}

	def protected void updateOpenedRepresentation(Session session, EObject diagramSemanticRoot, String diagramName)
	{
		var editingSession = SessionUIManager.INSTANCE.getUISession(session)
		if (editingSession !== null)
		{
			for (editor : editingSession.editors)
			{
				var editorRepresentation = editor.representation
				if (editorRepresentation !== null && diagramName.equals(editorRepresentation.name))
				{
					DialectUIManager.INSTANCE.refreshEditor(editor, new NullProgressMonitor)
					saveSession(session)
					return
				}
			}
		}
		// No opened representations, try to open or create and open
		var representations = DialectManager.INSTANCE.getRepresentations(diagramSemanticRoot, session)
		if (representations === null || representations.empty) {
			createAndOpenRepresentation(session, NABLA_IR_DIAGRAM_ID, diagramName, diagramSemanticRoot)
		}
		for (representation : representations) {
			var editor = DialectUIManager.INSTANCE.openEditor(session, representation, new NullProgressMonitor)
			if (editor instanceof DialectEditor)
			{
				DialectUIManager.INSTANCE.refreshEditor(editor, new NullProgressMonitor)
				unselectAllElements(session, representation)
			}
		}
		saveSession(session)
	}

	def protected void unselectAllElements(Session session, DRepresentation representation)
	{
		session.transactionalEditingDomain.commandStack.execute(
			new RecordingCommand(session.transactionalEditingDomain)
			{
				override protected doExecute()
				{
					representation.uiState.elementsToSelect.clear
					representation.uiState.elementsToSelect.addAll(new ArrayList<EObject>())
				}
			}
		)
	}

	def protected IrRoot getSemanticRoot(Session session)
	{
		var semanticResources = session.semanticResources
		for (semanticResource : semanticResources)
		{
			val contents = semanticResource.contents
			if (contents !== null)
			{
				var root = contents.get(0)
				if (root instanceof IrRoot)
					return root
			}
		}
		return null
	}

	def protected void saveSession(Session session)
	{
		session.transactionalEditingDomain.commandStack.execute(
			new RecordingCommand(session.transactionalEditingDomain)
			{
				override protected doExecute()
				{
					session.save(new NullProgressMonitor)
				}
			}
		)
	}
}