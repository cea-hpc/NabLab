/*******************************************************************************
 * Copyright (c) 2020 CEA
 * This program and the accompanying materials are made available under the
 * terms of the Eclipse Public License 2.0 which is available at
 * http://www.eclipse.org/legal/epl-2.0.
 *
 * SPDX-License-Identifier: EPL-2.0
 * Contributors: see AUTHORS file
 *******************************************************************************/
#ifndef MESH_STL_PVDFILEWRITER2D_H_
#define MESH_STL_PVDFILEWRITER2D_H_

#include "mesh/AbstractPvdFileWriter2D.h"

using namespace std;

namespace nablalib
{

class PvdFileWriter2D : public AbstractPvdFileWriter2D
{
public:
	PvdFileWriter2D(const string& moduleName, const string& directoryName)
	: AbstractPvdFileWriter2D(moduleName, directoryName) {}
	~PvdFileWriter2D() {}

	void write(const string& name, vector<double>& data)
	{
		if (isDisabled()) return;
		m_vtp_writer << "				<DataArray Name=\"" + name + "\" type=\"Float32\" format=\"ascii\">" << endl;
		for (size_t r=0 ; r<data.size() ; ++r) m_vtp_writer << " " << data[r];
		m_vtp_writer << endl;
		m_vtp_writer << "				</DataArray>" << endl;
	}

	template<size_t N> void write(const string& name, vector<RealArray1D<N>>& data)
	{
		if (isDisabled()) return;
		m_vtp_writer << "				<DataArray Name=\"" + name + "\" type=\"Float32\" NumberOfComponents=\"" + to_string(N) + "\" format=\"ascii\">" << endl;
		for (size_t r=0 ; r<data.size() ; ++r)
			for (size_t i=0 ; i<N ; ++i)
				m_vtp_writer << " " << data[r][i];
		m_vtp_writer << endl;
		m_vtp_writer << "				</DataArray>" << endl;
	}
};
}
#endif /* MESH_STL_PVDFILEWRITER2D_H_ */
