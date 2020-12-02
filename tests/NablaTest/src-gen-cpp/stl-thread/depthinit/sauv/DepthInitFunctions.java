package depthinit;

public class DepthInitFunctions
{
	static
	{
		System.load("/home/lelandaisb/workspaces/NabLab/tests/NablaTest/src-gen-cpp/stl-thread/depthinit/build/libdepthinitjni.so");
	}

	public native void jsonInit(String jsonContent);
	public native double nextWaveHeight();
}