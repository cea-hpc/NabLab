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
	public static Boolean compareDB(String currentName, String refName, double tolerance) throws IOException
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
								String dataDescriptorKey = key + "_descriptor";
								DataDescriptor dataDescriptor = toDataDescriptor(dbRef.get(bytes(dataDescriptorKey)));
								int bytes = dataDescriptor.dataTypeBytes;

								DataDiff dataDiff = compareData(value, ref, bytes, tolerance);
								if (dataDiff.nbErrors == 0)
									System.err.println(key + ": " + "OK");
								else
								{
									result = false;
									int nbVals = value.length / bytes;
									if (nbVals == 1)
										System.err.println(key + ": " + "ERROR");
									else
										System.err.println(key + ": " + "ERRORS " + dataDiff.nbErrors + "/" + nbVals);

									ByteBuffer valueByteBuffer = ByteBuffer.wrap(value);
									ByteBuffer refByteBuffer = ByteBuffer.wrap(ref);
									if (isScalar(dataDescriptor.dataSizes))
									{
										if (bytes == 1)
											System.err.println("	Expected " + getBoolean(refByteBuffer, 0) + " but was " +  getBoolean(valueByteBuffer, 0));
										if (bytes == Integer.BYTES)
											System.err.println("	Expected " + refByteBuffer.getInt() + " but was " + valueByteBuffer.getInt());
										else if (bytes == Double.BYTES)
										{
											double relativeError = getRelativeError(valueByteBuffer.getDouble(0), refByteBuffer.getDouble(0));
											System.err.println("	Expected " + refByteBuffer.getDouble(0) + " but was " + valueByteBuffer.getDouble(0) + " (Relative error = " + relativeError + ")");
										}
									}
									else
									{
										String indexes = getMismatchIndexes(dataDescriptor.dataSizes, dataDiff.relativeMaxErrorIndex / bytes);
										if (bytes == 1)
											System.err.println("	Error "  + key + indexes + " : expected " + getBoolean(refByteBuffer, dataDiff.relativeMaxErrorIndex) + " but was " + getBoolean(valueByteBuffer, dataDiff.relativeMaxErrorIndex));
										if (bytes == Integer.BYTES)
											System.err.println("	Max relative error "  + key + indexes + " : expected " + refByteBuffer.getInt(dataDiff.relativeMaxErrorIndex) + " but was " + valueByteBuffer.getInt(dataDiff.relativeMaxErrorIndex));
										else if (bytes == Double.BYTES)
										{
											double relativeError = getRelativeError(valueByteBuffer.getDouble(dataDiff.relativeMaxErrorIndex), refByteBuffer.getDouble(dataDiff.relativeMaxErrorIndex));
											System.err.println("	Max relative error "  + key + indexes + " : expected " + refByteBuffer.getDouble(dataDiff.relativeMaxErrorIndex) + " but was "  + valueByteBuffer.getDouble(dataDiff.relativeMaxErrorIndex) +  " (Relative error = " + relativeError + ")");
										}
									}
								}
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

	private static Boolean isScalar(int dataSizes[])
	{
		return dataSizes.length == 0;
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

	private static double getRelativeError(double val, double ref)
	{
		double notNullRef = 1;
		if (ref != 0)
			notNullRef = ref;
		return Math.abs((val -ref) / notNullRef);
	}

	private static double getRelativeError(boolean val, boolean ref)
	{
		if (val != ref)
			return 1;
		else
			return 0;
	}

	public static boolean getBoolean(ByteBuffer bytes, int offset)
	{
		return bytes.get(offset) != 0;
	}

	private static double getRelativeError(ByteBuffer valueByteBuffer, ByteBuffer refByteBuffer, int bytes, int indx)
	{
		if (bytes == Integer.BYTES)
			return getRelativeError(valueByteBuffer.getInt(indx), refByteBuffer.getInt(indx));
		else if (bytes == Double.BYTES)
			return getRelativeError(valueByteBuffer.getDouble(indx), refByteBuffer.getDouble(indx));
		else if (bytes == 1) // booleans are same as int (0 or 1)
			return getRelativeError(getBoolean(valueByteBuffer, indx), getBoolean(refByteBuffer, indx));
		else
			return 0.;
	}

	private static DataDiff compareData(byte[] value, byte[] ref, int bytes, double tolerance)
	{
		DataDiff dataDiff = new DataDiff(0, 0, 0.0, 0);
		ByteBuffer valueByteBuffer = ByteBuffer.wrap(value);
		ByteBuffer refByteBuffer = ByteBuffer.wrap(ref);
		for (int i = 0; i <= value.length -bytes && i <= ref.length - bytes; i = i + bytes)
		{
			double relativeError = getRelativeError(valueByteBuffer, refByteBuffer, bytes, i);
			if (relativeError > 0)
			{
				dataDiff.nbDiffs ++;
				if (relativeError > tolerance)
				{
					dataDiff.nbErrors ++;
					if (relativeError > dataDiff.relativeMaxError)
					{
						dataDiff.relativeMaxErrorIndex = i;
						dataDiff.relativeMaxError = relativeError;
					}
				}
			}
		}
		return dataDiff;
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

	public static <T> byte[] toByteArray(final T val) throws IOException
	{
		ByteArrayOutputStream bos = new ByteArrayOutputStream();
		DataOutputStream dos = new DataOutputStream(bos);
		if (val instanceof Integer)
			dos.writeInt((Integer)val);
		else if (val instanceof Double)
			dos.writeDouble((Double)val);
		else if (val instanceof Boolean)
			dos.writeBoolean((Boolean)val);
		else {
			// Neither Boolean, Integer or Double
			throw new IllegalArgumentException("Only Boolean, Integer and Double supported.");
		}
		dos.flush();
		return bos.toByteArray();
	}

	public static byte[] toByteArray(boolean[] data1d) throws IOException
	{
		if (data1d == null) return null;
		int n = data1d.length;
		byte[] byts = new byte[n * 1];
		for (int i = 0; i <n; i++)
			System.arraycopy(toByteArray(data1d[i]), 0, byts, i * 1, 1);
		return byts;
	}

	public static byte[] toByteArray(int[] data1d) throws IOException
	{
		if (data1d == null) return null;
		int n = data1d.length;
		byte[] byts = new byte[n * Integer.BYTES];
		for (int i = 0; i <n; i++)
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

	public static byte[] toByteArray(final boolean[][] data2d) throws IOException
	{
		if (data2d == null) return null;
		int n = data2d.length;
		int m = data2d[0].length;
		byte[] byts = new byte[n * m * 1];
		for (int i = 0; i < n; i++)
			for (int j = 0; j < m; j++)
				System.arraycopy(toByteArray(data2d[i][j]), 0, byts, (i * m + j) * 1, 1);
		return byts;
	}

	public static byte[] toByteArray(final int[][] data2d) throws IOException
	{
		if (data2d == null) return null;
		int n = data2d.length;
		int m = data2d[0].length;
		byte[] byts = new byte[n * m * Integer.BYTES];
		for (int i = 0; i < n; i++)
			for (int j = 0; j < m; j++)
				System.arraycopy(toByteArray(data2d[i][j]), 0, byts, (i * m + j) * Integer.BYTES, Integer.BYTES);
		return byts;
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

	public static byte[] toByteArray(final Vector vector) throws IOException
	{
		return toByteArray(vector.getData().toArray());
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

	public static <T> byte[] toByteArray(final boolean[][][] data3d) throws IOException
	{
		if (data3d == null) return null;
		int dim1 = data3d.length;
		int dim2 = data3d[0].length;
		int dim3 = data3d[0][0].length;
		byte[] byts = new byte[dim1 * dim2 * dim3 * 1];
		for (int i = 0; i < dim1; i++)
			for (int j = 0; j < dim2; j++)
				for (int k = 0; k < dim3; k++)
					System.arraycopy(toByteArray(data3d[i][j][k]), 0, byts, (i * dim2 * dim3 + j * dim3 + k) * 1, 1);
		return byts;
	}

	public static <T> byte[] toByteArray(final int[][][] data3d) throws IOException
	{
		if (data3d == null) return null;
		int dim1 = data3d.length;
		int dim2 = data3d[0].length;
		int dim3 = data3d[0][0].length;
		byte[] byts = new byte[dim1 * dim2 * dim3 * Integer.BYTES];
		for (int i = 0; i < dim1; i++)
			for (int j = 0; j < dim2; j++)
				for (int k = 0; k < dim3; k++)
					System.arraycopy(toByteArray(data3d[i][j][k]), 0, byts, (i * dim2 * dim3 + j * dim3 + k) * Integer.BYTES, Integer.BYTES);
		return byts;
	}

	public static <T> byte[] toByteArray(final double[][][] data3d) throws IOException
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

	public static <T> byte[] toByteArray(final boolean[][][][] data4d) throws IOException
	{
		if (data4d == null) return null;
		int dim1 = data4d.length;
		int dim2 = data4d[0].length;
		int dim3 = data4d[0][0].length;
		int dim4 = data4d[0][0][0].length;
		byte[] byts = new byte[dim1 * dim2 * dim3 * dim4 * 1];
		for (int i = 0; i < dim1; i++)
			for (int j = 0; j < dim2; j++)
				for (int k = 0; k < dim3; k++)
					for (int l = 0; l < dim4; l++)
						System.arraycopy(toByteArray(data4d[i][j][k][l]), 0, byts, (i * dim2 * dim3 * dim4 + j * dim3 * dim4 + k * dim4 + l) * 1, 1);
		return byts;
	}

	public static <T> byte[] toByteArray(final int[][][][] data4d) throws IOException
	{
		if (data4d == null) return null;
		int dim1 = data4d.length;
		int dim2 = data4d[0].length;
		int dim3 = data4d[0][0].length;
		int dim4 = data4d[0][0][0].length;
		byte[] byts = new byte[dim1 * dim2 * dim3 * dim4 * Integer.BYTES];
		for (int i = 0; i < dim1; i++)
			for (int j = 0; j < dim2; j++)
				for (int k = 0; k < dim3; k++)
					for (int l = 0; l < dim4; l++)
						System.arraycopy(toByteArray(data4d[i][j][k][l]), 0, byts, (i * dim2 * dim3 * dim4 + j * dim3 * dim4 + k * dim4 + l) * Integer.BYTES, Integer.BYTES);
		return byts;
	}

	public static <T> byte[] toByteArray(final double[][][][] data4d) throws IOException
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
