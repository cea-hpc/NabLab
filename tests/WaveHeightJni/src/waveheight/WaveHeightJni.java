/*******************************************************************************
 * Copyright (c) 2020 CEA
 * This program and the accompanying materials are made available under the
 * terms of the Eclipse Public License 2.0 which is available at
 * http://www.eclipse.org/legal/epl-2.0.
 *
 * SPDX-License-Identifier: EPL-2.0
 * Contributors: see AUTHORS file
 *******************************************************************************/

/**
 * Design Pattern inspired from https://dhilst.github.io/2016/10/15/JNI-CPP.html
 * Principle: a java long attribute to keep the link to the C++ object
 */
package waveheight;

public class WaveHeightJni
{
	static
	{
		// Loads the libwaveheightjni.so This is the place where our native methods reside.
		//System.loadLibrary("waveheightjni"); // Need classpath to be set to the lib path before execution
		System.load(System.getProperty("user.home") + "/workspaces/runtime-EclipseApplication/WaveHeightJni/lib/libwaveheightjni.so");
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
	public WaveHeightJni()
	{
		nativeObjectPointer = nativeNew();	
	}

	public native void jsonInit(String jsonContent);
	public native double nextWaveHeight();
}