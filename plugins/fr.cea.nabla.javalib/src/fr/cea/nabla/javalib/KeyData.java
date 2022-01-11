package fr.cea.nabla.javalib;

import java.io.Serializable;

public class KeyData  implements Serializable
{
	private static final long serialVersionUID = 1L;
	public String dataName; 
    public int dataBytes;
    
    KeyData(String dataName, int dataBytes)
    {
    	this.dataName = dataName;
    	this.dataBytes = dataBytes;
    }
};