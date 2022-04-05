/*******************************************************************************
 * Copyright (c) 2021 CEA
 * This program and the accompanying materials are made available under the
 * terms of the Eclipse Public License 2.0 which is available at
 * http://www.eclipse.org/legal/epl-2.0.
 *
 * SPDX-License-Identifier: EPL-2.0
 * Contributors: see AUTHORS file
 *******************************************************************************/
package fr.cea.nabla.ide.web

import org.eclipse.xtext.ide.server.ServerModule
import org.eclipse.xtext.ide.server.ProjectManager

class NabLabServerModule extends ServerModule
{
	
	override protected configure()
	{
		super.configure()
		bind(typeof(ProjectManager)).to(typeof(NabLabProjectManager))
	}
	
}