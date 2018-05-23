#ifndef TYPES_REAL3X3_H_
#define TYPES_REAL3X3_H_

#include "types/Real3.h"

namespace nablalib
{
	struct Real3x3
	{
	  Real3 x;
	  Real3 y;
	  Real3 z;

	  Real3x3(double v);
	  Real3x3(Real3 x, Real3 y, Real3 z);
	  Real3x3(const Real3x3& v);
	  Real3x3& operator=(const Real3x3& v);
	  Real3x3& operator+=(const Real3x3& v);
	  Real3x3 operator*(const Real3x3& v);
	  Real3x3 operator-(const Real3x3& v);
	  Real3x3 operator+(const Real3x3& v);
	  Real3x3 operator/(const Real3x3& v);
	};
}

#endif /* TYPES_REAL3X3_H_ */
