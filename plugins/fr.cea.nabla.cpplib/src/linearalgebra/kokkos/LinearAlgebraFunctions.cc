/*******************************************************************************
 * Copyright (c) 2020 CEA
 * This program and the accompanying materials are made available under the
 * terms of the Eclipse Public License 2.0 which is available at
 * http://www.eclipse.org/legal/epl-2.0.
 *
 * SPDX-License-Identifier: EPL-2.0
 * Contributors: see AUTHORS file
 *******************************************************************************/
#include "linearalgebra/kokkos/LinearAlgebraFunctions.h"
#include <iostream>

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
     return print(*M.m_matrix);
   }
 }  

/*
 * Matlab style printing function for Kokkos Sparse Matrix
 */
std::string printMatlabStyle(const NablaSparseMatrix& M, std::string A) {
  if (!M.m_matrix) {
    std::stringstream ss;
    ss << "\n"<< A <<" = sparse(" << M.m_nb_row << ", " << M.m_nb_col << ");\n";
    for (auto i(0); i < M.m_nb_row; ++i) {
      for (auto j(0); j < M.m_nb_col; ++j) {
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
    return printMatlabStyle(*M.m_matrix, A);
  } 
}
  
/*
 * Simple pretty printing function for Kokkos Sparse Matrix
 */
std::string print(const SparseMatrixType& M) {
  std::stringstream ss;
  for (auto i(0); i < M.numRows(); ++i) {
    for (auto j(0), k(0); j < M.numCols(); ++j) {
	  if (!j)
	    ss << "|";
	  if (!M.rowConst(i).length || j != M.rowConst(i).colidx(k)) {
	    ss << std::setw(2) << "0";
	  } else {
	    ss << std::setw(2) << M.rowConst(i).value(k);
		++k;
	  }
	  ss << " ";
	  if (j == M.numCols() - 1)
	    ss << "|" << std::endl;
	}
  }
  return std::string(ss.str());
}

/*
 * Simple pretty printing function for Nabla Sparse Matrix
 */
  std::string printMatlabStyle(const SparseMatrixType& M, std::string A) {
  std::stringstream ss;
  ss << "\n"<< A <<" = sparse(" << M.numRows() << ", " << M.numCols() << ");\n";
  for (auto i(0); i < M.numRows(); ++i) {
    for (auto j(0), k(0); j < M.numCols(); ++j) {
      if (M.rowConst(i).length && j == M.rowConst(i).colidx(k)) {
	      ss <<  A << "(" << i+1 << ", " << j+1 << ") = " << M.rowConst(i).value(k) << ";\n";
        ++k;
      }
    }
  }
  return std::string(ss.str());
}
  
/*
 * Simple pretty printing function for Kokkos Vector
 */
std::string print(const VectorType& v) {
  std::stringstream ss;

  for (size_t i(0); i < v.extent(0); ++i) {
  if (!i)
    ss << "|";
  ss << std::setw(2) << v(i) << " ";
  if (i == v.extent(0) - 1)
    ss << "|" << std::endl;
  }
  return std::string(ss.str());
}


/*
 * Matlab style pretty printing function for Kokkos Vector
 */
std::string printMatlabStyle(const VectorType& v, std::string A) {
  std::stringstream ss;
  ss << "\n"<< A <<" = zeros(" << v.extent(0) << ", 1);\n";
  for (size_t i(0); i < v.extent(0); ++i) {
    ss << A << "(" << i+1 << ") = "<< v(i) << ";\n";
  }
  return std::string(ss.str());
}
  
/*
 * \brief Conjugate Gradient function (solves A x = b)
 * \param A:         [in] Kokkos sparse matrix
 * \param b:         [in] Kokkos vector
 * \param x0:        [in] Kokkos vector (initial guess, can be null vector)
 * \param info:      [in/out] Misc. informations on computation result
 * \param max_it:    [in] Iteration threshold (default = 200)
 * \param tolerance: [in] Convergence threshold (default = std::numeric_limits<double>::epsilon)
 * \return: Solution vector
 */
VectorType CGSolve(const SparseMatrixType& A, const VectorType& b, const VectorType& x0, CGInfo& info,
		               const size_t max_it, const double tolerance) {

  size_t it(0);
  double norm_res(0.0);
  const size_t count(x0.extent(0));

  VectorType p("p", count);
  VectorType r("r", count);
  VectorType Ap("Ap", count);
  VectorType x("x", count);
  // Copy of innitial guess
  Kokkos::deep_copy(x, x0);

  /* r = b - A * x ;*/

  /* p = x */
  Kokkos::deep_copy(p, x);
  /* Ap = A * p */
  KokkosSparse::spmv("N", 1.0, A, p, 0.0, Ap);
  /* b - Ap => r */
  KokkosBlas::update(1., b, -1.0, Ap, 0.0, r);
  /* p = r */
  Kokkos::deep_copy(p, r);

  double old_rdot(KokkosBlas::dot(r, r));
  norm_res = std::sqrt(old_rdot);

  while (tolerance < norm_res && it < max_it) {
    /* pAp_dot = dot(p, Ap = A * p) */

    /* Ap = A * p */
    KokkosSparse::spmv("N", 1.0, A, p, 0.0, Ap);

    VectorType::execution_space().fence();

    const double pAp_dot(KokkosBlas::dot(p, Ap));
    const double alpha(old_rdot / pAp_dot);

    /* x += alpha * p */
    KokkosBlas::axpby(alpha, p, 1.0, x);
    /* r += -alpha * Ap */
    KokkosBlas::axpby(-alpha, Ap, 1.0, r);

    const double r_dot(KokkosBlas::dot(r, r));
    const double beta(r_dot / old_rdot);

    /* p = r + beta * p */
    KokkosBlas::axpby(1.0, r, beta, p);

    norm_res = std::sqrt(old_rdot = r_dot);
    ++it;
  }
  VectorType::execution_space().fence();

  // fill infos
  info.m_display << "---== Solved A * x = b ==---" << std::endl;
  info.m_display << "Nb it = " << it << std::endl;
  info.m_display << "Res = " << norm_res << std::endl;
  info.m_display << "----------------------------" << std::endl;
  info.m_nb_it += it;
  info.m_norm_res += norm_res;

  return x;
}

/*
 * \brief Call to conjugate gradient to solve A x = b
 * \param A:         [in] Sparse matrix
 * \param b:         [in] Vector
 * \param info:      [in/out] Misc. informations on computation result
 * \param x0:        [in/out] Initial guess of the solution. If none is provided, a null vector is used.
 * \return: Solution vector
 * \note: Iteration threshold is 100, convergence threshold is 1.e-8
 */
VectorType solveLinearSystem(NablaSparseMatrix& A, const VectorType& b, CGInfo& info, VectorType* x0)
{
  if (!x0) {
    VectorType default_x0("x0", b.extent(0));
    for (size_t i(0); i < b.extent(0); ++i)
      default_x0(i) = 0.0;
    return CGSolve(A.crsMatrix(), b, default_x0, info, 100, 1.e-8);
  } else {
    return CGSolve(A.crsMatrix(), b, *x0, info, 100, 1.e-8);
  }
}

}  // LinearAlgebraFunctions

}  // nablalib
