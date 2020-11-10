package fr.cea.nabla.javalib.utils;

import static org.iq80.leveldb.impl.Iq80DBFactory.asString;
import static org.iq80.leveldb.impl.Iq80DBFactory.bytes;
import static org.iq80.leveldb.impl.Iq80DBFactory.factory;

import java.io.File;
import java.io.IOException;

import org.iq80.leveldb.DB;
import org.iq80.leveldb.DBIterator;

import fr.cea.nabla.javalib.types.Matrix;
import fr.cea.nabla.javalib.types.Vector;

import org.apache.commons.io.FileUtils;

public class LevelDBUtils 
{
	public static Boolean compareDB(String currentName, String refName) throws IOException
	{
		// Final result
		Boolean result = true;
		String copyRefName = refName + "Copy";

		try 
		{
			// We have to copy ref not to modify it (for git repo)
			File copyRef = new File(copyRefName);
			File sourceLocation= new File(refName);
			FileUtils.copyDirectory(sourceLocation, copyRef);

			// Loading ref DB
			org.iq80.leveldb.Options options = new org.iq80.leveldb.Options();
			options.createIfMissing(false);

			DB db_ref = factory.open(new File(copyRefName), options);
			DBIterator it_ref = db_ref.iterator();

			DB db = factory.open(new File(currentName), options);
			DBIterator it = db.iterator();
	
			// Results comparison
			System.out.println("# Compairing results ...");

			try 
			{
				for(it_ref.seekToFirst(), it.seekToFirst(); it_ref.hasNext() && it.hasNext(); it_ref.next(), it.next())
				{
					String key = asString(it.peekNext().getKey());
					if (!key.equals(asString(it_ref.peekNext().getKey())))
					{
						System.err.println("ERROR - Incompatible ref. Key : " + key + " not found.");
						result = false;
						break;
					}
					String value = asString(it.peekNext().getValue());
					String ref = asString(it_ref.peekNext().getValue());
					System.out.println(key + ": " + (value.contentEquals(ref) ? "OK" : "ERROR"));
					if (!value.equals(ref))
					{
						result = false;
						System.err.println("value = " + value);
						System.err.println(" ref = " + ref);

					}
				}
			}
			catch (Exception e)
			{
				System.err.println(e);
			}
			finally {
				// Make sure you close the iterator to avoid resource leaks.
				it.close();
				it_ref.close();
			}

			db.close();
			db_ref.close();
			destroyDB(copyRefName);
			return result;
		}
		catch (Exception e)
		{
			System.err.println("No ref database to compare with ! Looking for " + refName);
			destroyDB(copyRefName);
			return false;
		}
	}
	
	public static void destroyDB(String name) throws IOException
	{
		org.iq80.leveldb.Options leveldbOptions = new org.iq80.leveldb.Options();
		factory.destroy(new File(name), leveldbOptions);
	}

	public static byte[] serialize(final int i) 	
	{
	    return bytes(Integer.toString(i));
	}

	public static byte[] serialize(final double d)
	{
	    return bytes(String.valueOf(d));
	}

	public static byte[] serialize(final double[] data1d) 
	{
		StringBuilder sb = new StringBuilder();
		for (double d : data1d)
			sb.append(d).append(" ");
		return bytes(sb.toString());
	}

	public static byte[] serialize(final Vector vector)
	{
		return serialize(vector.toArray());
	}

	public static byte[] serialize(final double[][] data2d) 
	{
		StringBuilder sb = new StringBuilder();
		for (double data1d[] : data2d)
		{
			for (double d : data1d)
				sb.append(d).append(" ");
			sb.append(" ");
		}
		return bytes(sb.toString());
	}

	public static byte[] serialize(final Matrix matrix)
	{
		return bytes(matrix.getNativeMatrix().toString());
	}

	public static byte[] serialize(final double[][][] data3d) 
	{
		StringBuilder sb = new StringBuilder();
		for (double[][] data2d : data3d)
		{	
			for (double[] data1d : data2d)
			{
				for (double d : data1d)
					sb.append(d).append(" ");
				sb.append(" ");
			}
			sb.append(" ");
		}
		return bytes(sb.toString());
	}

	public static byte[] serialize(final double[][][][] data4d) 
	{
		StringBuilder sb = new StringBuilder();
		for (double[][][] data3d : data4d)
		{	
			for (double[][] data2d : data3d)
			{
				for (double data1d[] : data2d)
				{
					for (double d : data1d)
						sb.append(d).append(" ");
					sb.append(" ");
				}
				sb.append(" ");
			}
			sb.append(" ");
		}
		return bytes(sb.toString());
	}
}
