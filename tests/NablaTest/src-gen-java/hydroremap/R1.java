/*** GENERATED FILE - DO NOT OVERWRITE ***/

package hydroremap;

import static org.iq80.leveldb.impl.Iq80DBFactory.bytes;
import static org.iq80.leveldb.impl.Iq80DBFactory.factory;

import java.io.File;
import java.io.FileReader;
import java.io.IOException;
import java.util.stream.IntStream;

import org.iq80.leveldb.DB;
import org.iq80.leveldb.WriteBatch;

import com.google.gson.JsonElement;
import com.google.gson.JsonObject;
import com.google.gson.JsonParser;

import fr.cea.nabla.javalib.*;
import fr.cea.nabla.javalib.mesh.*;

@SuppressWarnings("all")
public final class R1
{
	public final static class Options
	{
		public String nonRegression;

		public void jsonInit(final String jsonContent)
		{
			final JsonParser parser = new JsonParser();
			final JsonElement json = parser.parse(jsonContent);
			assert(json.isJsonObject());
			final JsonObject o = json.getAsJsonObject();
			// Non regression
			if (o.has("nonRegression"))
			{
				final JsonElement valueof_nonRegression = o.get("nonRegression");
				nonRegression = valueof_nonRegression.getAsJsonPrimitive().getAsString();
			}
		}
	}

	// Mesh and mesh variables
	private final CartesianMesh2D mesh;
	private final int nbNodes, nbCells;

	// User options
	private final Options options;

	// Main module
	private H mainModule;

	// Global variables
	protected double[] rv3;

	public R1(CartesianMesh2D aMesh, Options aOptions)
	{
		// Mesh and mesh variables initialization
		mesh = aMesh;
		nbNodes = mesh.getNbNodes();
		nbCells = mesh.getNbCells();

		// User options
		options = aOptions;

		// Initialize variables with default values

		// Allocate arrays
		rv3 = new double[nbCells];
	}

	/**
	 * Job rj1 called @1.0 in simulate method.
	 * In variables: hv1
	 * Out variables: hv4
	 */
	protected void rj1()
	{
		IntStream.range(0, nbCells).parallel().forEach(cCells -> 
		{
			mainModule.hv4[cCells] = mainModule.hv1[cCells];
		});
	}

	/**
	 * Job rj2 called @2.0 in simulate method.
	 * In variables: hv4
	 * Out variables: rv3
	 */
	protected void rj2()
	{
		IntStream.range(0, nbCells).parallel().forEach(cCells -> 
		{
			rv3[cCells] = mainModule.hv4[cCells];
		});
	}

	public void setMainModule(H aMainModule)
	{
		mainModule = aMainModule;
		mainModule.r1 = this;
	}
};
