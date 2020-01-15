/*******************************************************************************
 * Copyright (c) 2020 CEA
 * This program and the accompanying materials are made available under the
 * terms of the Eclipse Public License 2.0 which is available at
 * http://www.eclipse.org/legal/epl-2.0.
 *
 * SPDX-License-Identifier: EPL-2.0
 * Contributors: see AUTHORS file
 *******************************************************************************/
#ifndef TYPES_MATRIX_H_
#define TYPES_MATRIX_H_

#include <iostream>
#include <iomanip>
#include <string>
#include <sstream>
#include <map>
#include <list>
#include <utility>
#include <algorithm>
#include <tuple>
#include <initializer_list>
#include <cmath>
#include <limits>
#include <array>

// Kokkos headers
#include "Kokkos_Core.hpp"
#include "Kokkos_hwloc.hpp"
#include "KokkosSparse.hpp"
#include "KokkosBlas.hpp"


namespace nablalib
{

typedef KokkosSparse::CrsMatrix<double, int, Kokkos::OpenMP, void, int> SparseMatrixType;
typedef Kokkos::View<double*> VectorType;

// T0D0: templatiser la classe pour passer nb_row, nb_col, nb_nnz en tpl arg,
// calculable dans une passe d'IR pour passer toutes les a1loc en static
class NablaSparseMatrix
{
  // Friend of forwardly-declared class NablasparseMatrixHelper
  friend class NablaSparseMatrixHelper;

  /******************************************** Internal Helper Class ********************************************/
  class NablaSparseMatrixHelper {
   public:
    explicit NablaSparseMatrixHelper(NablaSparseMatrix& m, int i, int j) : m_matrix(m), m_row(i), m_col(j) {}
	~NablaSparseMatrixHelper() = default;

	NablaSparseMatrixHelper& operator=(double val);

   private:
    NablaSparseMatrix& m_matrix;
	const int m_row;
	const int m_col;
  };
  /***************************************************************************************************************/

 public:
  NablaSparseMatrix(std::string name, int rows, int cols);
  explicit NablaSparseMatrix(std::string name, int rows, int cols,
		                     std::initializer_list<std::tuple<int, int, double>> init_list);
  ~NablaSparseMatrix() = default;

  void build();
  SparseMatrixType& crsMatrix();
  NablaSparseMatrixHelper operator()(int row, int col);
  double operator()(int row, int col) const;

 private:
  int findCrsOffset(const int& i, const int& j) const;

  // Attributes
  std::map<int, std::list<std::pair<int, double>>> m_building_struct;
  std::string m_name;
  int m_nb_row;
  int m_nb_col;
  int m_nb_nnz;
  Kokkos::View<double*> m_val;
  Kokkos::View<int*> m_row_map;
  Kokkos::View<int*> m_col_ind;
  SparseMatrixType* m_matrix;
};

}
#endif /* TYPES_MATRIX_H_ */
