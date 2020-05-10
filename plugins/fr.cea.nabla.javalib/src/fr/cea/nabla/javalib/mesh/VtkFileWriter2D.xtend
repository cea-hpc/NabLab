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

class VtkFileWriter2D extends FileWriter
{
	new(String moduleName, String directoryName)
	{
		super(moduleName, directoryName)
	}

	override writeFile(VtkFileContent it)
	{
		if (!disabled)
		{
			try
			{
				val writer = new PrintWriter(directoryName + '/' + moduleName + '.' + iteration + '.vtk', 'UTF-8')

				writer.println('# vtk DataFile Version 2.0')
				writer.println(moduleName + ' at iteration ' + iteration)
				writer.println('ASCII')
				writer.println('DATASET POLYDATA')

				writer.println('FIELD FieldData 1')
				writer.println('TIME 1 1 double')
				writer.println(time)

				writer.println('POINTS ' + nodes.size + ' float')
				nodes.forEach[n | writer.println(n.get(0) + "\t" + n.get(1) + "\t" + 0.0)]

				writer.println('POLYGONS ' + cells.size + ' ' + cells.size * 5)
				cells.forEach[writer.println('4\t' + nodeIds.join('\t'))]

				// POINT DATA
				if (hasNodeData)
				{
					writer.println('\nDATA_DATA ' + nodes.size)
					for (nodeVariableName : nodeScalars.keySet)
					{
						writer.println('SCALARS ' + nodeVariableName + ' float 1')
						writer.println('LOOKUP_TABLE default')
						nodeScalars.get(nodeVariableName).forEach[x | writer.println(x)]
					}
					if (!nodeVectors.empty)
						println("* Warning: vectors serialization not yet implemented. Use pvd format.")
				}

				// CELL DATA
				if (hasCellData)
				{
					writer.println('\nCELL_DATA ' + cells.size)
					for (cellVariableName : cellScalars.keySet)
					{
						writer.println('SCALARS ' + cellVariableName + ' float 1')
						writer.println('LOOKUP_TABLE default')
						cellScalars.get(cellVariableName).forEach[x | writer.println(x)]
					}
					if (!cellVectors.empty)
						println("* Warning: vectors serialization not yet implemented. Use pvd format.")
				}

				writer.close
			}
			catch (FileNotFoundException e)
			{
				e.printStackTrace
			} 
			catch (UnsupportedEncodingException e)
			{
				e.printStackTrace
			}
		}
	}
}
