/*******************************************************************************
 * Copyright (c) 2022 CEA
 * This program and the accompanying materials are made available under the
 * terms of the Eclipse Public License 2.0 which is available at
 * http://www.eclipse.org/legal/epl-2.0.
 *
 * SPDX-License-Identifier: EPL-2.0
 * Contributors: see AUTHORS file
 *******************************************************************************/
package fr.cea.nabla.sirius

import fr.cea.nabla.ir.JobExtensions
import fr.cea.nabla.ir.ir.IrAnnotable
import fr.cea.nabla.ir.ir.IrRoot
import fr.cea.nabla.ir.ir.Job
import fr.cea.nabla.ir.ir.JobCaller
import java.util.ArrayList
import java.util.Collection
import org.eclipse.core.runtime.NullProgressMonitor
import org.eclipse.emf.common.util.URI
import org.eclipse.emf.ecore.EObject
import org.eclipse.emf.transaction.RecordingCommand
import org.eclipse.sirius.business.api.dialect.DialectManager
import org.eclipse.sirius.business.api.dialect.command.CreateRepresentationCommand
import org.eclipse.sirius.business.api.session.Session
import org.eclipse.sirius.business.api.session.SessionManager
import org.eclipse.sirius.diagram.DDiagramElement
import org.eclipse.sirius.diagram.DSemanticDiagram
import org.eclipse.sirius.diagram.ui.tools.internal.editor.DDiagramEditorImpl
import org.eclipse.sirius.ui.business.api.session.SessionEditorInput
import org.eclipse.sirius.ui.business.api.session.SessionUIManager
import org.eclipse.sirius.viewpoint.DRepresentation
import org.eclipse.sirius.viewpoint.description.RepresentationDescription

@SuppressWarnings("restriction")
class NablaSiriusUIServices {

	static final String NABLA_IR_DIAGRAM_ID = "NablaIrDiagram"

	def void goIntoDiagram(JobCaller jobCaller, DDiagramElement elementView)
	{
		val session = SessionManager.INSTANCE.getSession(jobCaller)
		if (session !== null)
		{
			val editingSession = SessionUIManager.INSTANCE.getUISession(session)
			if (editingSession !== null)
			{
				val parentDiagram = elementView.parentDiagram
				val editor = editingSession.getEditor(parentDiagram)
				if (editor instanceof DDiagramEditorImpl)
				{
					val nablaIrDiagramOnJob = createNablaIrDiagram(session, jobCaller)
					val sessionURI = session.sessionResource.URI
					val uid = nablaIrDiagramOnJob.uid
					val uri = URI.createURI(sessionURI.toString + "#" + uid);
					val uriEditorInput = new SessionEditorInput(uri, parentDiagram.name, session)
					editor.setInput(uriEditorInput)
					unselectAllElements(session, nablaIrDiagramOnJob)
				}
				saveSession(session)
			}
		}
	}
	
	def void backToParentDiagram(DSemanticDiagram diagram)
	{
		val diagramTarget = diagram.target
		if (diagramTarget instanceof Job)
		{
			val parent = diagramTarget.caller.eContainer
			val annotable = (parent instanceof IrRoot ? parent : diagramTarget.caller)
			val session = SessionManager.INSTANCE.getSession(annotable)
			if (session !== null)
			{
				val editingSession = SessionUIManager.INSTANCE.getUISession(session)
				if (editingSession !== null)
				{
					val editor = editingSession.getEditor(diagram)
					if (editor instanceof DDiagramEditorImpl)
					{
						var nablaIrDiagramOnJob = getExistingDiagram(session, annotable)
						if (nablaIrDiagramOnJob === null)
						{
							nablaIrDiagramOnJob = createNablaIrDiagram(session, annotable)
						}
						val sessionURI = session.sessionResource.URI
						val uid = nablaIrDiagramOnJob.uid
						val uri = URI.createURI(sessionURI.toString + "#" + uid)
						val uriEditorInput = new SessionEditorInput(uri, annotable.name, session)
						editor.setInput(uriEditorInput)
						unselectAllElements(session, nablaIrDiagramOnJob)
					}
					saveSession(session)
				}
			}
		}
	}
	
	def void unselectAllElements(Session session, DRepresentation representation)
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
	
	def private DRepresentation createNablaIrDiagram(Session session, IrAnnotable irAnnotable)
	{
		val Collection<RepresentationDescription> representationDescriptions = DialectManager.INSTANCE.
			getAvailableRepresentationDescriptions(session.getSelectedViewpoints(false), irAnnotable)
		var DRepresentation representation = null
		for (RepresentationDescription representationDescription : representationDescriptions)
		{
			if (NABLA_IR_DIAGRAM_ID.equals(representationDescription.getName()))
			{
				val CreateRepresentationCommand cmd = new CreateRepresentationCommand(session,
					representationDescription, irAnnotable, irAnnotable.name, new NullProgressMonitor())
				session.transactionalEditingDomain.commandStack.execute(cmd)
				representation = cmd.createdRepresentation
			}
		}
		return representation
	}
	
	def private DRepresentation getExistingDiagram(Session session, IrAnnotable irAnnotable)
	{
		val representations = DialectManager.INSTANCE.getRepresentations(irAnnotable, session)
		if (representations !== null && !(representations.empty))
		{
			return representations.get(0)
		}
		return null
	}

	def private String getName(EObject object)
	{
		if (object instanceof IrRoot)
		{
			return object.name
		}
		else if (object instanceof Job)
		{
			return JobExtensions.getDisplayName(object)
		}
		return 'Sirius Diagram'
	}
	
	def private void saveSession(Session session)
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