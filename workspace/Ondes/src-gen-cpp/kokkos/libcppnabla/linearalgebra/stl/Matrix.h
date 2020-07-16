/*******************************************************************************
 * Copyright (c) 2020 CEA
 * This program and the accompanying materials are made available under the
 * terms of the Eclipse Public License 2.0 which is available at
 * http://www.eclipse.org/legal/epl-2.0.
 *
 * SPDX-License-Identifier: EPL-2.0
 * Contributors: see AUTHORS file
 *******************************************************************************/
#ifndef LINEARALGEBRA_STL_MATRIX_H_
#define LINEARALGEBRA_STL_MATRIX_H_

#include <iostream>
#include <iomanip>
#include <string>
#include <sstream>
#include <map>
#include <list>
#include <utility>
#include <algorithm>
#include <numeric>
#include <initializer_list>
#include <cmath>
#include <cassert>
#include <limits>
#include <mutex>

#include "linearalgebra/stl/CrsMatrix.h"

namespace nablalib
{

typedef CrsMatrix<double> SparseMatrixType;
typedef std::vector<double> VectorType;

// TODO: templatiser la classe pour passer nb_row, nb_col, nb_nnz en tpl arg,
// calculable dans une passe d'IR pour passer toutes les a1loc en static
class NablaSparseMatrix
{
  // Friend of forwardly-declared class NablasparseMatrixHelper
  friend class NablaSparseMatrixHelper;

  /******************************************** Internal Helper Class ********************************************/
  class NablaSparseMatrixHelper {
   public:
    explicit NablaSparseMatrixHelper(NablaSparseMatrix& m, const int i, const int j) : m_matrix(m), m_row(i), m_col(j) {}
	  ~NablaSparseMatrixHelper() = default;

	NablaSparseMatrixHelper& operator=(double val);

   private:
    NablaSparseMatrix& m_matrix;
	  const int m_row;
	  const int m_col;
  };
  /***************************************************************************************************************/

 public:
  NablaSparseMatrix(const std::string name, const int rows, const int cols);
  explicit NablaSparseMatrix(const std::string name, const int rows, const int cols,
                             std::initializer_list<std::tuple<int, int, double>> init_list);
  ~NablaSparseMatrix();

  // explicit build
  void build();
  // implicit build and accessor
  SparseMatrixType& crsMatrix();
  // getter
  double operator()(const int row, const int col) const;
  // setter
  NablaSparseMatrixHelper operator()(const int row, const int col);
  
 //private:
  int findCrsOffset(const int& i, const int& j) const;

  // Attributes
  std::map<int, std::list<std::pair<int, double>>> m_building_struct;
  const std::string m_name;
  const int m_nb_row;
  const int m_nb_col;
  int m_nb_nnz;
  SparseMatrixType* m_matrix;
  std::mutex m_mutex;
};

}
#endif /* LINEARALGEBRA_STL_MATRIX_H_ */
