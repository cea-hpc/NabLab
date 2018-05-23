package fr.cea.nabla.generator.ir

import com.google.inject.Inject
import com.google.inject.Singleton
import fr.cea.nabla.ir.ir.IrFactory
import fr.cea.nabla.nabla.Function
import fr.cea.nabla.nabla.FunctionArg
import fr.cea.nabla.nabla.Reduction
import fr.cea.nabla.nabla.ReductionArg

/**
 * Attention : cette classe doit être un singleton car elle utilise des méthodes create.
 * Si elle n'est pas singleton, plusieurs instances d'un même objet seront créées lors
 * deu parcours du graphe d'origine (voir la documentation Xtext).
 */
@Singleton
class IrFunctionFactory 
{
	@Inject extension Nabla2IrUtils
	@Inject extension IrAnnotationHelper

	def create IrFactory::eINSTANCE.createFunction toIrFunction(Function f, FunctionArg a)
	{
		annotations += a.toIrAnnotation
		name = f.name
		returnType = a.returnType.toIrBasicType
		inTypes += a.inTypes.map[toIrBasicType]
	}

	def create IrFactory::eINSTANCE.createReduction toIrReduction(Reduction f, ReductionArg a)
	{
		annotations += a.toIrAnnotation
		name = f.name
		collectionType = a.collectionType.toIrBasicType
		returnType = a.returnType.toIrBasicType
	}
}