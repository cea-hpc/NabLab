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
import fr.cea.nabla.ir.ir.Variable
import fr.cea.nabla.nabla.ArgOrVarRef
import fr.cea.nabla.nabla.FunctionCall
import fr.cea.nabla.nabla.NablaModule
import fr.cea.nabla.nabla.ReductionCall
import fr.cea.nabla.nabla.SimpleVarDefinition
import fr.cea.nabla.nabla.VarGroupDeclaration
import fr.cea.nabla.typing.DeclarationProvider
import org.eclipse.emf.ecore.EObject
import org.eclipse.xtext.EcoreUtil2

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

		// Global variables creation
		for (instruction : m.instructions)
		{
			switch instruction
			{
				SimpleVarDefinition: variables += instruction.variable.toIrSimpleVariable
				VarGroupDeclaration: instruction.variables.forEach[x | variables += x.toIrVariable]
			}
		}

		// Time loop job creation
		for (iteration : m.iterations)
		{
			for (timeIterator : iteration.iterators)
			{
				jobs += timeIterator.toIrBeforeTimeLoopJob
				jobs += timeIterator.toIrAfterTimeLoopJob
				jobs += timeIterator.toIrNextTimeLoopIterationJob
			}
		}

		// Time n+1 variables and EndOfInitJob creation 
		val timeIteratorVarRefsByVariable = m.eAllContents.filter(ArgOrVarRef).filter[!timeIterators.empty].groupBy[target]
		for (v : timeIteratorVarRefsByVariable.keySet)
		{
			val varRefs = timeIteratorVarRefsByVariable.get(v)
			for (varRef : varRefs)
			{
				val iterators = varRef.timeIterators
				switch iterators.last.type
				{
					case CURRENT: 
					{
						// nothing to do
					}
					case INIT:
					{
						val varAtInit = varRef.target.toIrArgOrVar(varRef.timeSuffix)
						val varAtCurrent = varRef.target.toIrArgOrVar(varRef.currentTimeSuffix)
						val tlCopy = IrFactory::eINSTANCE.createTimeLoopCopy =>
						[
							source = varAtInit as Variable
							destination = varAtCurrent as Variable
						]
						val beforeJob = iterators.last.target.toIrBeforeTimeLoopJob
						beforeJob.copies += tlCopy
					}
					case NEXT:
					{
						val varAtNext = varRef.target.toIrArgOrVar(varRef.timeSuffix)
						val varAtCurrent = varRef.target.toIrArgOrVar(varRef.currentTimeSuffix)
						val nextIterJob = iterators.last.target.toIrNextTimeLoopIterationJob
						nextIterJob.copies += IrFactory::eINSTANCE.createTimeLoopCopy =>
						[
							source = varAtNext as Variable
							destination = varAtCurrent as Variable
						]

						val afterJob = iterators.last.target.toIrAfterTimeLoopJob
						val outerTimeIteratorSuffix = varRef.outerTimeSuffix
						if (outerTimeIteratorSuffix !== null)
						{
							val varAtOuterTimeIterator = varRef.target.toIrArgOrVar(outerTimeIteratorSuffix)
							afterJob.copies += IrFactory::eINSTANCE.createTimeLoopCopy =>
							[
								source = varAtNext as Variable
								destination = varAtOuterTimeIterator as Variable
							]
						}
					}
				}
			}
		}

		if (initCoordVariable === null)
			initCoordVariable = variables.findFirst[x | x.name == MandatoryMeshVariables::COORD]

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
}