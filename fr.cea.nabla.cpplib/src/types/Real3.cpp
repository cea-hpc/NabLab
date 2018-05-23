#include "types/Real3.h"

namespace nablalib
{
  Real3::Real3(double v) { x = y = z = v; }
  Real3::Real3(double x, double y, double z) { this->x = x; this->y = y; this->z = z; }
  Real3::Real3(const Real3& v) { x = v.x; y = v.y; z = v.z; }
  Real3& Real3::operator=(const Real3& v) { x = v.x; y = v.y; z = v.z; return *this; }
  Real3& Real3::operator+=(const Real3& v) { x += v.x; y += v.y; z += v.z; return *this; }
  Real3 Real3::operator*(const Real3& v) { return Real3(x*v.x, y*v.y, z*v.z); }
  Real3 Real3::operator-(const Real3& v) { return Real3(x-v.x, y-v.y, z-v.z); }
  Real3 Real3::operator+(const Real3& v) { return Real3(x+v.x, y+v.y, z+v.z); }
  Real3 Real3::operator/(const Real3& v) { return Real3(x/v.x, y/v.y, z/v.z); }
}
