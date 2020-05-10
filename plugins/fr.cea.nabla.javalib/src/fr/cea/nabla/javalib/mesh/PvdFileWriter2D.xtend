/*******************************************************************************
 * Copyright (c) 2020 CEA
 * This program and the accompanying materials are made available under the 
 * terms of the Eclipse Public License 2.0 which is available at
 * http://www.eclipse.org/legal/epl-2.0.
 *
 * SPDX-License-Identifier: EPL-2.0
 * Contributors: see AUTHORS file
 *******************************************************************************/
package fr.cea.nabla.javalib.mesh

import java.io.FileNotFoundException
import java.io.PrintWriter
import java.io.UnsupportedEncodingException
import java.util.LinkedHashMap
import java.util.Map

class PvdFileWriter2D extends FileWriter
{
	val fileNameByTimes = new LinkedHashMap<Double, String>

	new(String moduleName, String directoryName)
	{ 
		super(moduleName, directoryName)
	}

	// Points in 3D needed for Paraview
	override writeFile(VtkFileContent it)
	{
		if (!disabled)
		{
			try
			{
				val fileName = moduleName + '.' + iteration + '.vtp'
				val vtpWriter = new PrintWriter(directoryName + '/' + fileName, 'UTF-8')
				vtpWriter.println('<?xml version="1.0"?>')
				vtpWriter.println('<VTKFile type="PolyData">')
				vtpWriter.println('	<PolyData>')
				vtpWriter.println('		<Piece NumberOfPoints="' + nodes.size + '" NumberOfPolys="' + cells.size + '">')
				vtpWriter.println('			<Points>')
				vtpWriter.println('				<DataArray type="Float32" NumberOfComponents="3" format="ascii">')
				nodes.forEach[n | vtpWriter.print(' ' + n.get(0) + ' ' + n.get(1) + ' 0.0')]
				vtpWriter.println('')
				vtpWriter.println('				</DataArray>')
				vtpWriter.println('			</Points>')
				vtpWriter.println('			<Polys>')
				vtpWriter.println('				<DataArray type="Int32" Name="connectivity" format="ascii">')
				cells.forEach[vtpWriter.print(' ' + nodeIds.join(' '))]
				vtpWriter.println('')
				vtpWriter.println('				</DataArray>')
				vtpWriter.println('				<DataArray type="Int32" Name="offsets" format="ascii">')
				for (i : 1..cells.size) vtpWriter.print(' ' + i * 4)
				vtpWriter.println('')
				vtpWriter.println('				</DataArray>')
				vtpWriter.println('			</Polys>')

				// POINT DATA
				if (hasNodeData)
				{
					vtpWriter.println('			<PointData' + nodeScalars.activeScalarIfExist + '>')
					for (nodeVariableName : nodeScalars.keySet)
					{
						vtpWriter.println('				<DataArray Name="' + nodeVariableName + '" type="Float32" format="ascii">')
						nodeScalars.get(nodeVariableName).forEach[x | vtpWriter.print(' ' + x)]
						vtpWriter.println('')
						vtpWriter.println('				</DataArray>')
					}
					for (nodeVariableName : nodeVectors.keySet)
					{
						val vectors = nodeVectors.get(nodeVariableName)
						vtpWriter.println('				<DataArray Name="' + nodeVariableName + '" type="Float32" NumberOfComponents="' + vectors.get(0).size + '" format="ascii">')
						for (vector : vectors)
							vector.forEach[x | vtpWriter.print(' ' + x)]
						vtpWriter.println('')
						vtpWriter.println('				</DataArray>')
					}
					vtpWriter.println('			</PointData>')
				}

				// CELL DATA
				if (hasCellData)
				{
					vtpWriter.println('			<CellData' + cellScalars.activeScalarIfExist + '>')
					for (cellVariableName : cellScalars.keySet)
					{
						vtpWriter.println('				<DataArray Name="' + cellVariableName + '" type="Float32" format="ascii">')
						cellScalars.get(cellVariableName).forEach[x | vtpWriter.print(' ' + x)]
						vtpWriter.println('')
						vtpWriter.println('				</DataArray>')
					}
					for (cellVariableName : cellVectors.keySet)
					{
						val vectors = cellVectors.get(cellVariableName)
						vtpWriter.println('				<DataArray Name="' + cellVariableName + '" type="Float32" NumberOfComponents="' + vectors.get(0).size + '" format="ascii">')
						for (vector : vectors)
							vector.forEach[x | vtpWriter.print(' ' + x)]
						vtpWriter.println('')
						vtpWriter.println('				</DataArray>')
					}
					vtpWriter.println('			</CellData>')
				}
				vtpWriter.println('		</Piece>')
				vtpWriter.println('	</PolyData>')
				vtpWriter.println('</VTKFile>')
				vtpWriter.close
				fileNameByTimes.put(time, fileName)

				val pvdWriter = new PrintWriter(directoryName + '/' + moduleName + '.pvd', 'UTF-8')
				pvdWriter.println('<?xml version="1.0"?>')
				pvdWriter.println('<VTKFile type="Collection" version="0.1">')
				pvdWriter.println('		<Collection>')
				for (t : fileNameByTimes.keySet)
					pvdWriter.println('			<DataSet timestep="' + t + '" group="" part="0" file="' + fileNameByTimes.get(t) + '"/>')
				pvdWriter.println('		</Collection>')
				pvdWriter.println('</VTKFile>')
				pvdWriter.close
			} catch (FileNotFoundException e) {
				e.printStackTrace
			} catch (UnsupportedEncodingException e) {
				e.printStackTrace
			}
		}
	}

	private def String getActiveScalarIfExist(Map<String, double[]> data)
	{
		if (data.empty) ""
		else ' Scalars="' + data.keySet.get(0) + '"'
	}
}
