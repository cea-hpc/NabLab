/*******************************************************************************
 * Copyright (c) 2018 CEA
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
import fr.cea.nabla.ir.ir.IrModule
import fr.cea.nabla.ir.ir.SimpleVariable
import fr.cea.nabla.ir.ir.TimeLoopJob
import fr.cea.nabla.ir.ir.Variable
import fr.cea.nabla.nabla.ArgOrVarRef
import fr.cea.nabla.nabla.ConnectivityVar
import fr.cea.nabla.nabla.CurrentTimeIteratorRef
import fr.cea.nabla.nabla.FunctionCall
import fr.cea.nabla.nabla.InitTimeIteratorRef
import fr.cea.nabla.nabla.NablaModule
import fr.cea.nabla.nabla.NextTimeIteratorRef
import fr.cea.nabla.nabla.ReductionCall
import fr.cea.nabla.nabla.SimpleVar
import fr.cea.nabla.nabla.SimpleVarDefinition
import fr.cea.nabla.nabla.Var
import fr.cea.nabla.nabla.VarGroupDeclaration
import fr.cea.nabla.typing.DeclarationProvider
import org.eclipse.emf.ecore.EObject
import org.eclipse.xtext.EcoreUtil2

import static fr.cea.nabla.ir.Utils.getDefaultIrVariable

class Nabla2Ir
{
	@Inject extension Nabla2IrUtils
	@Inject extension TimeIteratorUtils
	@Inject extension IrJobFactory
	@Inject extension IrFunctionFactory
	@Inject extension IrArgOrVarFactory
	@Inject extension IrConnectivityFactory
	@Inject extension IrAnnotationHelper
	@Inject extension DeclarationProvider

	def create IrFactory::eINSTANCE.createIrModule toIrModule(NablaModule nablaModule, SimpleVar nablaTimeVariable, ConnectivityVar nablaNodeCoordVariable)
	{
		annotations += nablaModule.toIrAnnotation
		name = nablaModule.name
		nablaModule.imports.forEach[x | imports += x.toIrImport]
		nablaModule.items.forEach[x | items += x.toIrItemType]
		nablaModule.connectivities.forEach[x | connectivities += x.toIrConnectivity]

		/* 
		 * To create functions, do not iterate on declarations to prevent creating external functions.
		 * Look for FunctionCall instead to link to the external function object properly.
		 * Same method fir reductions.
		 */
		nablaModule.eAllContents.filter(FunctionCall).forEach[x | functions += x.declaration.model.toIrFunction(x.function.moduleName)]
		nablaModule.eAllContents.filter(ReductionCall).forEach[x | reductions += x.declaration.model.toIrReduction(x.reduction.moduleName)]

		// Time loop job creation
		if (nablaModule.iteration !== null)
		{
			var TimeLoopJob outerTL = null
			for (ti : nablaModule.iteration.iterators)
			{
				val currentTL = ti.toIrTimeLoopJob
				if (outerTL !== null) outerTL.innerTimeLoop = currentTL

				jobs += currentTL
				jobs += ti.toIrBeforeTimeLoopJob
				jobs += ti.toIrNextTimeLoopIterationJob
				// Nothing to do after time loop if it is the outer time loop => no job creation
				if (outerTL !== null) jobs += ti.toIrAfterTimeLoopJob

				outerTL = currentTL
			}
		}

		// Global variables creation
		for (instruction : nablaModule.instructions)
		{
			switch instruction
			{
				SimpleVarDefinition: fillIrVariables(nablaModule, it, instruction.variable, nablaNodeCoordVariable)
				VarGroupDeclaration: instruction.variables.forEach[x | fillIrVariables(nablaModule, it, x, nablaNodeCoordVariable) ]
			}
		}

		if (initNodeCoordVariable === null) // can be initialized in fillIrVariables
			initNodeCoordVariable = getDefaultIrVariable(it, nablaNodeCoordVariable.name) as ConnectivityVariable
		nodeCoordVariable = getDefaultIrVariable(it, nablaNodeCoordVariable.name) as ConnectivityVariable
		timeVariable = getDefaultIrVariable(it, nablaTimeVariable.name) as SimpleVariable

		nablaModule.jobs.forEach[x | jobs += x.toIrInstructionJob]

		// Create a unique name for reduction instruction variable
		var i = 0
		for (v : eAllContents.filter(SimpleVariable).toIterable)
			if (v.name == ReductionCallExtensions.ReductionVariableName)
				v.name = v.name.replace("<NUMBER>", (i++).toString)
	}

	private def getModuleName(EObject it) 
	{
		val module = EcoreUtil2.getContainerOfType(it, NablaModule)
		return module.name
	}

	private def void fillIrVariables(NablaModule nablaModule, IrModule irModule, Var v, ConnectivityVar nablaNodeCoordVariable)
	{
		// Time n+1 variables and EndOfInitJob creation 
		val vRefs = nablaModule.eAllContents.filter(ArgOrVarRef).filter[!timeIterators.empty && target == v]
		if (vRefs.empty) 
		{
			irModule.variables += v.toIrVariable
		}
		else for (vRef : vRefs.toIterable)
		{
			val iterators = vRef.timeIterators
			switch iterators.last
			{
				CurrentTimeIteratorRef: 
				{
					irModule.variables += v.toIrArgOrVar(vRef.irTimeSuffix) as Variable
				}
				InitTimeIteratorRef:
				{
					val varAtInit = v.toIrArgOrVar(vRef.irTimeSuffix) as Variable
					irModule.variables += varAtInit
					if (v == nablaNodeCoordVariable) irModule.initNodeCoordVariable = varAtInit as ConnectivityVariable
					val varAtCurrent = v.toIrArgOrVar(vRef.irCurrentTimeSuffix) as Variable
					val tlCopy = toIrCopy(varAtInit, varAtCurrent)
					val beforeJob = iterators.last.target.toIrBeforeTimeLoopJob
					beforeJob.copies += tlCopy
				}
				NextTimeIteratorRef:
				{
					val varAtNext = v.toIrArgOrVar(vRef.irTimeSuffix) as Variable
					irModule.variables += varAtNext
					val varAtCurrent = v.toIrArgOrVar(vRef.irCurrentTimeSuffix) as Variable
					val nextIterJob = iterators.last.target.toIrNextTimeLoopIterationJob
					nextIterJob.copies += toIrCopy(varAtNext, varAtCurrent)

					val afterJob = iterators.last.target.toIrAfterTimeLoopJob
					val outerTimeIteratorSuffix = vRef.irOuterTimeSuffix
					if (outerTimeIteratorSuffix !== null)
					{
						val varAtOuterTimeIterator = v.toIrArgOrVar(outerTimeIteratorSuffix)
						afterJob.copies += toIrCopy(varAtNext as Variable, varAtOuterTimeIterator as Variable)
					}
				}
			}
		}
	}

	private def create IrFactory::eINSTANCE.createTimeLoopCopy toIrCopy(Variable from, Variable to)
	{
		source = from as Variable
		destination = to as Variable
	}
}