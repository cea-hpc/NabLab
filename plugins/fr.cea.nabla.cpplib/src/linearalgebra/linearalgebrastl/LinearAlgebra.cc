/*******************************************************************************
 * Copyright (c) 2022 CEA
 * This program and the accompanying materials are made available under the
 * terms of the Eclipse Public License 2.0 which is available at
 * http://www.eclipse.org/legal/epl-2.0.
 *
 * SPDX-License-Identifier: EPL-2.0
 * Contributors: see AUTHORS file
 *******************************************************************************/
#include "LinearAlgebra.h"

#include <iostream>
#include <algorithm>

/*
 * Simple pretty printing function for Nabla Sparse Matrix
 */
 std::string
 LinearAlgebra::print(const Matrix& M) {
	return M.print();
 }

/*
 * Matlab style printing function for Nabla Sparse Matrix
 */
std::string
LinearAlgebra::printMatlabStyle(const Matrix& M, std::string A) {
  if (!M.m_matrix) {
    std::stringstream ss;
    ss << "\n"<< A <<" = sparse(" << M.m_nb_rows << ", " << M.m_nb_cols << ");\n";
    for (auto i(0); i < M.m_nb_rows; ++i) {
      for (auto j(0); j < M.m_nb_cols; ++j) {
        auto pos_line(std::find_if(M.m_building_struct.begin(), M.m_building_struct.end(),
                                   [&](const std::pair<int, std::list<std::pair<int, double>>>& line){return (line.first == i);}));
        if (pos_line != M.m_building_struct.end()) {
          auto pos_col(std::find_if(pos_line->second.begin(), pos_line->second.end(),
                                    [&](const std::pair<int, double>& col){return col.first == j;}));
          if (pos_col != pos_line->second.end())
            ss <<  A << "(" << i+1 << ", " << j+1 << ") = "   <<pos_col->second << ";\n";
        }
      }
    }
    return std::string(ss.str());
  } else {
    return M.m_matrix->printMatlabStyle(A);
  } 
}

/*
 * Simple pretty printing function for Vector
 */
std::string
LinearAlgebra::print(const Vector& v) {
  std::stringstream ss;
  for (size_t i(0); i < v.m_data.size(); ++i) {
  if (!i)
    ss << "|";
  ss << std::setw(2) << v.m_data.at(i) << " ";
  if (i == v.m_data.size() - 1)
    ss << "|" << std::endl;
  }
  return std::string(ss.str());
}

/*
 * Matlab style pretty printing function for Vector
 */
std::string
LinearAlgebra::printMatlabStyle(const Vector& v, std::string A) {
  std::stringstream ss;
  ss << "\n"<< A <<" = zeros(" << v.m_data.size() << ", 1);\n";
  for (size_t i(0); i < v.m_data.size(); ++i) {
    ss << A << "(" << i+1 << ") = "<< v.m_data.at(i) << ";\n";
  }
  return std::string(ss.str());
}

/*
 * \brief Conjugate Gradient function (solves A x = b)
 * \param A:         [in] sparse matrix
 * \param b:         [in] vector
 * \param x0:        [in] initial guess vector, can be null vector
 * \param max_it:    [in] Iteration threshold (default = 200)
 * \param tolerance: [in] Convergence threshold (default = std::numeric_limits<double>::epsilon)
 * \return:          Solution vector
 */
