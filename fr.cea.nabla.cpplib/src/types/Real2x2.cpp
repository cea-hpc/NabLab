#include "types/Real2x2.h"

namespace nablalib
{
Real2x2 operator*(const Real2x2& a, const int b) { return Real2x2(a.x*b, a.y*b); }
Real2x2 operator*(const int a, const Real2x2& b) { return Real2x2(b.x*a, b.y*a); }
Real2x2 operator*(const Real2x2& a, const double b) { return Real2x2(a.x*b, a.y*b); }
Real2x2 operator*(const double a, const Real2x2& b) { return Real2x2(b.x*a, b.y*a); }

Real2x2 operator+(const Real2x2& a, const Real2x2& b) { return Real2x2(a.x+b.x, a.y+b.y); }

Real2x2 operator-(const Real2x2& a, const Real2x2& b) { return Real2x2(a.x-b.x, a.y-b.y); }
}
