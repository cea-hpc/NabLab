/*******************************************************************************
 * Copyright (c) 2021 CEA
 * This program and the accompanying materials are made available under the
 * terms of the Eclipse Public License 2.0 which is available at
 * http://www.eclipse.org/legal/epl-2.0.
 *
 * SPDX-License-Identifier: EPL-2.0
 * Contributors: see AUTHORS file
 *******************************************************************************/
#ifndef __LINEARALGEBRA_H_
#define __LINEARALGEBRA_H_

#include "Matrix.h"
#include "Vector.h"

class LinearAlgebra
{
 public:
  struct CGInfo {
    int m_nb_it;
    int m_nb_call;
    double m_norm_res;
    std::stringstream m_display;
  };
  CGInfo m_info;

  void jsonInit(const char* jsonContent) {}
  std::string print(const Matrix& M);
  std::string printMatlabStyle(const Matrix& M, std::string A);

  std::string print(const Vector& v);
  std::string printMatlabStyle(const Vector& v, std::string A);

  VectorType CGSolve(const SparseMatrixType& A, const VectorType& b, const VectorType& x0,
                     const size_t max_it = 200, const double tolerance = std::numeric_limits<double>::epsilon());
  VectorType CGSolve(const SparseMatrixType& A, const VectorType& b,
                     const SparseMatrixType& C_minus_1, const VectorType& x0,
                     const size_t max_it, const double tolerance);

  Vector solveLinearSystem(Matrix& A, const Vector& b, const size_t max_it = 100, const double tolerance = 1.e-8);
  Vector solveLinearSystem(Matrix& A, const Vector& b, Vector& x0, const size_t max_it = 100, const double tolerance = 1.e-8);
  Vector solveLinearSystem(Matrix& A, const Vector& b, Matrix& C_minus_1, const size_t max_it = 100, const double tolerance = 1.e-8);
  Vector solveLinearSystem(Matrix& A, const Vector& b, Matrix& C_minus_1, Vector& x0, const size_t max_it = 100, const double tolerance = 1.e-8);
};

#endif
