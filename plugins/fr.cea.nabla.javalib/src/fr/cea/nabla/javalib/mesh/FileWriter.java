package fr.cea.nabla.javalib.mesh;

import java.io.File;

public abstract class FileWriter 
{
	protected String moduleName;
	protected String directoryName;
	  
	public boolean isDisabled() 
	{
	    return directoryName == null || directoryName.length() == 0;
	}
	  
	protected FileWriter(String moduleName, String directoryName) 
	{
	    this.moduleName = moduleName;
	    this.directoryName = directoryName;
	    
	    if (!isDisabled())
	    {
	      File outputDir = new File(directoryName);
	      if (!outputDir.exists())
	    	  	outputDir.mkdir();
	    }
	}
	    
	public abstract void writeFile(VtkFileContent content);
}
