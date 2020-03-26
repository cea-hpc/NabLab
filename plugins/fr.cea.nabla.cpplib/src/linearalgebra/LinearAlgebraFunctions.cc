/*******************************************************************************
 * Copyright (c) 2020 CEA
 * This program and the accompanying materials are made available under the
 * terms of the Eclipse Public License 2.0 which is available at
 * http://www.eclipse.org/legal/epl-2.0.
 *
 * SPDX-License-Identifier: EPL-2.0
 * Contributors: see AUTHORS file
 *******************************************************************************/
#include "linearalgebra/LinearAlgebraFunctions.h"

namespace nablalib
{

namespace LinearAlgebraFunctions
{
/*
 * Simple pretty printing function for Sparse Matrix
 */
 std::string print(const NablaSparseMatrix& M) {
   if (!M.m_matrix) {
     std::stringstream ss;
     for (auto i(0); i < M.m_nb_row; ++i) {
       for (auto j(0); j < M.m_nb_col; ++j) {
         if (j == 0)
           ss << "|";
         auto pos_line(std::find_if(M.m_building_struct.begin(), M.m_building_struct.end(),
                                    [&](const std::pair<int, std::list<std::pair<int, double>>>& line)
                                    {return (line.first == i);}));
         if (pos_line != M.m_building_struct.end()) {
           auto pos_col(std::find_if(pos_line->second.begin(), pos_line->second.end(),
                                     [&](const std::pair<int, double>& col){return col.first == j;}));
           if (pos_col != pos_line->second.end())
             ss << std::setprecision(2) << std::setw(6) << pos_col->second;
           else
             ss << std::setprecision(2) << std::setw(6) << "0";
         } else {
           ss << std::setprecision(2) << std::setw(6) << "0";
         }
         if (j == M.m_nb_col - 1)
           ss << "|";
       }
       ss << std::endl;
     }
     return std::string(ss.str());
   } else {
     return M.m_matrix->print();
   }
 }  

/*
 * Simple pretty printing function for Vector
 */
std::string print(const VectorType& v) {
  std::stringstream ss;
  for (size_t i(0); i < v.size(); ++i) {
  if (!i)
    ss << "|";
  ss << std::setw(2) << v.at(i) << " ";
  if (i == v.size() - 1)
    ss << "|" << std::endl;
  }
  return std::string(ss.str());
}

/*
 * \brief Conjugate Gradient function (solves A x = b)
 * \param A:         [in] sparse matrix
 * \param b:         [in] vector
 * \param x:         [in/out] vector (initial guess, can be null vector)
 * \param info:      [in/out] Misc. informations on computation result
 * \param max_it:    [in] Iteration threshold (default = 200)
 * \param tolerance: [in] Convergence threshold (default = std::numeric_limits<double>::epsilon)
 */
void CGSolve(const SparseMatrixType& A, const VectorType& b, VectorType& x, CGInfo& info,
             const size_t max_it, const double tolerance) {
  size_t it(0);
  double norm_res(0.0);
  const size_t count(x.size());

  ///* r = b - A * x ;*/

  ///* p = x */
  VectorType p(x.begin(), x.end());
  ///* Ap = A * p */
  VectorType Ap(std::move(A * p));
  ///* b - Ap => r */
  VectorType r(count);
  std::transform(b.begin(), b.end(), Ap.begin(), r.begin(),
                 [&](const double& lhs, const double& rhs){return (lhs - rhs);});
  ///* p = r */
  std::copy(r.begin(), r.end(), p.begin());
  double old_rdot(std::inner_product(r.begin(), r.end(), r.begin(), 0.0));
  norm_res = std::sqrt(old_rdot);

  while (tolerance < norm_res && it < max_it) {
    ///* pAp_dot = dot(p, Ap = A * p) */ 
  
    ///* Ap = A * p */
    Ap = std::move(A * p);
  
    //VectorType::execution_space().fence();
	
    const double pAp_dot(std::inner_product(p.begin(), p.end(), Ap.begin(), 0.0));
    const double alpha(old_rdot / pAp_dot);
  
    ///* x += alpha * p */
    std::transform(x.begin(), x.end(), p.begin(), x.begin(),
                   [&](const double& x_i, const double& p_i){return (x_i + alpha * p_i);});
    ///* r += -alpha * Ap */
    std::transform(r.begin(), r.end(), Ap.begin(), r.begin(),
                   [&](const double& r_i, const double& Ap_i){return (r_i - alpha * Ap_i);});
  
    const double r_dot(std::inner_product(r.begin(), r.end(), r.begin(), 0.0));
    const double beta(r_dot / old_rdot);

    ///* p = r + beta * p */
    std::transform(p.begin(), p.end(), r.begin(), p.begin(),
                   [&](const double& p_i, const double& r_i){return (r_i + beta * p_i);});

    norm_res = std::sqrt(old_rdot = r_dot);
    ++it;
  }
  //VectorType::execution_space().fence();
  
  // fill infos
  info.m_display << "---== Solved A * x = b ==---" << std::endl;
  info.m_display << "Nb it = " << it << std::endl;
  info.m_display << "Res = " << norm_res << std::endl;
  info.m_display << "----------------------------" << std::endl;
  info.m_nb_it += it;
  info.m_norm_res += norm_res;
}

/*
 * \brief Call to conjugate gradient to solve A x = b
 * \param A:         [in] Sparse matrix
 * \param b:         [in] Vector
 * \param info:      [in/out] Misc. informations on computation result
 * \return: Solution vector
 * \note: Initial guess is null vector, default iteration threshold is 100),
 *        default convergence threshold is 1.e-8
 */
VectorType solveLinearSystem(NablaSparseMatrix& A, const VectorType& b, CGInfo& info)
{
  const size_t count(b.size());
  VectorType x(count, 0.0);
  CGSolve(A.crsMatrix(), b, x, info, 100, 1.e-8);
  return x;
}

}  // LinearAlgebraFunctions

}  // nablalib

