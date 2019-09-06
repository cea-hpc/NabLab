package fr.cea.nabla.ir.interpreter

class Utils 
{
	static def int getTotalSize(int[] sizes)
	{
		if (sizes.empty) 0
		else sizes.head * sizes.tail.totalSize
	}
}