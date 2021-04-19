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