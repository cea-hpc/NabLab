/*******************************************************************************
 * Copyright (c) 2018 CEA
 * This program and the accompanying materials are made available under the
 * terms of the Eclipse Public License 2.0 which is available at
 * http://www.eclipse.org/legal/epl-2.0.
 *
 * SPDX-License-Identifier: EPL-2.0
 * Contributors: see AUTHORS file
 *******************************************************************************/
#ifndef MESH_PVDFILEWRITER2D_H_
#define MESH_PVDFILEWRITER2D_H_

#include <string>
#include <vector>
#include <map>

#include "types/Types.h"
#include "mesh/NodeIdContainer.h"
#include "mesh/FileWriter.h"

using namespace std;

namespace nablalib
{

class PvdFileWriter2D : public FileWriter
{
public:
	PvdFileWriter2D(const string& moduleName, const string& baseDirName = string());
	~PvdFileWriter2D();

	void writeFile(
			const int& iteration,
			const double& time,
			const int& nbNodes,
			const RealArray1D<2>* nodes,
			const int& nbCells,
			const Quad* cells,
			const map<string, double*> cellVariables,
			const map<string, double*> nodeVariables) override;
private:
	map<double, string> m_file_name_by_times;
};
}
#endif /* MESH_PVDFILEWRITER2D_H_ */
