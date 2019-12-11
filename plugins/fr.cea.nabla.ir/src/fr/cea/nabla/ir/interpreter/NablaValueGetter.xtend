package fr.cea.nabla.ir.interpreter

import java.util.List

class NablaValueGetter 
{
	//To handle NV0*
	static def dispatch getValue(NablaValue it, List<Integer> indices)
	{
		switch indices.size
		{
			case 0 : it
			default : throw new RuntimeException("Wrong access")
		}
	}

	static def dispatch getValue(NV1Bool it, List<Integer> indices)
	{
		switch indices.size
		{
			case 0 : it
			case 1 : new NV0Bool(data.get(indices.get(0)))
			default : throw new RuntimeException("Wrong access")
		}
	}

	static def dispatch getValue(NV2Bool it, List<Integer> indices)
	{
		switch indices.size
		{
			case 0 : it
			case 1 : new NV1Bool(data.get(indices.get(0)))
			case 2 : new NV0Bool(data.get(indices.get(0)).get(indices.get(1)))
			default : throw new RuntimeException("Wrong access")
		}
	}

	static def dispatch getValue(NV3Bool it, List<Integer> indices)
	{
		switch indices.size
		{
			case 0 : it
			case 1 : new NV2Bool(data.get(indices.get(0)))
			case 2 : new NV1Bool(data.get(indices.get(0)).get(indices.get(1)))
			case 3 : new NV0Bool(data.get(indices.get(0)).get(indices.get(1)).get(indices.get(2)))
			default : throw new RuntimeException("Wrong access")
		}
	}

	static def dispatch getValue(NV4Bool it, List<Integer> indices)
	{
		switch indices.size
		{
			case 0 : it
			case 1 : new NV3Bool(data.get(indices.get(0)))
			case 2 : new NV2Bool(data.get(indices.get(0)).get(indices.get(1)))
			case 3 : new NV1Bool(data.get(indices.get(0)).get(indices.get(1)).get(indices.get(2)))
			case 4 : new NV0Bool(data.get(indices.get(0)).get(indices.get(1)).get(indices.get(2)).get(indices.get(3)))
			default : throw new RuntimeException("Wrong access")
		}
	}

	static def dispatch getValue(NV1Int it, List<Integer> indices)
	{
		switch indices.size
		{
			case 0 : it
			case 1 : new NV0Int(data.get(indices.get(0)))
			default : throw new RuntimeException("Wrong access")
		}	
	}

	static def dispatch getValue(NV2Int it, List<Integer> indices)
	{
		switch indices.size
		{
			case 0 : it
			case 1 : new NV1Int(data.get(indices.get(0)))
			case 2 : new NV0Int(data.get(indices.get(0)).get(indices.get(1)))
			default : throw new RuntimeException("Wrong access")
		}
	}

	static def dispatch getValue(NV3Int it, List<Integer> indices)
	{
		switch indices.size
		{
			case 0 : it
			case 1 : new NV2Int(data.get(indices.get(0)))
			case 2 : new NV1Int(data.get(indices.get(0)).get(indices.get(1)))
			case 3 : new NV0Int(data.get(indices.get(0)).get(indices.get(1)).get(indices.get(2)))
			default : throw new RuntimeException("Wrong access")
		}
	}

	static def dispatch getValue(NV4Int it, List<Integer> indices)
	{
		switch indices.size
		{
			case 0 : it
			case 1 : new NV3Int(data.get(indices.get(0)))
			case 2 : new NV2Int(data.get(indices.get(0)).get(indices.get(1)))
			case 3 : new NV1Int(data.get(indices.get(0)).get(indices.get(1)).get(indices.get(2)))
			case 4 : new NV0Int(data.get(indices.get(0)).get(indices.get(1)).get(indices.get(2)).get(indices.get(3)))
			default : throw new RuntimeException("Wrong access")
		}
	}

	static def dispatch getValue(NV1Real it, List<Integer> indices)
	{
		switch indices.size
		{
			case 0 : it
			case 1 : new NV0Real(data.get(indices.get(0)))
			default : throw new RuntimeException("Wrong access")
		}
	}

	static def dispatch getValue(NV2Real it, List<Integer> indices)
	{
		switch indices.size
		{
			case 0 : it
			case 1 : new NV1Real(data.get(indices.get(0)))
			case 2 : new NV0Real(data.get(indices.get(0)).get(indices.get(1)))
			default : throw new RuntimeException("Wrong access")
		}
	}

	static def dispatch getValue(NV3Real it, List<Integer> indices)
	{
		switch indices.size
		{
			case 0 : it
			case 1 : new NV2Real(data.get(indices.get(0)))
			case 2 : new NV1Real(data.get(indices.get(0)).get(indices.get(1)))
			case 3 : new NV0Real(data.get(indices.get(0)).get(indices.get(1)).get(indices.get(2)))
			default : throw new RuntimeException("Wrong access")
		}
	}

	static def dispatch getValue(NV4Real it, List<Integer> indices)
	{
		switch indices.size
		{
			case 0 : it
			case 1 : new NV3Real(data.get(indices.get(0)))
			case 2 : new NV2Real(data.get(indices.get(0)).get(indices.get(1)))
			case 3 : new NV1Real(data.get(indices.get(0)).get(indices.get(1)).get(indices.get(2)))
			case 4 : new NV0Real(data.get(indices.get(0)).get(indices.get(1)).get(indices.get(2)).get(indices.get(3)))
			default : throw new RuntimeException("Wrong access")
		}
	}
}