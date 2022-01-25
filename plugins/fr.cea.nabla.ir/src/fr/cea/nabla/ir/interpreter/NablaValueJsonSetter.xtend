/*******************************************************************************
 * Copyright (c) 2022 CEA
 * This program and the accompanying materials are made available under the
 * terms of the Eclipse Public License 2.0 which is available at
 * http://www.eclipse.org/legal/epl-2.0.
 *
 * SPDX-License-Identifier: EPL-2.0
 * Contributors: see AUTHORS file
 *******************************************************************************/
package fr.cea.nabla.ir.interpreter

import com.google.gson.JsonArray
import com.google.gson.JsonPrimitive

class NablaValueJsonSetter
{
	static def dispatch setValue(NV0Bool it, JsonPrimitive j) { data = j.asBoolean }
	static def dispatch setValue(NV0Int it, JsonPrimitive j) { data = j.asInt }
	static def dispatch setValue(NV0Real it, JsonPrimitive j) { data = j.asDouble }

	static def dispatch setValue(NV1Bool it, JsonArray ja)
	{
		for (i : 0..<data.size)
			data.set(i, ja.get(i).asBoolean)
	}

	static def dispatch setValue(NV1Int it, JsonArray ja)
	{
		for (i : 0..<data.size)
			data.set(i, ja.get(i).asInt)
	}

	static def dispatch setValue(NV1Real it, JsonArray ja)
	{
		for (i : 0..<data.size)
			data.set(i, ja.get(i).asDouble)
	}

	static def dispatch setValue(NV2Bool it, JsonArray ja)
	{
		for (i : 0..<data.size)
		{
			val datai = data.get(i)
			val jai = ja.get(i).asJsonArray
			for (j : 0..<datai.size)
				datai.set(j, jai.get(j).asBoolean)
		}
	}

	static def dispatch setValue(NV2Int it, JsonArray ja)
	{
		for (i : 0..<data.size)
		{
			val datai = data.get(i)
			val jai = ja.get(i).asJsonArray
			for (j : 0..<datai.size)
				datai.set(j, jai.get(j).asInt)
		}
	}

	static def dispatch setValue(NV2Real it, JsonArray ja)
	{
		for (i : 0..<data.size)
		{
			val datai = data.get(i)
			val jai = ja.get(i).asJsonArray
			for (j : 0..<datai.size)
				datai.set(j, jai.get(j).asDouble)
		}
	}

	static def dispatch setValue(NV3Bool it, JsonArray ja)
	{
		for (i : 0..<data.size)
		{
			val datai = data.get(i)
			val jai = ja.get(i).asJsonArray
			for (j : 0..<datai.size)
			{
				val dataij = datai.get(j)
				val jaij = jai.get(j).asJsonArray
				for (k : 0..<dataij.size)
					dataij.set(k, jaij.get(k).asBoolean)
			}
		}
	}

	static def dispatch setValue(NV3Int it, JsonArray ja)
	{
		for (i : 0..<data.size)
		{
			val datai = data.get(i)
			val jai = ja.get(i).asJsonArray
			for (j : 0..<datai.size)
			{
				val dataij = datai.get(j)
				val jaij = jai.get(j).asJsonArray
				for (k : 0..<dataij.size)
					dataij.set(k, jaij.get(k).asInt)
			}
		}
	}

	static def dispatch setValue(NV3Real it, JsonArray ja)
	{
		for (i : 0..<data.size)
		{
			val datai = data.get(i)
			val jai = ja.get(i).asJsonArray
			for (j : 0..<datai.size)
			{
				val dataij = datai.get(j)
				val jaij = jai.get(j).asJsonArray
				for (k : 0..<dataij.size)
					dataij.set(k, jaij.get(k).asDouble)
			}
		}
	}

	static def dispatch setValue(NV4Bool it, JsonArray ja)
	{
		for (i : 0..<data.size)
		{
			val datai = data.get(i)
			val jai = ja.get(i).asJsonArray
			for (j : 0..<datai.size)
			{
				val dataij = datai.get(j)
				val jaij = jai.get(j).asJsonArray
				for (k : 0..<dataij.size)
				{
					val dataijk = dataij.get(k)
					val jaijk = jaij.get(k).asJsonArray
					for (l : 0..<dataijk.size)
						dataijk.set(l, jaijk.get(l).asBoolean)
				}
			}
		}
	}

	static def dispatch setValue(NV4Int it, JsonArray ja)
	{
		for (i : 0..<data.size)
		{
			val datai = data.get(i)
			val jai = ja.get(i).asJsonArray
			for (j : 0..<datai.size)
			{
				val dataij = datai.get(j)
				val jaij = jai.get(j).asJsonArray
				for (k : 0..<dataij.size)
				{
					val dataijk = dataij.get(k)
					val jaijk = jaij.get(k).asJsonArray
					for (l : 0..<dataijk.size)
						dataijk.set(l, jaijk.get(l).asInt)
				}
			}
		}
	}

	static def dispatch setValue(NV4Real it, JsonArray ja)
	{
		for (i : 0..<data.size)
		{
			val datai = data.get(i)
			val jai = ja.get(i).asJsonArray
			for (j : 0..<datai.size)
			{
				val dataij = datai.get(j)
				val jaij = jai.get(j).asJsonArray
				for (k : 0..<dataij.size)
				{
					val dataijk = dataij.get(k)
					val jaijk = jaij.get(k).asJsonArray
					for (l : 0..<dataijk.size)
						dataijk.set(l, jaijk.get(l).asDouble)
				}
			}
		}
	}
}
