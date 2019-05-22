package fr.cea.nabla.ui.launchconfig

import org.eclipse.core.runtime.CoreException
import org.eclipse.core.runtime.IProgressMonitor
import org.eclipse.debug.core.ILaunch
import org.eclipse.debug.core.ILaunchConfiguration
import org.eclipse.debug.core.model.ILaunchConfigurationDelegate
import com.google.inject.Inject

class NablagenLaunchConfigurationDelegate implements ILaunchConfigurationDelegate 
{
	@Inject NablagenRunner runner

	override launch(ILaunchConfiguration configuration, String mode, ILaunch launch, IProgressMonitor monitor) throws CoreException 
	{
		val file = NablagenLaunchConstants::getSourceFile(configuration)
		if (file !== null)
			runner.launch(file)
	}
}