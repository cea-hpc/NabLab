/*******************************************************************************
 * Copyright (c) 2020 CEA
 * This program and the accompanying materials are made available under the
 * terms of the Eclipse Public License 2.0 which is available at
 * http://www.eclipse.org/legal/epl-2.0.
 *
 * SPDX-License-Identifier: EPL-2.0
 * Contributors: see AUTHORS file
 *******************************************************************************/
#ifndef MESH_ABSTRACTPVDFILEWRITER2D_H_
#define MESH_ABSTRACTPVDFILEWRITER2D_H_

#include <string>
#include <map>
#include <fstream>

#include "types/Types.h"
#include "mesh/NodeIdContainer.h"

using namespace std;

namespace nablalib
{

class AbstractPvdFileWriter2D
{
public:
	enum State { closed, ready, onNodes, nodesFinished, onCells, cellsFinished };
	~AbstractPvdFileWriter2D();

	bool isDisabled() { return m_directory_name.empty(); }
	const std::string& outputDirectory() { return m_directory_name; }

	void startVtpFile(
			const int& iteration,
			const double& time,
			const size_t& nbNodes,
			const RealArray1D<2>* nodes,
			const size_t& nbCells,
			const Quad* cells);

	void openNodeData();
	void openCellData();
	void closeNodeData();
	void closeCellData();

	void closeVtpFile();

protected:
	AbstractPvdFileWriter2D(const string& moduleName, const string& directoryName);
	ofstream m_vtp_writer;

private:
	void changeState(const State& expectedState, const State& newState);
	map<double, string> m_file_name_by_times;
	string m_module_name;
	string m_directory_name;
	State m_state;
};
}
#endif /* MESH_ABSTRACTPVDFILEWRITER2D_H_ */
