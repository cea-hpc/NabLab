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
#ifndef TYPES_REAL3_H_
#define TYPES_REAL3_H_

#include <iostream>

namespace nablalib
{
struct Real3
{
	double x;
	double y;
	double z;

	Real3() { x = y = z = 0.0; }
	Real3(double v) { x = y = z = v; }
	Real3(double x, double y, double z) { this->x = x; this->y = y; this->z = z; }
	Real3(const Real3& v) { x = v.x; y = v.y; z = v.z; }

	Real3& operator=(const double v) { x = v; y = v; z = v; return *this; }
	Real3& operator=(const Real3& v) { x = v.x; y = v.y; z = v.z; return *this; }
	Real3& operator+=(const double v) { x += v; y += v; z += v; return *this; }
	Real3& operator+=(const Real3& v) { x += v.x; y += v.y; z += v.z; return *this; }

	friend std::ostream& operator <<(std::ostream& s, const Real3& a)
	{
		s << "[" << a.x << "," << a.y << "," << a.z << "]";
		return s;
	}
};

Real3 operator*(const Real3& a, const int b);
Real3 operator*(const int a, const Real3& b);
Real3 operator*(const Real3& a, const double b);
Real3 operator*(const double a, const Real3& b);
Real3 operator*(const Real3& a, const Real3& b);

Real3 operator+(const Real3& a, const int b);
Real3 operator+(const int a, const Real3& b);
Real3 operator+(const Real3& a, const double b);
Real3 operator+(const double a, const Real3& b);
Real3 operator+(const Real3& a, const Real3& b);

Real3 operator-(const Real3& a, const int b);
Real3 operator-(const Real3& a, const double b);
Real3 operator-(const Real3& a, const Real3& b);

Real3 operator/(const Real3& a, const int b);
Real3 operator/(const Real3& a, const double b);
Real3 operator/(const Real3& a, const Real3& b);
}
#endif /* TYPES_REAL3_H_ */
