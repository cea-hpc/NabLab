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
import fr.cea.nabla.ArgOrVarRefExtensions
import fr.cea.nabla.ir.MandatoryVariables
import fr.cea.nabla.ir.ir.IrFactory
import fr.cea.nabla.ir.ir.Variable
import fr.cea.nabla.nabla.ArgOrVarRef
import fr.cea.nabla.nabla.FunctionCall
import fr.cea.nabla.nabla.InitTimeIterator
import fr.cea.nabla.nabla.NablaModule
import fr.cea.nabla.nabla.NextTimeIterator
import fr.cea.nabla.nabla.ReductionCall
import fr.cea.nabla.nabla.SimpleVarDefinition
import fr.cea.nabla.nabla.VarGroupDeclaration
import fr.cea.nabla.typing.DeclarationProvider
import org.eclipse.emf.ecore.EObject
import org.eclipse.xtext.EcoreUtil2

class Nabla2Ir
{
	@Inject extension Nabla2IrUtils
	@Inject extension IrJobFactory
	@Inject extension IrFunctionFactory
	@Inject extension IrArgOrVarFactory
	@Inject extension IrConnectivityFactory
	@Inject extension IrAnnotationHelper
	@Inject extension DeclarationProvider
	@Inject extension ArgOrVarRefExtensions

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

		// Time n+1 variables and EndOfInitJob creation 
		val timeIteratorVarRefsByVariable = m.eAllContents.filter(ArgOrVarRef).filter[timeIterator !== null].groupBy[target]
		for (v : timeIteratorVarRefsByVariable.keySet)
		{
			val timeIteratorVarRefs = timeIteratorVarRefsByVariable.get(v)
			for (r : timeIteratorVarRefs)
			{
				val vAtN = r.target.toIrArgOrVar('') as Variable // no arg with time suffix
				// No duplicates thanks to r.timeSuffix and Xtend create methods
				val vAtR = r.target.toIrArgOrVar(r.timeSuffix) as Variable
				// No duplicates thanks to unique attribute on IrModule::variables
				variables += vAtR
				val timeIterator = r.timeIterator
				switch timeIterator
				{
					InitTimeIterator: 
					{
						val vAt0 = vAtR
						jobs += toEndOfInitJob(vAt0, vAtN)
						if (v.name == MandatoryVariables::COORD) initCoordVariable = vAt0
					}
					// Copy Xn+1 to Xn at the end of time loop.
					// Xn+1 => NextTimeIterator::div == 0
					NextTimeIterator case timeIterator.div==0: 
					{
						val vAtNplus1 = vAtR
						jobs += toEndOfLoopJob(vAtN, vAtNplus1)
					}
					// No job to create for instances of NextTimeIterator with div !== 1
				}
			}
		}

		if (initCoordVariable === null)
			initCoordVariable = variables.findFirst[x | x.name == MandatoryVariables::COORD]

		m.jobs.forEach[x | jobs += x.toIrInstructionJob]
	}

	private def getModuleName(EObject it) 
	{
		val module = EcoreUtil2.getContainerOfType(it, NablaModule)
		return module.name
	}
}