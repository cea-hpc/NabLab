package fr.cea.nabla.ir.interpreter

import java.util.List

class NablaValueSetter 
{
//	static def dispatch setValue(NablaValue it, List<Integer> indices, NablaValue value)
//	{
//		switch indices.size
//		{
//			case 0 : 
//			default : throw new RuntimeException("Wrong access")	
//		}	
//	}
//
//	static def dispatch setValue(NV0Bool it, List<Integer> indices, NV0Bool value)
//	{
//		switch indices.size
//		{
//			case 0 : data = value.data
//			default : throw new RuntimeException("Wrong access")
//		}	
//	}
//	
//	static def dispatch setValue(NV1Bool it, List<Integer> indices, NV0Bool value)
//	{
//		switch indices.size
//		{
//			case 1 : data.set(indices.get(0), value.data)
//			default : throw new RuntimeException("Wrong access")	
//		}	
//	}
//
//	static def dispatch setValue(NV1Bool it, List<Integer> indices, NV1Bool value)
//	{
//		switch indices.size
//		{
//			case 1 : data.set(indices.get(0), value.data)
//			default : throw new RuntimeException("Wrong access")	
//		}	
//	}
//
//	static def dispatch setValue(NV2Bool it, List<Integer> indices, NablaValue value)
//	{
//		switch indices.size
//		{
//			case 1 : new NV1Bool(data.get(indices.get(0)))
//			case 2 : new NV0Bool(data.get(indices.get(0)).get(indices.get(1)))
//			default : throw new RuntimeException("Wrong access")	
//		}	
//	}
//
//	static def dispatch setValue(NV3Bool it, List<Integer> indices, NablaValue value)
//	{
//		switch indices.size
//		{
//			case 1 : new NV2Bool(data.get(indices.get(0)))
//			case 2 : new NV1Bool(data.get(indices.get(0)).get(indices.get(1)))
//			case 3 : new NV0Bool(data.get(indices.get(0)).get(indices.get(1)).get(indices.get(2)))
//			default : throw new RuntimeException("Wrong access")	
//		}	
//	}
//
//	static def dispatch setValue(NV1Int it, List<Integer> indices, NablaValue value)
//	{
//		switch indices.size
//		{
//			case 1 : new NV0Int(data.get(indices.get(0)))
//			default : throw new RuntimeException("Wrong access")	
//		}	
//	}
//
//	static def dispatch setValue(NV2Int it, List<Integer> indices, NablaValue value)
//	{
//		switch indices.size
//		{
//			case 1 : new NV1Int(data.get(indices.get(0)))
//			case 2 : new NV0Int(data.get(indices.get(0)).get(indices.get(1)))
//			default : throw new RuntimeException("Wrong access")	
//		}	
//	}
//
//	static def dispatch setValue(NV3Int it, List<Integer> indices, NablaValue value)
//	{
//		switch indices.size
//		{
//			case 1 : new NV2Int(data.get(indices.get(0)))
//			case 2 : new NV1Int(data.get(indices.get(0)).get(indices.get(1)))
//			case 3 : new NV0Int(data.get(indices.get(0)).get(indices.get(1)).get(indices.get(2)))
//			default : throw new RuntimeException("Wrong access")	
//		}	
//	}
//
//	static def dispatch setValue(NV1Real it, List<Integer> indices, NablaValue value)
//	{
//		switch indices.size
//		{
//			case 1 : new NV0Real(data.get(indices.get(0)))
//			default : throw new RuntimeException("Wrong access")	
//		}	
//	}
//
//	static def dispatch setValue(NV2Real it, List<Integer> indices, NablaValue value)
//	{
//		switch indices.size
//		{
//			case 1 : new NV1Real(data.get(indices.get(0)))
//			case 2 : new NV0Real(data.get(indices.get(0)).get(indices.get(1)))
//			default : throw new RuntimeException("Wrong access")	
//		}	
//	}
//
//	static def dispatch setValue(NV3Real it, List<Integer> indices, NablaValue value)
//	{
//		switch indices.size
//		{
//			case 1 : new NV2Real(data.get(indices.get(0)))
//			case 2 : new NV1Real(data.get(indices.get(0)).get(indices.get(1)))
//			case 3 : new NV0Real(data.get(indices.get(0)).get(indices.get(1)).get(indices.get(2)))
//			default : throw new RuntimeException("Wrong access")	
//		}	
//	}
}