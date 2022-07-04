/*******************************************************************************
 * Copyright (c) 2022 CEA
 * This program and the accompanying materials are made available under the
 * terms of the Eclipse Public License 2.0 which is available at
 * http://www.eclipse.org/legal/epl-2.0.
 *
 * SPDX-License-Identifier: EPL-2.0
 * Contributors: see AUTHORS file
 *******************************************************************************/
package fr.cea.nabla.ir.generator.arcane

import fr.cea.nabla.ir.IrTypeExtensions
import fr.cea.nabla.ir.annotations.AcceleratorAnnotation
import fr.cea.nabla.ir.ir.ArgOrVar
import fr.cea.nabla.ir.ir.BaseType
import fr.cea.nabla.ir.ir.Cardinality
import fr.cea.nabla.ir.ir.Connectivity
import fr.cea.nabla.ir.ir.ConnectivityType
import fr.cea.nabla.ir.ir.Expression
import fr.cea.nabla.ir.ir.IrType
import fr.cea.nabla.ir.ir.ItemIndex
import fr.cea.nabla.ir.ir.ItemIndexDefinition
import fr.cea.nabla.ir.ir.IterableInstruction
import fr.cea.nabla.ir.ir.Iterator
import fr.cea.nabla.ir.ir.LinearAlgebraType
import fr.cea.nabla.ir.ir.PrimitiveType
import java.util.ArrayList

import static extension fr.cea.nabla.ir.ContainerExtensions.*
import static extension fr.cea.nabla.ir.generator.arcane.ExpressionContentProvider.*

class TypeContentProvider
{
	static def getTypeName(IrType it)
	{
		switch it
		{
			BaseType:
			{
				val t = typeNameAndDimension
				val dimension = t.value
				if (dimension == 0)
					t.key
				else
					"NumArray<" + t.key + "," + dimension + ">"
			}
			ConnectivityType: getVariableTypeName(it)
			LinearAlgebraType: getLinearAlgebraClass(it)
			default: throw new RuntimeException("Unexpected type: " + class.name)
		}
	}

	/**
	 * Return true if it is scalar or Real* or Real*x*, false otherwise.
	 */
	static def isArcaneScalarType(IrType it)
	{
		it instanceof BaseType && (it as BaseType).typeNameAndDimension.value == 0
	}

	static def isArcaneStlVector(IrType t)
	{
		if (t instanceof LinearAlgebraType)
			t.sizes.size == 1 && t.sizes.head instanceof Cardinality
		else
			false
	}

	static def getLinearAlgebraClass(LinearAlgebraType t)
	{
		switch t.sizes.size
		{
			case 1:
			{
				val s = t.sizes.head
				if (s instanceof Cardinality)
				{
					val itemType = s.container.connectivityCall.connectivity.returnType
					"Arcane2AlienVector<" + itemType.name.toFirstUpper + ">"
				}
				else 
					IrTypeExtensions.VectorClass
			}
			case 2: IrTypeExtensions.MatrixClass
			default: throw new RuntimeException("Unexpected dimension: " + t.sizes.size)
		}
	}

	static def getFunctionArgTypeName(IrType it, boolean const)
	{
		if (!IrTypeExtensions.isScalar(it) && it instanceof BaseType && (it as BaseType).primitive == PrimitiveType.REAL)
		{
			val dim = ((it as BaseType).sizes.size)
			switch dim
			{
				case 1: '''RealArrayVariant'''
				case 2: '''RealArray2Variant'''
				default: throw new RuntimeException("Not yet implemented")
			}
		}
		else
			switch it
			{
				case null: null
				BaseType:
				{
					val t = typeNameAndDimension
					val dimension = t.value
					switch dimension
					{
						case 0: '''«IF const»const «ENDIF»«t.key»'''
						case 1: '''«IF const»Const«ENDIF»ArrayView<«t.key»>'''
						default: '''«IF const»Const«ENDIF»Array«dimension»View<«t.key»>'''
					}
				}
				LinearAlgebraType: IrTypeExtensions.getLinearAlgebraClass(it)
				// no ConnectivityType in functions
				default: throw new RuntimeException("Unexpected type: " + class.name)
			}
	}

	static def CharSequence formatIteratorsAndIndices(ArgOrVar v, Iterable<ItemIndex> iterators, Iterable<Expression> indices)
	{
		switch v.type
		{
			case (iterators.empty && indices.empty): ''''''
			BaseType case isNumArray(v): '''«FOR i : indices BEFORE '(' SEPARATOR ', ' AFTER ')'»«i.content»«ENDFOR»'''
			BaseType: '''«FOR i : indices»[«i.content»]«ENDFOR»'''
			// for the ArcaneStlVector, the setValue method must keep the ItemEnumerator arg (not the index)
			LinearAlgebraType: '''«FOR i : getConnectivityIndexList(iterators, v) SEPARATOR ', '»«i»«ENDFOR»«FOR i : indices SEPARATOR ', '»«i.content»«ENDFOR»'''
			ConnectivityType: '''«FOR i : getConnectivityIndexList(iterators, v)»[«i»]«ENDFOR»«FOR i : indices»[«i.content»]«ENDFOR»'''
		}
	}

