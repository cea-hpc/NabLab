/*******************************************************************************
 * Copyright (c) 2020 CEA
 * This program and the accompanying materials are made available under the
 * terms of the Eclipse Public License 2.0 which is available at
 * http://www.eclipse.org/legal/epl-2.0.
 *
 * SPDX-License-Identifier: EPL-2.0
 * Contributors: see AUTHORS file
 *******************************************************************************/
#ifndef UTILS_STL_SERIALIZER_H_
#define UTILS_STL_SERIALIZER_H_

#include "linearalgebra/stl/Matrix.h"
#include "utils/Serializer.h"

/*
 * Collection of free functions to serialize variables build over STL backend into strings.
 * Values are space separated.
 */
namespace nablalib {
std::string serialize(const SparseMatrixType& M);
std::string serialize(const NablaSparseMatrix& M);
}

#endif
