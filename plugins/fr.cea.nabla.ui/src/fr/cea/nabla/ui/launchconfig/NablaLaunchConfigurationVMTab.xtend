/*******************************************************************************
 * Copyright (c) 2020 CEA
 * This program and the accompanying materials are made available under the 
 * terms of the Eclipse Public License 2.0 which is available at
 * http://www.eclipse.org/legal/epl-2.0.
 * 
 * SPDX-License-Identifier: EPL-2.0
 * Contributors: see AUTHORS file
 *******************************************************************************/
package fr.cea.nabla.ui.launchconfig

import org.eclipse.core.runtime.CoreException
import org.eclipse.core.runtime.preferences.InstanceScope
import org.eclipse.debug.core.ILaunchConfiguration
import org.eclipse.debug.core.ILaunchConfigurationWorkingCopy
import org.eclipse.debug.ui.AbstractLaunchConfigurationTab
import org.eclipse.swt.SWT
import org.eclipse.swt.events.SelectionAdapter
import org.eclipse.swt.events.SelectionEvent
import org.eclipse.swt.layout.GridData
import org.eclipse.swt.layout.GridLayout
import org.eclipse.swt.widgets.Button
import org.eclipse.swt.widgets.Composite
import org.eclipse.swt.widgets.DirectoryDialog
import org.eclipse.swt.widgets.Group
import org.eclipse.swt.widgets.Text

class NablaLaunchConfigurationVMTab extends AbstractLaunchConfigurationTab {
	boolean fDisableUpdate = false

	Text fTxtVMHome

	override createControl(Composite parent) {
		val topControl = new Composite(parent, SWT.NONE)
		topControl.setLayout(new GridLayout(1, false))

		val grpSource = new Group(topControl, SWT.NONE)
		grpSource.setLayout(new GridLayout(2, false))
		grpSource.setLayoutData(new GridData(SWT.FILL, SWT.CENTER, true, false, 1, 1))
		grpSource.setText("GraalVM Home")

		fTxtVMHome = new Text(grpSource, SWT.BORDER)
		fTxtVMHome.addModifyListener([e|if(!fDisableUpdate) updateLaunchConfigurationDialog])
		fTxtVMHome.setLayoutData(new GridData(SWT.FILL, SWT.CENTER, true, false, 1, 1))

		val btnBrowseSource = new Button(grpSource, SWT::NONE)
		btnBrowseSource.addSelectionListener(new GraalVMHomePathSelectionAdapter(parent, fTxtVMHome))
		btnBrowseSource.setText("Browse...")

		setControl(topControl)
	}

	override getName() {
		'GraalVM'
	}

	override initializeFrom(ILaunchConfiguration configuration) {
		fDisableUpdate = true

		fTxtVMHome.text = ''

		try {
			fTxtVMHome.text = configuration.getAttribute(NablaLaunchConstants::GRAAL_HOME_LOCATION, '')
		} catch (CoreException e) {
		}
		fDisableUpdate = false
	}

	override performApply(ILaunchConfigurationWorkingCopy configuration) {
		InstanceScope.INSTANCE.getNode('fr.cea.nabla.ui').put('graalvm.home', fTxtVMHome.text)
		configuration.setAttribute(NablaLaunchConstants::GRAAL_HOME_LOCATION, fTxtVMHome.text)
	}

	override setDefaults(ILaunchConfigurationWorkingCopy configuration) {
		configuration.setAttribute(NablaLaunchConstants::GRAAL_HOME_LOCATION,
			InstanceScope.INSTANCE.getNode('fr.cea.nabla.ui').get('graalvm.home', ''))
	}
}

class GraalVMHomePathSelectionAdapter extends SelectionAdapter {
	val Composite parent
	val Text fTxtFile

	new(Composite parent, Text fTxtFile) {
		this.parent = parent
		this.fTxtFile = fTxtFile
	}

	override void widgetSelected(SelectionEvent e) {
		val dialog = new DirectoryDialog(parent.shell)
		dialog.setMessage("Select the GraalVM home directory:")
		fTxtFile.setText(dialog.open)
	}
}
