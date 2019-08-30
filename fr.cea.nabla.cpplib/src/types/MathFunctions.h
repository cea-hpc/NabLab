/*******************************************************************************
 * Copyright (c) 2018 CEA
 * This program and the accompanying materials are made available under the
 * terms of the Eclipse Public License 2.0 which is available at
 * http://www.eclipse.org/legal/epl-2.0.
 *
 * SPDX-License-Identifier: EPL-2.0
 * Contributors: see AUTHORS file
 *******************************************************************************/
#ifndef TYPES_MATHFUNCTIONS_H_
#define TYPES_MATHFUNCTIONS_H_

#include "types/Types.h"

namespace nablalib
{

namespace MathFunctions
{
	double fabs(const double& v) noexcept { return std::fabs(v); }
	double sqrt(const double& v) noexcept { return std::sqrt(v); }
	double min(const double& a, const double& b) noexcept { return std::min(a, b); }
	double max(const double& a, const double& b) noexcept { return std::max(a, b); }
	double sin(const double& v) noexcept { return std::sin(v); }
	double cos(const double& v) noexcept { return std::cos(v); }
	double asin(const double& v) noexcept { return std::asin(v); }
	double acos(const double& v) noexcept { return std::acos(v); }

	template<size_t N>
	double dot(const RealArray1D<N>& a, const RealArray1D<N>& b) noexcept
	{
		double result = 0.0;
		for (int i=0 ; i<N ; ++i)
			result += a[i]*b[i];
		return result;
	}

	double det(const Real2& a, const Real2& b) noexcept
	{
		return a[0]*b[1] - a[1]*b[0];
	}

	template<size_t N>
	double norm(const RealArray1D<N>& a) noexcept
	{
		return sqrt(dot(a,a));
	}
}
}

#endif /* TYPES_MATHFUNCTIONS_H_ */
