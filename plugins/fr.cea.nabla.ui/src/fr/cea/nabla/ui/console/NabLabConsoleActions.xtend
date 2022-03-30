/*******************************************************************************
 * Copyright (c) 2022 CEA
 * This program and the accompanying materials are made available under the
 * terms of the Eclipse Public License 2.0 which is available at
 * http://www.eclipse.org/legal/epl-2.0.
 *
 * SPDX-License-Identifier: EPL-2.0
 * Contributors: see AUTHORS file
 *******************************************************************************/
package fr.cea.nabla.ui.console

import org.eclipse.jface.action.Action
import org.eclipse.jface.action.Separator
import org.eclipse.jface.resource.ImageDescriptor
import org.eclipse.ui.IActionBars
import org.eclipse.ui.ISharedImages
import org.eclipse.ui.PlatformUI
import org.eclipse.ui.console.IConsole
import org.eclipse.ui.console.IConsoleConstants
import org.eclipse.ui.console.IConsolePageParticipant
import org.eclipse.ui.part.IPageBookViewPage

class NabLabConsoleActions implements IConsolePageParticipant
{
	IPageBookViewPage page
	Action stop
	IActionBars bars
	NabLabConsole console

	override void init(IPageBookViewPage page, IConsole console)
	{
		this.console = console as NabLabConsole
		this.console.actions = this
		this.page = page
		this.bars = page.site.actionBars

		createTerminateAllButton
		bars.menuManager.add(new Separator)
		bars.toolBarManager.appendToGroup(IConsoleConstants.LAUNCH_GROUP, stop)

		bars.updateActionBars
	}

	override dispose()
	{
		stop = null
		bars = null
		page = null
	}

	override Object getAdapter(Class adapter)
	{
		null
	}

	override activated()
	{
	}

	override deactivated()
	{
	}

	private def void createTerminateAllButton()
	{
		val image = PlatformUI.workbench.sharedImages.getImage(ISharedImages.IMG_ELCL_STOP)
		val imageDescriptor = ImageDescriptor.createFromImage(image)
		this.stop = new Action("Terminate all", imageDescriptor)
		{
			override void run()
			{
				for(c : console.runners) c.run
			}
		}
		updateVis
	}

	package def void updateVis()
	{
		if (page !== null)
		{
			stop.enabled = !console.runners.empty
			bars.updateActionBars
		}
	}
}