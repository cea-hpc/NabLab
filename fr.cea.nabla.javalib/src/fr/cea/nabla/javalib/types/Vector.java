package fr.cea.nabla.javalib.types;

import org.apache.commons.math3.linear.ArrayRealVector;
import org.apache.commons.math3.linear.OpenMapRealVector;

public class Vector 
{
	private Object lock = new Object();
	private org.apache.commons.math3.linear.RealVector nativeVector;
	
	public Vector(org.apache.commons.math3.linear.RealVector nativeVector)
	{
		this.nativeVector = nativeVector;
	}
	
	public static Vector createDenseVector(int size)
	{
		return new Vector(new ArrayRealVector(size));
	}
	
	public static Vector createSparseVector(int size)
	{
		return new Vector(new OpenMapRealVector(size));
	}

	public org.apache.commons.math3.linear.RealVector getNativeVector() 
	{ 
		return nativeVector; 
	}
	
	public double get(int i) 
	{ 
		return nativeVector.getEntry(i); 
	}
	
	public void set(int i, double value) 
	{ 
		synchronized(lock) { nativeVector.setEntry(i, value); }
	}
	
	public void add(int i, double increment) 
	{ 
		synchronized(lock) { nativeVector.addToEntry(i, increment); } 
	}
	
	public double[] toArray() 
	{ 
		return nativeVector.toArray(); 
	}
}
