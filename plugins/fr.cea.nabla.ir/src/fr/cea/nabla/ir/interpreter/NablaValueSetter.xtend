/*******************************************************************************
 * Copyright (c) 2020 CEA
 * This program and the accompanying materials are made available under the 
 * terms of the Eclipse Public License 2.0 which is available at
 * http://www.eclipse.org/legal/epl-2.0.
 *
 * SPDX-License-Identifier: EPL-2.0
 * Contributors: see AUTHORS file
 *******************************************************************************/
package fr.cea.nabla.ir.interpreter

import java.util.List

class NablaValueSetter
{
	/**
	 * let it instanceOf NViT, value instanceOf NVjT, card(indices) = k
	 * => i - k = j
	 */
	static def setValue(NablaValue it, List<Integer> indices, NablaValue value)
	{
		switch indices.size
		{
			case 0 : set(value)
			case 1 : subSet(indices.get(0), value)
			case 2 : subSet(indices.get(0), indices.get(1), value)
			case 3 : subSet(indices.get(0), indices.get(1), indices.get(2), value)
			case 4 : subSet(indices.get(0), indices.get(1), indices.get(2), indices.get(3), value)
		}
	}

	private static def dispatch set(NV0Bool it, NV0Bool value) { data = value.data }
	private static def dispatch set(NV0Int it, NV0Int value) { data = value.data }
	private static def dispatch set(NV0Real it, NV0Real value) { data = value.data }

	private static def dispatch set(NV1Bool it, NV1Bool value)
	{
		for (i : 0..<data.size)
			data.set(i, value.data.get(i))
	}

	private static def dispatch set(NV1Int it, NV1Int value)
	{
		for (i : 0..<data.size)
			data.set(i, value.data.get(i))
	}

	private static def dispatch set(NV1Real it, NV1Real value)
	{
		for (i : 0..<data.size)
			data.set(i, value.data.get(i))
	}

