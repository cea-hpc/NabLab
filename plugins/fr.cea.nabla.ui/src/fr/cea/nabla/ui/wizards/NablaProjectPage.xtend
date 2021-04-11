/*******************************************************************************
 * Copyright (c) 2020 CEA
 * This program and the accompanying materials are made available under the
 * terms of the Eclipse Public License 2.0 which is available at
 * http://www.eclipse.org/legal/epl-2.0.
 *
 * SPDX-License-Identifier: EPL-2.0
 * Contributors: see AUTHORS file
 *******************************************************************************/
 package fr.cea.nabla.ui.wizards

import java.util.regex.Pattern
import org.eclipse.jface.util.BidiUtils
import org.eclipse.swt.SWT
import org.eclipse.swt.layout.GridData
import org.eclipse.swt.layout.GridLayout
import org.eclipse.swt.widgets.Button
import org.eclipse.swt.widgets.Composite
import org.eclipse.swt.widgets.Event
import org.eclipse.swt.widgets.Group
import org.eclipse.swt.widgets.Label
import org.eclipse.swt.widgets.Listener
import org.eclipse.swt.widgets.Text
import org.eclipse.ui.dialogs.WizardNewProjectCreationPage

/**
 * The first page of the new project wizard.
 */
class NablaProjectPage extends WizardNewProjectCreationPage
{
	static val MODULE_OR_EXTENSION_NAME_FIELD_WIDTH = 250
	Text moduleOrExtensionNameField
	Button moduleButton
	Button extensionButton

	var moduleModifyListener = new Listener()
	{
		override handleEvent(Event event)
		{
			// setLocationForSelection()
			val valid = validatePage
			pageComplete = valid
		}
	}

	new(String pageName)
	{
		super(pageName)
	}

	override createControl(Composite parent)
	{
		super.createControl(parent)
		val p = createButtonGroup(control as Composite)
		createModuleNameGroup(p as Composite)
		pageComplete = validatePage
	}

	override protected validatePage()
	{
		val validProject = super.validatePage
		if (validProject)
		{
			val moduleFieldContents = moduleOrExtensionName
			if (moduleFieldContents.empty)
			{
				errorMessage = null
				message = "Module/Extension name must be specified"
				return false
			}
			val authorizedModuleCharacters = Pattern::compile("([A-Z]|_)([a-z]|[A-Z]|[0-9]|_)*").matcher(moduleFieldContents)
			if (!authorizedModuleCharacters.matches)
			{
				if (!authorizedModuleCharacters.lookingAt)
				{
					errorMessage = "Module/Extension name must start with an upper case"
					return false
				}
				errorMessage = "Module/Extension name contains invalid character(s)"
				return false
			}
			errorMessage = null
			message = null
			return true
		}
		return false
	}

	def boolean isModule()
	{
		moduleButton.selection
	}

	def String getModuleOrExtensionName()
	{
		if (moduleOrExtensionNameField === null) ""
		else moduleOrExtensionNameField.text.trim
	}

	private def createButtonGroup(Composite parent)
	{
		val group = new Group(parent, SWT.SHADOW_IN)
		group.layout = new GridLayout()
		group.layoutData = new GridData(GridData.FILL_HORIZONTAL)
		group.setText("Module or Extension")

		moduleButton = new Button(group, SWT.RADIO)
		moduleButton.setText("Module")
		moduleButton.selection = true

		extensionButton = new Button(group, SWT.RADIO)
		extensionButton.setText("Extension")
		extensionButton.selection = false
		extensionButton.alignment = SWT.RIGHT
		return group
	}

	private def createModuleNameGroup(Composite parent)
	{
		val moduleGroup = new Composite(parent, SWT.NONE)
		val layout = new GridLayout()
		layout.numColumns = 2
		moduleGroup.layout = layout
		moduleGroup.layoutData = new GridData(GridData.FILL_HORIZONTAL)

		val moduleOrExtensionLabel = new Label(moduleGroup, SWT.NONE)
		moduleOrExtensionLabel.text = "Name:"
		moduleOrExtensionLabel.font = parent.font

		moduleOrExtensionNameField = new Text(moduleGroup, SWT.BORDER)
		val data = new GridData(GridData.FILL_HORIZONTAL)
		data.widthHint = MODULE_OR_EXTENSION_NAME_FIELD_WIDTH
		moduleOrExtensionNameField.layoutData = data
		moduleOrExtensionNameField.font = parent.font

		moduleOrExtensionNameField.addListener(SWT.Modify, moduleModifyListener)
		BidiUtils.applyBidiProcessing(moduleOrExtensionNameField, BidiUtils.BTD_DEFAULT)
		return moduleGroup
	}
}