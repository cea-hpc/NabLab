/*******************************************************************************
 * Copyright (c) 2018 CEA
 * This program and the accompanying materials are made available under the
 * terms of the Eclipse Public License 2.0 which is available at
 * http://www.eclipse.org/legal/epl-2.0.
 *
 * SPDX-License-Identifier: EPL-2.0
 * Contributors: see AUTHORS file
 *******************************************************************************/
#ifndef TYPES_MATHFUNCTIONS_H_
#define TYPES_MATHFUNCTIONS_H_

#include "types/Real2.h"
#include "types/Real3.h"

namespace nablalib
{

namespace MathFunctions
{
	double fabs(const double& v) noexcept;
	double sqrt(const double& v) noexcept;
	double min(const double& a, const double& b) noexcept;
	double max(const double& a, const double& b) noexcept;
	double dot(const Real2& a, const Real2& b) noexcept;
	double dot(const Real3& a, const Real3& b) noexcept;
	double norm(const Real2& a) noexcept;
	double norm(const Real3& a) noexcept;
	double det(const Real2& a, const Real2& b) noexcept;
	double sin(const double& v) noexcept;
	double cos(const double& v) noexcept;
	double asin(const double& v) noexcept;
	double acos(const double& v) noexcept;
}
}

#endif /* TYPES_MATHFUNCTIONS_H_ */
