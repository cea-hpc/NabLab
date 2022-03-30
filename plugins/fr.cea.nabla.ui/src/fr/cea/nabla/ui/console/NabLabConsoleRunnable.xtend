/*******************************************************************************
 * Copyright (c) 2022 CEA
 * This program and the accompanying materials are made available under the
 * terms of the Eclipse Public License 2.0 which is available at
 * http://www.eclipse.org/legal/epl-2.0.
 *
 * SPDX-License-Identifier: EPL-2.0
 * Contributors: see AUTHORS file
 *******************************************************************************/
package fr.cea.nabla.ui.console

class NabLabConsoleRunnable implements Runnable
{
	val NabLabConsoleFactory consoleFactory
	val Thread worker
	val Runnable stop

	new(NabLabConsoleFactory consoleFactory, Thread worker)
	{
		this.consoleFactory = consoleFactory
		this.worker = worker
		this.stop = []
	}

	new(NabLabConsoleFactory consoleFactory, Thread worker, Runnable stop)
	{
		this.consoleFactory = consoleFactory
		this.worker = worker
		this.stop = stop
	}

	override void run()
	{
		consoleFactory.openConsole
		consoleFactory.addRunnerToConsole(stop)
		worker.start()
		worker.join()
		consoleFactory.removeRunnerToConsole(stop)
	}
}