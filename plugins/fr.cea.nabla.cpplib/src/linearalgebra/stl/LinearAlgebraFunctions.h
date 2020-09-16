/*******************************************************************************
 * Copyright (c) 2020 CEA
 * This program and the accompanying materials are made available under the
 * terms of the Eclipse Public License 2.0 which is available at
 * http://www.eclipse.org/legal/epl-2.0.
 *
 * SPDX-License-Identifier: EPL-2.0
 * Contributors: see AUTHORS file
 *******************************************************************************/
#ifndef LINEARALGEBRA_STL_LINEARALGEBRAFUNCTIONS_H_
#define LINEARALGEBRA_STL_LINEARALGEBRAFUNCTIONS_H_

#include <rapidjson/document.h>
#include "linearalgebra/stl/Matrix.h"

namespace nablalib
{

class LinearAlgebraFunctions
{
public:
  struct CGInfo {
    int m_nb_it;
    int m_nb_call;
    double m_norm_res;
    std::stringstream m_display;
  };

  void jsonInit(const rapidjson::Value::ConstObject& d) {}
  std::string print(const NablaSparseMatrix& M);
  std::string printMatlabStyle(const NablaSparseMatrix& M, std::string A);

  std::string print(const VectorType& v);
  std::string printMatlabStyle(const VectorType& v, std::string A);

  VectorType CGSolve(const SparseMatrixType& A, const VectorType& b, const VectorType& x0, CGInfo& info,
                     const size_t max_it = 200, const double tolerance = std::numeric_limits<double>::epsilon());
  VectorType CGSolve(const SparseMatrixType& A, const VectorType& b,
                     const SparseMatrixType& C_minus_1, const VectorType& x0,
                     CGInfo& info, const size_t max_it, const double tolerance);

  VectorType solveLinearSystem(NablaSparseMatrix& A, const VectorType& b, CGInfo& info,
                               VectorType* x0 = nullptr, const size_t max_it = 100, const double tolerance = 1.e-8);
  VectorType solveLinearSystem(NablaSparseMatrix& A, const VectorType& b, NablaSparseMatrix& C_minus_1, CGInfo& info,
                               VectorType* x0 = nullptr, const size_t max_it = 100, const double tolerance = 1.e-8);
};

}

#endif /* LINEARALGEBRA_STL_LINEARALGEBRAFUNCTIONS_H_ */
