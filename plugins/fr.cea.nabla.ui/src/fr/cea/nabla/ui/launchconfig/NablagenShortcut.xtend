package fr.cea.nabla.ui.launchconfig

import com.google.inject.Inject
import java.util.ArrayList
import org.eclipse.core.resources.IFile
import org.eclipse.core.resources.IResource
import org.eclipse.core.runtime.CoreException
import org.eclipse.core.runtime.NullProgressMonitor
import org.eclipse.debug.core.DebugPlugin
import org.eclipse.debug.core.ILaunchConfiguration
import org.eclipse.debug.ui.ILaunchShortcut
import org.eclipse.jface.viewers.ISelection
import org.eclipse.jface.viewers.TreeSelection
import org.eclipse.ui.IEditorPart
import org.eclipse.ui.PlatformUI
import org.eclipse.xtext.ui.editor.XtextEditor

class NablagenShortcut implements ILaunchShortcut
{
	@Inject NablagenRunner runner
	
	override launch(ISelection selection, String mode) 
	{
		if (selection !== null && selection instanceof TreeSelection)
		{
			val elt = (selection as TreeSelection).firstElement
			if (elt !== null && elt instanceof IResource)
				launchGeneration(elt as IResource, mode)
		}
	}
	
	override launch(IEditorPart editor, String mode) 
	{
		if (editor instanceof XtextEditor)
		{
			val resource = (editor as XtextEditor).resource
			if (resource !== null)
				launchGeneration(resource, mode)
		}
	}
	
	private def launchGeneration(IResource file, String mode)
	{
		if (file instanceof IFile)
		{
			// try to save dirty editors
			PlatformUI::workbench.activeWorkbenchWindow.activePage.saveAllEditors(true)
			try
			{
				var configurations = getLaunchConfigurations(file)
				if (configurations.length == 0) 
				{
					// no configuration found, create new one
					val manager = DebugPlugin::^default.launchManager
					val type = manager.getLaunchConfigurationType(NablagenLaunchConstants.LAUNCH_CONFIGURATION_TYPE_ID)

					val configuration = type.newInstance(null, file.name)
					configuration.setAttribute(NablagenLaunchConstants.PROJECT, file.project.name)
					configuration.setAttribute(NablagenLaunchConstants.FILE_LOCATION, file.projectRelativePath.toPortableString)

					// save and return new configuration
					configuration.doSave

					configurations =  #[configuration]
				}

				// launch
				configurations.get(0).launch(mode, new NullProgressMonitor());

			} 
			catch (CoreException e) 
			{
				// could not create launch configuration, run file directly
				runner.launch(file);
			}
		}
	}
	
	/**
	 * Get all launch configurations that target a dedicated resource file.
	 * 
	 * @param resource root file to execute
	 * @return {@link ILaunchConfiguration}s using resource
	 */
	private def ILaunchConfiguration[] getLaunchConfigurations(IResource resource) 
	{
		val configurations = new ArrayList<ILaunchConfiguration>
		val manager = DebugPlugin.^default.launchManager
		val type = manager.getLaunchConfigurationType(NablagenLaunchConstants::LAUNCH_CONFIGURATION_TYPE_ID)

		// try to find existing configurations using the same file
		try 
		{
			for (ILaunchConfiguration configuration : manager.getLaunchConfigurations(type))
			{
				try
				{
					val file = NablagenLaunchConstants::getSourceFile(configuration)
					if (resource.equals(file))
						configurations.add(configuration)
				} 
				catch (CoreException e) 
				{
					// could not read configuration, ignore
				}
			}
		} 
		catch (CoreException e) 
		{
			// could not load configurations, ignore
		}

		return configurations
	}
}