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
import static org.iq80.leveldb.impl.Iq80DBFactory.bytes;
import static org.iq80.leveldb.impl.Iq80DBFactory.factory;

import java.io.ByteArrayInputStream;
import java.io.ByteArrayOutputStream;
import java.io.DataOutputStream;
import java.io.File;
import java.io.IOException;
import java.io.ObjectInputStream;
import java.io.ObjectOutputStream;
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
					String key = asString(itRef.peekNext().getKey());
					String descriptorSuffix = "_descriptor";
					if (!key.endsWith(descriptorSuffix))
					{
						byte[] value = db.get(bytes(key));
						if (value == null)
						{
							System.err.println("ERROR - Key : " + key + " not found.");
							result = false;
						}
						else
						{
							byte[] ref = itRef.peekNext().getValue();
							if (Arrays.equals(value, ref))
								System.err.println(key + ": " + "OK");
							else
							{
								System.err.println(key + ": " + "ERROR");
								result = false;
								String dataDescriptorKey = key + "_descriptor";
								DataDescriptor dataDescriptor = toDataDescriptor(dbRef.get(bytes(dataDescriptorKey)));
								int bytes = dataDescriptor.dataTypeBytes;
								
								int mismatchIndex = Arrays.mismatch(value, ref);
								ByteBuffer valueByteBuffer = ByteBuffer.wrap(value);
								ByteBuffer refByteBuffer = ByteBuffer.wrap(ref);
								int bufSize = valueByteBuffer.remaining();
								if (bufSize == bytes)
								{
									if (bytes == Integer.BYTES)
										System.err.println("	Value " + key + " = " + valueByteBuffer.getInt() + " vs Reference " + key + " = " + refByteBuffer.getInt());
									else if (bytes == Double.BYTES)
										System.err.println("	Value " + key + " = " + valueByteBuffer.getDouble() + " vs Reference " + key + " = " + refByteBuffer.getDouble());
								}
								else if (bufSize % bytes == 0)
								{
									int indx = mismatchIndex / bytes;
									String indexes = getMismatchIndexes(dataDescriptor.dataSizes, indx);
									if (bytes == Integer.BYTES)
										System.err.println("	Value "  + key + indexes + " = " + valueByteBuffer.getInt(indx * Integer.BYTES) + " vs Reference " + key + indexes + " = " + refByteBuffer.getInt(indx * Integer.BYTES));
									else if (bytes == Double.BYTES)
										System.err.println("	Value "  + key + indexes + " = " + valueByteBuffer.getDouble(indx * Double.BYTES) + " vs Reference " + key + indexes + " = " + refByteBuffer.getDouble(indx * Double.BYTES));
								}
								else
									System.err.println("Unable to determine the type of data.");
							}
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

	private static String getMismatchIndexes(int[] dataSizes, int mismatchIndex)
	{
		if (dataSizes.length == 1)
			return "[" + mismatchIndex + "]";
		else if (dataSizes.length == 2)
			return "[" + mismatchIndex / dataSizes[1] + "]" + "[" + mismatchIndex % dataSizes[1] + "]";
		else if (dataSizes.length == 3)
			return "[" + mismatchIndex / (dataSizes[1] * dataSizes[2]) + "]"
					+ "[" + (mismatchIndex % (dataSizes[1] * dataSizes[2])) / dataSizes[2] + "]"
					+ "[" + (mismatchIndex % (dataSizes[1] * dataSizes[2])) % dataSizes[2] + "]";
		else if (dataSizes.length == 4)
			return "[" + mismatchIndex / (dataSizes[1] * dataSizes[2] * dataSizes[3] ) + "]"
					+ "[" + (mismatchIndex % (dataSizes[1] * dataSizes[2] * dataSizes[3] )) / ( dataSizes[2] * dataSizes[3] ) + "]"
					+ "[" + ((mismatchIndex % (dataSizes[1] * dataSizes[2] * dataSizes[3] )) % ( dataSizes[2] * dataSizes[3] )) / dataSizes[3] + "]"
					+ "[" + ((mismatchIndex % (dataSizes[1] * dataSizes[2] * dataSizes[3] )) % ( dataSizes[2] * dataSizes[3] )) % dataSizes[3] + "]";
		return "";
	}

	public static void destroyDB(String name) throws IOException
	{
		org.iq80.leveldb.Options leveldbOptions = new org.iq80.leveldb.Options();
		factory.destroy(new File(name), leveldbOptions);
	}

	public static byte[] toByteArrayDescriptor(int dataBytes, int[] dataSizes) throws IOException
	{
		DataDescriptor dataDescriptor = new DataDescriptor(dataBytes, dataSizes);
		ByteArrayOutputStream bos = new ByteArrayOutputStream();
		ObjectOutputStream oos = new ObjectOutputStream(bos);
		oos.writeObject(dataDescriptor);
		oos.flush();
		return bos.toByteArray();
	}

	private static DataDescriptor toDataDescriptor(byte[] bytes) throws IOException, ClassNotFoundException
	{
		ByteArrayInputStream in = new ByteArrayInputStream(bytes);
	    ObjectInputStream is = new ObjectInputStream(in);
	    return (DataDescriptor) is.readObject();
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
		int n = data1d.length;
		byte[] byts = new byte[n * Integer.BYTES];
		for (int i = 0; i < n; i++)
			System.arraycopy(toByteArray(data1d[i]), 0, byts, i * Integer.BYTES, Integer.BYTES);
		return byts;
	}

	public static byte[] toByteArray(double[] data1d) throws IOException
	{
		if (data1d == null) return null;
		int n = data1d.length;
		byte[] byts = new byte[n * Double.BYTES];
		for (int i = 0; i <n; i++)
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
		int n = data2d.length;
		int m = data2d[0].length;
		byte[] byts = new byte[n * m * Double.BYTES];
		for (int i = 0; i < n; i++)
			for (int j = 0; j < m; j++)
				System.arraycopy(toByteArray(data2d[i][j]), 0, byts, (i * m + j) * Double.BYTES, Double.BYTES);
		return byts;
	}

	public static byte[] toByteArray(final Matrix matrix) throws IOException
	{
		if (matrix == null) return null;
		int n = matrix.getData().getRowDimension();
		int m =  matrix.getData().getColumnDimension();
		byte[] byts = new byte[n * m * Double.BYTES];
		for (int i = 0; i < n; i++)
			for (int j = 0; j < m; j++)
				System.arraycopy(toByteArray(matrix.getValue(i, j)), 0, byts, (i * m + j) * Double.BYTES, Double.BYTES);
		return byts;
	}

	public static byte[] toByteArray(final double[][][] data3d) throws IOException
	{
		if (data3d == null) return null;
		int dim1 = data3d.length;
		int dim2 = data3d[0].length;
		int dim3 = data3d[0][0].length;
		byte[] byts = new byte[dim1 * dim2 * dim3 * Double.BYTES];
		for (int i = 0; i < dim1; i++)
			for (int j = 0; j < dim2; j++)
				for (int k = 0; k < dim3; k++)
					System.arraycopy(toByteArray(data3d[i][j][k]), 0, byts, (i * dim2 * dim3 + j * dim3 + k) * Double.BYTES, Double.BYTES);
		return byts;
	}

	public static byte[] toByteArray(final double[][][][] data4d) throws IOException
	{
		if (data4d == null) return null;
		int dim1 = data4d.length;
		int dim2 = data4d[0].length;
		int dim3 = data4d[0][0].length;
		int dim4 = data4d[0][0][0].length;
		byte[] byts = new byte[dim1 * dim2 * dim3 * dim4 * Double.BYTES];
		for (int i = 0; i < dim1; i++)
			for (int j = 0; j < dim2; j++)
				for (int k = 0; k < dim3; k++)
					for (int l = 0; l < dim4; l++)
						System.arraycopy(toByteArray(data4d[i][j][k][l]), 0, byts, (i * dim2 * dim3 * dim4 + j * dim3 * dim4 + k * dim4 + l) * Double.BYTES, Double.BYTES);
		return byts;
	}
}
