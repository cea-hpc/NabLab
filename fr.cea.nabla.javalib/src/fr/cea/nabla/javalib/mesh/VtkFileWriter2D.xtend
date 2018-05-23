package fr.cea.nabla.javalib.mesh

import fr.cea.nabla.javalib.mesh.Mesh
import fr.cea.nabla.javalib.types.Real2
import java.io.FileNotFoundException
import java.io.PrintWriter
import java.io.UnsupportedEncodingException
import java.util.HashMap

class VtkFileWriter2D
{
	val String moduleName
	val Mesh<Real2> mesh
	val nodeVariables = new HashMap<String, double[]>
	val cellVariables = new HashMap<String, double[]>

	new(String moduleName, Mesh<Real2> mesh) 
	{ 
		this.moduleName = moduleName
		this.mesh = mesh
		
	}
	
	def addNodeVariable(String name, double[] v) { nodeVariables.put(name, v) }
	def addCellVariable(String name, double[] v) { cellVariables.put(name, v) }

	def writeFile(int iteration)
	{
		if (cellVariables.empty && nodeVariables.empty) return;
		
		try {
			val writer = new PrintWriter('output/' + moduleName + '.' + iteration + '.vtk', 'UTF-8')
			writer.println('# vtk DataFile Version 2.0')
			writer.println(moduleName + ' at iteration ' + iteration)
			writer.println('ASCII')
			writer.println('DATASET POLYDATA')
			
			writer.println('POINTS ' + mesh.nodes.length + ' float')
			for (node : mesh.nodes) writer.println(node.x + "\t" + node.y + "\t" + 0.0)

			val cells = mesh.quads
			writer.println('POLYGONS ' + cells.size + ' ' + cells.size * 5)
			cells.forEach[writer.println('4\t' + nodeIds.join('\t'))]

			// POINT DATA
			if (! nodeVariables.empty) writer.println('\nDATA_DATA ' + mesh.nodes.size)
			for (variableName : nodeVariables.keySet)
			{
				writer.println('SCALARS ' + variableName + ' float 1')
				writer.println('LOOKUP_TABLE default')
				nodeVariables.get(variableName).forEach[x | writer.println(x)]
			}

			// CELL DATA
			if (! cellVariables.empty) writer.println('\nCELL_DATA ' + cells.size)
			for (variableName : cellVariables.keySet)
			{
				writer.println('SCALARS ' + variableName + ' float 1')
				writer.println('LOOKUP_TABLE default')
				cellVariables.get(variableName).forEach[x | writer.println(x)]
			}
			
			writer.close
		} catch (FileNotFoundException e) {
			e.printStackTrace();
		} catch (UnsupportedEncodingException e) {
			e.printStackTrace();
		}
	}	
}
