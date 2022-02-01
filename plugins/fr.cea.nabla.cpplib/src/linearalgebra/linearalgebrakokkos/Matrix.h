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
#include <tuple>
#include <initializer_list>
#include <cmath>
#include <limits>
#include <array>
#include <mutex>

// Kokkos headers
#include "Kokkos_Core.hpp"
#include "Kokkos_hwloc.hpp"
#include "KokkosSparse.hpp"
#include "KokkosBlas.hpp"

typedef KokkosSparse::CrsMatrix<double, int, Kokkos::OpenMP, void, int> SparseMatrixType;

// TODO: templatiser la classe pour passer nb_row, nb_col, nb_nnz en tpl arg,
// calculable dans une passe d'IR pour passer toutes les a1loc en static
class Matrix
{
 public:
  Matrix(const std::string name, const size_t rows, const size_t cols);
  explicit Matrix(const std::string name, const size_t rows, const size_t cols,
                  std::initializer_list<std::tuple<int, int, double>> init_list);
  ~Matrix();

  // explicit build
  void build();
  // implicit build and accessor
  SparseMatrixType& crsMatrix();
  const size_t getNbRows() const;
  const size_t getNbCols() const;
  // getter
  double getValue(const size_t row, const size_t col) const;
  // setter
  void setValue(const size_t row, const size_t col, double value);

// private:
  int findCrsOffset(const int& i, const int& j) const;

  // Attributes
  std::map<int, std::list<std::pair<int, double>>> m_building_struct;
  const std::string m_name;
  const int m_nb_rows;
  const int m_nb_cols;
  int m_nb_nnz;
  SparseMatrixType* m_data;
  std::mutex m_mutex;
};

const char* serialize(const SparseMatrixType& M, int& size, bool& mustDeletePtr);
const char* serialize(const Matrix& M, int& size, bool& mustDeletePtr);

#endif
