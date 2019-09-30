package fr.cea.nabla.ir.interpreter

import java.util.List

import static fr.cea.nabla.ir.interpreter.NablaValueGetter.*

class NablaValueSetter 
{
	/**
	 * let it instanceOf NViT, value instanceOf NVjT, card(indices) = k
	 * => i - k = j
	 * So, getValue(it, indices) instanceOf NVjT
	 * NB : card(indices) > 0 => j < 3
	 */
	static def setValue(NablaValue it, List<Integer> indices, NablaValue value)
	{
		val nablaValue = getValue(it, indices)
		set(nablaValue, value)
	}

	static def dispatch set(NV0Bool it, NV0Bool value) { data = value.data }
	static def dispatch set(NV0Int it, NV0Int value) { data = value.data }
	static def dispatch set(NV0Real it, NV0Real value) { data = value.data }

	static def dispatch set(NV1Bool it, NV1Bool value)
	{
		for (i : 0..<data.size) data.set(i, value.data.get(i))
	}
	static def dispatch set(NV1Int it, NV1Int value)
	{
		for (i : 0..<data.size) data.set(i, value.data.get(i))
	}
	static def dispatch set(NV1Real it, NV1Real value)
	{
		for (i : 0..<data.size) data.set(i, value.data.get(i))
	}

	static def dispatch set(NV2Bool it, NV2Bool value)
	{
		for (i : 0..<data.size)
			for (j : 0..<data.get(i).size)
				data.get(i).set(j, value.data.get(i).get(j))
	}
	static def dispatch set(NV2Int it, NV2Int value)
	{
		for (i : 0..<data.size)
			for (j : 0..<data.get(i).size)
				data.get(i).set(j, value.data.get(i).get(j))
	}
	static def dispatch set(NV2Real it, NV2Real value)
	{
		for (i : 0..<data.size)
			for (j : 0..<data.get(i).size)
				data.get(i).set(j, value.data.get(i).get(j))
	}
}
