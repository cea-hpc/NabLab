#include <math.h>
#include "types/MathFunctions.h"

using namespace std;

namespace nablalib
{
  double MathFunctions::fabs(double v) { return fabs(v); }
  double MathFunctions::sqrt(double v) { return sqrt(v); }
  double MathFunctions::min(double a, double b) { return min(a, b); }
  double MathFunctions::max(double a, double b) { return max(a, b); }
  double MathFunctions::dot(Real2 a, Real2 b) { return (a.x*b.x) + (a.y*b.y); }
  double MathFunctions::dot(Real3 a, Real3 b) { return (a.x*b.x) + (a.y*b.y) + (a.z*b.z); }
  double MathFunctions::norm(Real2 a) { return sqrt(dot(a,a)); }
  double MathFunctions::norm(Real3 a) { return sqrt(dot(a,a)); }
  double MathFunctions::det(Real2 a, Real2 b) { return a.x*b.y - a.y*b.x; }
}

