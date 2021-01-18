/*** GENERATED FILE - DO NOT OVERWRITE ***/

/**
 * Design Pattern inspired from https://dhilst.github.io/2016/10/15/JNI-CPP.html
 * Principle: a java long attribute to keep the link to the C++ object
 */
package batilib;

public class BatiLibCppJni
{
	static
	{
		System.load("/home/lelandaisb/workspaces/NabLab/tests/NablaTest/../NablaTest/src-gen-interpreter/depthinit/lib/libbatilibcppjni.so");
	}

	// This is a long here (in Java) but is used as a pointer to hold the
	// address of our native object at "native world".
	private long nativeObjectPointer;

	// This method is used to allocate an instance of this class at native
	// world and return the address of it.
	private native long nativeNew();

	// Our constructor. The nativeNew() method is called to allocate a new
	// instance of our native object and return its address. The address is
	// assigned to nativeObjectPointer. Just as a note, Java forbiddes
	// native constructors, so we need a native method to allocate our
	// native object.
	public BatiLibCppJni()
	{
		nativeObjectPointer = nativeNew();	
	}

	public native void jsonInit(String jsonContent);
	public native double nextWaveHeight();
	public native double nextDepth1(double x0, double[] x1);
	public native double nextDepth2(double x0, double[][] x1);
	public native double[] nextDepth3(double[] x0);
	public native double[][] nextDepth4(double[][] x0);
}
