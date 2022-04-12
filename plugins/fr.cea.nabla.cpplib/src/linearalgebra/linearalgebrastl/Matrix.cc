/*******************************************************************************
 * Copyright (c) 2022 CEA
 * This program and the accompanying materials are made available under the
 * terms of the Eclipse Public License 2.0 which is available at
 * http://www.eclipse.org/legal/epl-2.0.
 *
 * SPDX-License-Identifier: EPL-2.0
 * Contributors: see AUTHORS file
 *******************************************************************************/
#include "Matrix.h"

Matrix::
Matrix(const std::string name, const size_t rows, const size_t cols)
: m_name(name), m_nb_rows(rows), m_nb_cols(cols), m_nb_nnz(0), m_matrix(nullptr) {}


Matrix::
Matrix(const std::string name)
  : m_name(name), m_nb_rows(0), m_nb_cols(0), m_nb_nnz(0), m_matrix(nullptr) {}


Matrix::
Matrix(const std::string name, const size_t rows, const size_t cols,
		std::initializer_list<std::tuple<int, int, double>> init_list)
: m_name(name), m_nb_rows(rows), m_nb_cols(cols), m_nb_nnz(init_list.size()), m_matrix(nullptr)
{
	std::for_each(init_list.begin(), init_list.end(),
			[&](const std::tuple<int, int, double>& i){
		m_building_struct[std::get<0>(i)].emplace_back(std::get<1>(i), std::get<2>(i));});
}


Matrix::
~Matrix()
{
	if (m_matrix)
		delete m_matrix;
}


void Matrix::
build()
{
	if (m_matrix)
		return;

	// Assuming ascending indexes for rows
	for (auto& row_i : m_building_struct)
		row_i.second.sort([&](const std::pair<int, double>& a, const std::pair<int, double>& b){
		return (a.first < b.first);});

	// Containers to build matrix
	std::vector<int> row_map(static_cast<size_t>(m_nb_rows + 1));
	std::vector<int> col_ind(static_cast<size_t>(m_nb_nnz));
	std::vector<double> val(static_cast<size_t>(m_nb_nnz));

	int offset(0);
	for (int row_i(0); row_i < m_nb_rows; ++row_i) {
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
	row_map.at(m_nb_rows) = offset; // past end index
	m_matrix = new SparseMatrixType(m_nb_rows, m_nb_cols, m_nb_nnz, std::move(val), std::move(row_map), std::move(col_ind));

	// clearing temp struct
	m_building_struct.clear();

	// std::cout << " OK:" << std::endl;
	// std::cout << "row map = {";
	// for (auto i(0); i < m_nb_rows + 1; ++i)
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


SparseMatrixType& Matrix::
crsMatrix()
{
	if (!m_matrix && !m_building_struct.empty())
		build();
	return *m_matrix;
}


const void Matrix::
resize(const size_t rows, const size_t cols)
{
	if (m_matrix)
	  delete m_matrix;
	m_nb_rows = rows;
	m_nb_cols = cols;
}


const size_t Matrix::
getNbRows() const
{
	return m_nb_rows;
}


const size_t Matrix::
getNbCols() const
{
	return m_nb_cols;
}


double Matrix::
getValue(const size_t _row, const size_t _col) const
{
	int row = static_cast<int>(_row);
	int col = static_cast<int>(_col);
	assert(row < m_nb_rows && col < m_nb_cols);
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


void Matrix::
setValue(const size_t _row, const size_t _col, double value)
{
	int row = static_cast<int>(_row);
	int col = static_cast<int>(_col);
	assert(row < m_nb_rows && col < m_nb_cols);
	if (!m_matrix) {
		std::lock_guard<std::mutex> guard(m_mutex);

		auto& row_i(m_building_struct[row]);
		auto pos(std::find_if(row_i.begin(), row_i.end(),
				[&](const std::pair<int, double>& j){return (j.first == col);}));
		if (pos == row_i.end()) {
			row_i.emplace_back(col, value);
			m_nb_nnz++;
		} else {
			pos->second = value;
		}
	} else {
		int offset(findCrsOffset(row, col));
		if (offset == -1) {
			// FIXME: Attention, il y a un elmt "invisible" sur 1a derniere ligne (l'elmt "past the end" qui indique la fin de la crs), si on tombe dessus on a un pb...
			std::cerr << "Error, can't assign " << value << " at (" << row << ", " << col << ") for matrix "
					<< m_name << " after it was build." << std::endl;
			std::terminate();
		} else {
			std::lock_guard<std::mutex> guard(m_mutex);
			m_matrix->row(row).value(offset) = value;
		}
	}
}

std::string Matrix::
print() const
{
	if (!m_matrix) {
		std::stringstream ss;
		for (auto i(0); i < m_nb_rows; ++i) {
			for (auto j(0); j < m_nb_cols; ++j) {
				if (j == 0)
					ss << "|";
				auto pos_line(std::find_if(m_building_struct.begin(), m_building_struct.end(),
								[&](const std::pair<int, std::list<std::pair<int, double>>>& line)
								{return (line.first == i);}));
				if (pos_line != m_building_struct.end()) {
					auto pos_col(std::find_if(pos_line->second.begin(), pos_line->second.end(),
								 [&](const std::pair<int, double>& col){return col.first == j;}));
					if (pos_col != pos_line->second.end())
						ss << std::setprecision(2) << std::setw(6) << pos_col->second;
					else
						ss << std::setprecision(2) << std::setw(6) << "0";
				} else {
					ss << std::setprecision(2) << std::setw(6) << "0";
				}
				if (j == m_nb_cols - 1)
					ss << "|";
			}
			ss << std::endl;
		}
		return std::string(ss.str());
	} else {
		return m_matrix->print();
	}
}

int Matrix::
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

const char* serialize(const SparseMatrixType& M, int& size, bool& mustDeletePtr)
{
	std::vector<double> v;
	for (auto i(0); i < M.numRows(); ++i) {
		auto rowConstI = M.rowConst(i);
		for (auto j(0), k(0); j < M.numCols(); ++j) {
			if (!rowConstI.length || j != rowConstI.colidx(k))
			{
				v.push_back(0);
			} else {
				v.push_back(rowConstI.value(k));
				++k;
			}
		}
	}
	size_t n = v.size();
	size = n * sizeof(double);
	double* array = new double[n];
	for (size_t i(0) ; i<n ; ++i)
		array[i] = v[i];
	mustDeletePtr = true;
	return (const char*)array;
}

const char* serialize(const Matrix& M, int& size, bool& mustDeletePtr)
{
	if (!M.m_matrix) {
		std::vector<double> v;
		for (auto i(0); i < M.m_nb_rows; ++i) {
			for (auto j(0); j < M.m_nb_cols; ++j) {
				auto pos_line(std::find_if(M.m_building_struct.begin(), M.m_building_struct.end(),
						[&](const std::pair<int, std::list<std::pair<int, double>>>& line)
						{return (line.first == i);}));
				if (pos_line != M.m_building_struct.end()) {
					auto pos_col(std::find_if(pos_line->second.begin(), pos_line->second.end(),
							[&](const std::pair<int, double>& col){return col.first == j;}));
					if (pos_col != pos_line->second.end())
						v.push_back(pos_col->second);
					else
						v.push_back(0);
				} else {
					v.push_back(0);
				}
			}
		}

		size = v.size() * sizeof(double);
		double* array = new double[v.size()];
		for (size_t i(0) ; i<v.size() ; ++i)
			array[i] = v[i];
		mustDeletePtr = true;
		return (const char*)array;
	} else {
		return serialize(*M.m_matrix, size, mustDeletePtr);
	}
}
