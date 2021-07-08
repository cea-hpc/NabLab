/*******************************************************************************
 * Copyright (c) 2021 CEA
 * This program and the accompanying materials are made available under the 
 * terms of the Eclipse Public License 2.0 which is available at
 * http://www.eclipse.org/legal/epl-2.0.
 *
 * SPDX-License-Identifier: EPL-2.0
 * Contributors: see AUTHORS file
 *******************************************************************************/
package fr.cea.nabla.typing

import fr.cea.nabla.ir.IrUtils
import fr.cea.nabla.nabla.Connectivity
import fr.cea.nabla.nabla.DefaultExtension
import fr.cea.nabla.nabla.Expression
import fr.cea.nabla.nabla.IntConstant
import fr.cea.nabla.nabla.PrimitiveType
import org.eclipse.emf.ecore.util.EcoreUtil
import org.eclipse.xtend.lib.annotations.Data

import static extension fr.cea.nabla.LabelServices.*

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
	abstract def int getDimension()
}

@Data
abstract class NSTScalar extends NablaSimpleType
{
	override getLabel() { primitive.literal }
	override getDimension() { 0 }
}

@Data
abstract class NSTArray1D extends NablaSimpleType
{
	val Expression size

	override getDimension() { 1 }

	override getLabel()
	{
		if (size instanceof IntConstant)
			primitive.literal + IrUtils.getUtfExponent(size.value)
		else
			primitive.literal + '[' + size.label + ']'
	}

	/**
	 * Replace the default Xtend @Data generation of equals
	 * to compare size expression with EcoreUtil::equals
	 */
	override equals(Object obj)
	{
		if (this === obj) return true
		if (obj === null) return false
		if (class !== obj.class) return false
		if (!super.equals(obj)) return false

		val other = obj as NSTArray1D
		if (this.size === null)
		{
			if (other.size !== null) return false
		}
		else 
			if (!EcoreUtil::equals(this.size, other.size))
				return false
		return true
	}
}

@Data
abstract class NSTArray2D extends NablaSimpleType 
{
	val Expression nbRows
	val Expression nbCols

	override getDimension() { 2 }

	override getLabel()
	{
		if (nbRows instanceof IntConstant && nbCols instanceof IntConstant)
			primitive.literal + IrUtils.getUtfExponent((nbRows as IntConstant).value) + '\u02E3' + IrUtils.getUtfExponent((nbCols as IntConstant).value)
		else
			primitive.literal + '[' + nbRows.label + ',' + nbCols.label + ']'
	}

	/**
	 * Replace the default Xtend @Data generation of equals
	 * to compare nbRows/nbCols expressions with EcoreUtil::equals
	 */
	override equals(Object obj)
	{
		if (this === obj) return true
		if (obj === null) return false
		if (getClass() != obj.getClass()) return false
		if (!super.equals(obj)) return false

		val other = obj as NSTArray2D
		if (this.nbRows === null)
		{
			if (other.nbRows !== null) return false
		}
		else
			if (!EcoreUtil::equals(this.nbRows, other.nbRows))
				return false;

		if (this.nbCols === null)
		{
			if (other.nbCols !== null) return false
		} 
		else
			if (!EcoreUtil::equals(this.nbCols, other.nbCols))
				return false
		return true
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

@Data
abstract class NablaLinearAlgebraType extends NablaType
{
}

@Data
class NLATVector extends NablaLinearAlgebraType
{
	val DefaultExtension defaultExtension
	val Expression size

	override getLabel() { 'Vector[' + size.label +  ']' }
	override getPrimitive() { PrimitiveType::REAL }

	override equals(Object obj)
	{
		if (this === obj) return true
		if (obj === null) return false
		if (getClass() != obj.getClass()) return false
		if (!super.equals(obj)) return false

		val other = obj as NLATVector
		if (this.size === null)
		{
			if (other.size !== null) return false
		}
		else
			if (!EcoreUtil::equals(this.size, other.size))
				return false
		return true
	}
}

@Data
class NLATMatrix extends NablaLinearAlgebraType
{
	val DefaultExtension defaultExtension
	val Expression nbRows
	val Expression nbCols

	override getLabel() { 'Matrix['  + nbRows.label + ',' + nbCols.label +  ']' }
	override getPrimitive() { PrimitiveType::REAL }

	override equals(Object obj)
	{
		if (this === obj) return true
		if (obj === null) return false
		if (getClass() != obj.getClass()) return false
		if (!super.equals(obj)) return false

		val other = obj as NLATMatrix
		if (this.nbRows === null)
		{
			if (other.nbRows !== null) return false
		}
		else
			if (!EcoreUtil::equals(this.nbRows, other.nbRows))
				return false;

		if (this.nbCols === null)
		{
			if (other.nbCols !== null) return false
		}
		else
			if (!EcoreUtil::equals(this.nbCols, other.nbCols))
				return false
		return true
	}
}

