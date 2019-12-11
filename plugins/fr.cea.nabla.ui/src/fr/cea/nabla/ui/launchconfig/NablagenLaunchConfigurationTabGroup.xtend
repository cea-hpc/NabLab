package fr.cea.nabla.ui.launchconfig

import org.eclipse.debug.ui.AbstractLaunchConfigurationTabGroup
import org.eclipse.debug.ui.ILaunchConfigurationDialog

class NablagenLaunchConfigurationTabGroup extends AbstractLaunchConfigurationTabGroup 
{	
	override createTabs(ILaunchConfigurationDialog dialog, String mode) 
	{
		setTabs(#[new NablagenLaunchConfigurationTab])
	}
}