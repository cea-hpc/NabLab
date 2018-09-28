/*******************************************************************************
 * Copyright (c) 2018 CEA
 * This program and the accompanying materials are made available under the 
 * terms of the Eclipse Public License 2.0 which is available at
 * http://www.eclipse.org/legal/epl-2.0.
 *
 * SPDX-License-Identifier: EPL-2.0
 *
 * Contributors:
 * 	Benoit Lelandais - initial implementation
 * 	Marie-Pierre Oudot - initial implementation
 * 	Jean-Sylvain Camier - Nabla generation support
 *******************************************************************************/
package fr.cea.nabla.ui

import org.eclipse.core.resources.IncrementalProjectBuilder
import java.util.Map
import org.eclipse.core.runtime.IProgressMonitor
import org.eclipse.core.runtime.CoreException

class NablacBuilder extends IncrementalProjectBuilder 
{
	override protected build(int kind, Map<String, String> args, IProgressMonitor monitor) throws CoreException 
	{
		println('NablacBuilder::build : ' + args)
		return null
	}
}