package fr.cea.nabla.javalib

class Utils 
{
	static def indexOf(int[] array, int value) 
	{
		for (int i : 0..<array.length)
			if (array.get(i) == value)
				return i
		throw new Exception("Value '" + value.toString + "' not in array [" + array.map[toString].join(',') + ']')
	}
}