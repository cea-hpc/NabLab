/*******************************************************************************
 * Copyright (c) 2020 CEA
 * This program and the accompanying materials are made available under the
 * terms of the Eclipse Public License 2.0 which is available at
 * http://www.eclipse.org/legal/epl-2.0.
 *
 * SPDX-License-Identifier: EPL-2.0
 * Contributors: see AUTHORS file
 *******************************************************************************/
#ifndef NABLALIB_UTILS_STL_SERIALIZER_H_
#define NABLALIB_UTILS_STL_SERIALIZER_H_

#include "nablalib/linearalgebra/stl/Matrix.h"
#include "nablalib/linearalgebra/stl/Vector.h"

using namespace nablalib::linearalgebra::stl;

/*
 * Collection of free functions to serialize variables build over STL backend into strings.
 * Values are space separated.
 */
namespace nablalib::utils::stl
{
// included in the namespace
#include "nablalib/utils/Serializer.h"

  /*
   * Collection of free functions to serialize variables into strings.
   * Values are space separated.
   */

  std::string serialize(const SparseMatrixType& M);
  std::string serialize(const Matrix& M);
  std::string serialize(const Vector& v);
}

#endif // NABLALIB_UTILS_STL_SERIALIZER_H_
