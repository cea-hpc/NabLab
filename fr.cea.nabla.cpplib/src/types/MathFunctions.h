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
#ifndef TYPES_MATHFUNCTIONS_H_
#define TYPES_MATHFUNCTIONS_H_

#include "types/Real2.h"
#include "types/Real3.h"

namespace nablalib
{

struct MathFunctions
{
	static double fabs(const double& v) noexcept;
	static double sqrt(const double& v) noexcept;
	static double min(const double& a, const double& b) noexcept;
	static double max(const double& a, const double& b) noexcept;
	static double dot(const Real2& a, const Real2& b) noexcept;
	static double dot(const Real3& a, const Real3& b) noexcept;
	static double norm(const Real2& a) noexcept;
	static double norm(const Real3& a) noexcept;
	static double det(const Real2& a, const Real2& b) noexcept;
	static double sin(const double& v) noexcept;
	static double cos(const double& v) noexcept;
	static double asin(const double& v) noexcept;
	static double acos(const double& v) noexcept;
};
}

#endif /* TYPES_MATHFUNCTIONS_H_ */
