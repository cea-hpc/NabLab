#include "types/Real3.h"

namespace nablalib
{
Real3 operator*(const Real3& a, const int b) { return Real3(a.x*b, a.y*b, a.z*b); }
Real3 operator*(const int a, const Real3& b) { return Real3(b.x*a, b.y*a, b.z*a); }
Real3 operator*(const Real3& a, const double b) { return Real3(a.x*b, a.y*b, a.z*b); }
Real3 operator*(const double a, const Real3& b) { return Real3(b.x*a, b.y*a, b.z*a); }

Real3 operator+(const Real3& a, const int b) { return Real3(a.x+b, a.y+b, a.z+b); }
Real3 operator+(const int a, const Real3& b) { return Real3(b.x+a, b.y+a, b.z+a); }
Real3 operator+(const Real3& a, const double b) { return Real3(a.x+b, a.y+b, a.z+b); }
Real3 operator+(const double a, const Real3& b) { return Real3(b.x+a, b.y+a, b.z+a); }
Real3 operator+(const Real3& a, const Real3& b) { return Real3(a.x+b.x, a.y+b.y, a.z+b.z); }

Real3 operator-(const Real3& a, const int b) { return Real3(a.x-b, a.y-b, a.z-b); }
Real3 operator-(const Real3& a, const double b) { return Real3(a.x-b, a.y-b, a.z-b); }
Real3 operator-(const Real3& a, const Real3& b) { return Real3(a.x-b.x, a.y-b.y, a.z-b.z); }

Real3 operator/(const Real3& a, const int b) { return Real3(a.x/b, a.y/b, a.z/b); }
Real3 operator/(const Real3& a, const double b) { return Real3(a.x/b, a.y/b, a.z/b); }
Real3 operator/(const Real3& a, const Real3& b) { return Real3(a.x/b.x, a.y/b.y, a.z/b.z); }
}
