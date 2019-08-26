package fr.cea.nabla.javalib.types;

import org.apache.commons.math3.linear.AbstractRealMatrix;
import org.apache.commons.math3.linear.Array2DRowRealMatrix;
import org.apache.commons.math3.linear.OpenMapRealMatrix;

public class Matrix 
{
	private Object lock = new Object();
	private AbstractRealMatrix nativeMatrix;
	
	public Matrix(AbstractRealMatrix nativeMatrix)
	{
		this.nativeMatrix = nativeMatrix;
	}
	
	public static Matrix createDenseMatrix(int nbRows, int nbCols)
	{
		return new Matrix(new Array2DRowRealMatrix(nbRows, nbCols));
	}
	
	public static Matrix createSparseMatrix(int nbRows, int nbCols)
	{
		return new Matrix(new OpenMapRealMatrix(nbRows, nbCols));
	}

	public AbstractRealMatrix getNativeMatrix() 
	{ 
		return nativeMatrix; 
	}
	
	public double get(int i, int j) 
	{ 
		return nativeMatrix.getEntry(i, j); 
	}
	
	public void set(int i, int j, double value) 
	{ 
		synchronized(lock) { nativeMatrix.setEntry(i, j, value); }
	}
	
	public void add(int i, int j, double increment) 
	{ 
		synchronized(lock) { nativeMatrix.addToEntry(i, j, increment); }
	}
}
