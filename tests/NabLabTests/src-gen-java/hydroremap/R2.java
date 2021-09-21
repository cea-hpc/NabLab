/* DO NOT EDIT THIS FILE - it is machine generated */

package hydroremap;

import java.io.FileReader;
import java.io.IOException;
import java.util.stream.IntStream;

import com.google.gson.Gson;
import com.google.gson.JsonObject;
import com.google.gson.JsonElement;

import fr.cea.nabla.javalib.*;
import fr.cea.nabla.javalib.mesh.*;

public final class R2
{
	// Mesh and mesh variables
	private final CartesianMesh2D mesh;
	@SuppressWarnings("unused")
	private final int nbNodes, nbCells;

	// Main module
	private Hydro mainModule;

	// Option and global variables
	double[] rv2;

	public R2(CartesianMesh2D aMesh)
	{
		// Mesh and mesh variables initialization
		mesh = aMesh;
		nbNodes = mesh.getNbNodes();
		nbCells = mesh.getNbCells();

		// Initialize variables with default values

		// Allocate arrays
		rv2 = new double[nbCells];
	}

	public void jsonInit(final String jsonContent)
	{
		final Gson gson = new Gson();
		final JsonObject o = gson.fromJson(jsonContent, JsonObject.class);
	}

	/**
	 * Job rj1 called @2.0 in simulate method.
	 * In variables: hv3
	 * Out variables: rv2
	 */
	protected void rj1()
	{
		IntStream.range(0, nbCells).parallel().forEach(cCells -> 
		{
			rv2[cCells] = mainModule.hv3[cCells];
		});
	}

	/**
	 * Job rj2 called @3.0 in simulate method.
	 * In variables: rv2
	 * Out variables: hv6
	 */
	protected void rj2()
	{
		IntStream.range(0, nbCells).parallel().forEach(cCells -> 
		{
			mainModule.hv6[cCells] = rv2[cCells];
		});
	}

	public void setMainModule(Hydro aMainModule)
	{
		mainModule = aMainModule;
		mainModule.r2 = this;
	}
};