/*******************************************************************************
 * Copyright (c) 2020 CEA
 * This program and the accompanying materials are made available under the
 * terms of the Eclipse Public License 2.0 which is available at
 * http://www.eclipse.org/legal/epl-2.0.
 *
 * SPDX-License-Identifier: EPL-2.0
 * Contributors: see AUTHORS file
 *******************************************************************************/
#include "linearalgebra/stl/Matrix.h"

namespace nablalib
{

NablaSparseMatrix::NablaSparseMatrixHelper& NablaSparseMatrix::NablaSparseMatrixHelper::
operator=(double val) {
  if (!m_matrix.m_matrix) {
    std::lock_guard<std::mutex> guard(m_matrix.m_mutex);
    
	  auto& row_i(m_matrix.m_building_struct[m_row]);
	  auto pos(std::find_if(row_i.begin(), row_i.end(),
						              [&](const std::pair<int, double>& j){return (j.first == m_col);}));
	  if (pos == row_i.end()) {
	    row_i.emplace_back(m_col, val);
	    m_matrix.m_nb_nnz++;
	  } else {
	    pos->second = val;
	  }
  } else {
	  int offset(m_matrix.findCrsOffset(m_row, m_col));
	  if (offset == -1) {
	    // FIXME: Attention, il y a un elmt "invisible" sur 1a derniere ligne (l'elmt "past the end" qui indique la fin de la crs), si on tombe dessus on a un pb...
	    std::cerr << "Error, can't assign " << val << " at (" << m_row << ", " << m_col << ") for matrix "
				        << m_matrix.m_name << " after it was build." << std::endl;
	    std::terminate();
	  } else {
      std::lock_guard<std::mutex> guard(m_matrix.m_mutex);
	    m_matrix.m_matrix->row(m_row).value(offset) = val;
	  }
  }
  return *this;
}


NablaSparseMatrix::
NablaSparseMatrix(const std::string name, const int rows, const int cols)
  : m_name(name), m_nb_row(rows), m_nb_col(cols), m_nb_nnz(0), m_matrix(nullptr) {}


NablaSparseMatrix::
NablaSparseMatrix(const std::string name, const int rows, const int cols,
                  std::initializer_list<std::tuple<int, int, double>> init_list)
  : m_name(name), m_nb_row(rows), m_nb_col(cols), m_nb_nnz(init_list.size()), m_matrix(nullptr)
{
  std::for_each(init_list.begin(), init_list.end(),
      [&](const std::tuple<int, int, double>& i){
	        m_building_struct[std::get<0>(i)].emplace_back(std::get<1>(i), std::get<2>(i));});
}


NablaSparseMatrix::
~NablaSparseMatrix()
{
  if (m_matrix)
    delete m_matrix;
}


void NablaSparseMatrix::
build()
{
  if (m_matrix)
    return;

  // std::cout << "Building CRS Matrix...";

  // Assuming ascending indexes for rows
  for (auto row_i : m_building_struct)
    row_i.second.sort([&](const std::pair<int, double>& a, const std::pair<int, double>& b){
	                        return (a.first < b.first);});

  // Containers to build matrix
  std::vector<int> row_map(static_cast<size_t>(m_nb_row + 1));
  std::vector<int> col_ind(static_cast<size_t>(m_nb_nnz));
  std::vector<double> val(static_cast<size_t>(m_nb_nnz));

  int offset(0);
  for (int row_i(0); row_i < m_nb_row; ++row_i) {
    row_map.at(row_i) = offset;
    auto pos(m_building_struct.find(row_i));
    if (pos != m_building_struct.end()) {
      for (auto nnz : pos->second) {
        col_ind.at(offset) = nnz.first;
        val.at(offset) = nnz.second;
        ++offset;
      }
    }
  }
  row_map.at(m_nb_row) = offset; // past end index
  m_matrix = new SparseMatrixType(m_nb_row, m_nb_col, m_nb_nnz, std::move(val), std::move(row_map), std::move(col_ind));
  
  // clearing temp struct
  m_building_struct.clear();

  // std::cout << " OK:" << std::endl;
  // std::cout << "row map = {";
  // for (auto i(0); i < m_nb_row + 1; ++i)
    // std::cout << row_map.at(i) << " ";
  // std::cout << "}" << std::endl;
  // std::cout << "col ind = {";
  // for (auto i(0); i < m_nb_nnz; ++i)
    // std::cout << col_ind.at(i) << " ";
  // std::cout << "}" << std::endl;
  // std::cout << "val = {";
  // for (auto i(0); i < m_nb_nnz; ++i)
    // std::cout << val.at(i) << " ";
  // std::cout << "}" << std::endl;
}


SparseMatrixType& NablaSparseMatrix::
crsMatrix()
{
  if (!m_matrix && !m_building_struct.empty())
    build();
  return *m_matrix;
}


NablaSparseMatrix::NablaSparseMatrixHelper NablaSparseMatrix::
operator()(const int row, const int col)
{
  assert(row < m_nb_row && col < m_nb_col);
  return NablaSparseMatrix::NablaSparseMatrixHelper(*this, row, col);
}


double NablaSparseMatrix::operator()(const int row, const int col) const
{
  assert(row < m_nb_row && col < m_nb_col);
  if (!m_matrix) {
    if (m_building_struct.find(row) == m_building_struct.end()) {
	    return 0.;
    } else {
	    auto pos(std::find_if(m_building_struct.at(row).begin(), m_building_struct.at(row).end(),
		                        [&](const std::pair<int, double>& j){return (j.first == col);}));
	    if (pos == m_building_struct.at(row).end())
	      return 0.;
      else
        return pos->second;
    }
  } else {
    int offset(findCrsOffset(row, col));
    if (offset == -1)
      return 0.;
    else
      return m_matrix->row(row).value(offset);
  }
}


int NablaSparseMatrix::
findCrsOffset(const int& i, const int& j) const
{
  int offset(-1);
  if (!m_matrix)
    return offset;
  auto row_view(m_matrix->row(i));
  for (int col_j(0); col_j < row_view.length; ++col_j) {
    if (row_view.colidx(col_j) == j) {
      offset = col_j;
      break;
    }
  }
  return offset;
}

}  // namespace nablalib
