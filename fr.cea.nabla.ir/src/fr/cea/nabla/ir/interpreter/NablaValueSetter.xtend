package fr.cea.nabla.ir.interpreter

import java.util.List

class NablaValueSetter 
{
	/**
	 * let it instanceOf NViT, value instanceOf NVjT, card(indices) = k
	 * => i - k = j
	 * NB : card(indices) > 0 => j < 3
	 */
	static def setValue(NablaValue it, List<Integer> indices, NablaValue value)
	{
		switch indices.size
		{
			case 0 : set(value)
			case 1 : subSet(indices.get(0), value)
			case 2 : subSet(indices.get(0), indices.get(1), value)
		}
	}

	private static def dispatch set(NV0Bool it, NV0Bool value) { data = value.data }
	private static def dispatch set(NV0Int it, NV0Int value) { data = value.data }
	private static def dispatch set(NV0Real it, NV0Real value) { data = value.data }

	private static def dispatch set(NV1Bool it, NV1Bool value)
	{
		for (i : 0..<data.size) data.set(i, value.data.get(i))
	}
	private static def dispatch set(NV1Int it, NV1Int value)
	{
		for (i : 0..<data.size) data.set(i, value.data.get(i))
	}
	private static def dispatch set(NV1Real it, NV1Real value)
	{
		for (i : 0..<data.size) data.set(i, value.data.get(i))
	}

	private static def dispatch set(NV2Bool it, NV2Bool value)
	{
		for (i : 0..<data.size)
			for (j : 0..<data.get(i).size)
				data.get(i).set(j, value.data.get(i).get(j))
	}
	private static def dispatch set(NV2Int it, NV2Int value)
	{
		for (i : 0..<data.size)
			for (j : 0..<data.get(i).size)
				data.get(i).set(j, value.data.get(i).get(j))
	}
	private static def dispatch set(NV2Real it, NV2Real value)
	{
		for (i : 0..<data.size)
			for (j : 0..<data.get(i).size)
				data.get(i).set(j, value.data.get(i).get(j))
	}

	private static def dispatch subSet(NV1Bool it, int indice, NV0Bool value) { data.set(indice, value.data) }
	private static def dispatch subSet(NV1Int it, int indice, NV0Int value) { data.set(indice, value.data) }
	private static def dispatch subSet(NV1Real it, int indice, NV0Real value)  { data.set(indice, value.data) }

	private static def dispatch subSet(NV2Bool it, int indice, NV1Bool value)
	{
		for (j : 0..<data.get(indice).size)
			data.get(indice).set(j, value.data.get(j))
	}

	private static def dispatch subSet(NV2Int it, int indice, NV1Int value)
	{
		for (j : 0..<data.get(indice).size)
			data.get(indice).set(j, value.data.get(j))
	}

	private static def dispatch subSet(NV2Real it, int indice, NV1Real value)
	{
		for (j : 0..<data.get(indice).size)
			data.get(indice).set(j, value.data.get(j))
	}

	private static def dispatch subSet(NV2Bool it, int i, int j, NV0Bool value) { data.get(i).set(j, value.data) }
	private static def dispatch subSet(NV2Int it, int i, int j, NV0Int value) { data.get(i).set(j, value.data) }
	private static def dispatch subSet(NV2Real it, int i, int j, NV0Real value) { data.get(i).set(j, value.data) }
}