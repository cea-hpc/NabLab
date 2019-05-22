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
	public static val FileExtension = 'nablagen'
	boolean fDisableUpdate = false
	
	Text fTxtProject
	Text fTxtFile
	
	override createControl(Composite parent) 
	{
		val topControl = new Composite(parent, SWT.NONE)
		topControl.setLayout(new GridLayout(1, false))

		val fGroup = new Group(topControl, SWT.NONE)
		fGroup.setLayout(new GridLayout(2, false))
		fGroup.setLayoutData(new GridData(SWT.FILL, SWT.CENTER, true, false, 1, 1))
		fGroup.setText("Project")
		
		fTxtProject = new Text(fGroup, SWT.BORDER)
		fTxtProject.setLayoutData(new GridData(SWT.FILL, SWT.CENTER, true, false, 1, 1))
		
		val fBtnBrowseProject = new Button(fGroup, SWT.NONE)
		fBtnBrowseProject.addSelectionListener(new NablagenProjectSelectionAdapter(parent, fTxtProject))
		fBtnBrowseProject.setText("Browse...");

		val grpLaunch = new Group(topControl, SWT.NONE)
		grpLaunch.setLayout(new GridLayout(2, false))
		grpLaunch.setLayoutData(new GridData(SWT.FILL, SWT.CENTER, true, false, 1, 1))
		grpLaunch.setText("Nablagen File")

		fTxtFile = new Text(grpLaunch, SWT.BORDER)
		fTxtFile.addModifyListener([e | if (!fDisableUpdate) updateLaunchConfigurationDialog])
		fTxtFile.setLayoutData(new GridData(SWT.FILL, SWT.CENTER, true, false, 1, 1))

		val btnBrowseScript = new Button(grpLaunch, SWT::NONE)
		btnBrowseScript.addSelectionListener(new NablagenFileSelectionAdapter(parent, fTxtFile))
		btnBrowseScript.setText("Browse...");

		setControl(topControl);
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
			fTxtFile.text = configuration.getAttribute(NablagenLaunchConstants::FILE_LOCATION, '')
		}
		catch (CoreException e)
		{	
		}
		fDisableUpdate = false
	}
	
	override performApply(ILaunchConfigurationWorkingCopy configuration) 
	{
		configuration.setAttribute(NablagenLaunchConstants::PROJECT, fTxtProject.text)
		configuration.setAttribute(NablagenLaunchConstants::FILE_LOCATION, fTxtFile.text)
	}
	
	override setDefaults(ILaunchConfigurationWorkingCopy configuration) 
	{
		configuration.setAttribute(NablagenLaunchConstants::PROJECT, '')
		configuration.setAttribute(NablagenLaunchConstants::FILE_LOCATION, '')
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
		dialog.setMessage("Select the project hosting your nablagen file:")
		dialog.setInput(ResourcesPlugin.workspace.root)
		if (dialog.open == Window.OK)
			fTxtProject.setText((dialog.firstResult as IResource).name)
	}
}

class NablagenFileSelectionAdapter extends SelectionAdapter 
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
		val dialog = new ElementTreeSelectionDialog(parent.shell, new WorkbenchLabelProvider, new SourceFileContentProvider(NablagenLaunchConfigurationTab::FileExtension))
		dialog.setTitle("Select Nablagen File")
		dialog.setMessage("Select the nablagen file to execute:")
		dialog.setInput(ResourcesPlugin.workspace.root)
		if (dialog.open == Window.OK)
			fTxtFile.setText((dialog.firstResult as IFile).projectRelativePath.toPortableString)
	}
}