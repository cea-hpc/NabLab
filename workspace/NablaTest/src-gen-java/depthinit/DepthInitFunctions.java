package depthinit;

public class DepthInitFunctions
{
	private double depth = 4.3;
	private String fileName = "";

	public double nextWaveHeight()
	{
		System.out.println("fileName = " + fileName + ", depth = " + depth);
		return depth;
	}
}
