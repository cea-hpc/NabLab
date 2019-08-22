/*******************************************************************************
 * Copyright (c) 2018 CEA
 * This program and the accompanying materials are made available under the 
 * terms of the Eclipse Public License 2.0 which is available at
 * http://www.eclipse.org/legal/epl-2.0.
 *
 * SPDX-License-Identifier: EPL-2.0
 * Contributors: see AUTHORS file
 *******************************************************************************/
#include "types/Real3.h"

namespace nablalib
{
Real3 operator*(const Real3& a, const int b) { return Real3(a.x*b, a.y*b, a.z*b); }
Real3 operator*(const int a, const Real3& b) { return Real3(b.x*a, b.y*a, b.z*a); }
Real3 operator*(const Real3& a, const double b) { return Real3(a.x*b, a.y*b, a.z*b); }
Real3 operator*(const double a, const Real3& b) { return Real3(b.x*a, b.y*a, b.z*a); }
Real3 operator*(const Real3& a, const Real3& b) { return Real3(a.x*b.x, a.y*b.y, a.z*b.z); }

Real3 operator+(const Real3& a, const int b) { return Real3(a.x+b, a.y+b, a.z+b); }
Real3 operator+(const int a, const Real3& b) { return Real3(b.x+a, b.y+a, b.z+a); }
Real3 operator+(const Real3& a, const double b) { return Real3(a.x+b, a.y+b, a.z+b); }
Real3 operator+(const double a, const Real3& b) { return Real3(b.x+a, b.y+a, b.z+a); }
Real3 operator+(const Real3& a, const Real3& b) { return Real3(a.x+b.x, a.y+b.y, a.z+b.z); }

Real3 operator-(const Real3& a, const int b) { return Real3(a.x-b, a.y-b, a.z-b); }
Real3 operator-(const Real3& a, const double b) { return Real3(a.x-b, a.y-b, a.z-b); }
Real3 operator-(const Real3& a, const Real3& b) { return Real3(a.x-b.x, a.y-b.y, a.z-b.z); }

Real3 operator/(const Real3& a, const int b) { return Real3(a.x/b, a.y/b, a.z/b); }
Real3 operator/(const Real3& a, const double b) { return Real3(a.x/b, a.y/b, a.z/b); }
Real3 operator/(const Real3& a, const Real3& b) { return Real3(a.x/b.x, a.y/b.y, a.z/b.z); }
}
