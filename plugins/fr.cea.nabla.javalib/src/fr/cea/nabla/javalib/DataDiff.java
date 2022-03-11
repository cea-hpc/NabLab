package fr.cea.nabla.javalib;

public class DataDiff
{
	public int nbDiffs;
	public int nbErrors;
	public double relativeMaxError;
	public int relativeMaxErrorIndex;

	DataDiff(int nbDiffs, int nbErrors, double relativeMaxError, int relativeMaxErrorIndex)
	{
		this.nbDiffs = nbDiffs;
		this.nbErrors = nbErrors;
		this.relativeMaxError = relativeMaxError;
		this.relativeMaxErrorIndex = relativeMaxErrorIndex;	
	}
}
