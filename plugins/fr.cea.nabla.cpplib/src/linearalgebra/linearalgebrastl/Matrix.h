/*******************************************************************************
 * Copyright (c) 2022 CEA
 * This program and the accompanying materials are made available under the
 * terms of the Eclipse Public License 2.0 which is available at
 * http://www.eclipse.org/legal/epl-2.0.
 *
 * SPDX-License-Identifier: EPL-2.0
 * Contributors: see AUTHORS file
 *******************************************************************************/
#ifndef __MATRIX_H_
#define __MATRIX_H_

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
#include "CrsMatrix.h"

#define DBL_PRECISION 6

typedef CrsMatrix<double> SparseMatrixType;

// TODO: templatiser la classe pour passer nb_row, nb_col, nb_nnz en tpl arg,
// calculable dans une passe d'IR pour passer toutes les a1loc en static
class Matrix
{

 public:
  Matrix(const std::string name, const size_t rows, const size_t cols);
  Matrix(const std::string name); // when size is known at runtime
  explicit Matrix(const std::string name, const size_t rows, const size_t cols,
                  std::initializer_list<std::tuple<int, int, double>> init_list);
  ~Matrix();

  // explicit build
  void build();
  // implicit build and accessor
  SparseMatrixType& crsMatrix();
  const void resize(const size_t rows, const size_t cols);
  const size_t getNbRows() const;
  const size_t getNbCols() const;
  // getter
  double getValue(const size_t row, const size_t col) const;
  // setter
  void setValue(const size_t row, const size_t col, double value);
  //print
  std::string print() const;

 //private:
  int findCrsOffset(const int& i, const int& j) const;

  // Attributes
  std::map<int, std::list<std::pair<int, double>>> m_building_struct;
  const std::string m_name;
  int m_nb_rows;
  int m_nb_cols;
  int m_nb_nnz;
  SparseMatrixType* m_matrix;
  std::mutex m_mutex;
};

const char* serialize(const SparseMatrixType& M, int& size, bool& mustDeletePtr);
const char* serialize(const Matrix& M, int& size, bool& mustDeletePtr);

#endif
