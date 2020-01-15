/*******************************************************************************
 * Copyright (c) 2020 CEA
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
import fr.cea.nabla.nabla.SizeType
import fr.cea.nabla.nabla.SizeTypeInt
import org.eclipse.xtend.lib.annotations.Data

import static extension fr.cea.nabla.LabelServices.*
import static extension fr.cea.nabla.ir.Utils.*

class NSTSizeType
{
	val Object value // Integer or Dimension

	static def NSTSizeType create(int v)
	{
		new NSTSizeType(v)
	}

	static def NSTSizeType create(SizeType v)
	{
		if (v instanceof SizeTypeInt)
			new NSTSizeType(v.value)
		else
			new NSTSizeType(v)
	}

	private new(int value) { this.value = value }
	private new(SizeType value) { this.value = value }

	def isUndefined() { value === null }
	def isSizeType() { value instanceof SizeType }
	def isInt() { value instanceof Integer }

	def getSizeTypeValue() { value as SizeType }
	def getIntValue() { value as Integer }

	def getLabel()
	{
		if (isInt) intValue.toString
		else sizeTypeValue.label
	}

	override boolean equals(Object obj)
	{
		if (this === obj) return true
		if (obj === null) return false
		if (class != obj.class) return false
		val other = obj as NSTSizeType
		if (value === null)
		{
			if (other.value !== null) return false
		}
		else
		{
			if (value.class != other.value.class) return false
			else
			{
				if (isInt) return (intValue == other.intValue)
				if (isSizeType) return (sizeTypeValue.label == other.sizeTypeValue.label)
			}
		}
		return true
  }
}

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
	val NSTSizeType size

	override getLabel()
	{
		if (size.int)
			primitive.literal + size.intValue.utfExponent
		else
			primitive.literal + '[' + size.label + ']'
	}
}

@Data
abstract class NSTArray2D extends NablaSimpleType 
{
	val NSTSizeType nbRows
	val NSTSizeType nbCols

	override getLabel()
	{
		if (nbRows.int && nbCols.int)
			primitive.literal + nbRows.intValue.utfExponent + '\u02E3' + nbCols.intValue.utfExponent
		else
			primitive.literal + '[' + nbRows.label + ',' + nbCols.label + ']'
	}
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

