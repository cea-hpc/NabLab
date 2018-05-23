package fr.cea.nabla.generator.ir

import com.google.inject.Inject
import com.google.inject.Singleton
import fr.cea.nabla.ir.ir.IrFactory
import fr.cea.nabla.ir.ir.IteratorRangeOrRef
import fr.cea.nabla.nabla.SpaceIterator
import fr.cea.nabla.nabla.SpaceIteratorRange
import fr.cea.nabla.nabla.SpaceIteratorRef

/**
 * Attention : cette classe doit être un singleton car elle utilise des méthodes create.
 * Si elle n'est pas singleton, plusieurs instances d'un même objet seront créées lors
 * deu parcours du graphe d'origine (voir la documentation Xtext).
 */
@Singleton
class IrIteratorFactory 
{	
	@Inject extension IrAnnotationHelper
	@Inject extension IrConnectivityFactory
	
	def create IrFactory::eINSTANCE.createIterator toIrIterator(SpaceIterator si)
	{
		annotations += si.toIrAnnotation
		name = si.name
		range = si.range.toIrIteratorRange
	}
	
	def create IrFactory::eINSTANCE.createIteratorRange toIrIteratorRange(SpaceIteratorRange range)
	{
		annotations += range.toIrAnnotation
		connectivity = range.connectivity.toIrConnectivity
		range.args.forEach[x | args += x.toIrIteratorRef]
	}

	def create IrFactory::eINSTANCE.createIteratorRef toIrIteratorRef(SpaceIteratorRef ref)
	{
		annotations += ref.toIrAnnotation
		iterator = ref.iterator.toIrIterator
		prev = ref.prev
		next = ref.next
	}
	
	def dispatch IteratorRangeOrRef toIrIteratorRangeOrRef(SpaceIteratorRange r) { r.toIrIteratorRange }
	def dispatch IteratorRangeOrRef toIrIteratorRangeOrRef(SpaceIteratorRef r) { r.toIrIteratorRef }
}