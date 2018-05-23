#include "types/Real3x3.h"

namespace nablalib
{
  Real3x3::Real3x3(double v) : x(v), y(v), z(v) { }
  Real3x3::Real3x3(Real3 x, Real3 y, Real3 z) : x(x), y(y), z(z) { }
  Real3x3::Real3x3(const Real3x3& v) : x(v.x), y(v.y), z(v.z) { }
  Real3x3& Real3x3::operator=(const Real3x3& v) { x = v.x; y = v.y; z = v.z; return *this; }
  Real3x3& Real3x3::operator+=(const Real3x3& v) { x += v.x; y += v.y; z += v.z; return *this; }
  Real3x3 Real3x3::operator*(const Real3x3& v) { return Real3x3(x*v.x, y*v.y, z*v.z); }
  Real3x3 Real3x3::operator-(const Real3x3& v) { return Real3x3(x-v.x, y-v.y, z-v.z); }
  Real3x3 Real3x3::operator+(const Real3x3& v) { return Real3x3(x+v.x, y+v.y, z+v.z); }
  Real3x3 Real3x3::operator/(const Real3x3& v) { return Real3x3(x/v.x, y/v.y, z/v.z); }
}
