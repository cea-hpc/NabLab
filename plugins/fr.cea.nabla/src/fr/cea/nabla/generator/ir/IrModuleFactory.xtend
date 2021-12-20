/*******************************************************************************
 * Copyright (c) 2021 CEA
 * This program and the accompanying materials are made available under the
 * terms of the Eclipse Public License 2.0 which is available at
 * http://www.eclipse.org/legal/epl-2.0.
 *
 * SPDX-License-Identifier: EPL-2.0
 * Contributors: see AUTHORS file
 *******************************************************************************/
package fr.cea.nabla.generator.ir

import com.google.inject.Inject
import fr.cea.nabla.ir.ir.IrFactory
import fr.cea.nabla.ir.ir.IrModule
import fr.cea.nabla.nabla.Function
import fr.cea.nabla.nabla.FunctionCall
import fr.cea.nabla.nabla.FunctionOrReduction
import fr.cea.nabla.nabla.NablaModule
import fr.cea.nabla.nabla.Reduction
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

class IrModuleFactory
{
	@Inject extension NabLabFileAnnotationFactory
	@Inject extension DeclarationProvider
	@Inject extension TimeIteratorExtensions
	@Inject extension IrArgOrVarFactory
	@Inject extension IrJobFactory
	@Inject extension IrFunctionFactory

	val irModuleModels = new HashMap<NablaModule, IrModule>

	/** 
	 * Return a IrModule instance for a ngenModule instance.
	 * If an IRModule instance already exists, it has to be duplicated
	 */
	def toIrModule(NablagenModule ngenModule)
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

		irModule.annotations += ngenModule.toNabLabFileAnnotation
		irModule.name = ngenModule.name
		irModule.main = (ngenModule instanceof MainModule)

		return irModule
	}

	private def create IrFactory::eINSTANCE.createIrModule toIrModule(NablaModule nablaModule)
	{
		for (f : nablaModule.allUsedFunctionAndReductions)
			switch f
			{
				Function case !f.external: functions += f.toIrInternFunction
				Reduction: functions += f.toIrFunction
			}

		// Time loop jobs creation
		if (nablaModule.iteration !== null)
			addJobsAndCountersToModule(nablaModule.iteration.iterator, it)

		// Variables creation: order must be kept to ensure default values validity
		val tlJobs = jobs.filter(j | j.timeLoopJob)
		for (d : nablaModule.declarations)
			switch d
			{
				SimpleVarDeclaration: variables += createIrVariables(d.variable, tlJobs)
				VarGroupDeclaration:
					for (v : d.variables)
						variables += createIrVariables(v, tlJobs)
			}

		// Job creation
		nablaModule.jobs.forEach[x | jobs += x.toIrInstructionJob => [ it.caller = null ]]
	}

	/**
	 * Need to be recursive if a function/reduction use a function/reduction
	 * coming from a NablaExtension (not in eAllContents of the NablaModule).
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