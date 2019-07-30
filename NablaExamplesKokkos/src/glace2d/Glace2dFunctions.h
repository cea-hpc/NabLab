/*******************************************************************************
 * Copyright (c) 2018 CEA
 * This program and the accompanying materials are made available under the
 * terms of the Eclipse Public License 2.0 which is available at
 * http://www.eclipse.org/legal/epl-2.0.
 *
 * SPDX-License-Identifier: EPL-2.0
 * Contributors: see AUTHORS file
 *******************************************************************************/
#ifndef GLACE2D_GLACE2DFUNCTIONS_H_
#define GLACE2D_GLACE2DFUNCTIONS_H_

#include "types/Types.h"

using namespace nablalib;

class Glace2dFunctions
{
public:
	static Real2x2 tensProduct(const Real2& a, const Real2& b) noexcept;
	static Real2 matVectProduct(const Real2x2& a, const Real2& b) noexcept;
	static double det(const Real2x2& a) noexcept;
	static double trace(const Real2x2& a) noexcept;
	static Real2x2 inverse(const Real2x2& m) noexcept;
  static Real2 perp(const Real2& a) noexcept;
};

#endif /* GLACE2D_GLACE2DFUNCTIONS_H_ */
