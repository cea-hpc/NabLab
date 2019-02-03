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
#ifndef GLACE2D_GLACE2DFUNCTIONS_H_
#define GLACE2D_GLACE2DFUNCTIONS_H_

#include "types/Types.h"

using namespace nablalib;

class Glace2dFunctions
{
public:
	static Real2x2 tensProduct(const Real2& a, const Real2& b);
	static Real2 matVectProduct(const Real2x2& a, const Real2& b);
	static double det(const Real2x2& a);
	static double trace(const Real2x2& a);
	static Real2x2 inverse(const Real2x2& m);
  	static Real2 perp(const Real2& a);
};

#endif /* GLACE2D_GLACE2DFUNCTIONS_H_ */
