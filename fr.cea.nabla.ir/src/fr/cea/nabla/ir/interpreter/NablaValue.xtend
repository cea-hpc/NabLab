package fr.cea.nabla.ir.interpreter

import org.eclipse.xtend.lib.annotations.Accessors
import org.eclipse.xtend.lib.annotations.Data

interface NablaValue { }

class NV0Bool implements NablaValue 
{  
	@Accessors boolean data 
	new(boolean data) { this.data = data }
}

class NV0Int implements NablaValue
{  
	@Accessors int data 
	new(int data) { this.data = data }
}

class NV0Real implements NablaValue
{  
	@Accessors double data 
	new(double data) { this.data = data }
}

@Data class NV1Bool implements NablaValue { boolean[] data }
@Data class NV1Int implements NablaValue { int[] data }
@Data class NV1Real implements NablaValue { double[] data }

@Data class NV2Bool implements NablaValue { boolean[][] data }
@Data class NV2Int implements NablaValue { int[][] data }
@Data class NV2Real implements NablaValue { double[][] data }

@Data class NV3Bool implements NablaValue { boolean[][][] data }
@Data class NV3Int implements NablaValue { int[][][] data }
@Data class NV3Real implements NablaValue { double[][][] data }

/*
 * Should test it... 
@Data class NV0<T> implements NablaValue { T data }
@Data class NV1<T> implements NablaValue { T[] data }
@Data class NV2<T> implements NablaValue { T[][] data }
@Data class NV3<T> implements NablaValue { T[][][] data }
* 
*/