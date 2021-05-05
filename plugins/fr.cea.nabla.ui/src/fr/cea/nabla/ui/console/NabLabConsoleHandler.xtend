/*******************************************************************************
 * Copyright (c) 2021 CEA
 * This program and the accompanying materials are made available under the 
 * terms of the Eclipse Public License 2.0 which is available at
 * http://www.eclipse.org/legal/epl-2.0.
 *
 * SPDX-License-Identifier: EPL-2.0
 * Contributors: see AUTHORS file
 *******************************************************************************/
package fr.cea.nabla.ui.console

import fr.cea.nabla.generator.NablaGeneratorMessageDispatcher.MessageType
import java.util.logging.ConsoleHandler
import java.util.logging.LogRecord

class NabLabConsoleHandler extends ConsoleHandler
{
	val NabLabConsoleFactory consoleFactory

	new(NabLabConsoleFactory consoleFactory)
	{
		this.consoleFactory = consoleFactory
	}

	override publish(LogRecord record)
	{
		consoleFactory.printConsole(MessageType.Exec, record.message)
	}
}