/*******************************************************************************
 * Copyright (c) 2021 CEA
 * This program and the accompanying materials are made available under the 
 * terms of the Eclipse Public License 2.0 which is available at
 * http://www.eclipse.org/legal/epl-2.0.
 *
 * SPDX-License-Identifier: EPL-2.0
 * Contributors: see AUTHORS file
 *******************************************************************************/
package fr.cea.nabla.ir.transformers

import fr.cea.nabla.ir.JobDependencies
import fr.cea.nabla.ir.JobExtensions
import fr.cea.nabla.ir.ir.IrFactory
import fr.cea.nabla.ir.ir.IrRoot
import fr.cea.nabla.ir.ir.Variable
import org.eclipse.emf.ecore.util.EcoreUtil

import static extension fr.cea.nabla.ir.IrTypeExtensions.*

class CreateInitVariableJobs extends IrTransformationStep
{
	new()
	{
		super('Create jobs to read option value or set default value of global variables')
	}

	/**
	 * Creates initialization jobs for each non constexpr global variables which:
	 * - has a default value: the job will set the value
	 * - is an option: the job will read the option
	 * - has a dynamic type: the job will allocate the array
	 */
	override transform(IrRoot ir)
	{
		trace('    IR -> IR: ' + description)

		for (m : ir.modules)
		{
			for (v : m.variables.filter[!constExpr])
			{
				if (v.defaultValue !== null || v.option || v.type.dynamicBaseType)
				{
					val j = toIrInitVariableJob(v)
					JobDependencies.computeAndSetInOutVars(j)
					m.jobs += j
					ir.jobs += j
				}
			}
		}

		// update job dependencies
		ir.jobs.forEach[x | JobDependencies.computeAndSetNextJobs(x)]

		return true
	}

	def create IrFactory::eINSTANCE.createInitVariableJob toIrInitVariableJob(Variable v)
	{
		v.annotations.forEach[x | annotations += EcoreUtil::copy(x)]
		name = v.initVariableJobName
		onCycle = false
		timeLoopJob = false
		target = v
		if (v.defaultValue !== null)
		{
			instruction = IrFactory::eINSTANCE.createAffectation =>
			[ a |
				a.left = IrFactory::eINSTANCE.createArgOrVarRef => 
				[ vref |
					vref.type = EcoreUtil::copy(v.type)
					vref.target = v
				]
				a.right = v.defaultValue
			]

			v.defaultValue = null
		}
	}

	/**
	 * Return the name of the initialization job of the variable v.
	 * Do not add "toFirstUpper": x and X possible in the same module.
	 */
	private def getInitVariableJobName(Variable v)
	{
		JobExtensions.INIT_VARIABLE_PREFIX + v.name
	}
}
