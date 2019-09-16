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

@Data
abstract class NablaType
{
	abstract def String getLabel()
	abstract def PrimitiveType getPrimitive()
}

@Data
class NablaConnectivityType extends NablaType
{
	val Connectivity[] supports
	val NablaSimpleType simple
	override getPrimitive() { simple.primitive }
	override getLabel()
	{
		val l = simple.label
		if (supports.empty) l
		else l + '{' + supports.map[name].join(',') + '}'
	}
}

@Data
abstract class NablaSimpleType extends NablaType
{
}

@Data
abstract class NSTScalar extends NablaSimpleType
{
	override getLabel() { primitive.literal }
}

@Data
abstract class NSTArray1D extends NablaSimpleType
{
	val int size
	override getLabel() { primitive.literal + size.utfExponent }
}

@Data
abstract class NSTArray2D extends NablaSimpleType 
{
	val int nbRows
	val int nbCols
	override getLabel() { primitive.literal + nbRows.utfExponent + '\u02E3' + nbCols.utfExponent }
}

@Data
class NSTBoolScalar extends NSTScalar
{
	override getPrimitive() { PrimitiveType::BOOL}
}

@Data
class NSTBoolArray1D extends NSTArray1D
{
	override getPrimitive() { PrimitiveType::BOOL}
}

@Data
class NSTBoolArray2D extends NSTArray2D
{
	override getPrimitive() { PrimitiveType::BOOL}
}

@Data
class NSTIntScalar extends NSTScalar
{
	override getPrimitive() { PrimitiveType::INT}
}

@Data
class NSTIntArray1D extends NSTArray1D
{
	override getPrimitive() { PrimitiveType::INT}
}

@Data
class NSTIntArray2D extends NSTArray2D
{
	override getPrimitive() { PrimitiveType::INT}
}

@Data
class NSTRealScalar extends NSTScalar
{
	override getPrimitive() { PrimitiveType::REAL}
}

@Data
class NSTRealArray1D extends NSTArray1D
{
	override getPrimitive() { PrimitiveType::REAL}
}

@Data
class NSTRealArray2D extends NSTArray2D
{
	override getPrimitive() { PrimitiveType::REAL}
}

