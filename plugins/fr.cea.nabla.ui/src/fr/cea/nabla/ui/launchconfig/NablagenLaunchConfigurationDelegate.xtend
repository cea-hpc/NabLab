/*******************************************************************************
 * Copyright (c) 2021 CEA
 * This program and the accompanying materials are made available under the
 * terms of the Eclipse Public License 2.0 which is available at
 * http://www.eclipse.org/legal/epl-2.0.
 *
 * SPDX-License-Identifier: EPL-2.0
 * Contributors: see AUTHORS file
 *******************************************************************************/
package fr.cea.nabla.ui.launchconfig

import com.google.inject.Inject
import org.eclipse.core.runtime.CoreException
import org.eclipse.core.runtime.IProgressMonitor
import org.eclipse.debug.core.ILaunch
import org.eclipse.debug.core.ILaunchConfiguration
import org.eclipse.debug.core.model.ILaunchConfigurationDelegate

class NablagenLaunchConfigurationDelegate implements ILaunchConfigurationDelegate
{
	@Inject NablagenRunner runner

	override launch(ILaunchConfiguration configuration, String mode, ILaunch launch, IProgressMonitor monitor) throws CoreException
	{
		val project = NablagenLaunchConstants::getProject(configuration)
		if (project.exists)
		{
			val nablagenFile = NablagenLaunchConstants::getFile(project, configuration, NablagenLaunchConstants.NGEN_FILE_LOCATION)
			val jsonFile = NablagenLaunchConstants::getFile(project, configuration, NablagenLaunchConstants.JSON_FILE_LOCATION)
			runner.launch(nablagenFile, jsonFile)
		}
	}
}