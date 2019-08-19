/*******************************************************************************
 * Copyright (c) 2018 CEA
 * This program and the accompanying materials are made available under the 
 * terms of the Eclipse Public License 2.0 which is available at
 * http://www.eclipse.org/legal/epl-2.0.
 *
 * SPDX-License-Identifier: EPL-2.0
 * Contributors: see AUTHORS file
 *******************************************************************************/
package fr.cea.nabla.typing

import fr.cea.nabla.nabla.Connectivity
import fr.cea.nabla.nabla.PrimitiveType
import org.eclipse.xtend.lib.annotations.Data

import static extension fr.cea.nabla.ir.Utils.*

abstract class AbstractType 
{
	def isUndefined() { this instanceof UndefinedType }
	abstract def String getLabel();
}

@Data
class UndefinedType extends AbstractType
{
	override getLabel() { 'Undefined' }
}

@Data
abstract class DefinedType extends AbstractType
{
	Connectivity[] connectivities
	abstract def PrimitiveType getRoot();
}

@Data
class BoolType extends DefinedType
{
	override getRoot() { PrimitiveType::BOOL }
	override getLabel() { root.literal }	
}

@Data
class IntType extends DefinedType
{
	override getRoot() { PrimitiveType::INT }
	override getLabel() { root.literal }
}

@Data
class RealType extends DefinedType
{
	override getRoot() { PrimitiveType::REAL }
	override getLabel() { root.literal }
}

@Data
abstract class ArrayType extends DefinedType
{
	int[] sizes
	
	override getLabel() 
	{ 
		val l = getRoot.literal + sizes.map[utfExponent].join('\u02E3')
		if (connectivities.empty) l
		else l + '{' + connectivities.map[name].join(',') + '}'
	}
}

@Data
class RealArrayType extends ArrayType
{
	override getRoot() { PrimitiveType::REAL }
}

@Data
class IntArrayType extends ArrayType
{
	override getRoot() { PrimitiveType::INT }
}