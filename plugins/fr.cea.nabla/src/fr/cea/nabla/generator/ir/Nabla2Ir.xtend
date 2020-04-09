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
import fr.cea.nabla.ir.ir.ConnectivityVariable
import fr.cea.nabla.ir.ir.IrFactory
import fr.cea.nabla.ir.ir.SimpleVariable
import fr.cea.nabla.ir.ir.TimeLoop
import fr.cea.nabla.nabla.ConnectivityVar
import fr.cea.nabla.nabla.FunctionCall
import fr.cea.nabla.nabla.FunctionOrReduction
import fr.cea.nabla.nabla.NablaModule
import fr.cea.nabla.nabla.ReductionCall
import fr.cea.nabla.nabla.SimpleVar
import fr.cea.nabla.nabla.SimpleVarDefinition
import fr.cea.nabla.nabla.VarGroupDeclaration
import fr.cea.nabla.overloading.DeclarationProvider
import java.util.LinkedHashSet
import org.eclipse.emf.ecore.EObject

import static fr.cea.nabla.ir.Utils.*

class Nabla2Ir
{
	@Inject extension Nabla2IrUtils
	@Inject extension IrArgOrVarFactory
	@Inject extension IrTimeLoopFactory
	@Inject extension IrJobFactory
	@Inject extension IrFunctionFactory
	@Inject extension IrConnectivityFactory
	@Inject extension IrAnnotationHelper
	@Inject extension DeclarationProvider

	def create IrFactory::eINSTANCE.createIrModule toIrModule(NablaModule nablaModule, SimpleVar nablaTimeVariable, SimpleVar nablaDeltatVariable, ConnectivityVar nablaNodeCoordVariable)
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
			val timeIterators = nablaModule.iteration.iterators
			val firstTimeIterator = timeIterators.head
			val mainIC = firstTimeIterator.toIrIterationCounter
			variables += mainIC
			mainTimeLoop = firstTimeIterator.toIrTimeLoop
			mainTimeLoop.iterationCounter = mainIC
			var TimeLoop outerTL = mainTimeLoop
			for (ti : timeIterators.tail)
			{
				val ic = ti.toIrIterationCounter
				variables += ic
				val tl = ti.toIrTimeLoop
				tl.iterationCounter = ic
				outerTL.innerTimeLoop = tl
				outerTL = tl
			}
		}

		// Global variables creation
		for (instruction : nablaModule.instructions)
		{
			switch instruction
			{
				SimpleVarDefinition: variables += createIrVariablesFor(nablaModule, instruction.variable)
				VarGroupDeclaration: instruction.variables.forEach[x | variables += createIrVariablesFor(nablaModule, x) ]
			}
		}

		// Special variables initialization
		initNodeCoordVariable = getInitIrVariable(it, nablaNodeCoordVariable.name) as ConnectivityVariable
		nodeCoordVariable = getCurrentIrVariable(it, nablaNodeCoordVariable.name) as ConnectivityVariable
		timeVariable = getCurrentIrVariable(it, nablaTimeVariable.name) as SimpleVariable
		deltatVariable = getCurrentIrVariable(it, nablaDeltatVariable.name) as SimpleVariable

		// TimeLoop jobs creation
		if (mainTimeLoop !== null) jobs += mainTimeLoop.createTimeLoopJobs

		// Job creation
		nablaModule.jobs.forEach[x | jobs += x.toIrInstructionJob]

		// Create a unique name for reduction instruction variable
		var i = 0
		for (v : eAllContents.filter(SimpleVariable).toIterable)
			if (v.name == ReductionCallExtensions.ReductionVariableName)
				v.name = v.name.replace("<NUMBER>", (i++).toString)
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