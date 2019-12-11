package fr.cea.nabla.ui.launchconfig

import org.eclipse.core.resources.ResourcesPlugin
import org.eclipse.debug.core.ILaunchConfiguration

class NablagenLaunchConstants 
{
	package static val LAUNCH_CONFIGURATION_TYPE_ID = 'fr.cea.nabla.ui.launchconfig.NablagenLaunchConfigurationType'
	package static val PROJECT = 'Project name'
	package static val FILE_LOCATION = 'File location'
	
	package static def getSourceFile(ILaunchConfiguration configuration)
	{
		val projectName = configuration.getAttribute(NablagenLaunchConstants::PROJECT, '')
		val project = ResourcesPlugin::workspace.root.getProject(projectName)
		if (project.exists)
		{
			val fileName = configuration.getAttribute(NablagenLaunchConstants::FILE_LOCATION, '')
			val file = project.getFile(fileName)
			if (file.exists)
				return file
		}
		return null
	}
}