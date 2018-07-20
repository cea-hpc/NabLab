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
 * 	Jean-Sylvan Camier - Nabla generation support
 *******************************************************************************/
package fr.cea.nabla.ui

import org.eclipse.xtext.builder.IXtextBuilderParticipant
import org.eclipse.xtext.builder.IXtextBuilderParticipant.IBuildContext
import org.eclipse.core.runtime.IProgressMonitor
import org.eclipse.core.runtime.CoreException

class NablacBuilderParticipant implements IXtextBuilderParticipant 
{
	override build(IBuildContext context, IProgressMonitor monitor) throws CoreException 
	{
		println('### NablacBuilderParticipant::build : ' + context.deltas.map[x|x.uri.toString].join(', '))
	}
}