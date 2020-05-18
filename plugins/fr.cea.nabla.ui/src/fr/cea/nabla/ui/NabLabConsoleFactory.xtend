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

@Singleton
class NabLabConsoleFactory implements IConsoleFactory
{
	public static val ConsoleName = "NabLab Console"
	static val BLUE = new Color(null, 70, 30, 180)
	static val BLACK = new Color(null, 0, 0, 0)

	@Inject NablaGeneratorMessageDispatcher dispatcher
	MessageConsole console

	override openConsole() 
	{
		val consoleMng = ConsolePlugin.^default.consoleManager
		console = consoleMng.consoles.filter(MessageConsole).findFirst[x | x.name == ConsoleName]
		if (console === null)
		{
			val imageDescriptor = UiUtils::getImageDescriptor("icons/Nabla.gif")
			val image = if (imageDescriptor.present) imageDescriptor.get else null
			console = new MessageConsole(ConsoleName, image)
			consoleMng.addConsoles(#[console])
			dispatcher.traceListeners += [type, msg | printConsole(type, msg)]
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
				switch type
				{
					case MessageType.Start:
					{
						console.activate
						console.clearConsole
						stream.color = BLACK
					}
					case MessageType.Exec: stream.color = BLUE
					case MessageType.End: stream.color = BLACK
				}
				stream.println(msg)
			])
		}
	}
}
