/*******************************************************************************
 * Copyright (c) 2020 CEA
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
import fr.cea.nabla.ir.ir.IrModule
import fr.cea.nabla.ir.ir.IrRoot
import fr.cea.nabla.ir.ir.Job
import fr.cea.nabla.ir.ir.JobCaller
import java.util.Collection
import java.util.Collections
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
class NablaSiriusServices
{
	static final String NABLA_IR_DIAGRAM_ID = "NablaIrDiagram"

	def int getAtBackgroundColor(Double at)
	{
		if (at !== null && at > 0)
		{
			return 255 - (at.intValue - 1) * 10
		}
		return 255
	}

	def int getAtLabelColor(Double at)
	{
		if (at !== null && at >= 10)
		{
			return 255
		}
		return 50
	}

	def Collection<Job> getJobs(IrAnnotable annotable)
	{
		if (annotable instanceof JobCaller)
		{
			return annotable.calls
		}
		else if (annotable instanceof IrRoot)
		{
			return annotable.main.calls
		}
		return Collections.emptyList()
	}

	def void goIntoDiagram(JobCaller jobCaller, DDiagramElement elementView)
	{
		var session = SessionManager.INSTANCE.getSession(jobCaller)
		if (session !== null)
		{
			var editingSession = SessionUIManager.INSTANCE.getUISession(session)
			if (editingSession !== null)
			{
				var parentDiagram = elementView.parentDiagram
				var editor = editingSession.getEditor(parentDiagram)
				if (editor instanceof DDiagramEditorImpl)
				{
					var nablaIrDiagramOnJob = createNablaIrDiagram(session, jobCaller)
					var sessionURI = session.sessionResource.URI
					var uid = nablaIrDiagramOnJob.uid
					var uri = URI.createURI(sessionURI.toString + "#" + uid);
					var uriEditorInput = new SessionEditorInput(uri, parentDiagram.name, session)
					((editor as DDiagramEditorImpl)).setInput(uriEditorInput)
				}
				saveSession(session)
			}
		}
	}

	def private DRepresentation createNablaIrDiagram(Session session, IrAnnotable irAnnotable)
	{
		var Collection<RepresentationDescription> representationDescriptions = DialectManager.INSTANCE.
			getAvailableRepresentationDescriptions(session.getSelectedViewpoints(false), irAnnotable)
		var DRepresentation representation = null
		for (RepresentationDescription representationDescription : representationDescriptions)
		{
			if (NABLA_IR_DIAGRAM_ID.equals(representationDescription.getName()))
			{
				var CreateRepresentationCommand cmd = new CreateRepresentationCommand(session,
					representationDescription, irAnnotable, irAnnotable.name, new NullProgressMonitor())
				session.transactionalEditingDomain.commandStack.execute(cmd)
				representation = cmd.createdRepresentation
			}
		}
		return representation
	}

	def boolean isNotRootDiagram(EObject graphicalElement)
	{
		if (graphicalElement instanceof DSemanticDiagram)
		{
			return !(graphicalElement.target instanceof IrModule)
		}
		return false
	}

	def void backToParentDiagram(DSemanticDiagram diagram)
	{
		val diagramTarget = diagram.target
		var IrAnnotable annotable = null
		if (diagramTarget instanceof Job)
		{
			val parent = diagramTarget.caller.eContainer
			if (parent instanceof IrRoot)
			{
				annotable = parent as IrRoot
			} else
			{
				annotable = diagramTarget.caller as JobCaller
			}
		}
		if (annotable instanceof IrAnnotable) {
			var session = SessionManager.INSTANCE.getSession(annotable)
			if (session !== null)
			{
				var editingSession = SessionUIManager.INSTANCE.getUISession(session)
				if (editingSession !== null)
				{
					var editor = editingSession.getEditor(diagram)
					if (editor instanceof DDiagramEditorImpl)
					{
						var nablaIrDiagramOnJob = getExistingDiagram(session, annotable)
						if (nablaIrDiagramOnJob === null)
						{
							nablaIrDiagramOnJob = createNablaIrDiagram(session, annotable)
						}
						var sessionURI = session.sessionResource.URI
						var uid = nablaIrDiagramOnJob.uid
						var uri = URI.createURI(sessionURI.toString + "#" + uid);
						var uriEditorInput = new SessionEditorInput(uri, annotable.name, session)
						((editor as DDiagramEditorImpl)).setInput(uriEditorInput)
					}
					saveSession(session)
				}
			}
		}
	}

	def private DRepresentation getExistingDiagram(Session session, IrAnnotable irAnnotable)
	{
		var representations = DialectManager.INSTANCE.getRepresentations(irAnnotable, session)
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
			return JobExtensions.getDiagramDisplayName(object)
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
