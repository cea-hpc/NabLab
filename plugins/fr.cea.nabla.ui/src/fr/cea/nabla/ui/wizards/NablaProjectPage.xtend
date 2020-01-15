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
import org.eclipse.swt.widgets.Composite
import org.eclipse.swt.widgets.Event
import org.eclipse.swt.widgets.Label
import org.eclipse.swt.widgets.Listener
import org.eclipse.swt.widgets.Text
import org.eclipse.ui.dialogs.WizardNewProjectCreationPage

/**
 * The first page of the new Nabla project wizard.
 */
class NablaProjectPage extends WizardNewProjectCreationPage
{

	static val MODULE_NAME_FIELD_WIDTH = 250
	String initialModuleFieldValue = null
	Text moduleNameField

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
		createModuleNameGroup(control as Composite)
		pageComplete = validatePage
	}

	override protected validatePage()
	{
		val validProject = super.validatePage
		if (validProject)
		{
			val moduleFieldContents = moduleNameFieldValue
			if (moduleFieldContents.empty)
			{
				errorMessage = null
				message = "Module name must be specified"
				return false
			}
			val authorizedModuleCharacters = Pattern::compile("([A-Z]|_)([a-z]|[A-Z]|[0-9]|_)*").matcher(moduleFieldContents)
			if (!authorizedModuleCharacters.matches)
			{
				if (!authorizedModuleCharacters.lookingAt)
				{
					errorMessage = "Module name must start with an upper case"
					return false
				}
				errorMessage = "Module name contains invalid character(s)"
				return false
			}
			errorMessage = null
			message = null
			return true
		}
		return false
	}

	def String getModuleName()
	{
		if (moduleNameField === null)
		{
			return initialModuleFieldValue
		}
		return moduleNameFieldValue
	}

	def setInitialModuleName(String name)
	{
		if (name === null)
		{
			initialModuleFieldValue = null
		} else {
			initialModuleFieldValue = name.trim
		}
	}

	private def String getModuleNameFieldValue()
	{
		if (moduleNameField === null)
		{
			return ""
		}
		return moduleNameField.text.trim
	}

	private def createModuleNameGroup(Composite parent)
	{
		val moduleGroup = new Composite(parent, SWT.NONE)
		val layout = new GridLayout()
		layout.numColumns = 2
		moduleGroup.layout = layout
		moduleGroup.layoutData = new GridData(GridData.FILL_HORIZONTAL)

		val moduleLabel = new Label(moduleGroup, SWT.NONE)
		moduleLabel.text = "Module Name:"
		moduleLabel.font = parent.font

		moduleNameField = new Text(moduleGroup, SWT.BORDER)
		val data = new GridData(GridData.FILL_HORIZONTAL)
		data.widthHint = MODULE_NAME_FIELD_WIDTH
		moduleNameField.layoutData = data
		moduleNameField.font = parent.font

		if (initialModuleFieldValue !== null)
		{
			moduleNameField.text = initialModuleFieldValue
		}
		moduleNameField.addListener(SWT.Modify, moduleModifyListener)
		BidiUtils.applyBidiProcessing(moduleNameField, BidiUtils.BTD_DEFAULT)
	}
}