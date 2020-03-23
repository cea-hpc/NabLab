/*******************************************************************************
 * Copyright (c) 2018 CEA
 * This program and the accompanying materials are made available under the 
 * terms of the Eclipse Public License 2.0 which is available at
 * http://www.eclipse.org/legal/epl-2.0.
 *
 * SPDX-License-Identifier: EPL-2.0
 * Contributors: see AUTHORS file
 *******************************************************************************/
#ifndef TYPES_H_
#define TYPES_H_

#include <array>
#include "types/MultiArray.h"

namespace nablalib
{

/*
template<size_t N> using IntArray1D = array<int, N>;
template<size_t N, size_t M> using IntArray2D = array<IntArray1D<M>, N>;
template<size_t N> using  RealArray1D = array<double, N>;
template<size_t N, size_t M> using RealArray2D = array<RealArray1D<M>, N>;

using Real2 = RealArray1D<2>;
*/

template<size_t N> using IntArray1D = MultiArray<int, N>;
template<size_t N, size_t M> using IntArray2D = MultiArray<int, M, N>;
template<size_t N> using  RealArray1D = MultiArray<double, N>;
template<size_t N, size_t M> using RealArray2D = MultiArray<double, M, N>;

using Real2 = RealArray<2>;

}  // namespace nablalib
  
#endif
