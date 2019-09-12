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
class NTConnectivityType extends NablaType
{
	val Connectivity[] supports
	val NTSimpleType simple
	override getPrimitive() { simple.primitive }
	override getLabel()
	{
		val l = simple.label
		if (supports.empty) l
		else l + '{' + supports.map[name].join(',') + '}'
	}
}

@Data
abstract class NTSimpleType extends NablaType
{
}

@Data
abstract class NTScalar extends NTSimpleType
{
	override getLabel() { primitive.literal }
}

@Data
abstract class NTArray1D extends NTSimpleType
{
	val int size
	override getLabel() { primitive.literal + size.utfExponent }
}

@Data
abstract class NTArray2D extends NTSimpleType 
{
	val int nbRows
	val int nbCols
	override getLabel() { primitive.literal + nbRows.utfExponent + '\u02E3' + nbCols.utfExponent }
}

@Data
class NTBoolScalar extends NTScalar
{
	override getPrimitive() { PrimitiveType::BOOL}
}

@Data
class NTBoolArray1D extends NTArray1D
{
	override getPrimitive() { PrimitiveType::BOOL}
}

@Data
class NTBoolArray2D extends NTArray2D
{
	override getPrimitive() { PrimitiveType::BOOL}
}

@Data
class NTIntScalar extends NTScalar
{
	override getPrimitive() { PrimitiveType::INT}
}

@Data
class NTIntArray1D extends NTArray1D
{
	override getPrimitive() { PrimitiveType::INT}
}

@Data
class NTIntArray2D extends NTArray2D
{
	override getPrimitive() { PrimitiveType::INT}
}
@Data
class NTRealScalar extends NTScalar
{
	override getPrimitive() { PrimitiveType::REAL}
}

@Data
class NTRealArray1D extends NTArray1D
{
	override getPrimitive() { PrimitiveType::REAL}
}

@Data
class NTRealArray2D extends NTArray2D
{
	override getPrimitive() { PrimitiveType::REAL}
}

