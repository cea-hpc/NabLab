package fr.cea.nabla.ui.handlers

import org.eclipse.core.commands.AbstractHandler
import org.eclipse.core.commands.ExecutionEvent
import org.eclipse.core.commands.ExecutionException

class GenerateProviderHandler extends AbstractHandler
{
	override execute(ExecutionEvent event) throws ExecutionException
	{
		println("GenerateProviderHandler triggered")
	}
}