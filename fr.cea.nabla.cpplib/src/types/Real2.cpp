#include "types/Real2.h"

namespace nablalib
{
  Real2::Real2(double v) { x = y = v; }
  Real2::Real2(double x, double y) { this->x = x; this->y = y; }
  Real2::Real2(const Real2& v) { x = v.x; y = v.y; }
  Real2& Real2::operator=(const Real2& v) { x = v.x; y = v.y; return *this; }
  Real2& Real2::operator+=(const Real2& v) { x += v.x; y += v.y; return *this; }
  Real2 Real2::operator*(const Real2& v) { return Real2(x*v.x, y*v.y); }
  Real2 Real2::operator-(const Real2& v) { return Real2(x-v.x, y-v.y); }
  Real2 Real2::operator+(const Real2& v) { return Real2(x+v.x, y+v.y); }
  Real2 Real2::operator/(const Real2& v) { return Real2(x/v.x, y/v.y); }
}
