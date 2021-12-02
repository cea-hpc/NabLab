/*******************************************************************************
 * Copyright (c) 2021 CEA
 * This program and the accompanying materials are made available under the
 * terms of the Eclipse Public License 2.0 which is available at
 * http://www.eclipse.org/legal/epl-2.0.
 *
 * SPDX-License-Identifier: EPL-2.0
 * Contributors: see AUTHORS file
 *******************************************************************************/
package fr.cea.nabla.ui.handlers

import com.google.inject.Inject
import com.google.inject.Singleton
import fr.cea.nabla.generator.NablaGeneratorMessageDispatcher.MessageType
import fr.cea.nabla.ir.ir.IrRoot
import fr.cea.nabla.ui.views.JobGraphView

import static extension fr.cea.nabla.ir.JobCallerExtensions.*

@Singleton
class OpenZestJobGraph extends OpenJobGraph
{
	@Inject JobGraphView jobGraphView

	protected override displayIr(IrRoot ir)
	{
		if (ir === null)
		{
			jobGraphView.viewerJobCaller = null
			consoleFactory.printConsole(MessageType.Error, "IR can not be built. Try to clean and rebuild all projects and start again.")
		}
		else
		{
			jobGraphView.viewerJobCaller = ir.main
			val name = (ir.main === null ? 'null' : ir.main.displayName)
			consoleFactory.printConsole(MessageType.End, "Job graph view initialized with: " + name)
		}
	}
}

