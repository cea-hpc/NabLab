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