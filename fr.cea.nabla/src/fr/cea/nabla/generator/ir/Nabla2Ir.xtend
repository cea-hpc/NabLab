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
import fr.cea.nabla.DeclarationProvider
import fr.cea.nabla.MandatoryOptions
import fr.cea.nabla.VarRefExtensions
import fr.cea.nabla.ir.ir.IrFactory
import fr.cea.nabla.nabla.FunctionCall
import fr.cea.nabla.nabla.InitTimeIterator
import fr.cea.nabla.nabla.NablaModule
import fr.cea.nabla.nabla.NextTimeIterator
import fr.cea.nabla.nabla.ReductionCall
import fr.cea.nabla.nabla.ScalarVarDefinition
import fr.cea.nabla.nabla.VarGroupDeclaration
import fr.cea.nabla.nabla.VarRef

class Nabla2Ir
{
	@Inject extension Nabla2IrUtils
	@Inject extension JobFactory
	@Inject extension IrFunctionFactory
	@Inject extension IrVariableFactory
	@Inject extension IrConnectivityFactory
	@Inject extension IrExpressionFactory
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
		
		// Pour les fonctions, il ne faut pas parcourir les déclarations du bloc car
		// il peut également y avoir des fonctions externes. Il faut donc regarder tous les appels
		m.eAllContents.filter(FunctionCall).forEach[x | functions += x.function.toIrFunction(x.declaration)]
		// Même remarque pour les réductions que pour les fonctions
		m.eAllContents.filter(ReductionCall).forEach[x | reductions += x.reduction.toIrReduction(x.declaration)]
		
		// Création de l'ensemble des variables globales
		for (vDecl : m.variables)
		{
			switch vDecl
			{
				ScalarVarDefinition: 
				{
					val irVar = vDecl.variable.toIrSimpleVariable
					irVar.defaultValue = vDecl.defaultValue.toIrExpression
					irVar.const = vDecl.const
					variables += irVar
				}
				VarGroupDeclaration: vDecl.variables.forEach[x | variables += x.toIrVariable]
			}
		}
		
		// il faut créer les variables au temps n+1 et les jobs de copie de Xn+1 <- Xn
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
						if (v.name == MandatoryOptions::COORD) nodeCoordVariable = vAt0
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
		
		if (nodeCoordVariable === null)
			nodeCoordVariable = variables.findFirst[x | x.name == MandatoryOptions::COORD]
		
		m.jobs.forEach[x | jobs += x.toIrInstructionJob]
	}
}