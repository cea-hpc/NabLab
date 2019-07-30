/*******************************************************************************
 * Copyright (c) 2018 CEA
 * This program and the accompanying materials are made available under the
 * terms of the Eclipse Public License 2.0 which is available at
 * http://www.eclipse.org/legal/epl-2.0.
 *
 * SPDX-License-Identifier: EPL-2.0
 * Contributors: see AUTHORS file
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
  double MathFunctions::sin(const double& v) noexcept { return std::sin(v); }
  double MathFunctions::cos(const double& v) noexcept { return std::cos(v); }
  double MathFunctions::asin(const double& v) noexcept { return std::asin(v); }
  double MathFunctions::acos(const double& v) noexcept { return std::acos(v); }
}

