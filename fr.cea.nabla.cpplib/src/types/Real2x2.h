#ifndef TYPES_REAL2X2_H_
#define TYPES_REAL2X2_H_

#include "types/Real2.h"

namespace nablalib
{
	struct Real2x2
	{
	  Real2 x;
	  Real2 y;

	  Real2x2(double v);
	  Real2x2(Real2 x, Real2 y);
	  Real2x2(const Real2x2& v);
	  Real2x2& operator=(const Real2x2& v);
	  Real2x2& operator+=(const Real2x2& v);
	  Real2x2 operator*(const Real2x2& v);
	  Real2x2 operator-(const Real2x2& v);
	  Real2x2 operator+(const Real2x2& v);
	  Real2x2 operator/(const Real2x2& v);
	};
}

#endif /* TYPES_REAL2X2_H_ */