	private static def dispatch set(NVVector it, NVVector value)
	{
		data = value.data
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

	private static def dispatch set(NV3Bool it, NV3Bool value)
	{
		for (i : 0..<data.size)
			for (j : 0..<data.get(i).size)
				for (k : 0..<data.get(i).get(j).size)
					data.get(i).get(j).set(k, value.data.get(i).get(j).get(k))
	}

	private static def dispatch set(NV3Int it, NV3Int value)
	{
		for (i : 0..<data.size)
			for (j : 0..<data.get(i).size)
				for (k : 0..<data.get(i).get(j).size)
					data.get(i).get(j).set(k, value.data.get(i).get(j).get(k))
	}

	private static def dispatch set(NV3Real it, NV3Real value)
	{
		for (i : 0..<data.size)
			for (j : 0..<data.get(i).size)
				for (k : 0..<data.get(i).get(j).size)
					data.get(i).get(j).set(k, value.data.get(i).get(j).get(k))
	}

	private static def dispatch set(NV4Bool it, NV4Bool value)
	{
		for (i : 0..<data.size)
			for (j : 0..<data.get(i).size)
				for (k : 0..<data.get(i).get(j).size)
					for (l : 0..<data.get(i).get(j).get(k).size)
						data.get(i).get(j).get(k).set(l, value.data.get(i).get(j).get(k).get(l))
	}

	private static def dispatch set(NV4Int it, NV4Int value)
	{
		for (i : 0..<data.size)
			for (j : 0..<data.get(i).size)
				for (k : 0..<data.get(i).get(j).size)
					for (l : 0..<data.get(i).get(j).get(k).size)
						data.get(i).get(j).get(k).set(l, value.data.get(i).get(j).get(k).get(l))
	}

	private static def dispatch set(NV4Real it, NV4Real value)
	{
		for (i : 0..<data.size)
			for (j : 0..<data.get(i).size)
				for (k : 0..<data.get(i).get(j).size)
					for (l : 0..<data.get(i).get(j).get(k).size)
						data.get(i).get(j).get(k).set(l, value.data.get(i).get(j).get(k).get(l))
	}

	private static def dispatch subSet(NV1Bool it, int indice, NV0Bool value) { data.set(indice, value.data) }
	private static def dispatch subSet(NV1Int it, int indice, NV0Int value) { data.set(indice, value.data) }
	private static def dispatch subSet(NV1Real it, int indice, NV0Real value) { data.set(indice, value.data) }
	private static def dispatch subSet(NVVector it, int indice, NV0Real value) { linearAlgebra.setValue(data, indice, value.data) }

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

	private static def dispatch subSet(NV3Bool it, int indice, NV2Bool value)
	{
		for (j : 0..<data.get(indice).size)
			for (k : 0..<data.get(indice).get(j).size)
				data.get(indice).get(j).set(k, value.data.get(j).get(k))
	}

	private static def dispatch subSet(NV3Int it, int indice, NV2Int value)
	{
		for (j : 0..<data.get(indice).size)
			for (k : 0..<data.get(indice).get(j).size)
				data.get(indice).get(j).set(k, value.data.get(j).get(k))
	}

	private static def dispatch subSet(NV3Real it, int indice, NV2Real value)
	{
		for (j : 0..<data.get(indice).size)
			for (k : 0..<data.get(indice).get(j).size)
				data.get(indice).get(j).set(k, value.data.get(j).get(k))
	}

	private static def dispatch subSet(NV4Bool it, int indice, NV3Bool value)
	{
		for (j : 0..<data.get(indice).size)
			for (k : 0..<data.get(indice).get(j).size)
				for (l : 0..<data.get(indice).get(j).get(k).size)
					data.get(indice).get(j).get(k).set(l, value.data.get(j).get(k).get(l))
	}

	private static def dispatch subSet(NV4Int it, int indice, NV3Int value)
	{
		for (j : 0..<data.get(indice).size)
			for (k : 0..<data.get(indice).get(j).size)
				for (l : 0..<data.get(indice).get(j).get(k).size)
					data.get(indice).get(j).get(k).set(l, value.data.get(j).get(k).get(l))
	}

	private static def dispatch subSet(NV4Real it, int indice, NV3Real value)
	{
		for (j : 0..<data.get(indice).size)
			for (k : 0..<data.get(indice).get(j).size)
				for (l : 0..<data.get(indice).get(j).get(k).size)
					data.get(indice).get(j).get(k).set(l, value.data.get(j).get(k).get(l))
	}

	private static def dispatch subSet(NV2Bool it, int i, int j, NV0Bool value) { data.get(i).set(j, value.data) }
	private static def dispatch subSet(NV2Int it, int i, int j, NV0Int value) { data.get(i).set(j, value.data) }
	private static def dispatch subSet(NV2Real it, int i, int j, NV0Real value) { data.get(i).set(j, value.data) }
	private static def dispatch subSet(NVMatrix it, int i, int j, NV0Real value) { linearAlgebra.setValue(data, i, j, value.data) }

	private static def dispatch subSet(NV3Bool it, int i, int j, NV1Bool value)
	{
		for (k : 0..<data.get(i).get(j).size)
			data.get(i).get(j).set(k, value.data.get(k))
	}

	private static def dispatch subSet(NV3Int it, int i, int j, NV1Int value)
	{
		for (k : 0..<data.get(i).get(j).size)
			data.get(i).get(j).set(k, value.data.get(k))
	}

	private static def dispatch subSet(NV3Real it, int i, int j, NV1Real value)
	{
		for (k : 0..<data.get(i).get(j).size)
			data.get(i).get(j).set(k, value.data.get(k))
	}

	private static def dispatch subSet(NV4Bool it, int i, int j, NV2Bool value)
	{
		for (k : 0..<data.get(i).get(j).size)
			for (l : 0..<data.get(i).get(j).get(k).size)
				data.get(i).get(j).get(k).set(l, value.data.get(k).get(l))
	}

	private static def dispatch subSet(NV4Int it, int i, int j, NV2Int value)
	{
		for (k : 0..<data.get(i).get(j).size)
			for (l : 0..<data.get(i).get(j).get(k).size)
				data.get(i).get(j).get(k).set(l, value.data.get(k).get(l))
	}

	private static def dispatch subSet(NV4Real it, int i, int j, NV2Real value)
	{
		for (k : 0..<data.get(i).get(j).size)
			for (l : 0..<data.get(i).get(j).get(k).size)
				data.get(i).get(j).get(k).set(l, value.data.get(k).get(l))
	}

	private static def dispatch subSet(NV3Bool it, int i, int j, int k, NV0Bool value) { data.get(i).get(j).set(k, value.data) }
	private static def dispatch subSet(NV3Int it, int i, int j, int k, NV0Int value) { data.get(i).get(j).set(k, value.data) }
	private static def dispatch subSet(NV3Real it, int i, int j, int k, NV0Real value) { data.get(i).get(j).set(k, value.data) }

	private static def dispatch subSet(NV4Bool it, int i, int j, int k, NV1Bool value)
	{
		for (l : 0..data.get(i).get(j).get(k).size)
			data.get(i).get(j).get(k).set(l, value.data.get(l))
	}

	private static def dispatch subSet(NV4Int it, int i, int j, int k, NV1Int value)
	{
		for (l : 0..data.get(i).get(j).get(k).size)
			data.get(i).get(j).get(k).set(l, value.data.get(l))
	}

	private static def dispatch subSet(NV4Real it, int i, int j, int k, NV1Real value)
	{
		for (l : 0..data.get(i).get(j).get(k).size)
			data.get(i).get(j).get(k).set(l, value.data.get(l))
	}

	private static def dispatch subSet(NV4Bool it, int i, int j, int k, int l, NV0Bool value) { data.get(i).get(j).get(k).set(l, value.data) }
	private static def dispatch subSet(NV4Int it, int i, int j, int k, int l, NV0Int value) { data.get(i).get(j).get(k).set(l, value.data) }
	private static def dispatch subSet(NV4Real it, int i, int j, int k, int l, NV0Real value) { data.get(i).get(j).get(k).set(l, value.data) }
}