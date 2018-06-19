#include "types/Real2.h"

namespace nablalib
{
Real2 operator*(const Real2& a, const int b) { return Real2(a.x*b, a.y*b); }
Real2 operator*(const int a, const Real2& b) { return Real2(b.x*a, b.y*a); }
Real2 operator*(const Real2& a, const double b) { return Real2(a.x*b, a.y*b); }
Real2 operator*(const double a, const Real2& b) { return Real2(b.x*a, b.y*a); }
Real2 operator*(const Real2& a, const Real2& b) { return Real2(a.x*b.x, a.y*b.y); }

Real2 operator+(const Real2& a, const int b) { return Real2(a.x+b, a.y+b); }
Real2 operator+(const int a, const Real2& b) { return Real2(b.x+a, b.y+a); }
Real2 operator+(const Real2& a, const double b) { return Real2(a.x+b, a.y+b); }
Real2 operator+(const double a, const Real2& b) { return Real2(b.x+a, b.y+a); }
Real2 operator+(const Real2& a, const Real2& b) { return Real2(a.x+b.x, a.y+b.y); }

Real2 operator-(const Real2& a, const int b) { return Real2(a.x-b, a.y-b); }
Real2 operator-(const Real2& a, const double b) { return Real2(a.x-b, a.y-b); }
Real2 operator-(const Real2& a, const Real2& b) { return Real2(a.x-b.x, a.y-b.y); }

Real2 operator/(const Real2& a, const int b) { return Real2(a.x/b, a.y/b); }
Real2 operator/(const Real2& a, const double b) { return Real2(a.x/b, a.y/b); }
Real2 operator/(const Real2& a, const Real2& b) { return Real2(a.x/b.x, a.y/b.y); }
}
