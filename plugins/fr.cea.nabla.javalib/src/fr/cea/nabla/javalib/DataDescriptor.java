package fr.cea.nabla.javalib;

import java.io.Serializable;

public class DataDescriptor  implements Serializable
{
	private static final long serialVersionUID = 1L;
	public int dataTypeBytes;
	public int[] dataSizes;

	DataDescriptor(int dataTypeBytes, int[] dataSizes)
	{
		this.dataTypeBytes = dataTypeBytes;
		this.dataSizes = dataSizes;
	}
};