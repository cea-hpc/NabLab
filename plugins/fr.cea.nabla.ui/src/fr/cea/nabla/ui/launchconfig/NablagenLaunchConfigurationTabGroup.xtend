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

import org.eclipse.debug.ui.AbstractLaunchConfigurationTabGroup
import org.eclipse.debug.ui.ILaunchConfigurationDialog

class NablagenLaunchConfigurationTabGroup extends AbstractLaunchConfigurationTabGroup
{
	override createTabs(ILaunchConfigurationDialog dialog, String mode) 
	{
		setTabs(#[new NablagenLaunchConfigurationTab])
	}
}