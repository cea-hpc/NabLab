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
 * 	Jean-Sylvain Camier - Nabla generation support
 *******************************************************************************/
#include <cmath>
#include "types/MathFunctions.h"

namespace nablalib
{
  double MathFunctions::fabs(const double& v) noexcept { return std::fabs(v); }
  double MathFunctions::sqrt(const double& v) noexcept { return std::sqrt(v); }
  double MathFunctions::min(const double& a, const double& b) noexcept { return std::min(a, b); }
  double MathFunctions::max(const double& a, const double& b) noexcept { return std::max(a, b); }
  double MathFunctions::dot(const Real2& a, const Real2& b) noexcept { return (a.x*b.x) + (a.y*b.y); }
  double MathFunctions::dot(const Real3& a, const Real3& b) noexcept { return (a.x*b.x) + (a.y*b.y) + (a.z*b.z); }
  double MathFunctions::norm(const Real2& a) noexcept { return sqrt(dot(a,a)); }
  double MathFunctions::norm(const Real3& a) noexcept { return sqrt(dot(a,a)); }
  double MathFunctions::det(const Real2& a, const Real2& b) noexcept { return a.x*b.y - a.y*b.x; }
}

