/*******************************************************************************
 * Copyright (c) 2020 CEA
 * This program and the accompanying materials are made available under the
 * terms of the Eclipse Public License 2.0 which is available at
 * http://www.eclipse.org/legal/epl-2.0.
 *
 * SPDX-License-Identifier: EPL-2.0
 * Contributors: see AUTHORS file
 *******************************************************************************/
#ifndef LINEARALGEBRA_STL_CRSMATRIX_H_
#define LINEARALGEBRA_STL_CRSMATRIX_H_

#include <vector>
#include <string>
#include <iostream>
#include <iomanip>
#include <sstream>
#include <functional>

namespace nablalib
{

// Compressed Row Storage sparse matrix for arithmetical types
// API was designed to be an alternative of KokkosSparse::CrsMatrix
template <typename T, typename std::enable_if_t<std::is_arithmetic<T>::value>* = nullptr>
class CrsMatrix
{
 public:
  /******************************************** Internal Helper Classes ********************************************/
  class RowView {
   public:
    explicit RowView(CrsMatrix& m, const int row)
    : m_row_val(m.m_val.data() + m.m_row.at(row)),
      m_col_ind(m.m_col.data() + m.m_row.at(row)),
      length(m.m_row.at(row + 1) - m.m_row.at(row)) {}
    ~RowView() {}
    T value(const int i) const {
      return m_row_val[i];
    }
    T& value(const int i) {
      return m_row_val[i];
    }
    int colidx(const int i) const {
      return m_col_ind[i];
    }
   private:
   // TODO: change to span when available
    T* m_row_val;
    int* m_col_ind;
   public:
    const int length;
  };

  class ConstRowView {
   public:
    explicit ConstRowView(const CrsMatrix& m, const int row)
    : m_row_val(m.m_val.data() + m.m_row.at(row)),
      m_col_ind(m.m_col.data() + m.m_row.at(row)),
      length(m.m_row.at(row + 1) - m.m_row.at(row)) {}
    ~ConstRowView() {}
    T value(const int i) const {
      return m_row_val[i];
    }
    int colidx(const int i) const {
      return m_col_ind[i];
    }
   private:
    const T* m_row_val;
    const int* m_col_ind;
   public:
    const int length;
  };
  /***************************************************************************************************************/
 public:
  // Ctor 
  explicit CrsMatrix(const int nb_row, const int nb_col, int nb_nnz, std::vector<T>&& val,
            std::vector<int>&& row_map, std::vector<int>&& col_ind)
  : m_nb_row(nb_row), m_nb_col(nb_col), m_nb_nnz(nb_nnz), m_row(row_map), m_col(col_ind), m_val(val) {}
  // Dtor
  ~CrsMatrix() {}
  
  // Accessors
  int numRows() const {
    return m_nb_row;
  }
  int numCols() const {
    return m_nb_col;
  }
  int nnz() const {
    return m_nb_nnz;
  }
  
  // Row view helpers
  ConstRowView rowConst(int row) const {
    return ConstRowView(*this, row);
  }
  RowView row(int row) {
    return RowView(*this, row);
  }
  
  // Pretty printing
  std::string print() const {
    std::stringstream ss;
    for (auto i(0); i < numRows(); ++i) {
      for (auto j(0), k(0); j < numCols(); ++j) {
	      if (!j)
	        ss << "|";
	      if (!rowConst(i).length || j != rowConst(i).colidx(k)) {
	        ss << std::setw(2) << "0";
	      } else {
	        ss << std::setw(2) << rowConst(i).value(k);
		      ++k;
	      }
	      ss << " ";
	      if (j == numCols() - 1)
	        ss << "|" << std::endl;
	    }
    }
    return std::string(ss.str());
  }
  // Pretty printing for Matlab
  std::string printMatlabStyle(std::string A) const {
    std::stringstream ss;
    ss << "\n"<< A <<" = sparse(" << numRows() << ", " << numCols() << ");\n";
    for (auto i(0); i < numRows(); ++i) {
      for (auto j(0), k(0); j < numCols(); ++j) {
        if (rowConst(i).length && j == rowConst(i).colidx(k)) {
	        ss <<  A << "(" << i+1 << ", " << j+1 << ") = " << rowConst(i).value(k) << ";\n";
          ++k;
        }
      }
    }
    return std::string(ss.str());
  }

   // Matrix vector product
   // return by value semantic
   std::vector<T> operator*(const std::vector<T>& x) const {
    assert(static_cast<int>(x.size()) == m_nb_col);
    std::vector<T> b(x.size(), 0.0);
    for (size_t i(0); i < x.size(); ++i)
      for (int j(m_row.at(i)); j < m_row.at(i + 1); ++j)
        b.at(i) += m_val.at(j) * x.at(m_col.at(j));
    return b;
  }
  
 private:
   const int m_nb_row;
   const int m_nb_col;
   int m_nb_nnz; 
   std::vector<int> m_row;
   std::vector<int> m_col;
   std::vector<T> m_val;
};

}
#endif /* LINEARALGEBRA_STL_CRSMATRIX_H_ */
