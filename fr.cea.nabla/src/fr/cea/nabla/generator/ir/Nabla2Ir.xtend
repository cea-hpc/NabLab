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
import fr.cea.nabla.VarRefExtensions
import fr.cea.nabla.ir.ir.IrFactory
import fr.cea.nabla.nabla.FunctionCall
import fr.cea.nabla.nabla.InitTimeIterator
import fr.cea.nabla.nabla.NablaModule
import fr.cea.nabla.nabla.NextTimeIterator
import fr.cea.nabla.nabla.ReductionCall
import fr.cea.nabla.nabla.SimpleVarDefinition
import fr.cea.nabla.nabla.VarGroupDeclaration
import fr.cea.nabla.nabla.VarRef
import fr.cea.nabla.typing.DeclarationProvider
import fr.cea.nabla.ir.MandatoryVariables

class Nabla2Ir
{
	@Inject extension Nabla2IrUtils
	@Inject extension IrJobFactory
	@Inject extension IrFunctionFactory
	@Inject extension IrVariableFactory
	@Inject extension IrConnectivityFactory
	@Inject extension IrAnnotationHelper
	@Inject extension DeclarationProvider
	@Inject extension VarRefExtensions
	
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
		m.eAllContents.filter(FunctionCall).forEach[x | functions += x.function.toIrFunction(x.declaration.model)]
		m.eAllContents.filter(ReductionCall).forEach[x | reductions += x.reduction.toIrReduction(x.declaration.model)]
		
		// Global variables creation
		for (vDecl : m.variables)
		{
			switch vDecl
			{
				SimpleVarDefinition: variables += vDecl.variable.toIrSimpleVariable
				VarGroupDeclaration: vDecl.variables.forEach[x | variables += x.toIrVariable]
			}
		}
		
		// Time n+1 variables and EndOfInitJob creation 
		val timeIteratorVarRefsByVariable = m.eAllContents.filter(VarRef).filter[timeIterator !== null].groupBy[variable]
		for (v : timeIteratorVarRefsByVariable.keySet)
		{
			val timeIteratorVarRefs = timeIteratorVarRefsByVariable.get(v)
			for (r : timeIteratorVarRefs)
			{
				val vAtN = r.variable.toIrVariable('')
				// No duplicates thanks to r.timeSuffix and Xtend create methods
				val vAtR = r.variable.toIrVariable(r.timeSuffix)
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
}