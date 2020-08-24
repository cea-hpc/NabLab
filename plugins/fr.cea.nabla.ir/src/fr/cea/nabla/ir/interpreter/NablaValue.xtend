/*******************************************************************************
 * Copyright (c) 2020 CEA
 * This program and the accompanying materials are made available under the 
 * terms of the Eclipse Public License 2.0 which is available at
 * http://www.eclipse.org/legal/epl-2.0.
 *
 * SPDX-License-Identifier: EPL-2.0
 * Contributors: see AUTHORS file
 *******************************************************************************/
package fr.cea.nabla.ir.interpreter

import fr.cea.nabla.javalib.types.Matrix
import fr.cea.nabla.javalib.types.Vector
import org.eclipse.xtend.lib.annotations.Accessors
import org.eclipse.xtend.lib.annotations.Data

interface NablaValue { }

class NV0Bool implements NablaValue
{
	@Accessors boolean data 
	new(boolean data) { this.data = data }

	override boolean equals(Object obj)
	{
		if (this === obj) return true
		if (obj === null) return false
		if (getClass() !== obj.getClass()) return false
		val other = obj as NV0Bool
		if (other.data !== this.data) return false
		return true
	}

	override String toString()
	{
		data.toString
	}
}

class NV0Int implements NablaValue
{
	@Accessors int data 
	new(int data) { this.data = data }

	override boolean equals(Object obj)
	{
		if (this === obj) return true
		if (obj === null) return false
		if (getClass() !== obj.getClass()) return false
		val other = obj as NV0Int
		if (other.data !== this.data) return false
		return true
	}

	override String toString()
	{
		data.toString
	}
}

class NV0Real implements NablaValue
{
	@Accessors double data 
	new(double data) { this.data = data }

	override boolean equals(Object obj)
	{
		if (this === obj) return true
		if (obj === null) return false
		if (getClass() !== obj.getClass()) return false
		val other = obj as NV0Real
		if (other.data !== this.data) return false
		return true
	}

	override String toString()
	{
		data.toString
	}
}

@Data class NV1Bool implements NablaValue
{ 
	boolean[] data

	override String toString()
	{
		'[' + data.join(', ') + ']'
	}
}

@Data class NV1Int implements NablaValue
{ 
	int[] data

	override String toString()
	{
		'[' + data.join(', ') + ']'
	}
}

@Data class NV1Real implements NablaValue
{ 
	double[] data

	override String toString()
	{
		'[' + data.join(', ') + ']'
	}
}
class NVVector implements NablaValue
{
	@Accessors Vector data

	new(Vector data)
	{
		this.data = data
	}

	override String toString()
	{
		data.toArray.map[d | d].toString
	}
}

@Data class NV2Bool implements NablaValue
{ 
	boolean[][] data

	override String toString()
	{
		data.map[d | d.map[ dd | dd]].toString
	}
}

@Data class NV2Int implements NablaValue
{ 
	int[][] data

	override String toString()
	{
		data.map[d | d.map[ dd | dd]].toString
	}
}

@Data class NV2Real implements NablaValue
{
	double[][] data

	override String toString()
	{
		data.map[d | d.map[ dd | dd]].toString
	}
}

class NVMatrix implements NablaValue
{
	@Accessors Matrix data

	new(Matrix data)
	{
		this.data = data
	}
}

@Data class NV3Bool implements NablaValue
{ 
	boolean[][][] data

	override String toString()
	{
		data.map[d | d.map[ dd | dd.map[ddd | ddd]]].toString
	}
}

@Data class NV3Int implements NablaValue
{
	int[][][] data

	override String toString()
	{
		data.map[d | d.map[ dd | dd.map[ddd | ddd]]].toString
	}
}

@Data class NV3Real implements NablaValue
{
	double[][][] data

	override String toString()
	{
		data.map[d | d.map[ dd | dd.map[ddd | ddd]]].toString
	}
}

@Data class NV4Bool implements NablaValue
{
	boolean[][][][] data

	override String toString()
	{
		data.map[d | d.map[ dd | dd.map[ddd | ddd.map[dddd | dddd]]]].toString
	}
}

@Data class NV4Int implements NablaValue
{
	int[][][][] data

	override String toString()
	{
		data.map[d | d.map[ dd | dd.map[ddd | ddd.map[dddd | dddd]]]].toString
	}
}

@Data class NV4Real implements NablaValue
{
	double[][][][] data

	override String toString()
	{
		data.map[d | d.map[ dd | dd.map[ddd | ddd.map[dddd | dddd]]]].toString
	}
}

/*
 * Should test it... 
@Data class NV0<T> implements NablaValue { T data }
@Data class NV1<T> implements NablaValue { T[] data }
@Data class NV2<T> implements NablaValue { T[][] data }
@Data class NV3<T> implements NablaValue { T[][][] data }
* 
*/