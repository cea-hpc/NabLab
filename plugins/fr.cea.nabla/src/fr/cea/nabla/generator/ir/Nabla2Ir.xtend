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
import fr.cea.nabla.ir.ir.IrFactory
import fr.cea.nabla.ir.ir.SimpleVariable
import fr.cea.nabla.nabla.FunctionCall
import fr.cea.nabla.nabla.FunctionOrReduction
import fr.cea.nabla.nabla.NablaModule
import fr.cea.nabla.nabla.OptionDeclaration
import fr.cea.nabla.nabla.ReductionCall
import fr.cea.nabla.nabla.SimpleVarDeclaration
import fr.cea.nabla.nabla.VarGroupDeclaration
import fr.cea.nabla.overloading.DeclarationProvider
import java.util.LinkedHashSet
import org.eclipse.emf.ecore.EObject

class Nabla2Ir
{
	@Inject extension Nabla2IrUtils
	@Inject extension IrTimeLoopFactory
	@Inject extension IrJobFactory
	@Inject extension IrFunctionFactory
	@Inject extension IrConnectivityFactory
	@Inject extension IrAnnotationHelper
	@Inject extension DeclarationProvider

	def create IrFactory::eINSTANCE.createIrModule toIrModule(NablaModule nablaModule)
	{
		annotations += nablaModule.toIrAnnotation
		name = nablaModule.name
		nablaModule.imports.forEach[x | imports += x.toIrImport]
		nablaModule.itemTypes.forEach[x | itemTypes += x.toIrItemType]
		nablaModule.connectivities.forEach[x | connectivities += x.toIrConnectivity]

		// Function and reduction
		nablaModule.allUsedFunctionAndReductions.forEach[x | functions += x.toIrFunction]

		// Time loop creation
		if (nablaModule.iteration !== null)
		{
			val timeIt = nablaModule.iteration.iterator
			variables += createTimeLoopsAndIterationCounters(it, timeIt)
		}

		// Option and global variables creation
		for (d : nablaModule.declarations)
			switch d
			{
				OptionDeclaration:
					options += createIrVariablesFor(nablaModule, d.variable).filter(SimpleVariable)
				SimpleVarDeclaration:
					variables += createIrVariablesFor(nablaModule, d.variable).filter(SimpleVariable)
				VarGroupDeclaration:
					for (v : d.variables)
						variables += createIrVariablesFor(nablaModule, v)
			}

		// TimeLoop jobs creation
		jobs += createTimeLoopJobs

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