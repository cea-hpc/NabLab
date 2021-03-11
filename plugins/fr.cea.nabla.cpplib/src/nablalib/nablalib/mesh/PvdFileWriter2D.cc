/*******************************************************************************
 * Copyright (c) 2020 CEA
 * This program and the accompanying materials are made available under the
 * terms of the Eclipse Public License 2.0 which is available at
 * http://www.eclipse.org/legal/epl-2.0.
 *
 * SPDX-License-Identifier: EPL-2.0
 * Contributors: see AUTHORS file
 *******************************************************************************/
#include <filesystem>

#include "PvdFileWriter2D.h"

using namespace std;

namespace nablalib::mesh
{
PvdFileWriter2D::PvdFileWriter2D(const string& moduleName, const string& directoryName)
: m_module_name(moduleName)
, m_directory_name(directoryName)
, m_state(closed)
{
	if (!isDisabled() && !filesystem::exists(m_directory_name))
		filesystem::create_directory(m_directory_name);
}

PvdFileWriter2D::~PvdFileWriter2D() {}

void
PvdFileWriter2D::startVtpFile(
		const int& iteration,
		const double& time,
		const size_t& nbNodes,
		const RealArray1D<2>* nodes,
		const size_t& nbCells,
		const Quad* cells)
{
	if (isDisabled()) return;
	changeState(closed, ready);

	const string fileName = m_module_name + "." + to_string(iteration) + ".vtp";
	m_file_name_by_times[time] = fileName;
	m_vtp_writer.open(m_directory_name + "/" + fileName);

	m_vtp_writer << "<?xml version=\"1.0\"?>" << endl;
	m_vtp_writer << "<VTKFile type=\"PolyData\">" << endl;
	m_vtp_writer << "	<PolyData>" << endl;
	m_vtp_writer << "		<Piece NumberOfPoints=\"" << nbNodes << "\" NumberOfPolys=\"" << nbCells << "\">" << endl;
	m_vtp_writer << "			<Points>" << endl;
	m_vtp_writer << "				<DataArray type=\"Float32\" NumberOfComponents=\"3\" format=\"ascii\">" << endl;
	for (size_t r=0 ; r<nbNodes ; ++r)
		m_vtp_writer << " " << nodes[r][0] << " " << nodes[r][1] << " " << 0.0;
	m_vtp_writer << endl;
	m_vtp_writer << "				</DataArray>" << endl;
	m_vtp_writer << "			</Points>" << endl;
	m_vtp_writer << "			<Polys>" << endl;
	m_vtp_writer << "				<DataArray type=\"Int32\" Name=\"connectivity\" format=\"ascii\">" << endl;
	for (size_t j=0 ; j<nbCells ; ++j)
	{
		m_vtp_writer << " ";
		for (auto nodeId : cells[j].getNodeIds())
			m_vtp_writer << " " << nodeId;
	}
	m_vtp_writer << endl;
	m_vtp_writer << "				</DataArray>" << endl;
	m_vtp_writer << "				<DataArray type=\"Int32\" Name=\"offsets\" format=\"ascii\">" << endl;
	for (size_t j=1 ; j<=nbCells ; ++j)
		m_vtp_writer << " " << j * 4;
	m_vtp_writer << endl;
	m_vtp_writer << "				</DataArray>" << endl;
	m_vtp_writer << "			</Polys>" << endl;
}

void
PvdFileWriter2D::openNodeData()
{
	if (isDisabled()) return;
	changeState(ready, onNodes);
	m_vtp_writer << "			<PointData>" << endl;
}

void
PvdFileWriter2D::openCellData()
{
	if (isDisabled()) return;
	changeState(nodesFinished, onCells);
	m_vtp_writer << "			<CellData>" << endl;
}

void
PvdFileWriter2D::openNodeArray(const string& name, const int& arraySize)
{
	if (isDisabled()) return;
	changeState(onNodes, onNodeArray);
	m_vtp_writer << "				<DataArray Name=\"" + name + "\" type=\"Float32\" NumberOfComponents=\"" + to_string(arraySize) + "\" format=\"ascii\">" << endl;
}

void
PvdFileWriter2D::openCellArray(const string& name, const int& arraySize)
{
	if (isDisabled()) return;
	changeState(onCells, onCellArray);
	m_vtp_writer << "				<DataArray Name=\"" + name + "\" type=\"Float32\" NumberOfComponents=\"" + to_string(arraySize) + "\" format=\"ascii\">" << endl;
}

void
PvdFileWriter2D::closeNodeArray()
{
	if (isDisabled()) return;
	changeState(onNodeArray, onNodes);
	m_vtp_writer << endl;
	m_vtp_writer << "				</DataArray>" << endl;
}

void
PvdFileWriter2D::closeCellArray()
{
	if (isDisabled()) return;
	changeState(onCellArray, onCells);
	m_vtp_writer << endl;
	m_vtp_writer << "				</DataArray>" << endl;
}

void
PvdFileWriter2D::closeNodeData()
{
	if (isDisabled()) return;
	changeState(onNodes, nodesFinished);
	m_vtp_writer << "			</PointData>" << endl;
}

void
PvdFileWriter2D::closeCellData()
{
	if (isDisabled()) return;
	changeState(onCells, cellsFinished);
	m_vtp_writer << "			</CellData>" << endl;
}

void
PvdFileWriter2D::closeVtpFile()
{
	if (isDisabled()) return;
	changeState(cellsFinished, closed);
	m_vtp_writer << "		</Piece>" << endl;
	m_vtp_writer << "	</PolyData>" << endl;
	m_vtp_writer << "</VTKFile>" << endl;
	m_vtp_writer.close();

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

void
PvdFileWriter2D::changeState(const State& expectedState, const State& newState)
{
	if (m_state != expectedState)
	{
		ostringstream stringStream;
		stringStream << "Unexpected pvd file writer state. Expected: ";
		stringStream << expectedState;
		stringStream << ", but was: ";
		stringStream << m_state;
		throw runtime_error(stringStream.str());
	}
	m_state = newState;
}
}
