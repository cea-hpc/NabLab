/*******************************************************************************
 * Copyright (c) 2020 CEA
 * This program and the accompanying materials are made available under the 
 * terms of the Eclipse Public License 2.0 which is available at
 * http://www.eclipse.org/legal/epl-2.0.
 *
 * SPDX-License-Identifier: EPL-2.0
 * Contributors: see AUTHORS file
 *******************************************************************************/
package fr.cea.nabla.ir.transformers

import fr.cea.nabla.ir.ir.ArgOrVarRef
import fr.cea.nabla.ir.ir.ConnectivityVariable
import fr.cea.nabla.ir.ir.Instruction
import fr.cea.nabla.ir.ir.InstructionJob
import fr.cea.nabla.ir.ir.IrFactory
import fr.cea.nabla.ir.ir.IrModule
import java.util.ArrayList
import org.eclipse.emf.ecore.util.EcoreUtil

import static fr.cea.nabla.ir.transformers.IrTransformationUtils.*

import static extension fr.cea.nabla.ir.JobExtensions.*

class DeclareConstVariables implements IrTransformationStep
{
	override getDescription()
	{
		'Declare const local variables in jobs (Kokkos optimization)'
	}

	override transform(IrModule m)
	{
		for (job : m.eAllContents.filter(InstructionJob).toIterable)
		{
			val jobInVars = job.inVars
			if (!jobInVars.empty)
			{
				val varDefinitions = new ArrayList<Instruction>
				for (jobInvar : jobInVars.filter(ConnectivityVariable))
				{
					val newConstVar = jobInvar.newVariable
					varDefinitions += IrFactory::eINSTANCE.createVariableDefinition => [variable = newConstVar]
					for (jobInVarRef : job.eAllContents.filter(ArgOrVarRef).filter[x | x.target == jobInvar].toIterable)
						jobInVarRef.target = newConstVar
				}
				insertBefore(job.instruction, varDefinitions)
			}
		}
		return true
	}

	override getOutputTraces()
	{
		#[]
	}

	private def newVariable(ConnectivityVariable v)
	{
		IrFactory::eINSTANCE.createConnectivityVariable =>
		[
			const = true
			name = 'const_' + v.name
			type = EcoreUtil::copy(type)
			defaultValue = IrFactory::eINSTANCE.createArgOrVarRef => [ target = v ]
		]
	}
}