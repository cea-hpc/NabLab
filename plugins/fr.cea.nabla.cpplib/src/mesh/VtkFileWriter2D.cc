/*******************************************************************************
 * Copyright (c) 2020 CEA
 * This program and the accompanying materials are made available under the
 * terms of the Eclipse Public License 2.0 which is available at
 * http://www.eclipse.org/legal/epl-2.0.
 *
 * SPDX-License-Identifier: EPL-2.0
 * Contributors: see AUTHORS file
 *******************************************************************************/
#include "VtkFileWriter2D.h"
#include <experimental/filesystem>
#include <fstream>

using namespace std;

namespace nablalib
{
VtkFileWriter2D::VtkFileWriter2D(const string& moduleName, const string& baseDirName)
: FileWriter(moduleName, baseDirName)
{
}

VtkFileWriter2D::~VtkFileWriter2D() {}

void
VtkFileWriter2D::writeFile(
					const int& iteration,
					const double& time,
					const int& nbNodes,
					const RealArray1D<2>* nodes,
					const int& nbCells,
					const Quad* cells,
					const map<string, double*> cellVariables,
					const map<string, double*> nodeVariables)
{
  if (m_disabled)
    return;

	ofstream writer;
	writer.open(m_directory_name + "/" + m_module_name + "." + to_string(iteration) + ".vtk");

	writer << "# vtk DataFile Version 2.0" << endl;
	writer << m_module_name << " at iteration " << iteration << endl;
	writer << "ASCII" << endl;
	writer << "DATASET POLYDATA" << endl;

	writer << "FIELD FieldData 1" << endl;
	writer << "TIME 1 1 double" << endl;
	writer << "time" << endl;

	writer << "POINTS " << nbNodes << " float" << endl;
	for (int r=0 ; r<nbNodes ; ++r)
		writer << nodes[r][0] << "\t" << nodes[r][1] << "\t" << 0.0 << endl;

	writer << "POLYGONS " << nbCells << " " << nbCells * 5 << endl;
	for (int j=0 ; j<nbCells ; ++j)
	{
		writer << "4";
		for (auto nodeId : cells[j].getNodeIds())
			writer << "\t" << nodeId;
		writer << endl;
	}

	// POINT DATA
	if (!nodeVariables.empty())
	{
		writer << "\nDATA_DATA " << nbNodes << endl;
		for (auto itr = nodeVariables.begin() ; itr != nodeVariables.end() ; itr++)
		{
			writer << "SCALARS " << itr->first << " float 1" << endl;
			writer << "LOOKUP_TABLE default" << endl;
			for (int r=0 ; r<nbNodes ; ++r) writer << itr->second[r] << endl;
		}
	}

	// CELL DATA
	if (!cellVariables.empty())
	{
		writer << "\nCELL_DATA " << nbCells << endl;
		for (auto itr = cellVariables.begin() ; itr != cellVariables.end() ; itr++)
		{
			writer << "SCALARS " << itr->first << " float 1" << endl;
			writer << "LOOKUP_TABLE default" << endl;
			for (int j=0 ; j<nbCells ; ++j) writer << itr->second[j] << endl;
		}
	}

	writer.close();
}
}
