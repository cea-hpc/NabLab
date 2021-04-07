/*******************************************************************************
 * Copyright (c) 2020 CEA
 * This program and the accompanying materials are made available under the
 * terms of the Eclipse Public License 2.0 which is available at
 * http://www.eclipse.org/legal/epl-2.0.
 *
 * SPDX-License-Identifier: EPL-2.0
 * Contributors: see AUTHORS file
 *******************************************************************************/
#ifndef __BATHYLIB_H_
#define __BATHYLIB_H_

#include "IBathyLib.h"

class BathyLib : public IBathyLib
{
public:
	void jsonInit(const char* jsonContent) override;

	double nextWaveHeight() override;

	template<size_t x>
	double nextDepth1(double x0, RealArray1D<x> x1)
	{
		std::cout << "C++ BatiLib::nextDepth1" << std:: endl;
		double sum = x0;
		for (size_t i=0 ; i<x1.size() ; ++i)
			sum += x1[i];
		return sum;
	}

	template<size_t x, size_t y>
	double nextDepth2(double x0, RealArray2D<x,y> x1)
	{
		std::cout << "C++ BatiLib::nextDepth2" << std:: endl;
		double sum = x0;
		for (size_t i=0 ; i<x1.size() ; ++i)
			for (size_t j=0 ; j<x1[i].size() ; ++j)
				sum += x1[i][j];
		return sum;
	}

	template<size_t x>
	RealArray1D<x> nextDepth3(RealArray1D<x> x0)
	{
		std::cout << "C++ BatiLib::nextDepth3" << std:: endl;
		RealArray1D<x> ret;
		ret.initSize(x0.size());
		for (size_t i=0 ; i<x0.size() ; ++i)
			ret[i] = 2*x0[i];
		return ret;
	}

	template<size_t x, size_t y>
	RealArray2D<x,y> nextDepth4(RealArray2D<x,y> x0)
	{
		std::cout << "C++ BatiLib::nextDepth4" << std:: endl;
		RealArray2D<x,y> ret;
		ret.initSize(x0.size(), x0[0].size());
		for (size_t i=0 ; i<x0.size() ; ++i)
			for (size_t j=0 ; j<x0[i].size() ; ++j)
				ret[i][j] = 2*x0[i][j];
		return ret;
	}

private:
	double depth = 4.3;
	std::string fileName = "";
};

#endif
