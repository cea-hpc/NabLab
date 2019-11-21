/*******************************************************************************
 * Copyright (c) 2018 CEA
 * This program and the accompanying materials are made available under the
 * terms of the Eclipse Public License 2.0 which is available at
 * http://www.eclipse.org/legal/epl-2.0.
 *
 * SPDX-License-Identifier: EPL-2.0
 *
 * Contributors:
 * 	Benoit Lelandais - initial implementation
 * 	Marie-Pierre Oudot - initial implementation
 * 	Jean-Sylvain Camier - Nabla generation support
 *******************************************************************************/
#ifndef GLACE2D_GLACE2DFUNCTIONS_H_
#define GLACE2D_GLACE2DFUNCTIONS_H_

#include "types/Types.h"
#include "types/MathFunctions.h"

using namespace nablalib;

class Glace2dFunctions
{
public:
	template<size_t N>
	static double trace(const RealArray2D<N, N>& a) noexcept
	{
		double result = 0.0;
		for (int ia=0 ; ia<N ; ++ia)
			result += a[ia][ia];
		return result;
	}

	static RealArray1D<2> perp(const RealArray1D<2>& a) noexcept
	{
		RealArray1D<2> result = { a[1], -a[0] };
		return result;
	}

	template<size_t N>
	static RealArray2D<N, N> tensProduct(const RealArray1D<N>&  a, const RealArray1D<N>&  b) noexcept
	{
		RealArray2D<N, N> result;
		for (int ia=0 ; ia<N ; ++ia)
			for (int ib=0 ; ib<N ; ++ib)
				result[ia][ib] = a[ia]*b[ib];
		return result;
	}

	static RealArray2D<2, 2> inverse(const RealArray2D<2, 2>& m) noexcept
	{
		RealArray2D<2, 2> result;
		double alpha = 1.0/det(m);
		result[0][0] = m[1][1] * alpha;
		result[0][1] = -m[0][1] * alpha;
		result[1][0] = -m[1][0] * alpha;
		result[1][1] = m[0][0] * alpha;
		return result;
	}
};

#endif /* GLACE2D_GLACE2DFUNCTIONS_H_ */
