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

import java.util.ArrayList
import org.eclipse.jface.resource.ImageDescriptor
import org.eclipse.ui.console.MessageConsole

class NabLabConsole extends MessageConsole
{
	public static val ConsoleName = "NabLab Console"

	package val runners = new ArrayList<Runnable>
	package NabLabConsoleActions actions

	new(ImageDescriptor imageDescriptor)
	{
		super(ConsoleName, imageDescriptor)
	}
}