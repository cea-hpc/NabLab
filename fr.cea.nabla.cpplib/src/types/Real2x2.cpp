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
 * 	Jean-Sylvan Camier - Nabla generation support
 *******************************************************************************/
#include "types/Real2x2.h"

namespace nablalib
{
Real2x2 operator*(const Real2x2& a, const int b) { return Real2x2(a.x*b, a.y*b); }
Real2x2 operator*(const int a, const Real2x2& b) { return Real2x2(b.x*a, b.y*a); }
Real2x2 operator*(const Real2x2& a, const double b) { return Real2x2(a.x*b, a.y*b); }
Real2x2 operator*(const double a, const Real2x2& b) { return Real2x2(b.x*a, b.y*a); }
Real2x2 operator*(const Real2x2& a, const Real2x2& b) { return Real2x2(a.x*b.x, a.y*b.y); }

Real2x2 operator/(const Real2x2& a, const int b) { return Real2x2(a.x/b, a.y/b); }
Real2x2 operator/(const Real2x2& a, const double b) { return Real2x2(a.x/b, a.y/b); }

Real2x2 operator+(const Real2x2& a, const Real2x2& b) { return Real2x2(a.x+b.x, a.y+b.y); }

Real2x2 operator-(const Real2x2& a, const Real2x2& b) { return Real2x2(a.x-b.x, a.y-b.y); }
}
