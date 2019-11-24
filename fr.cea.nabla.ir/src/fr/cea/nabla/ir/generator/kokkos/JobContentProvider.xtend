/*******************************************************************************
 * Copyright (c) 2018 CEA
 * This program and the accompanying materials are made available under the 
 * terms of the Eclipse Public License 2.0 which is available at
 * http://www.eclipse.org/legal/epl-2.0.
 *
 * SPDX-License-Identifier: EPL-2.0
 * Contributors: see AUTHORS file
 *******************************************************************************/
package fr.cea.nabla.ir.generator.kokkos

import fr.cea.nabla.ir.MandatoryMeshVariables
import fr.cea.nabla.ir.MandatorySimulationVariables
import fr.cea.nabla.ir.ir.ConnectivityVariable
import fr.cea.nabla.ir.ir.EndOfInitJob
import fr.cea.nabla.ir.ir.EndOfTimeLoopJob
import fr.cea.nabla.ir.ir.InSituJob
import fr.cea.nabla.ir.ir.InstructionJob
import fr.cea.nabla.ir.ir.Job
import org.eclipse.xtend.lib.annotations.Accessors

import static extension fr.cea.nabla.ir.generator.Utils.*

abstract class JobContentProvider 
{
	@Accessors val extension InstructionContentProvider instructionContentProvider

	new(InstructionContentProvider icp) 
	{ 
		instructionContentProvider = icp
	}

	abstract def CharSequence getJobCallsContent(Iterable<Job> jobs)
	abstract def CharSequence getContent(Job it)

	protected def dispatch CharSequence getInnerContent(InstructionJob it)
	'''
		«instruction.innerContent»
	'''

	protected def dispatch CharSequence getInnerContent(InSituJob it)
	'''
		if (!writer.isDisabled() && «condition») 
		{
			std::map<string, double*> cellVariables;
			std::map<string, double*> nodeVariables;
			«FOR v : variables.filter(ConnectivityVariable)»
			«v.type.connectivities.head.returnType.type.name»Variables.insert(pair<string,double*>("«v.persistenceName»", «v.name».data()));
			«ENDFOR»
			auto quads = mesh->getGeometricMesh()->getQuads();
			writer.writeFile(iteration, «MandatorySimulationVariables::TIME», nbNodes, «MandatoryMeshVariables::COORD».data(), nbCells, quads.data(), cellVariables, nodeVariables);
			«IF timeStep>0»«LastWriteTimeVariableName» += «timeStep»;«ENDIF»
		}
	'''

	protected def dispatch CharSequence getInnerContent(EndOfTimeLoopJob it)
	'''
		std::swap(«right.name», «left.name»);
	'''

	protected def dispatch CharSequence getInnerContent(EndOfInitJob it)
	'''
		deep_copy(«left.name», «right.name»);
	'''
}