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
 * 	Jean-Sylvan Camier - Nabla generation support
 *******************************************************************************/
package fr.cea.nabla.javalib.mesh

import fr.cea.nabla.javalib.types.Real2
import java.io.FileNotFoundException
import java.io.PrintWriter
import java.io.UnsupportedEncodingException
import java.io.File

class VtkFileWriter2D
{
	val String moduleName

	new(String moduleName) 
	{ 
		this.moduleName = moduleName
		val outputDir = new File('output')
		if (outputDir.exists)
			outputDir.listFiles.forEach[x | x.delete]
		else
			outputDir.mkdir
	}
	
	def writeFile(int iteration, Real2[] nodes, Quad[] cells, Iterable<Pair<String, double[]>> cellVariables, Iterable<Pair<String, double[]>> nodeVariables)
	{
		try {
			
			val writer = new PrintWriter('output/' + moduleName + '.' + iteration + '.vtk', 'UTF-8')
			writer.println('# vtk DataFile Version 2.0')
			writer.println(moduleName + ' at iteration ' + iteration)
			writer.println('ASCII')
			writer.println('DATASET POLYDATA')
			
			writer.println('POINTS ' + nodes.length + ' float')
			for (node : nodes) writer.println(node.x + "\t" + node.y + "\t" + 0.0)

			writer.println('POLYGONS ' + cells.size + ' ' + cells.size * 5)
			cells.forEach[writer.println('4\t' + nodeIds.join('\t'))]

			// POINT DATA
			if (! (nodeVariables === null || nodeVariables.empty))
			{
				writer.println('\nDATA_DATA ' + nodes.size)
				for (nodeVariable : nodeVariables)
				{
					writer.println('SCALARS ' + nodeVariable.key + ' float 1')
					writer.println('LOOKUP_TABLE default')
					nodeVariable.value.forEach[x | writer.println(x)]
				}
			}

			// CELL DATA
			if (! (cellVariables === null || cellVariables.empty))
			{
				writer.println('\nCELL_DATA ' + cells.size)
				for (cellVariable : cellVariables)
				{
					writer.println('SCALARS ' + cellVariable.key + ' float 1')
					writer.println('LOOKUP_TABLE default')
					cellVariable.value.forEach[x | writer.println(x)]
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
