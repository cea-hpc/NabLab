/*******************************************************************************
 * Copyright (c) 2018 CEA
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
import java.util.Map

class VtkFileWriter2D extends FileWriter
{
	new(String moduleName) 
	{
		super(moduleName) 
	}
	
	override writeFile(int iteration, double time, double[][] nodes, Quad[] cells, Map<String, double[]> cellVariables, Map<String, double[]> nodeVariables)
	{
		try {
			
			val writer = new PrintWriter(OutputDir + '/' + moduleName + '.' + iteration + '.vtk', 'UTF-8')
			
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
			if (! (nodeVariables === null || nodeVariables.empty))
			{
				writer.println('\nDATA_DATA ' + nodes.size)
				for (nodeVariableName : nodeVariables.keySet)
				{
					writer.println('SCALARS ' + nodeVariableName + ' float 1')
					writer.println('LOOKUP_TABLE default')
					nodeVariables.get(nodeVariableName).forEach[x | writer.println(x)]
				}
			}

			// CELL DATA
			if (! (cellVariables === null || cellVariables.empty))
			{
				writer.println('\nCELL_DATA ' + cells.size)
				for (cellVariableName : cellVariables.keySet)
				{
					writer.println('SCALARS ' + cellVariableName + ' float 1')
					writer.println('LOOKUP_TABLE default')
					cellVariables.get(cellVariableName).forEach[x | writer.println(x)]
				}
			}
			
			writer.close
		} catch (FileNotFoundException e) {
			e.printStackTrace();
		} catch (UnsupportedEncodingException e) {
			e.printStackTrace();
		}
	}	
}
