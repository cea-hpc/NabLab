/*******************************************************************************
 * Copyright (c) 2018 CEA
 * This program and the accompanying materials are made available under the
 * terms of the Eclipse Public License 2.0 which is available at
 * http://www.eclipse.org/legal/epl-2.0.
 *
 * SPDX-License-Identifier: EPL-2.0
 * Contributors: see AUTHORS file
 *******************************************************************************/
#include "PvdFileWriter2D.h"
#include <experimental/filesystem>
#include <fstream>

using namespace std;

namespace nablalib
{
PvdFileWriter2D::PvdFileWriter2D(const string& moduleName, const string& baseDirName)
: FileWriter(moduleName, baseDirName)
{
}

PvdFileWriter2D::~PvdFileWriter2D() {}

void
PvdFileWriter2D::writeFile(
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

	const string fileName = m_module_name + "." + to_string(iteration) + ".vtp";
	ofstream vtpWriter;
	vtpWriter.open(m_directory_name + "/" + fileName);

	vtpWriter << "<?xml version=\"1.0\"?>" << endl;
	vtpWriter << "<VTKFile type=\"PolyData\">" << endl;
	vtpWriter << "	<PolyData>" << endl;
	vtpWriter << "		<Piece NumberOfPoints=\"" << nbNodes << "\" NumberOfPolys=\"" << nbCells << "\">" << endl;
	vtpWriter << "			<Points>" << endl;
	vtpWriter << "				<DataArray type=\"Float32\" NumberOfComponents=\"3\" format=\"ascii\">" << endl;
	for (int r=0 ; r<nbNodes ; ++r)
		vtpWriter << " " << nodes[r][0] << " " << nodes[r][1] << " " << 0.0;
	vtpWriter << endl;
	vtpWriter << "				</DataArray>" << endl;
	vtpWriter << "			</Points>" << endl;
	vtpWriter << "			<Polys>" << endl;
	vtpWriter << "				<DataArray type=\"Int32\" Name=\"connectivity\" format=\"ascii\">" << endl;
	for (int j=0 ; j<nbCells ; ++j)
	{
		vtpWriter << " ";
		for (auto nodeId : cells[j].getNodeIds())
			vtpWriter << " " << nodeId;
	}
	vtpWriter << endl;
	vtpWriter << "				</DataArray>" << endl;
	vtpWriter << "				<DataArray type=\"Int32\" Name=\"offsets\" format=\"ascii\">" << endl;
	for (int j=1 ; j<=nbCells ; ++j)
		vtpWriter << " " << j * 4;
	vtpWriter << endl;
	vtpWriter << "				</DataArray>" << endl;
	vtpWriter << "			</Polys>" << endl;

	// POINT DATA
	if (!nodeVariables.empty())
	{
		vtpWriter << "			<PointData Scalars=\"" + nodeVariables.begin()->first + "\">" << endl;
		for (auto itr = nodeVariables.begin() ; itr != nodeVariables.end() ; itr++)
		{
			vtpWriter << "				<DataArray Name=\"" + itr->first + "\" type=\"Float32\" format=\"ascii\">" << endl;
			for (int r=0 ; r<nbNodes ; ++r) vtpWriter << " " << itr->second[r];
			vtpWriter << endl;
			vtpWriter << "				</DataArray>" << endl;
		}
		vtpWriter << "			</PointData>" << endl;
	}

	// CELL DATA
	if (!cellVariables.empty())
	{
		vtpWriter << "			<CellData Scalars=\"" + cellVariables.begin()->first + "\">" << endl;
		for (auto itr = cellVariables.begin() ; itr != cellVariables.end() ; itr++)
		{
			vtpWriter << "				<DataArray Name=\"" + itr->first + "\" type=\"Float32\" format=\"ascii\">" << endl;
			for (int j=0 ; j<nbCells ; ++j) vtpWriter << " " << itr->second[j];
			vtpWriter << endl;
			vtpWriter << "				</DataArray>" << endl;
		}
		vtpWriter << "			</CellData>" << endl;
	}
	vtpWriter << "		</Piece>" << endl;
	vtpWriter << "	</PolyData>" << endl;
	vtpWriter << "</VTKFile>" << endl;
	vtpWriter.close();
	m_file_name_by_times[time] = fileName;

	ofstream pvdWriter;
	pvdWriter.open(m_directory_name + "/" + m_module_name + ".pvd");
	pvdWriter << "<?xml version=\"1.0\"?>" << endl;
	pvdWriter << "<VTKFile type=\"Collection\" version=\"0.1\">" << endl;
	pvdWriter << "	<Collection>" << endl;
	for (auto itr = m_file_name_by_times.begin() ; itr != m_file_name_by_times.end() ; itr++)
		pvdWriter << "			<DataSet timestep=\"" << itr->first << "\" group=\"\" part=\"0\" file=\"" + itr->second + "\"/>" << endl;
	pvdWriter << "	</Collection>" << endl;
	pvdWriter << "</VTKFile>" << endl;
	pvdWriter.close();
}
}
