/**
 * Copyright (c) 2020 CEA
 * This program and the accompanying materials are made available under the
 * terms of the Eclipse Public License 2.0 which is available at
 * http://www.eclipse.org/legal/epl-2.0.
 * 
 * SPDX-License-Identifier: EPL-2.0
 * Contributors: see AUTHORS file
 */
package fr.cea.nabla.javalib.mesh;

import java.io.FileNotFoundException;
import java.io.PrintWriter;
import java.io.UnsupportedEncodingException;


public class VtkFileWriter2D extends FileWriter {
	public VtkFileWriter2D( String moduleName,  String directoryName) {
		super(moduleName, directoryName);
	}

	@Override
	public void writeFile( VtkFileContent it) 
	{
		if (!isDisabled()) 
		{
			try 
			{
				PrintWriter writer = new PrintWriter(directoryName + "/" + moduleName + "." + it.getIteration() + ".vtk", "UTF-8");

				writer.println("# vtk DataFile Version 2.0");
				writer.println(moduleName + " at iteration " + it.getIteration());
				writer.println("ASCII");
				writer.println("DATASET POLYDATA");

				writer.println("FIELD FieldData 1");
				writer.println("TIME 1 1 double");
				writer.println(it.getTime());

				writer.println("POINTS " + it.getNodes().length + " float");
				for (double[] n : it.getNodes())
					writer.println(n[0] + "\t" + n[1] + "\t" + 0.0);

				writer.println("POLYGONS " + it.getCells().length + " " + it.getCells().length * 5);
				for (Quad q : it.getCells())
				{
					writer.print("4\t");
					for (int i = 0; i < q.getNodeIds().length ; i++)
						writer.print(q.getNodeIds()[i] + (i < q.getNodeIds().length -1 ? "\t" : ""));
					writer.print("\n");	 
				}

				// POINT DATA
				if (it.hasNodeData()) 
				{
					writer.println("\nDATA_DATA " + it.getNodes().length);
					for (String nodeVariableName : it.getNodeScalars().keySet()) 
					{
						writer.println("SCALARS " + nodeVariableName + " float 1");
						writer.println("LOOKUP_TABLE default");
						for (double x : it.getNodeScalars().get(nodeVariableName))
							writer.println(x);
					}
					if (!it.getNodeVectors().isEmpty())
						System.out.println("* Warning: vectors serialization not yet implemented. Use pvd format.");
				}

				// CELL DATA        
				if (it.hasCellData()) 
				{
					writer.println("\nCELL_DATA " + it.getCells().length);
					for ( String cellVariableName :  it.getCellScalars().keySet()) 
					{
						writer.println("SCALARS " + cellVariableName + " float 1");
						writer.println("LOOKUP_TABLE default");
						for (double x : it.getCellScalars().get(cellVariableName))
							writer.println(x);
					}
				}
				if (!it.getCellVectors().isEmpty()) 
					System.out.println("* Warning: vectors serialization not yet implemented. Use pvd format.");

				writer.close();
			} 
			catch ( FileNotFoundException | UnsupportedEncodingException e) {
				e.printStackTrace();
			}
		}
	}
}

