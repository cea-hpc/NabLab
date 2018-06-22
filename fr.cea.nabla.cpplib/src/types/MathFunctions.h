#ifndef TYPES_MATHFUNCTIONS_H_
#define TYPES_MATHFUNCTIONS_H_

#include "types/Real2.h"
#include "types/Real3.h"

namespace nablalib
{

struct MathFunctions
{
	static double fabs(double v);
	static double sqrt(double v);
	static double min(double a, double b);
	static double max(double a, double b);
	static double reduceMin(double a, double b);
	static double reduceMax(double a, double b);
	static double dot(Real2 a, Real2 b);
	static double dot(Real3 a, Real3 b);
	static double norm(Real2 a);
	static double norm(Real3 a);
	static double det(Real2 a, Real2 b);
};
}

#endif /* TYPES_MATHFUNCTIONS_H_ */