VectorType
LinearAlgebra::CGSolve(const SparseMatrixType& A, const VectorType& b, const VectorType& x0,
                       const size_t max_it, const double tolerance) {
  size_t it(0);
  double norm_res(0.0);
  const size_t count(x0.size());
  // Copy initial guess solution
  VectorType x(x0.begin(), x0.end());

  /* r = b - A * x ;*/

  /* p = x */
  VectorType p(x.begin(), x.end());
  /* Ap = A * p */
  VectorType Ap(A * p);
  /* b - Ap => r */
  VectorType r(count);
  std::transform(b.begin(), b.end(), Ap.begin(), r.begin(),
                 [&](const double& lhs, const double& rhs){return (lhs - rhs);});
  /* p = r */
  std::copy(r.begin(), r.end(), p.begin());
  double old_rdot(std::inner_product(r.begin(), r.end(), r.begin(), 0.0));
  norm_res = std::sqrt(old_rdot);

  while (tolerance < norm_res && it < max_it) {
    /* pAp_dot = dot(p, Ap = A * p) */ 
  
    /* Ap = A * p */
    Ap = (A * p);

    const double pAp_dot(std::inner_product(p.begin(), p.end(), Ap.begin(), 0.0));
    const double alpha(old_rdot / pAp_dot);
  
    /* x += alpha * p */
    std::transform(x.begin(), x.end(), p.begin(), x.begin(),
                   [&](const double& x_i, const double& p_i){return (x_i + alpha * p_i);});
    /* r += -alpha * Ap */
    std::transform(r.begin(), r.end(), Ap.begin(), r.begin(),
                   [&](const double& r_i, const double& Ap_i){return (r_i - alpha * Ap_i);});
  
    const double r_dot(std::inner_product(r.begin(), r.end(), r.begin(), 0.0));
    const double beta(r_dot / old_rdot);

    /* p = r + beta * p */
    std::transform(p.begin(), p.end(), r.begin(), p.begin(),
                   [&](const double& p_i, const double& r_i){return (r_i + beta * p_i);});

    norm_res = std::sqrt(old_rdot = r_dot);
    ++it;
  }

  // fill infos
  m_info.m_display << "---== Solved A * x = b ==---" << std::endl;
  m_info.m_display << "Nb it = " << it << std::endl;
  m_info.m_display << "Res = " << norm_res << std::endl;
  m_info.m_display << "----------------------------" << std::endl;
  m_info.m_nb_it += it;
  m_info.m_nb_call++;
  m_info.m_norm_res += norm_res;
  
  return x;
}

/*
 * \brief Preconditioned Conjugate Gradient function (solves C^-1(Ax)=C^-1 b)
 * \param A:         [in] Kokkos sparse matrix
 * \param b:         [in] Kokkos vector
 * \param C_minus_1: [in] Kokkos sparse matrix (preconditioner matrix)
 * \param x0:        [in] Kokkos vector (initial guess, can be null vector)
 * \param max_it:    [in] Iteration threshold (default = 200)
 * \param tolerance: [in] Convergence threshold (default = std::numeric_limits<double>::epsilon)
 * \return: Solution vector
 */
VectorType
LinearAlgebra::CGSolve(const SparseMatrixType& A, const VectorType& b,
                       const SparseMatrixType& C_minus_1, const VectorType& x0,
                       const size_t max_it, const double tolerance) {
  size_t it(0);
  double norm_res(0.0);
  const size_t count(x0.size());
  // Copy initial guess solution
  VectorType x(x0.begin(), x0.end());

  /* r = b - A * x ;*/

  /* p = x */
  VectorType p(x.begin(), x.end());
  /* Ap = A * p */
  VectorType Ap(A * p);
  /* b - Ap => r */
  VectorType r(count);
  std::transform(b.begin(), b.end(), Ap.begin(), r.begin(),
                 [&](const double& lhs, const double& rhs){return (lhs - rhs);});
                 
  /* z = C^-1 * r */
  VectorType z(C_minus_1 * r);
  
  /* p = z */
  std::copy(z.begin(), z.end(), p.begin());
  double old_rTz(std::inner_product(r.begin(), r.end(), z.begin(), 0.0));
  norm_res = std::sqrt(old_rTz);

  while (tolerance < norm_res && it < max_it) {
    /* pAp_dot = dot(p, Ap = A * p) */ 
  
    /* Ap = A * p */
    Ap = (A * p);
	
    const double pAp_dot(std::inner_product(p.begin(), p.end(), Ap.begin(), 0.0));
    const double alpha(old_rTz / pAp_dot);
  
    /* x += alpha * p */
    std::transform(x.begin(), x.end(), p.begin(), x.begin(),
                   [&](const double& x_i, const double& p_i){return (x_i + alpha * p_i);});
    /* r += -alpha * Ap */
    std::transform(r.begin(), r.end(), Ap.begin(), r.begin(),
                   [&](const double& r_i, const double& Ap_i){return (r_i - alpha * Ap_i);});

    /* z = C^-1 * r */
    z = (C_minus_1 * r);

    const double rTz(std::inner_product(r.begin(), r.end(), z.begin(), 0.0));
    const double beta(rTz / old_rTz);

    /* p = z + beta * p */
    std::transform(p.begin(), p.end(), z.begin(), p.begin(),
                   [&](const double& p_i, const double& z_i){return (z_i + beta * p_i);});

    norm_res = std::sqrt(old_rTz = rTz);
    ++it;
  }

  // fill infos
  m_info.m_display << "---== Solved A * x = b ==---" << std::endl;
  m_info.m_display << "Nb it = " << it << std::endl;
  m_info.m_display << "Res = " << norm_res << std::endl;
  m_info.m_display << "----------------------------" << std::endl;
  m_info.m_nb_it += it;
  m_info.m_nb_call++;
  m_info.m_norm_res += norm_res;
  
  return x;
}

