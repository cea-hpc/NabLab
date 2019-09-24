package fr.cea.nabla.ir.interpreter

import fr.cea.nabla.ir.ir.Connectivity
import org.eclipse.xtend.lib.annotations.Data

abstract class NablaValue 
{
}

@Data
abstract class NablaSimpleValue extends NablaValue
{
}

@Data
abstract class NSVScalar extends NablaSimpleValue
{
}

@Data
abstract class NSVArray1D extends NablaSimpleValue
{
	abstract def int getSize()
}

@Data
abstract class NSVArray2D extends NablaSimpleValue 
{
	abstract def int getNbRows()
	abstract def int getNbCols()
}

@Data
class NSVBoolScalar extends NSVScalar
{
	boolean value
}

@Data
class NSVBoolArray1D extends NSVArray1D
{
	val boolean[] values
	override getSize() { values.size }
}

@Data
class NSVBoolArray2D extends NSVArray2D
{
	val boolean[][] values
	override getNbRows() { values.size }
	override getNbCols() { values.get(0).size }
}

@Data
class NSVIntScalar extends NSVScalar
{
	int value
}

@Data
class NSVIntArray1D extends NSVArray1D
{
	val int[] values
	override getSize() { values.size }
}

@Data
class NSVIntArray2D extends NSVArray2D
{
	val int[][] values
	override getNbRows() { values.size }
	override getNbCols() { values.get(0).size }
}

@Data
class NSVRealScalar extends NSVScalar
{
	double value
}

@Data
class NSVRealArray1D extends NSVArray1D
{
	val double[] values
	override getSize() { values.size }
}

@Data
class NSVRealArray2D extends NSVArray2D
{
	val double[][] values
	override getNbRows() { values.size }
	override getNbCols() { values.get(0).size }
}

@Data
class NablaConnectivityValue extends NablaValue
{
	val Connectivity[] connectivities
	val NablaSimpleValue[] values
}