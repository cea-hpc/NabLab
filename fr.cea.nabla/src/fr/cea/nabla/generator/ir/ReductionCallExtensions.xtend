package fr.cea.nabla.generator.ir

import com.google.inject.Inject
import fr.cea.nabla.FunctionCallExtensions
import fr.cea.nabla.ir.ir.IrFactory
import fr.cea.nabla.nabla.Loop
import fr.cea.nabla.nabla.ReductionCall
import org.eclipse.emf.ecore.EObject
import com.google.inject.Singleton
import fr.cea.nabla.nabla.Job

/**
 * Attention : cette classe doit être un singleton car elle utilise des méthodes create.
 * Si elle n'est pas singleton, plusieurs instances d'un même objet seront créées (voir la documentation Xtext).
 */
@Singleton
class ReductionCallExtensions 
{
	@Inject extension FunctionCallExtensions
	@Inject extension Nabla2IrUtils
	@Inject extension IrExpressionFactory
	@Inject extension IrAnnotationHelper
	@Inject extension IrFunctionFactory
	@Inject extension IrIteratorFactory
	
	def create IrFactory::eINSTANCE.createScalarVariable toIrGlobalVariable(ReductionCall rc)
	{
		name = rc.reduction.name + rc.hashCode
		type = rc.declaration.returnType.toIrBasicType
	}
	
	def create IrFactory::eINSTANCE.createScalarVariable toIrLocalVariable(ReductionCall rc)
	{
		name = rc.reduction.name + rc.hashCode
		type = rc.declaration.returnType.toIrBasicType
		defaultValue = rc.declaration.seed.toIrExpression
	}

	def create IrFactory::eINSTANCE.createReductionCall toIrReductionCall(ReductionCall rc)
	{
		annotations += rc.toIrAnnotation
		reduction = rc.reduction.toIrReduction(rc.declaration)
		iterator = rc.iterator.toIrIterator
		arg = rc.arg.toIrExpression		
	}
	
	def boolean isGlobal(EObject it)
	{
		if (eContainer === null) false
		else if (eContainer instanceof Loop) false
		else if (eContainer instanceof ReductionCall) false
		else if (eContainer instanceof Job) true
		else eContainer.global	
	}
}