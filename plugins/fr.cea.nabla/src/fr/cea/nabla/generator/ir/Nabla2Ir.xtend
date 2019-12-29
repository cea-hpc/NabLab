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
import fr.cea.nabla.ir.MandatoryMeshVariables
import fr.cea.nabla.ir.ir.IrFactory
import fr.cea.nabla.ir.ir.SimpleVariable
import fr.cea.nabla.ir.ir.TimeLoopJob
import fr.cea.nabla.ir.ir.Variable
import fr.cea.nabla.nabla.ArgOrVarRef
import fr.cea.nabla.nabla.CurrentTimeIteratorRef
import fr.cea.nabla.nabla.FunctionCall
import fr.cea.nabla.nabla.InitTimeIteratorRef
import fr.cea.nabla.nabla.NablaModule
import fr.cea.nabla.nabla.NextTimeIteratorRef
import fr.cea.nabla.nabla.ReductionCall
import fr.cea.nabla.nabla.SimpleVarDefinition
import fr.cea.nabla.nabla.Var
import fr.cea.nabla.nabla.VarGroupDeclaration
import fr.cea.nabla.typing.DeclarationProvider
import java.util.ArrayList
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

	def create IrFactory::eINSTANCE.createIrModule toIrModule(NablaModule m)
	{
		annotations += m.toIrAnnotation
		name = m.name
		m.imports.forEach[x | imports += x.toIrImport]
		m.items.forEach[x | items += x.toIrItemType]
		m.connectivities.forEach[x | connectivities += x.toIrConnectivity]

		/* 
		 * To create functions, do not iterate on declarations to prevent creating external functions.
		 * Look for FunctionCall instead to link to the external function object properly.
		 * Same method fir reductions.
		 */
		m.eAllContents.filter(FunctionCall).forEach[x | functions += x.declaration.model.toIrFunction(x.function.moduleName)]
		m.eAllContents.filter(ReductionCall).forEach[x | reductions += x.declaration.model.toIrReduction(x.reduction.moduleName)]

		// Time loop job creation
		for (iteration : m.iterations)
		{
			var TimeLoopJob outerTL = null
			for (ti : iteration.iterators)
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
		for (instruction : m.instructions)
		{
			switch instruction
			{
				SimpleVarDefinition: variables += toIrVariables(m, instruction.variable)
				VarGroupDeclaration: instruction.variables.forEach[x | variables += toIrVariables(m, x) ]
			}
		}
		initCoordVariable = getDefaultIrVariable(it, MandatoryMeshVariables::COORD)

		m.jobs.forEach[x | jobs += x.toIrInstructionJob]

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

	private def toIrVariables(NablaModule m, Var v)
	{
		val irVariables = new ArrayList<Variable>

		// Time n+1 variables and EndOfInitJob creation 
		val vRefs = m.eAllContents.filter(ArgOrVarRef).filter[!timeIterators.empty && target == v]
		if (vRefs.empty) 
		{
			irVariables += v.toIrVariable
		}
		else for (vRef : vRefs.toIterable)
		{
			val iterators = vRef.timeIterators
			switch iterators.last
			{
				CurrentTimeIteratorRef: 
				{
					irVariables += v.toIrArgOrVar(vRef.irTimeSuffix) as Variable
				}
				InitTimeIteratorRef:
				{
					val varAtInit = v.toIrArgOrVar(vRef.irTimeSuffix) as Variable
					irVariables += varAtInit
					val varAtCurrent = v.toIrArgOrVar(vRef.irCurrentTimeSuffix) as Variable
					val tlCopy = IrFactory::eINSTANCE.createTimeLoopCopy =>
					[
						source = varAtInit
						destination = varAtCurrent
					]
					val beforeJob = iterators.last.target.toIrBeforeTimeLoopJob
					beforeJob.copies += tlCopy
				}
				NextTimeIteratorRef:
				{
					val varAtNext = v.toIrArgOrVar(vRef.irTimeSuffix) as Variable
					irVariables += varAtNext
					val varAtCurrent = v.toIrArgOrVar(vRef.irCurrentTimeSuffix) as Variable
					val nextIterJob = iterators.last.target.toIrNextTimeLoopIterationJob
					nextIterJob.copies += IrFactory::eINSTANCE.createTimeLoopCopy =>
					[
						source = varAtNext
						destination = varAtCurrent
					]

					val afterJob = iterators.last.target.toIrAfterTimeLoopJob
					val outerTimeIteratorSuffix = vRef.irOuterTimeSuffix
					if (outerTimeIteratorSuffix !== null)
					{
						val varAtOuterTimeIterator = v.toIrArgOrVar(outerTimeIteratorSuffix)
						afterJob.copies += IrFactory::eINSTANCE.createTimeLoopCopy =>
						[
							source = varAtNext as Variable
							destination = varAtOuterTimeIterator as Variable
						]
					}
				}
			}
		}
		return irVariables
	}
}