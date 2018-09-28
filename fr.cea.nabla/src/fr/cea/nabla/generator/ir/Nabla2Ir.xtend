/*******************************************************************************
 * Copyright (c) 2018 CEA
 * This program and the accompanying materials are made available under the 
 * terms of the Eclipse Public License 2.0 which is available at
 * http://www.eclipse.org/legal/epl-2.0.
 *
 * SPDX-License-Identifier: EPL-2.0
 *
 * Contributors:
 * 	Benoit Lelandais - initial implementation
 * 	Marie-Pierre Oudot - initial implementation
 * 	Jean-Sylvan Camier - Nabla generation support
 *******************************************************************************/
package fr.cea.nabla.generator.ir

import com.google.inject.Inject
import fr.cea.nabla.FunctionCallExtensions
import fr.cea.nabla.ir.ir.IrFactory
import fr.cea.nabla.nabla.ConnectivityDeclarationBlock
import fr.cea.nabla.nabla.FunctionCall
import fr.cea.nabla.nabla.NablaModule
import fr.cea.nabla.nabla.ReductionCall
import fr.cea.nabla.nabla.ScalarVarDefinition
import fr.cea.nabla.nabla.TimeLoopJob
import fr.cea.nabla.nabla.VarGroupDeclaration

class Nabla2Ir
{
	@Inject extension Nabla2IrUtils
	@Inject extension JobExtensions
	@Inject extension IrFunctionFactory
	@Inject extension IrVariableFactory
	@Inject extension IrConnectivityFactory
	@Inject extension IrExpressionFactory
	@Inject extension IrAnnotationHelper
	@Inject extension FunctionCallExtensions
	
	def create IrFactory::eINSTANCE.createIrModule toIrModule(NablaModule m)
	{
		annotations += m.toIrAnnotation
		name = m.name
		m.imports.forEach[x | imports += x.toIrImport]
		
		// Pour les fonctions, il ne faut pas parcourir les déclarations du bloc car
		// il peut également y avoir des fonctions externes. Il faut donc regarder tous les appels
		m.eAllContents.filter(FunctionCall).forEach[x | functions += x.function.toIrFunction(x.declaration)]
		// Même remarque pour les réductions que pour les fonctions
		m.eAllContents.filter(ReductionCall).forEach[x | reductions += x.reduction.toIrReduction(x.declaration)]
		
		// Rien de particulier pour les connectivités qui sont propres à chaque module
		for (block : m.blocks.filter(ConnectivityDeclarationBlock))
			block.connectivities.forEach[x | connectivities += x.toIrConnectivity]

		// Création de l'ensemble des variables globales
		for (vDecl : m.variables)
			switch vDecl
			{
				ScalarVarDefinition: 
				{
					val irVar = vDecl.variable.toIrScalarVariable
					irVar.defaultValue = vDecl.defaultValue.toIrExpression
					irVar.const = vDecl.const
					variables += irVar
				}
				VarGroupDeclaration: vDecl.variables.forEach[x | variables += x.toIrVariable]
			}
		
		// en IR, les variables globales doivent être initialisées par un job
		//m.variables.filter(GlobalVariableDeclarationBlock).forEach[x | x.populateIrJobs(jobs)]
				
		// il faut créer les variables au temps n+1 et les jobs de copie de Xn+1 <- Xn
		m.jobs.filter(TimeLoopJob).forEach[x | x.populateIrVariablesAndJobs(variables, jobs)]
	
		m.jobs.forEach[x | x.populateIrJobs(jobs)]
	}
}