/*******************************************************************************
 * Copyright (c) 2020 CEA
 * This program and the accompanying materials are made available under the 
 * terms of the Eclipse Public License 2.0 which is available at
 * http://www.eclipse.org/legal/epl-2.0.
 *
 * SPDX-License-Identifier: EPL-2.0
 * Contributors: see AUTHORS file
 *******************************************************************************/
package fr.cea.nabla.generator.ir

import com.google.inject.Inject
import com.google.inject.Singleton
import fr.cea.nabla.ir.ir.IrFactory
import fr.cea.nabla.ir.ir.IrModule
import fr.cea.nabla.ir.ir.SimpleVariable
import fr.cea.nabla.ir.ir.TimeLoopJob
import fr.cea.nabla.nabla.FunctionCall
import fr.cea.nabla.nabla.FunctionOrReduction
import fr.cea.nabla.nabla.NablaModule
import fr.cea.nabla.nabla.OptionDeclaration
import fr.cea.nabla.nabla.ReductionCall
import fr.cea.nabla.nabla.SimpleVarDeclaration
import fr.cea.nabla.nabla.VarGroupDeclaration
import fr.cea.nabla.nablagen.MainModule
import fr.cea.nabla.nablagen.NablagenModule
import fr.cea.nabla.overloading.DeclarationProvider
import java.util.HashMap
import java.util.LinkedHashSet
import org.eclipse.emf.ecore.EObject
import org.eclipse.emf.ecore.util.EcoreUtil

@Singleton
class Nabla2Ir
{
	@Inject extension IrAnnotationHelper
	@Inject extension DeclarationProvider
	@Inject extension TimeIteratorExtensions
	@Inject extension IrArgOrVarFactory
	@Inject extension IrJobFactory
	@Inject extension IrFunctionFactory

	val irModuleModels = new HashMap<NablaModule, IrModule>

	def createIrModule(NablagenModule ngenModule)
	{
		val nablaModule = ngenModule.type
		var irModule = irModuleModels.get(nablaModule)
		if (irModule === null)
		{
			irModule = nablaModule.toIrModule
			irModuleModels.put(nablaModule, irModule)
		}
		else
		{
			irModule = EcoreUtil.copy(irModule)
		}

		irModule.annotations += ngenModule.toIrAnnotation
		irModule.name = ngenModule.name
		irModule.main = (ngenModule instanceof MainModule)

		return irModule
	}

	private def create IrFactory::eINSTANCE.createIrModule toIrModule(NablaModule nablaModule)
	{
		nablaModule.allUsedFunctionAndReductions.forEach[x | functions += x.toIrFunction]

		// Time loop jobs creation
		if (nablaModule.iteration !== null)
			addJobsAndCountersToModule(nablaModule.iteration.iterator, it)

		// Variables creation: order must be keep to ensure default values validity
		val tlJobs = jobs.filter(TimeLoopJob)
		for (d : nablaModule.declarations)
			switch d
			{
				OptionDeclaration:
				{
					val options = createIrVariables(d.variable, tlJobs)
					options.filter(SimpleVariable).forEach[option = true]
					variables += options
				}
				SimpleVarDeclaration:
					variables += createIrVariables(d.variable, tlJobs)
				VarGroupDeclaration:
					for (v : d.variables)
						variables += createIrVariables(v, tlJobs)
			}

		// Job creation
		nablaModule.jobs.forEach[x | jobs += x.toIrInstructionJob]
	}

	/**
	 * Need to be recursive if a function/reduction use a function/reduction
	 */
	private def LinkedHashSet<FunctionOrReduction> getAllUsedFunctionAndReductions(EObject it)
	{
		val allUsedFunctionAndReductions = new LinkedHashSet<FunctionOrReduction>
		for (call : eAllContents.filter(FunctionCall).toIterable)
		{
			val f = call.declaration.model
			allUsedFunctionAndReductions += f
			if (f.body !== null)
				allUsedFunctionAndReductions += f.body.allUsedFunctionAndReductions
		}
		for (call : eAllContents.filter(ReductionCall).toIterable)
		{
			val f = call.declaration.model
			allUsedFunctionAndReductions += f
			if (f.body !== null)
				allUsedFunctionAndReductions += f.body.allUsedFunctionAndReductions
		}
		return allUsedFunctionAndReductions
	}
}