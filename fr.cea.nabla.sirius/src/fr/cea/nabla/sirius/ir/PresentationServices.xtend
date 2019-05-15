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
package fr.cea.nabla.sirius.ir

import fr.cea.nabla.ir.ir.EndOfTimeLoopJob
import fr.cea.nabla.ir.ir.Variable

import static extension fr.cea.nabla.ir.VariableExtensions.*

class PresentationServices 
{
	static def startsGraph(Variable it) { previousJobs.empty }
	static def endsGraph(Variable it) { nextJobs.empty }
	static def startsTimeLoop(Variable it) { previousJobs.exists[x|x instanceof EndOfTimeLoopJob] }
	static def endsTimeLoop(Variable it) { nextJobs.exists[x|x instanceof EndOfTimeLoopJob] }
	static def isOnCycle(Variable it) { previousJobs.exists[x|x.onCycle] }
	static def isInit(Variable it) { !previousJobs.exists[x|x.at>0] }	
} 