	static def dispatch getVariableTypeName(ConnectivityType it)
	{
		val support = connectivities.head.returnType.name.toFirstUpper
		val t = base.typeNameAndDimension
		val dimension = connectivities.size - 1 + t.value
		return "Variable" + support + getVariableDimensionName(dimension, true) + t.key
	}

	static def dispatch getVariableTypeName(BaseType it)
	{
		val t = typeNameAndDimension
		return "Variable" + getVariableDimensionName(t.value, false) + t.key
	}

	static def dispatch getVariableTypeName(LinearAlgebraType it)
	{
		throw new RuntimeException("Not yet implemented")
	}

	static def Pair<String, Integer> getTypeNameAndDimension(BaseType it)
	{
		val d = intSizes.size

		if (primitive == PrimitiveType.REAL)
		{
			if (d > 1)
			{
				val x = intSizes.get(0)
				val y = intSizes.get(1)
				if (x == 2 && y == 2) return 'Real2x2' -> d - 2
				if (x == 3 && y == 3) return 'Real3x3' -> d - 2
			}

			if (d > 0)
			{
				val s = intSizes.get(0)
				if (s == 2) return 'Real2' -> d - 1
				if (s == 3) return 'Real3' -> d - 1
			}
		}

		// All the other cases
		val typeName = switch primitive
		{
			case BOOL: 'bool'
			case INT: 'Int32'
			case REAL: 'Real'
		}
		return typeName -> d
	}

	static def getResizeDims(IrType it)
	{
		switch it
		{
			BaseType case !isStatic: sizes.map[content]
			LinearAlgebraType case !isStatic: sizes.map[content]
			ConnectivityType:
			{
				val t = base.typeNameAndDimension
				val dimension = connectivities.size - 1 + t.value
				// only Array2 must be resized
				if (dimension > 0)
				{
					val dimensions = new ArrayList<CharSequence>
					dimensions += connectivities.tail.map[nbElems]
					dimensions += base.sizes.map[content]
					dimensions.subList(0, dimension)
				}
				else
					#[]
			}
			default: #[]
		}
	}

	static def isNumArray(ArgOrVar v)
	{
		v.type instanceof BaseType						// a BaseType...
		&& !isArcaneScalarType(v.type)					// ...but not scalar...
		&& AcceleratorAnnotation.tryToGet(v) === null	// ...and not a view
	}

	private static def getVariableDimensionName(int dimension, boolean hasSupport)
	{
		switch dimension
		{
			case 0: (hasSupport ? "" : "Scalar")
			case 1: "Array"
			case 2: "Array2"
			default: throw new RuntimeException("Unexpected dimension for variable type: " + dimension)
		}
	}

	/* Waiting for more... and management of global matrices */
	private static def getConnectivityIndexList(Iterable<ItemIndex> iterators, ArgOrVar v)
	{
		val indices = new ArrayList<String>
		if (!iterators.empty)
		{
			val firstIterator = iterators.head
			if (firstIterator.isAnItemType)
				if (ArcaneUtils.isArcaneManaged(v) || isArcaneStlVector(v.type)) // ArcaneStlVector needs ItemType
					indices += firstIterator.name
				else
					indices += firstIterator.name + ".localId()"
			else
				indices += firstIterator.name

			for (iterator : iterators.tail)
			{
				val name = iterator.name
				if (iterator.isAnItemType)
					indices += name + ".localId()"
				else
					indices += name
			}
		}
		return indices
	}

	/**
	 * Return true if ItemIndex represents ItemType instance false otherwise.
	 * It is the case when ItemIndex is an iterator on a topLevelConnectivity (for example allCells)
	 * only in an ENUMERATE_LOOP (RUN_COMMAND loops use index instead of ItemType instances).
	 */
	private static def isAnItemType(ItemIndex i)
	{
		val c = i.eContainer
		switch c
		{
			case null: false
			ItemIndexDefinition: false
			Iterator:
			{
				val loop = c.eContainer as IterableInstruction
				val cpuLoop = (AcceleratorAnnotation.tryToGet(loop) === null)
				c.container.connectivityCall.args.empty && cpuLoop
			}
		}
	}

	private static def getNbElems(Connectivity it)
	{
		if (inTypes.empty)
			"nb" + returnType.name.toFirstUpper + "()"
		else
		{
			val varName = "MaxNb" + name.toFirstUpper
			provider.generationVariables.get(varName)
		}
	}
}