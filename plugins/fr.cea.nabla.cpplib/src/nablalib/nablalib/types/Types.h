/*******************************************************************************
 * Copyright (c) 2022 CEA
 * This program and the accompanying materials are made available under the 
 * terms of the Eclipse Public License 2.0 which is available at
 * http://www.eclipse.org/legal/epl-2.0.
 *
 * SPDX-License-Identifier: EPL-2.0
 * Contributors: see AUTHORS file
 *******************************************************************************/
#ifndef NABLALIB_TYPES_TYPES_H_
#define NABLALIB_TYPES_TYPES_H_

#include <array>
#include "nablalib/types/MultiArray.h"

namespace nablalib::types
{
// Type alias
using Id = size_t;

template<size_t N>
using BoolArray1D = MultiArray<bool, N>;

template<size_t M, size_t N>
using BoolArray2D = MultiArray<bool, M, N>;

template<size_t N>
using IntArray1D = MultiArray<int, N>;

template<size_t M, size_t N>
using IntArray2D = MultiArray<int, M, N>;

template<size_t N>
using  RealArray1D = MultiArray<double, N>;

template<size_t M, size_t N>
using RealArray2D = MultiArray<double, M, N>;

}
  
#endif // NABLALIB_TYPES_TYPES_H_
