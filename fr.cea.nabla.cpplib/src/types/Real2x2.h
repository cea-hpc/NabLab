#ifndef TYPES_REAL2X2_H_
#define TYPES_REAL2X2_H_

#include <iostream>
#include "types/Real2.h"

namespace nablalib
{
struct Real2x2
{
	Real2 x;
	Real2 y;

	Real2x2() : x(), y() { }
	Real2x2(double v) : x(v), y(v) { }
	Real2x2(Real2 x, Real2 y) : x(x), y(y) { }
	Real2x2(const Real2x2& v) : x(v.x), y(v.y) { }

	Real2x2& operator=(const Real2x2& v)  { x = v.x; y = v.y; return *this; }
	Real2x2& operator+=(const Real2x2& v)  { x += v.x; y += v.y; return *this; }

	friend std::ostream& operator <<(std::ostream& s, const Real2x2& a)
	{
		s << "[" << a.x << "," << a.y << "]";
		return s;
	}
};

Real2x2 operator*(const Real2x2& a, const int b);
Real2x2 operator*(const int a, const Real2x2& b);
Real2x2 operator*(const Real2x2& a, const double b);
Real2x2 operator*(const double a, const Real2x2& b);
Real2x2 operator*(const Real2x2& a, const Real2x2& b);

Real2x2 operator/(const Real2x2& a, const int b);
Real2x2 operator/(const Real2x2& a, const double b);

Real2x2 operator+(const Real2x2& a, const Real2x2& b);

Real2x2 operator-(const Real2x2& a, const Real2x2& b);
}
#endif /* TYPES_REAL2X2_H_ */
