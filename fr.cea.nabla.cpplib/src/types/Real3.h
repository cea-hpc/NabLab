#ifndef TYPES_REAL3_H_
#define TYPES_REAL3_H_

namespace nablalib
{
	struct Real3
	{
	  double x;
	  double y;
	  double z;

	  Real3(double v);
	  Real3(double x, double y, double z);
	  Real3(const Real3& v);
	  Real3& operator=(const Real3& v);
	  Real3& operator+=(const Real3& v);
	  Real3 operator*(const Real3& v);
	  Real3 operator-(const Real3& v);
	  Real3 operator+(const Real3& v);
	  Real3 operator/(const Real3& v);
	};
}

#endif /* TYPES_REAL3_H_ */
