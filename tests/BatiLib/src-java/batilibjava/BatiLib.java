package batilibjava;

import com.google.gson.JsonElement;
import com.google.gson.JsonObject;
import com.google.gson.JsonParser;

public class BatiLib implements IBatiLib
{
	private double depth = 4.3;
	private String fileName = "";

	@Override
	public void jsonInit(final String jsonContent)
	{
		System.out.println("Java BatiLib::jsonInit");

		final JsonParser parser = new JsonParser();
		final JsonElement json = parser.parse(jsonContent);
		assert(json.isJsonObject());
		final JsonObject o = json.getAsJsonObject();

		if (o.has("depth"))
		{
			final JsonElement valueof_depth = o.get("depth");
			assert(valueof_depth.isJsonPrimitive());
			depth = valueof_depth.getAsJsonPrimitive().getAsDouble();
		}
		System.out.println("   depth : " + depth);

		if (o.has("fileName"))
		{
			final JsonElement valueof_fileName = o.get("fileName");
			assert(valueof_fileName.isJsonPrimitive());
			fileName = valueof_fileName.getAsJsonPrimitive().getAsString();
		}
		System.out.println("   fileName : " + fileName);
	}

	@Override
	public double nextWaveHeight()
	{
		System.out.println("Java BatiLib::nextWaveHeight");
		return 1.0;
	}

	@Override
	public double nextDepth1(double x0, double[] x1)
	{
		System.out.println("Java BatiLib::nextDepth1");
		double sum = x0;
		for (int i=0 ; i<x1.length ; ++i)
			sum += x1[i];
		return sum;
	}

	@Override
	public double nextDepth2(double x0, double[][] x1)
	{
		System.out.println("Java BatiLib::nextDepth2");
		double sum = x0;
		for (int i=0 ; i<x1.length ; ++i)
			for (int j=0 ; j<x1[i].length ; ++j)
				sum += x1[i][j];
		return sum;
	}

	@Override
	public double[] nextDepth3(double[] x0)
	{
		System.out.println("Java BatiLib::nextDepth3");
		double[] ret = new double[x0.length];
		for (int i=0 ; i<x0.length ; ++i)
			ret[i] = 2*x0[i];
		return ret;
	}

	@Override
	public double[][] nextDepth4(double[][] x0)
	{
		System.out.println("Java BatiLib::nextDepth4");
		double[][] ret = new double[x0.length][x0[0].length];
		for (int i=0 ; i<x0.length ; ++i)
			for (int j=0 ; j<x0[i].length ; ++j)
				ret[i][j] = 2*x0[i][j];
		return ret;
	}
}
