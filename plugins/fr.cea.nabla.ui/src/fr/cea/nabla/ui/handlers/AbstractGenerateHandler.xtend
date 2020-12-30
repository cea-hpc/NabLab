package fr.cea.nabla.ui.handlers

import com.google.inject.Inject
import fr.cea.nabla.generator.NablaGeneratorMessageDispatcher
import fr.cea.nabla.ui.NabLabConsoleFactory
import org.eclipse.core.commands.AbstractHandler
import org.eclipse.core.commands.ExecutionEvent
import org.eclipse.core.commands.ExecutionException
import org.eclipse.core.resources.IFile
import org.eclipse.jface.viewers.TreeSelection
import org.eclipse.swt.widgets.Shell
import org.eclipse.ui.handlers.HandlerUtil

abstract class AbstractGenerateHandler extends AbstractHandler
{
	@Inject protected NabLabConsoleFactory consoleFactory
	@Inject protected NablaGeneratorMessageDispatcher dispatcher

	override execute(ExecutionEvent event) throws ExecutionException
	{
		val selection = HandlerUtil::getActiveMenuSelection(event)
		if (selection !== null && selection instanceof TreeSelection)
		{
			val elt = (selection as TreeSelection).firstElement
			if (elt instanceof IFile)
			{
				val shell = HandlerUtil::getActiveShell(event)
				generate(elt, shell)
			}
		}
		return selection
	}

	abstract def void generate(IFile file, Shell shell)
}