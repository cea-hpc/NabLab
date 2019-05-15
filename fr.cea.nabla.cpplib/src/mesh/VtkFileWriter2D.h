/*******************************************************************************
 * Copyright (c) 2018 CEA
 * This program and the accompanying materials are made available under the
 * terms of the Eclipse Public License 2.0 which is available at
 * http://www.eclipse.org/legal/epl-2.0.
 *
 * SPDX-License-Identifier: EPL-2.0
 *
 * Contributors:
 * 	Benoit Lelandais - initial implementation
 * 	Marie-Pierre Oudot - initial implementation
 * 	Jean-Sylvain Camier - Nabla generation support
 *******************************************************************************/
#ifndef MESH_VTKFILEWRITER2D_H_
#define MESH_VTKFILEWRITER2D_H_

#include <string>
#include <vector>
#include <map>

#include "types/Types.h"
#include "mesh/NodeIdContainer.h"

using namespace std;

namespace nablalib
{

class VtkFileWriter2D
{
public:
	VtkFileWriter2D(const string& moduleName, const string& baseDirName = string());
	~VtkFileWriter2D();

	void writeFile(
			const int& iteration,
			const int& nbNodes,
			const Real2* nodes,
			const int& nbCells,
			const Quad* cells,
			const map<string, double*> cellVariables,
			const map<string, double*> nodeVariables);

	bool isDisabled() { return m_disabled; }
	const std::string& outputDirectory() { return m_directoryName; }

private:
	static const string OutputDir;
	string m_moduleName;
	string m_directoryName;
	bool m_disabled;
};

}
#endif /* MESH_VTKFILEWRITER2D_H_ */
