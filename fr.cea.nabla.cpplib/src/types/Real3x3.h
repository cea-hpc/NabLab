#ifndef TYPES_REAL3X3_H_
#define TYPES_REAL3X3_H_

#include <iostream>
#include "types/Real3.h"

namespace nablalib
{
struct Real3x3
{
	Real3 x;
	Real3 y;
	Real3 z;

	Real3x3() : x(), y(), z() { }
	Real3x3(double v) : x(v), y(v), z(v) { }
	Real3x3(Real3 x, Real3 y, Real3 z) : x(x), y(y), z(z) { }
	Real3x3(const Real3x3& v) : x(v.x), y(v.y), z(v.z) { }

	Real3x3& operator=(const Real3x3& v) { x = v.x; y = v.y; z = v.z; return *this; }
	Real3x3& operator+=(const Real3x3& v) { x += v.x; y += v.y; z += v.z; return *this; }

	friend std::ostream& operator <<(std::ostream& s, const Real3x3& a)
	{
		s << "[" << a.x << "," << a.y << "," << a.z << "]";
		return s;
	}
};

Real3x3 operator*(const Real3x3& a, const int b);
Real3x3 operator*(const int a, const Real3x3& b);
Real3x3 operator*(const Real3x3& a, const double b);
Real3x3 operator*(const double a, const Real3x3& b);
Real3x3 operator*(const Real3x3& a, const Real3x3& b);

Real3x3 operator/(const Real3x3& a, const int b);
Real3x3 operator/(const Real3x3& a, const double b);

Real3x3 operator+(const Real3x3& a, const Real3x3& b);

Real3x3 operator-(const Real3x3& a, const Real3x3& b);
}

#endif /* TYPES_REAL3X3_H_ */
