package fr.cea.nabla.ui

import com.google.inject.Inject
import com.google.inject.Singleton
import fr.cea.nabla.generator.NablaGeneratorMessageDispatcher
import fr.cea.nabla.generator.NablaGeneratorMessageDispatcher.MessageType
import org.eclipse.swt.graphics.Color
import org.eclipse.swt.widgets.Display
import org.eclipse.ui.console.ConsolePlugin
import org.eclipse.ui.console.IConsoleFactory
import org.eclipse.ui.console.MessageConsole
import org.eclipse.ui.console.MessageConsoleStream

@Singleton
class NabLabConsoleFactory implements IConsoleFactory
{
	public static val ConsoleName = "NabLab Console"
	static val BLUE = new Color(null, 70, 30, 180)
	static val BLACK = new Color(null, 0, 0, 0)

	@Inject NablaGeneratorMessageDispatcher dispatcher
	MessageConsole console
	MessageConsoleStream stream

	override openConsole() 
	{
		val consoleMng = ConsolePlugin.^default.consoleManager
		console = consoleMng.consoles.filter(MessageConsole).findFirst[x | x.name == ConsoleName]
		if (console === null)
		{
			val imageDescriptor = UiUtils::getImageDescriptor("icons/NabLab.gif")
			val image = if (imageDescriptor.present) imageDescriptor.get else null
			console = new MessageConsole(ConsoleName, image)
			consoleMng.addConsoles(#[console])
			dispatcher.traceListeners += [type, msg | printConsole(type, msg)]
		}
	}

	def void clearAndActivateConsole()
	{
		if (console !== null)
		{
			console.clearConsole
			console.activate
		}
	}

	def void printConsole(MessageType type, String msg)
	{
		if (console !== null)
		{
			if (stream === null) {
				stream = console.newMessageStream
			}
			val display = Display.^default
			display.syncExec
			([
				stream.color = switch type
				{
					case MessageType.Exec: BLUE
					default: BLACK
				}
				stream.println(msg)
			])
		}
	}
}
