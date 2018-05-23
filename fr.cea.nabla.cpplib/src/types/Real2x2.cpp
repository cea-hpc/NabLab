#include "types/Real2x2.h"

namespace nablalib
{
  Real2x2::Real2x2(double v) : x(v), y(v) { }
  Real2x2::Real2x2(Real2 x, Real2 y) : x(x), y(y) { }
  Real2x2::Real2x2(const Real2x2& v) : x(v.x), y(v.y) { }
  Real2x2& Real2x2::operator=(const Real2x2& v) { x = v.x; y = v.y; return *this; }
  Real2x2& Real2x2::operator+=(const Real2x2& v) { x += v.x; y += v.y; return *this; }
  Real2x2 Real2x2::operator*(const Real2x2& v) { return Real2x2(x*v.x, y*v.y); }
  Real2x2 Real2x2::operator-(const Real2x2& v) { return Real2x2(x-v.x, y-v.y); }
  Real2x2 Real2x2::operator+(const Real2x2& v) { return Real2x2(x+v.x, y+v.y); }
  Real2x2 Real2x2::operator/(const Real2x2& v) { return Real2x2(x/v.x, y/v.y); }
}
