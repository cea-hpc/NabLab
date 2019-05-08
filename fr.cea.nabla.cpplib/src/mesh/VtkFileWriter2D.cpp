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
#include "VtkFileWriter2D.h"
#include <experimental/filesystem>
#include <fstream>

using namespace std;

namespace nablalib
{
const string VtkFileWriter2D::OutputDir = "output";

VtkFileWriter2D::VtkFileWriter2D(const string& moduleName)
: m_moduleName(moduleName)
{
	const string outputDirName (OutputDir);
	if (experimental::filesystem::exists(outputDirName))
		experimental::filesystem::remove_all(outputDirName);
	else
		experimental::filesystem::create_directory(outputDirName);
}

VtkFileWriter2D::~VtkFileWriter2D() {}

void
VtkFileWriter2D::writeFile(
					const int& iteration,
					const int& nbNodes,
					const Real2* nodes,
					const int& nbCells,
					const Quad* cells,
					const map<string, double*> cellVariables,
					const map<string, double*> nodeVariables)
{
	ofstream writer;
	writer.open(OutputDir + "/" + m_moduleName + "." + to_string(iteration) + ".vtk");

	writer << "# vtk DataFile Version 2.0" << endl;
	writer << m_moduleName << " at iteration " << iteration << endl;
	writer << "ASCII" << endl;
	writer << "DATASET POLYDATA" << endl;

	writer << "POINTS " << nbNodes << " float" << endl;
	for (int r=0 ; r<nbNodes ; ++r)
		writer << nodes[r].x << "\t" << nodes[r].y << "\t" << 0.0 << endl;

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
