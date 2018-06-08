#ifndef TYPES_REAL2_H_
#define TYPES_REAL2_H_

#include <iostream>

namespace nablalib
{
struct Real2
{
	double x;
	double y;

	Real2() { x = y = 0.0; }
	Real2(double v) { x = y = v; }
	Real2(double x, double y) { this->x = x; this->y = y; }
	Real2(const Real2& v) { x = v.x; y = v.y; }

	Real2& operator=(const double v) { x = v; y = v; return *this; }
	Real2& operator=(const Real2& v) { x = v.x; y = v.y; return *this; }
	Real2& operator+=(const double v) { x += v; y += v; return *this; }
	Real2& operator+=(const Real2& v) { x += v.x; y += v.y; return *this; }

	friend std::ostream& operator <<(std::ostream& s, const Real2& a)
	{
		s << "[" << a.x << "," << a.y << "]";
		return s;
	}
};

Real2 operator*(const Real2& a, const int b);
Real2 operator*(const int a, const Real2& b);
Real2 operator*(const Real2& a, const double b);
Real2 operator*(const double a, const Real2& b);

Real2 operator+(const Real2& a, const int b);
Real2 operator+(const int a, const Real2& b);
Real2 operator+(const Real2& a, const double b);
Real2 operator+(const double a, const Real2& b);
Real2 operator+(const Real2& a, const Real2& b);

Real2 operator-(const Real2& a, const int b);
Real2 operator-(const Real2& a, const double b);
Real2 operator-(const Real2& a, const Real2& b);

Real2 operator/(const Real2& a, const int b);
Real2 operator/(const Real2& a, const double b);
Real2 operator/(const Real2& a, const Real2& b);
}
#endif /* TYPES_REAL2_H_ */
