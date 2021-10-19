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

import org.eclipse.core.resources.IFile
import org.eclipse.core.resources.IResource
import org.eclipse.core.resources.ResourcesPlugin
import org.eclipse.core.runtime.CoreException
import org.eclipse.debug.core.ILaunchConfiguration
import org.eclipse.debug.core.ILaunchConfigurationWorkingCopy
import org.eclipse.debug.ui.AbstractLaunchConfigurationTab
import org.eclipse.jface.window.Window
import org.eclipse.swt.SWT
import org.eclipse.swt.events.SelectionAdapter
import org.eclipse.swt.events.SelectionEvent
import org.eclipse.swt.layout.GridData
import org.eclipse.swt.layout.GridLayout
import org.eclipse.swt.widgets.Button
import org.eclipse.swt.widgets.Composite
import org.eclipse.swt.widgets.Group
import org.eclipse.swt.widgets.Text
import org.eclipse.ui.dialogs.ElementTreeSelectionDialog
import org.eclipse.ui.model.WorkbenchLabelProvider

class NablagenLaunchConfigurationTab extends AbstractLaunchConfigurationTab
{
	public static val NablagenFileExtension = 'ngen'
	public static val JsonFileExtension = 'json'
	boolean fDisableUpdate = false

	Text fTxtProject
	Text fTxtFile
	Text fJsonFile

	override createControl(Composite parent)
	{
		val topControl = new Composite(parent, SWT.NONE)
		topControl.setLayout(new GridLayout(1, false))

		var fGroup = new Group(topControl, SWT.NONE)
		fGroup.setLayout(new GridLayout(2, false))
		fGroup.setLayoutData(new GridData(SWT.FILL, SWT.CENTER, true, false, 1, 1))
		fGroup.setText("Project")

		fTxtProject = new Text(fGroup, SWT.BORDER)
		fTxtProject.setLayoutData(new GridData(SWT.FILL, SWT.CENTER, true, false, 1, 1))

		val fBtnBrowseProject = new Button(fGroup, SWT.NONE)
		fBtnBrowseProject.addSelectionListener(new NablagenProjectSelectionAdapter(parent, fTxtProject))
		fBtnBrowseProject.setText("Browse...");

		fGroup = new Group(topControl, SWT.NONE)
		fGroup.setLayout(new GridLayout(2, false))
		fGroup.setLayoutData(new GridData(SWT.FILL, SWT.CENTER, true, false, 1, 1))
		fGroup.setText("Nablagen File")

		fTxtFile = new Text(fGroup, SWT.BORDER)
		fTxtFile.addModifyListener([e | if (!fDisableUpdate) updateLaunchConfigurationDialog])
		fTxtFile.setLayoutData(new GridData(SWT.FILL, SWT.CENTER, true, false, 1, 1))

		val btnBrowseScript = new Button(fGroup, SWT::NONE)
		btnBrowseScript.addSelectionListener(new NablagenFileSelectionAdapter(parent, fTxtFile))
		btnBrowseScript.setText("Browse...");

		fGroup = new Group(topControl, SWT.NONE)
		fGroup.setLayout(new GridLayout(2, false))
		fGroup.setLayoutData(new GridData(SWT.FILL, SWT.CENTER, true, false, 1, 1))
		fGroup.setText("Json File")

		fJsonFile = new Text(fGroup, SWT.BORDER)
		fJsonFile.addModifyListener([e | if (!fDisableUpdate) updateLaunchConfigurationDialog])
		fJsonFile.setLayoutData(new GridData(SWT.FILL, SWT.CENTER, true, false, 1, 1))

		val btnBrowseScript2 = new Button(fGroup, SWT::NONE)
		btnBrowseScript2.addSelectionListener(new JsonFileSelectionAdapter(parent, fJsonFile))
		btnBrowseScript2.setText("Browse...");

		setControl(topControl)
	}

	override getName()
	{
		'Global'
	}

	override initializeFrom(ILaunchConfiguration configuration)
	{
		fDisableUpdate = true

		fTxtProject.text = ''
		fTxtFile.text = ''

		try
		{
			fTxtProject.text = configuration.getAttribute(NablagenLaunchConstants::PROJECT, '')
			fTxtFile.text = configuration.getAttribute(NablagenLaunchConstants::NGEN_FILE_LOCATION, '')
			fJsonFile.text = configuration.getAttribute(NablagenLaunchConstants::JSON_FILE_LOCATION, '')
		}
		catch (CoreException e)
		{
		}
		fDisableUpdate = false
	}

	override performApply(ILaunchConfigurationWorkingCopy configuration)
	{
		configuration.setAttribute(NablagenLaunchConstants::PROJECT, fTxtProject.text)
		configuration.setAttribute(NablagenLaunchConstants::NGEN_FILE_LOCATION, fTxtFile.text)
		configuration.setAttribute(NablagenLaunchConstants::JSON_FILE_LOCATION, fJsonFile.text)
	}

	override setDefaults(ILaunchConfigurationWorkingCopy configuration)
	{
		configuration.setAttribute(NablagenLaunchConstants::PROJECT, '')
		configuration.setAttribute(NablagenLaunchConstants::NGEN_FILE_LOCATION, '')
		configuration.setAttribute(NablagenLaunchConstants::JSON_FILE_LOCATION, '')
	}
}

class NablagenProjectSelectionAdapter extends SelectionAdapter
{
	val Composite parent
	val Text fTxtProject

	new(Composite parent, Text fTxtProject)
	{
		this.parent = parent
		this.fTxtProject = fTxtProject
	}

	override void widgetSelected(SelectionEvent e)
	{
		val dialog = new ElementTreeSelectionDialog(parent.shell, new WorkbenchLabelProvider, new ProjectContentProvider)
		dialog.setTitle("Select Project")
		dialog.setMessage("Select the project hosting your ngen file:")
		dialog.setInput(ResourcesPlugin.workspace.root)
		if (dialog.open == Window.OK)
			fTxtProject.setText((dialog.firstResult as IResource).name)
	}
}

class NablagenFileSelectionAdapter extends SelectionAdapter
{
	val Composite parent
	val Text fNablagenFile

	new(Composite parent, Text fNablagenFile)
	{
		this.parent = parent
		this.fNablagenFile = fNablagenFile
	}

	override void widgetSelected(SelectionEvent e)
	{
		val dialog = new ElementTreeSelectionDialog(parent.shell, new WorkbenchLabelProvider, new SourceFileContentProvider(NablagenLaunchConfigurationTab::NablagenFileExtension))
		dialog.setTitle("Select 'ngen' File")
		dialog.setMessage("Select the ngen file to execute:")
		dialog.setInput(ResourcesPlugin.workspace.root)
		if (dialog.open == Window.OK)
			fNablagenFile.setText((dialog.firstResult as IFile).projectRelativePath.toPortableString)
	}
}

class JsonFileSelectionAdapter extends SelectionAdapter
{
	val Composite parent
	val Text fJsonFile

	new(Composite parent, Text fJsonFile)
	{
		this.parent = parent
		this.fJsonFile = fJsonFile
	}

	override void widgetSelected(SelectionEvent e)
	{
		val dialog = new ElementTreeSelectionDialog(parent.shell, new WorkbenchLabelProvider, new SourceFileContentProvider(NablagenLaunchConfigurationTab::JsonFileExtension))
		dialog.setTitle("Select 'json' Data File")
		dialog.setMessage("Select the json data file containing the user options:")
		dialog.setInput(ResourcesPlugin.workspace.root)
		if (dialog.open == Window.OK)
			fJsonFile.setText((dialog.firstResult as IFile).projectRelativePath.toPortableString)
	}
}