#ifndef TYPES_REAL2_H_
#define TYPES_REAL2_H_

namespace nablalib
{
	struct Real2
	{
	  double x;
	  double y;

	  Real2(double v);
	  Real2(double x, double y);
	  Real2(const Real2& v);
	  Real2& operator=(const Real2& v);
	  Real2& operator+=(const Real2& v);
	  Real2 operator*(const Real2& v);
	  Real2 operator-(const Real2& v);
	  Real2 operator+(const Real2& v);
	  Real2 operator/(const Real2& v);
	};
}

#endif /* TYPES_REAL2_H_ */
