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

import org.eclipse.core.resources.IFile
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

class NablaLaunchConfigurationMainTab extends AbstractLaunchConfigurationTab
{
	public static val SourceFileExtension = 'nabla'
	public static val GenFileExtension = 'nablagen'
	public static val MoniloggerFileExtension = 'mnlg'
	boolean fDisableUpdate = false

	Text fTxtSourceFile
	Text fTxtGenFile
	Text fTxtMoniloggerFile

	override createControl(Composite parent) 
	{
		val topControl = new Composite(parent, SWT.NONE)
		topControl.setLayout(new GridLayout(1, false))

		val grpSource = new Group(topControl, SWT.NONE)
		grpSource.setLayout(new GridLayout(2, false))
		grpSource.setLayoutData(new GridData(SWT.FILL, SWT.CENTER, true, false, 1, 1))
		grpSource.setText("Nabla File")

		fTxtSourceFile = new Text(grpSource, SWT.BORDER)
		fTxtSourceFile.addModifyListener([e | if (!fDisableUpdate) updateLaunchConfigurationDialog])
		fTxtSourceFile.setLayoutData(new GridData(SWT.FILL, SWT.CENTER, true, false, 1, 1))

		val btnBrowseSource = new Button(grpSource, SWT::NONE)
		btnBrowseSource.addSelectionListener(new NablaFileSelectionAdapter(parent, fTxtSourceFile))
		btnBrowseSource.setText("Browse...")

		val grpGen = new Group(topControl, SWT.NONE)
		grpGen.setLayout(new GridLayout(2, false))
		grpGen.setLayoutData(new GridData(SWT.FILL, SWT.CENTER, true, false, 1, 1))
		grpGen.setText("Nablagen File")

		fTxtGenFile = new Text(grpGen, SWT.BORDER)
		fTxtGenFile.addModifyListener([e | if (!fDisableUpdate) updateLaunchConfigurationDialog])
		fTxtGenFile.setLayoutData(new GridData(SWT.FILL, SWT.CENTER, true, false, 1, 1))

		val btnBrowseGen = new Button(grpGen, SWT::NONE)
		btnBrowseGen.addSelectionListener(new NablaGenFileSelectionAdapter(parent, fTxtGenFile))
		btnBrowseGen.setText("Browse...")

		val grpMonilogger = new Group(topControl, SWT.NONE)
		grpMonilogger.setLayout(new GridLayout(2, false))
		grpMonilogger.setLayoutData(new GridData(SWT.FILL, SWT.CENTER, true, false, 1, 1))
		grpMonilogger.setText("Monilogger File")

		fTxtMoniloggerFile = new Text(grpMonilogger, SWT.BORDER)
		fTxtMoniloggerFile.addModifyListener([e | if (!fDisableUpdate) updateLaunchConfigurationDialog])
		fTxtMoniloggerFile.setLayoutData(new GridData(SWT.FILL, SWT.CENTER, true, false, 1, 1))

		val btnBrowseMonilogger = new Button(grpMonilogger, SWT::NONE)
		btnBrowseMonilogger.addSelectionListener(new MoniloggerFileSelectionAdapter(parent, fTxtMoniloggerFile))
		btnBrowseMonilogger.setText("Browse...")

		setControl(topControl)
	}
	
	override getName()
	{
		'Global'
	}

	override initializeFrom(ILaunchConfiguration configuration)
	{
		fDisableUpdate = true

		fTxtSourceFile.text = ''
		fTxtGenFile.text = ''
		fTxtMoniloggerFile.text = ''

		try
		{
			fTxtSourceFile.text = configuration.getAttribute(NablaLaunchConstants::SOURCE_FILE_LOCATION, '')
			fTxtGenFile.text = configuration.getAttribute(NablaLaunchConstants::GEN_FILE_LOCATION, '')
			val moniloggers = configuration.getAttribute(NablaLaunchConstants::MONILOGGER_FILES_LOCATIONS, newArrayList)
			fTxtMoniloggerFile.text = if (moniloggers.empty) '' else moniloggers.head
		}
		catch (CoreException e)
		{
		}
		fDisableUpdate = false
	}

	override performApply(ILaunchConfigurationWorkingCopy configuration)
	{
		configuration.setAttribute(NablaLaunchConstants::SOURCE_FILE_LOCATION, fTxtSourceFile.text)
		configuration.setAttribute(NablaLaunchConstants::GEN_FILE_LOCATION, fTxtGenFile.text)
		configuration.setAttribute(NablaLaunchConstants::MONILOGGER_FILES_LOCATIONS, newArrayList(fTxtMoniloggerFile.text))
	}

	override setDefaults(ILaunchConfigurationWorkingCopy configuration)
	{
		configuration.setAttribute(NablaLaunchConstants::SOURCE_FILE_LOCATION, '')
		configuration.setAttribute(NablaLaunchConstants::GEN_FILE_LOCATION, '')
		configuration.setAttribute(NablaLaunchConstants::MONILOGGER_FILES_LOCATIONS, newArrayList)
	}
}

class NablaFileSelectionAdapter extends SelectionAdapter
{
	val Composite parent
	val Text fTxtFile

	new(Composite parent, Text fTxtFile)
	{
		this.parent = parent
		this.fTxtFile = fTxtFile
	}

	override void widgetSelected(SelectionEvent e)
	{
		val dialog = new ElementTreeSelectionDialog(parent.shell, new WorkbenchLabelProvider, new SourceFileContentProvider(NablaLaunchConfigurationMainTab::SourceFileExtension))
		dialog.setTitle("Select Nabla File")
		dialog.setMessage("Select the nabla file to execute:")
		dialog.setInput(ResourcesPlugin.workspace.root)
		if (dialog.open == Window.OK)
			fTxtFile.setText((dialog.firstResult as IFile).fullPath.makeRelative.toPortableString)
	}
}

class NablaGenFileSelectionAdapter extends SelectionAdapter
{
	val Composite parent
	val Text fTxtFile

	new(Composite parent, Text fTxtFile)
	{
		this.parent = parent
		this.fTxtFile = fTxtFile
	}

	override void widgetSelected(SelectionEvent e)
	{
		val dialog = new ElementTreeSelectionDialog(parent.shell, new WorkbenchLabelProvider, new SourceFileContentProvider(NablaLaunchConfigurationMainTab::GenFileExtension))
		dialog.setTitle("Select Nablagen File")
		dialog.setMessage("Select the nablagen file to use for the execution:")
		dialog.setInput(ResourcesPlugin.workspace.root)
		if (dialog.open == Window.OK)
			fTxtFile.setText((dialog.firstResult as IFile).fullPath.makeRelative.toPortableString)
	}
}

class MoniloggerFileSelectionAdapter extends SelectionAdapter
{
	val Composite parent
	val Text fTxtFile

	new(Composite parent, Text fTxtFile)
	{
		this.parent = parent
		this.fTxtFile = fTxtFile
	}

	override void widgetSelected(SelectionEvent e)
	{
		val dialog = new ElementTreeSelectionDialog(parent.shell, new WorkbenchLabelProvider, new SourceFileContentProvider(NablaLaunchConfigurationMainTab::MoniloggerFileExtension))
		dialog.setTitle("Select Monilogger File")
		dialog.setMessage("Select a monilogger file to add to the execution:")
		dialog.setInput(ResourcesPlugin.workspace.root)
		if (dialog.open == Window.OK)
			fTxtFile.setText((dialog.firstResult as IFile).fullPath.makeRelative.toPortableString)
	}
}