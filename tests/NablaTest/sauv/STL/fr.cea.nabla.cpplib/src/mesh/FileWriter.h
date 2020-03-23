/*******************************************************************************
 * Copyright (c) 2018 CEA
 * This program and the accompanying materials are made available under the
 * terms of the Eclipse Public License 2.0 which is available at
 * http://www.eclipse.org/legal/epl-2.0.
 *
 * SPDX-License-Identifier: EPL-2.0
 * Contributors: see AUTHORS file
 *******************************************************************************/
#ifndef MESH_FILEWRITER_H_
#define MESH_FILEWRITER_H_

#include <string>
#include <vector>
#include <map>

#include "types/Types.h"
#include "mesh/NodeIdContainer.h"

using namespace std;

namespace nablalib
{

class FileWriter
{
protected:
	FileWriter(const string& moduleName, const string& baseDirName);
	virtual ~FileWriter();

public:
	virtual void writeFile(
			const int& iteration,
			const double& time,
			const int& nbNodes,
			const Real2* nodes,
			const int& nbCells,
			const Quad* cells,
			const map<string, double*> cellVariables,
			const map<string, double*> nodeVariables)=0;

	bool isDisabled() { return m_disabled; }
	const std::string& outputDirectory() { return m_directory_name; }

protected:
	static const string OutputDir;
	string m_module_name;
	string m_directory_name;
	bool m_disabled;
};

}
#endif /* MESH_FILEWRITER_H_ */
