package fr.cea.nabla.generator.ir

import com.google.inject.Inject
import fr.cea.nabla.FunctionCallExtensions
import fr.cea.nabla.ir.ir.IrFactory
import fr.cea.nabla.ir.ir.Job
import fr.cea.nabla.nabla.ConnectivityDeclarationBlock
import fr.cea.nabla.nabla.FunctionCall
import fr.cea.nabla.nabla.NablaModule
import fr.cea.nabla.nabla.ReductionCall
import fr.cea.nabla.nabla.ScalarVarDefinition
import fr.cea.nabla.nabla.TimeLoopJob
import fr.cea.nabla.nabla.VarGroupDeclaration
import org.eclipse.emf.common.util.EList

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
	@Inject extension ReductionCallExtensions
	
	def create IrFactory::eINSTANCE.createIrModule toIrModule(NablaModule m)
	{
		annotations += m.toIrAnnotation
		name = m.name
		m.imports.forEach[x | imports += x.toIrImport]
		
		// Pour les fonctions, il ne faut pas parcourir les déclarations du bloc car
		// il peut également y avoir des fonctions externes. Il faut donc regarder tous les appels
		m.eAllContents.filter(FunctionCall).forEach[x | functions += x.function.toIrFunction(x.declaration)]
		
		// Même remarque pour les réductions que pour les fonctions
		for (rc : m.eAllContents.filter(ReductionCall).toIterable)
		{
			// creation de la reduction IR
			reductions += rc.reduction.toIrReduction(rc.declaration)
			
//			if (rc.global)
//			{
//				// La réduction est globale. Il faut :
//				// - créer une variable globale pour stocker le résultat de la réduction
//				// - créer un job d'initialisation de cette variable
//				// - créer le job correspondant à la réduction
//				variables += rc.toIrGlobalVariable
//				rc.populateIrJobs(jobs)
//			}
		}
		
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
	
	// permet de faire l'initialisation de variable par job
//	private def void populateIrJobs(GlobalVariableDeclarationBlock it, EList<Job> irJobs)
//	{
//		for (decl : declarations.filter[x | !(x.const || x.defaultValue===null)])
//			for (v : decl.variables)
//			{
//				val irAffectation = IrFactory::eINSTANCE.createAffectation
//				irAffectation.annotations += decl.defaultValue.toIrAnnotation
//				irAffectation.left = IrFactory::eINSTANCE.createVarRef => [ variable = v.toIrGlobalVariable ]
//				irAffectation.operator = '='
//				irAffectation.right = decl.defaultValue.toIrExpression
//				
//				val irJob = IrFactory::eINSTANCE.createInstructionJob
//				irJob.annotations += v.toIrAnnotation
//				irJob.name = 'Init_' + v.name
//				irJob.instruction = irAffectation
//				irJobs += irJob
//			}
//	}
	
	private def void populateIrJobs(ReductionCall it, EList<Job> irJobs)
	{
		// job d'initialisation de la variable globale	
		val defaultValue = declaration.seed
		val irVariable = toIrGlobalVariable
		val irAffectation = IrFactory::eINSTANCE.createAffectation
		irAffectation.annotations += defaultValue.toIrAnnotation
		irAffectation.left = IrFactory::eINSTANCE.createVarRef => [ variable = irVariable ]
		irAffectation.operator = '='
		irAffectation.right = defaultValue.toIrExpression

		val irJob = IrFactory::eINSTANCE.createInstructionJob
		irJob.annotations += defaultValue.toIrAnnotation
		irJob.name = 'Init_' + irVariable.name
		irJob.instruction = irAffectation
		irJobs += irJob
		
		// job de la réduction
		val irReductionJob = IrFactory::eINSTANCE.createReductionJob
		irReductionJob.annotations += toIrAnnotation
		irReductionJob.name = 'Compute_' + irVariable.name
		irReductionJob.variable = IrFactory::eINSTANCE.createVarRef => [ variable = irVariable ]
		irReductionJob.reduction = toIrReductionCall
		irJobs += irReductionJob
	}
}