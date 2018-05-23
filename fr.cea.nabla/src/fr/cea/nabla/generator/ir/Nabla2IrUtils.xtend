package fr.cea.nabla.generator.ir

import com.google.inject.Inject
import com.google.inject.Singleton
import fr.cea.nabla.generator.GeneratorUtils
import fr.cea.nabla.ir.ir.IrFactory
import fr.cea.nabla.nabla.BasicType
import fr.cea.nabla.nabla.Import
import fr.cea.nabla.nabla.ItemArgType
import fr.cea.nabla.nabla.ItemType

/**
 * Attention : cette classe doit être un singleton car elle utilise des méthodes create.
 * Si elle n'est pas singleton, plusieurs instances d'un même objet seront créées lors
 * deu parcours du graphe d'origine (voir la documentation Xtext).
 */
@Singleton
class Nabla2IrUtils extends GeneratorUtils
{
	@Inject extension IrAnnotationHelper 
	
	def toIrBasicType(BasicType t)
	{
		val type = fr.cea.nabla.ir.ir.BasicType::get(t.value + 1) // le premier literal est void en IR
		if (type === null) throw new RuntimeException('Conversion Nabla --> IR impossible : type inconnu ' + t.literal)
		return type
	}	
	
	def toIrItemType(ItemType t)
	{
		val type = fr.cea.nabla.ir.ir.ItemType::get(t.value + 1) // le premier literal est none en IR
		if (type === null) throw new RuntimeException('Conversion Nabla --> IR impossible : type inconnu ' + t.literal)
		return type
	}	
	
	def create IrFactory::eINSTANCE.createItemArgType toIrItemArgType(ItemArgType i)
	{
		multiple = i.multiple
		type = i.type.toIrItemType
	}
	
	def create IrFactory::eINSTANCE.createImport toIrImport(Import i)
	{
		importedNamespace = i.importedNamespace
		annotations += i.toIrAnnotation
	}
}