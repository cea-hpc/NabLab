package fr.cea.nabla.ui

import com.google.inject.Inject
import com.google.inject.Singleton
import fr.cea.nabla.generator.NablaGeneratorMessageDispatcher
import org.eclipse.ui.console.ConsolePlugin
import org.eclipse.ui.console.IConsoleFactory
import org.eclipse.ui.console.MessageConsole
import org.eclipse.ui.console.MessageConsoleStream

@Singleton
class NabLabConsoleFactory implements IConsoleFactory
{
	static val ConsoleName = "NabLab Console"
	@Inject NablaGeneratorMessageDispatcher dispatcher
	MessageConsole console
	MessageConsoleStream defaultStream

	override openConsole()
	{
		val consoleMng = ConsolePlugin.^default.consoleManager
		if (!consoleMng.consoles.filter(MessageConsole).exists[x | x.name == ConsoleName])
			consoleMng.addConsoles(#[nabLabConsole])
	}

	private def MessageConsole getNabLabConsole()
	{
		if (console === null)
		{
			val imageDescriptor = UiUtils::getImageDescriptor("icons/NabLab.gif")
			val image = if (imageDescriptor.present) imageDescriptor.get else null
			console = new MessageConsole(ConsoleName, image)
			defaultStream = console.newMessageStream
			dispatcher.traceListeners += [msg | defaultStream.print(msg)]
		}
		return console
	}
}