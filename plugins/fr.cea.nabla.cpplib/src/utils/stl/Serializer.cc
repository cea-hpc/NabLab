/*******************************************************************************
 * Copyright (c) 2020 CEA
 * This program and the accompanying materials are made available under the
 * terms of the Eclipse Public License 2.0 which is available at
 * http://www.eclipse.org/legal/epl-2.0.
 *
 * SPDX-License-Identifier: EPL-2.0
 * Contributors: see AUTHORS file
 *******************************************************************************/

#include "utils/stl/Serializer.h"

namespace nablalib {

std::string serialize(const SparseMatrixType& M) {
  std::stringstream ss;
  for (auto i(0); i < M.numRows(); ++i) {
    for (auto j(0), k(0); j < M.numCols(); ++j) {
	    if (!M.rowConst(i).length || j != M.rowConst(i).colidx(k)) {
	      ss << "0";
	    } else {
	      ss << std::setprecision(DBL_PRECISION) << M.rowConst(i).value(k);
        ++k;
	    }
	    ss << " ";
	  }
  }
  return std::string(ss.str());
}

std::string serialize(const NablaSparseMatrix& M) {
  if (!M.m_matrix) {
    std::stringstream ss;
    for (auto i(0); i < M.m_nb_row; ++i) {
      for (auto j(0); j < M.m_nb_col; ++j) {
        auto pos_line(std::find_if(M.m_building_struct.begin(), M.m_building_struct.end(),
                                   [&](const std::pair<int, std::list<std::pair<int, double>>>& line)
                                   {return (line.first == i);}));
        if (pos_line != M.m_building_struct.end()) {
          auto pos_col(std::find_if(pos_line->second.begin(), pos_line->second.end(),
                                    [&](const std::pair<int, double>& col){return col.first == j;}));
          if (pos_col != pos_line->second.end())
            ss << std::setprecision(DBL_PRECISION) << pos_col->second;
          else
            ss << "0";
        } else {
          ss << "0";
        }
        ss << " ";
      }
    }
    return std::string(ss.str());
  } else {
    return serialize(*M.m_matrix);
  }
}

}
