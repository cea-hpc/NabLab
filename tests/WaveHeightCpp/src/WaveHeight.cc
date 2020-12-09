/*******************************************************************************
 * Copyright (c) 2020 CEA
 * This program and the accompanying materials are made available under the
 * terms of the Eclipse Public License 2.0 which is available at
 * http://www.eclipse.org/legal/epl-2.0.
 *
 * SPDX-License-Identifier: EPL-2.0
 * Contributors: see AUTHORS file
 *******************************************************************************/
#include "waveheight/WaveHeight.h"
#include <string>
#include <rapidjson/document.h>
#include <rapidjson/istreamwrapper.h>
#include <rapidjson/stringbuffer.h>
#include <rapidjson/writer.h>

namespace  waveheight
{

void WaveHeight::jsonInit(const char* jsonContent)
{
	rapidjson::Document document;
	assert(!document.Parse(jsonContent).HasParseError());
	assert(document.IsObject());
	const rapidjson::Value::Object& o = document.GetObject();

	if (o.HasMember("depth"))
	{
		const rapidjson::Value& valueof_depth = o["depth"];
		assert(valueof_depth.IsDouble());
		depth = valueof_depth.GetDouble();
	}

	// if the option is mandatory, the line should be:
	// assert(o.HasMember("fileName"));
	if (o.HasMember("fileName"))
	{
		const rapidjson::Value& valueof_fileName = o["fileName"];
		assert(valueof_fileName.IsString());
		fileName = valueof_fileName.GetString();
	}
}

double WaveHeight::nextWaveHeight()
{
	counter++;
	std::cout << counter << " C++ " << fileName << ". Depth = " << depth << std::endl;
	return depth;
}

}
