/*******************************************************************************
 * Copyright (c) 2020 CEA
 * This program and the accompanying materials are made available under the
 * terms of the Eclipse Public License 2.0 which is available at
 * http://www.eclipse.org/legal/epl-2.0.
 *
 * SPDX-License-Identifier: EPL-2.0
 * Contributors: see AUTHORS file
 *******************************************************************************/
package waveheight;

import com.google.gson.JsonElement;
import com.google.gson.JsonObject;
import com.google.gson.JsonParser;

public class WaveHeight
{
	private int counter = 0;
	private double depth = 4.3;
	private String fileName = "";

	public void jsonInit(final String jsonContent)
	{
		final JsonParser parser = new JsonParser();
		final JsonElement json = parser.parse(jsonContent);
		assert(json.isJsonObject());
		final JsonObject o = json.getAsJsonObject();

		if (o.has("depth"))
		{
			final JsonElement valueof_depth = o.get("depth");
			assert(valueof_depth.isJsonPrimitive());
			depth = valueof_depth.getAsJsonPrimitive().getAsDouble();
		}

		if (o.has("fileName"))
		{
			final JsonElement valueof_fileName = o.get("fileName");
			assert(valueof_fileName.isJsonPrimitive());
			fileName = valueof_fileName.getAsJsonPrimitive().getAsString();
		}
	}

	public double nextWaveHeight()
	{
		counter++;
		System.out.println(counter + " Java " + fileName + ". Depth = " + depth);
		return depth;
	}
}
