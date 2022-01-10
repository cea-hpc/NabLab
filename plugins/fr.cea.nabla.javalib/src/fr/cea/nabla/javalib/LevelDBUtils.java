/*******************************************************************************
 * Copyright (c) 2022 CEA
 * This program and the accompanying materials are made available under the 
 * terms of the Eclipse Public License 2.0 which is available at
 * http://www.eclipse.org/legal/epl-2.0.
 *
 * SPDX-License-Identifier: EPL-2.0
 * Contributors: see AUTHORS file
 *******************************************************************************/
package fr.cea.nabla.javalib;

import static org.iq80.leveldb.impl.Iq80DBFactory.asString;
import static org.iq80.leveldb.impl.Iq80DBFactory.factory;

import java.io.ByteArrayOutputStream;
import java.io.DataOutputStream;
import java.io.File;
import java.io.IOException;
import java.nio.ByteBuffer;
import java.util.Arrays;

import org.apache.commons.io.FileUtils;
import org.iq80.leveldb.DB;
import org.iq80.leveldb.DBIterator;

import linearalgebrajava.Matrix;
import linearalgebrajava.Vector;

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

			DB dbRef = factory.open(new File(copyRefName), options);
			DBIterator itRef = dbRef.iterator();

			DB db = factory.open(new File(currentName), options);
			DBIterator it = db.iterator();

			// Results comparison
			System.out.println("# Comparing results ...");

			try 
			{
				for(itRef.seekToFirst() ; itRef.hasNext() ; itRef.next())
				{
					byte[] byteKey = itRef.peekNext().getKey();
					String key = asString(byteKey);
					byte[] byteValue = db.get(byteKey);
					if (byteValue == null)
					{
						System.err.println("ERROR - Key : " + key + " not found.");
						result = false;
					}
					else
					{
						byte[] ref = itRef.peekNext().getValue();
						byte[] value = byteValue;
						System.err.println(key + ": " + (Arrays.equals(value, ref) ? "OK" : "ERROR"));
						if (!Arrays.equals(value, ref))
						{
							result = false;
							int mismatchIndex = Arrays.mismatch(value, ref);
							ByteBuffer valueByteBuffer = ByteBuffer.wrap(value);
							ByteBuffer refByteBuffer = ByteBuffer.wrap(ref);
							int bufSize = valueByteBuffer.remaining();
							if (bufSize == Integer.BYTES)
								System.err.println("	" + valueByteBuffer.getInt() + " (value) != " + refByteBuffer.getInt() + " (ref)");
							else if (bufSize == Double.BYTES)
								System.err.println("	" + valueByteBuffer.getDouble() + " (value) != " + refByteBuffer.getDouble() + " (ref)");
							else if (bufSize % Double.BYTES == 0)
							{
								int indx = (int)(mismatchIndex / Double.BYTES);
								System.err.println("	" + valueByteBuffer.getDouble(indx * Double.BYTES) + " (value[" + indx + "]) != " + refByteBuffer.getDouble(indx * Double.BYTES) + " (ref[" + indx + "])");
							}
							else if (bufSize % Integer.BYTES == 0)
							{
								int indx = (int)(mismatchIndex / Integer.BYTES);
								System.err.println("	" + valueByteBuffer.getInt(indx * Integer.BYTES) + " (value[" + indx + "]) != " + refByteBuffer.getInt(indx * Integer.BYTES) + " (ref[" + indx + "])");
							}
							else
								System.out.println("Unable to determine the type of data.");
						}
					}
				}


				// looking for key in the db that are not in the ref (new variables)
				for(it.seekToFirst() ; it.hasNext() ; it.next())
				{
					byte[] byteKey = it.peekNext().getKey();
					if (dbRef.get(byteKey) == null)
					{
						System.err.println("ERROR - Key : " + asString(byteKey) + " can not be compared (not present in the ref).");
						result = false;
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
				itRef.close();
			}

			db.close();
			dbRef.close();
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

	public static <T extends Number>  byte[] toByteArray(final T number) throws IOException
	{
		ByteArrayOutputStream bos = new ByteArrayOutputStream();
		DataOutputStream dos = new DataOutputStream(bos);
		if (number instanceof Integer)
			dos.writeInt((Integer)number);
		else if (number instanceof Double)
			dos.writeDouble((Double)number);
		else {
			// Neither Double nor Integer
			throw new IllegalArgumentException("Only Double and Integer supported.");
		}
		dos.flush();
		return bos.toByteArray();
	}

	public static byte[] toByteArray(final boolean b) throws IOException
	{
		ByteArrayOutputStream bos = new ByteArrayOutputStream();
		DataOutputStream dos = new DataOutputStream(bos);
		dos.writeBoolean(b);
		dos.flush();
		return bos.toByteArray();
	}

	public static byte[] toByteArray(int[] data1d) throws IOException
	{
		if (data1d == null) return null;
		byte[] byts = new byte[data1d.length * Integer.BYTES];
		for (int i = 0; i < data1d.length; i++)
			System.arraycopy(toByteArray(data1d[i]), 0, byts, i * Integer.BYTES, Integer.BYTES);
		return byts;
	}

	public static byte[] toByteArray(double[] data1d) throws IOException
	{
		if (data1d == null) return null;
		byte[] byts = new byte[data1d.length * Double.BYTES];
		for (int i = 0; i < data1d.length; i++)
			System.arraycopy(toByteArray(data1d[i]), 0, byts, i * Double.BYTES, Double.BYTES);
		return byts;
	}

	public static byte[] toByteArray(final Vector vector) throws IOException
	{
		return toByteArray(vector.getData().toArray());
	}

	public static byte[] toByteArray(final double[][] data2d) throws IOException
	{
		if (data2d == null) return null;
		// ----------
		byte[] byts = new byte[data2d.length * data2d[0].length * Double.BYTES];
		for (int i = 0; i < data2d.length; i++)
			for (int j = 0; j < data2d[i].length; j++)
				System.arraycopy(toByteArray(data2d[i][j]), 0, byts, (i * data2d[0].length + j) * Double.BYTES, Double.BYTES);
		return byts;
	}

	public static byte[] toByteArray(final Matrix matrix) throws IOException
	{
		if (matrix == null) return null;
		// ----------
		byte[] byts = new byte[matrix.getData().getRowDimension() * matrix.getData().getColumnDimension() * Double.BYTES];
		for (int i = 0; i < matrix.getData().getRowDimension(); i++)
			for (int j = 0; j < matrix.getData().getColumnDimension(); j++)
				System.arraycopy(toByteArray(matrix.getValue(i, j)), 0, byts, (i * matrix.getData().getRowDimension() + j) * Double.BYTES, Double.BYTES);
		return byts;
	}

	public static byte[] toByteArray(final double[][][] data3d) throws IOException
	{
		if (data3d == null) return null;
		// ----------
		byte[] byts = new byte[data3d.length * data3d[0].length * data3d[0][0].length * Double.BYTES];
		for (int i = 0; i < data3d.length; i++)
			for (int j = 0; j < data3d[i].length; j++)
				for (int k = 0; k < data3d[i][j].length; k++)
					System.arraycopy(toByteArray(data3d[i][j][k]), 0, byts, (i * data3d[0].length * data3d[0][0].length + j * data3d[0][0].length + k) * Double.BYTES, Double.BYTES);
		return byts;
	}

	public static byte[] toByteArray(final double[][][][] data4d) throws IOException
	{
		if (data4d == null) return null;
		// ----------
		byte[] byts = new byte[data4d.length * data4d[0].length * data4d[0][0].length * data4d[0][0][0].length * Double.BYTES];
		for (int i = 0; i < data4d.length; i++)
			for (int j = 0; j < data4d[i].length; j++)
				for (int k = 0; k < data4d[i][j].length; k++)
					for (int l = 0; l < data4d[i][j][k].length; l++)
						System.arraycopy(toByteArray(data4d[i][j][k][l]), 0, byts, (i * data4d[0].length * data4d[0][0].length * data4d[0][0][0].length + j * data4d[0][0].length * data4d[0][0][0].length + k * data4d[0][0][0].length + l) * Double.BYTES, Double.BYTES);
		return byts;
	}
}
