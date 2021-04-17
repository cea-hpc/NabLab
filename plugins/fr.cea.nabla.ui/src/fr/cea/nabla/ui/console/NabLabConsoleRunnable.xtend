package fr.cea.nabla.ui.console

class NabLabConsoleRunnable implements Runnable
{
	val NabLabConsoleFactory consoleFactory
	val Thread worker

	new(NabLabConsoleFactory consoleFactory, Runnable r)
	{
		this.consoleFactory = consoleFactory
		this.worker = new Thread(r)
	}

	override void run()
	{
		consoleFactory.openConsole
		consoleFactory.addRunnerToConsole(worker)
		worker.start()
		worker.join()
		consoleFactory.removeRunnerToConsole(worker)
	}
}