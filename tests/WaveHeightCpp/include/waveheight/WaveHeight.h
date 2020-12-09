/*******************************************************************************
 * Copyright (c) 2020 CEA
 * This program and the accompanying materials are made available under the
 * terms of the Eclipse Public License 2.0 which is available at
 * http://www.eclipse.org/legal/epl-2.0.
 *
 * SPDX-License-Identifier: EPL-2.0
 * Contributors: see AUTHORS file
 *******************************************************************************/
#ifndef __WAVEHEIGHT_WAVEHEIGHT
#define __WAVEHEIGHT_WAVEHEIGHT

#include <iostream>
#include <string>

namespace waveheight
{
	class WaveHeight
	{
	public:
		void jsonInit(const char* jsonContent);
		double nextWaveHeight();

	private:
		int counter = 0;
		double depth = 4.3;
		std::string fileName = "";
	};
}

#endif
