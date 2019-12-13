package fr.cea.nabla.ir.transformers

import fr.cea.nabla.ir.ir.ArgOrVarRef
import fr.cea.nabla.ir.ir.ConnectivityVariable
import fr.cea.nabla.ir.ir.InstructionJob
import fr.cea.nabla.ir.ir.IrFactory
import fr.cea.nabla.ir.ir.IrModule
import org.eclipse.emf.ecore.util.EcoreUtil

import static fr.cea.nabla.ir.transformers.IrTransformationUtils.*

import static extension fr.cea.nabla.ir.JobExtensions.*

class DeclareConstVariables implements IrTransformationStep 
{
	override getDescription() 
	{
		'Declare const local variables in jobs (Kokkos optimization)'
	}
	
	override transform(IrModule m) 
	{
		for (job : m.eAllContents.filter(InstructionJob).toIterable)
		{
			val jobInVars = job.inVars
			if (!jobInVars.empty)
			{
				val varDefinition = IrFactory::eINSTANCE.createVarDefinition
				for (jobInvar : jobInVars.filter(ConnectivityVariable))
				{
					val newConstVar = jobInvar.newVariable
					varDefinition.variables += newConstVar
					for (jobInVarRef : job.eAllContents.filter(ArgOrVarRef).filter[x | x.target == jobInvar].toIterable)
						jobInVarRef.target = newConstVar
				}
				insertBefore(job.instruction, #[varDefinition])
			}	
		}
		return true
	}
	
	override getOutputTraces() 
	{
		#[]
	}
//	private def dispatch newVariable(ScalarVariable v)
//	{
//		IrFactory::eINSTANCE.createScalarVariable =>
//		[
//			const = true
//			name = 'const_' + v.name
//			type = v.type
//			defaultValue = IrFactory::eINSTANCE.createVarRef => [ variable = v ]
//		]
//	}

//	private def dispatch newVariable(ArrayVariable v)
	private def newVariable(ConnectivityVariable v)
	{
		IrFactory::eINSTANCE.createConnectivityVariable =>
		[
			const = true
			name = 'const_' + v.name
			type = EcoreUtil::copy(type)
			defaultValue = IrFactory::eINSTANCE.createArgOrVarRef => [ target = v ]
		]
	}
}