/*
 * \brief Call to conjugate gradient to solve A x = b
 * \param A:         [in] Sparse matrix
 * \param b:         [in] Vector
 * \param max_it:    [in] Iteration threshold (default = 100)
 * \param tolerance: [in] Convergence threshold (default = 1.e-8)
 * \return: Solution vector
 */
Vector
LinearAlgebra::solveLinearSystem(Matrix& A, const Vector& b, const size_t max_it, const double tolerance)
{
  VectorType default_x0(b.m_data.size(), 0.0);
  VectorType res = CGSolve(A.crsMatrix(), b.m_data, default_x0, max_it, tolerance);
  Vector v(res);
  return v;
}

/*
 * \brief Call to conjugate gradient to solve A x = b
 * \param A:         [in] Sparse matrix
 * \param b:         [in] Vector
 * \param x0:        [in/out] Initial guess of the solution.
 * \param max_it:    [in] Iteration threshold (default = 100)
 * \param tolerance: [in] Convergence threshold (default = 1.e-8)
 * \return: Solution vector
 */
Vector
LinearAlgebra::solveLinearSystem(Matrix& A, const Vector& b, Vector& x0, const size_t max_it, const double tolerance)
{
  VectorType res = CGSolve(A.crsMatrix(), b.m_data, x0.m_data, max_it, tolerance);
  Vector v(res);
  return v;
}

/*
 * \brief Call to conjugate gradient to solve A x = b with a preconditioner
 *        Actually solves C^-1(Ax)=C^-1 b
 * \param A:         [in] Sparse matrix
 * \param b:         [in] Vector
 * \param C_minus_1: [in] Sparse matrix used as preconditioner
 * \param max_it:    [in] Iteration threshold (default = 100)
 * \param tolerance: [in] Convergence threshold (default = 1.e-8)
 * \return: Solution vector
 */
Vector
LinearAlgebra::solveLinearSystem(Matrix& A, const Vector& b, Matrix& C_minus_1, const size_t max_it, const double tolerance)
{
  VectorType default_x0(b.m_data.size(), 0.0);
  VectorType res = CGSolve(A.crsMatrix(), b.m_data, C_minus_1.crsMatrix(), default_x0, max_it, tolerance);
  Vector v(res);
  return v;
}

/*
 * \brief Call to conjugate gradient to solve A x = b with a preconditioner
 *        Actually solves C^-1(Ax)=C^-1 b
 * \param A:         [in] Sparse matrix
 * \param b:         [in] Vector
 * \param C_minus_1: [in] Sparse matrix used as preconditioner
 * \param x0:        [in/out] Initial guess of the solution.
 * \param max_it:    [in] Iteration threshold (default = 100)
 * \param tolerance: [in] Convergence threshold (default = 1.e-8)
 * \return: Solution vector
 */
Vector
LinearAlgebra::solveLinearSystem(Matrix& A, const Vector& b, Matrix& C_minus_1, Vector& x0, const size_t max_it, const double tolerance)
{
  VectorType res = CGSolve(A.crsMatrix(), b.m_data, C_minus_1.crsMatrix(), x0.m_data, max_it, tolerance);
  Vector v(res);
  return v;
}
