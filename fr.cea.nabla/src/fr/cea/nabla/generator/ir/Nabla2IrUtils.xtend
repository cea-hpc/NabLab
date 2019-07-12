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
 * 	Jean-Sylvain Camier - Nabla generation support
 *******************************************************************************/
package fr.cea.nabla.generator.ir

import com.google.inject.Inject
import com.google.inject.Singleton
import fr.cea.nabla.ir.ir.IrFactory
import fr.cea.nabla.nabla.BaseType
import fr.cea.nabla.nabla.Import
import fr.cea.nabla.nabla.ItemArgType
import fr.cea.nabla.nabla.ItemType
import fr.cea.nabla.nabla.PrimitiveType

/**
 * Attention : cette classe doit être un singleton car elle utilise des méthodes create.
 * Si elle n'est pas singleton, plusieurs instances d'un même objet seront créées lors
 * deu parcours du graphe d'origine (voir la documentation Xtext).
 */
@Singleton
class Nabla2IrUtils
{
	@Inject extension IrAnnotationHelper 
	
	def toIrPrimitiveType(PrimitiveType t)
	{
		val type = fr.cea.nabla.ir.ir.PrimitiveType::get(t.value + 1) // le premier literal est void en IR
		if (type === null) throw new RuntimeException('Conversion Nabla --> IR impossible : type inconnu ' + t.literal)
		return type
	}	
	
	def create IrFactory::eINSTANCE.createItemType toIrItemType(ItemType i)
	{
		name = i.name
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
	
	// No create method to ensure a new instance every time (for n+1 time variables)
	def toIrBaseType(BaseType i)
	{
		IrFactory::eINSTANCE.createBaseType => 
		[
			root = i.root.toIrPrimitiveType
			sizes.addAll(i.sizes)
		]
	}

}