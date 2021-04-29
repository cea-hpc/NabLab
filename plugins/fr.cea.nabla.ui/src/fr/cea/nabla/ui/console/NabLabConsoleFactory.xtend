/*******************************************************************************
 * Copyright (c) 2020 CEA
 * This program and the accompanying materials are made available under the 
 * terms of the Eclipse Public License 2.0 which is available at
 * http://www.eclipse.org/legal/epl-2.0.
 *
 * SPDX-License-Identifier: EPL-2.0
 * Contributors: see AUTHORS file
 *******************************************************************************/
package fr.cea.nabla.ui.console

import com.google.inject.Singleton
import fr.cea.nabla.generator.NablaGeneratorMessageDispatcher.MessageType
import fr.cea.nabla.ui.NablaUiUtils
import org.eclipse.swt.graphics.Color
import org.eclipse.swt.widgets.Display
import org.eclipse.ui.console.ConsolePlugin
import org.eclipse.ui.console.IConsoleFactory

@Singleton
class NabLabConsoleFactory implements IConsoleFactory
{
	static val BLUE = new Color(null, 70, 30, 180)
	static val BLACK = new Color(null, 0, 0, 0)
	static val ORANGE = new Color(null, 255, 140, 0)
	static val RED = new Color(null, 139, 0, 0)

	NabLabConsole console

	override openConsole()
	{
		val consoleMng = ConsolePlugin.^default.consoleManager
		console = consoleMng.consoles.filter(NabLabConsole).head
		if (console === null)
		{
			val id = NablaUiUtils::getImageDescriptor("icons/NabLab.gif")
			val image = if (id.present) id.get else null
			console = new NabLabConsole(image)
			consoleMng.addConsoles(#[console])
		}
		else
		{
			console.clearConsole
			console.activate
		}
	}

	def void printConsole(MessageType type, String msg)
	{
		if (console !== null)
		{
			val display = Display.^default
			display.syncExec
			([
				val stream = console.newMessageStream
				stream.color = switch type
				{
					case MessageType.Exec: BLUE
					case MessageType.Warning: ORANGE
					case MessageType.Error: RED
					default: BLACK
				}
				stream.println(msg)
			])
		}
	}

	package def void addRunnerToConsole(Runnable t)
	{
		if (console !== null)
		{
			console.runners += t
			if (console.actions !== null) Display.^default.asyncExec([console.actions.updateVis])
		}
	}

	package def void removeRunnerToConsole(Runnable t)
	{
		if (console !== null)
		{
			console.runners -= t
			if (console.actions !== null) Display.^default.asyncExec([console.actions.updateVis])
		}
	}
}

