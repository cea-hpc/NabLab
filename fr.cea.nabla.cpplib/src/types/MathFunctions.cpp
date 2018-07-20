/*******************************************************************************
 * Copyright (c) 2018 CEA
 * This program and the accompanying materials are made available under the 
 * terms of the Eclipse Public License 2.0 which is available at
 * http://www.eclipse.org/legal/epl-2.0.
 *
 * SPDX-License-Identifier: EPL-2.0
 *
 * Contributors:
 * 	Benoit Lelandais - initial implementation
 * 	Marie-Pierre Oudot - initial implementation
 * 	Jean-Sylvan Camier - Nabla generation support
 *******************************************************************************/
#include <cmath>
#include "types/MathFunctions.h"

namespace nablalib
{
  double MathFunctions::fabs(double v) { return std::fabs(v); }
  double MathFunctions::sqrt(double v) { return std::sqrt(v); }
  double MathFunctions::min(double a, double b) { return std::min(a, b); }
  double MathFunctions::max(double a, double b) { return std::max(a, b); }
  double MathFunctions::reduceMin(double a, double b) { return std::min(a, b); }
  double MathFunctions::reduceMax(double a, double b) { return std::max(a, b); }
  double MathFunctions::dot(Real2 a, Real2 b) { return (a.x*b.x) + (a.y*b.y); }
  double MathFunctions::dot(Real3 a, Real3 b) { return (a.x*b.x) + (a.y*b.y) + (a.z*b.z); }
  double MathFunctions::norm(Real2 a) { return sqrt(dot(a,a)); }
  double MathFunctions::norm(Real3 a) { return sqrt(dot(a,a)); }
  double MathFunctions::det(Real2 a, Real2 b) { return a.x*b.y - a.y*b.x; }
}

