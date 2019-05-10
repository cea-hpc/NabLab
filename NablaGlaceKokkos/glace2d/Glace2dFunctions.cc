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
#include "glace2d/Glace2dFunctions.h"
#include "types/MathFunctions.h"

using namespace nablalib;

Real2x2
Glace2dFunctions::tensProduct(const Real2& a, const Real2& b) noexcept
{
	return Real2x2(b*a.x, b*a.y);
}

Real2
Glace2dFunctions::matVectProduct(const Real2x2& a, const Real2& b) noexcept
{
	return Real2(MathFunctions::dot(a.x, b), MathFunctions::dot(a.y, b));
}

double
Glace2dFunctions::det(const Real2x2& a) noexcept
{
	return a.x.x * a.y.y - a.x.y * a.y.x;
}

double
Glace2dFunctions::trace(const Real2x2& a) noexcept
{
	return a.x.x + a.y.y;
}

Real2x2
Glace2dFunctions::inverse(const Real2x2& m) noexcept
{
	Real2x2 r(Real2(m.y.y, -m.x.y), Real2(-m.y.x, m.x.x));
	return r * (1.0 / det(m));
}

Real2
Glace2dFunctions::perp(const Real2& a) noexcept
{
	return Real2(a.y, -a.x);
}

