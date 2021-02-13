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
import java.text.DecimalFormat;
import java.text.NumberFormat;
import java.util.LinkedHashMap;

public class PvdFileWriter2D extends FileWriter
{
	private LinkedHashMap<Double, String> fileNameByTimes = new LinkedHashMap<Double, String>();

	public PvdFileWriter2D( String moduleName,  String directoryName)
	{
		super(moduleName, directoryName);
	}

	@Override
	public void writeFile(VtkFileContent it) {
		if (!isDisabled())
		{
			NumberFormat formatter = new DecimalFormat("#0.######");     
			try {
				String fileName = moduleName + "." + it.getIteration() + ".vtp";
				PrintWriter vtpWriter = new PrintWriter(directoryName + "/" + fileName, "UTF-8");
				vtpWriter.println("<?xml version=\"1.0\"?>");
				vtpWriter.println("<VTKFile type=\"PolyData\">");
				vtpWriter.println("\t<PolyData>");
				vtpWriter.println("\t\t<Piece NumberOfPoints=\"" + it.getNodes().length + "\" NumberOfPolys=\"" + it.getCells().length + "\">");
				vtpWriter.println("\t\t\t<Points>");
				vtpWriter.println("\t\t\t\t<DataArray type=\"Float32\" NumberOfComponents=\"3\" format=\"ascii\">");
				for (double[] node : it.getNodes())
					vtpWriter.print(" " + node[0] + " " + node[1] + " 0.0");
				vtpWriter.println("");
				vtpWriter.println("\t\t\t\t</DataArray>");
				vtpWriter.println("\t\t\t</Points>");
				vtpWriter.println("\t\t\t<Polys>");
				vtpWriter.println("\t\t\t\t<DataArray type=\"Int32\" Name=\"connectivity\" format=\"ascii\">");				 
				for (int i = 0; i < it.getCells().length; i++)
				{
					vtpWriter.print(" ");
					for (int j = 0; j < it.getCells()[i].getNodeIds().length; j++)
						vtpWriter.print(it.getCells()[i].getNodeIds()[j] + (j < it.getCells()[i].getNodeIds().length -1 ? " " : ""));
				}
				vtpWriter.println("");
				vtpWriter.println("\t\t\t\t</DataArray>");
				vtpWriter.println("\t\t\t\t<DataArray type=\"Int32\" Name=\"offsets\" format=\"ascii\">");
				for (int i = 1; i <= it.getCells().length; i++)
					vtpWriter.print((" " + i * 4));
				vtpWriter.println("");
				vtpWriter.println("\t\t\t\t</DataArray>");
				vtpWriter.println("\t\t\t</Polys>");

				// POINT DATA
				if (it.hasNodeData()) {
					vtpWriter.println("\t\t\t<PointData>");
					for (String nodeVariableName : it.getNodeScalars().keySet()) {
						{
							vtpWriter.println("\t\t\t\t<DataArray Name=\"" + nodeVariableName + "\" type=\"Float32\" format=\"ascii\">");
							for (double x : it.getNodeScalars().get(nodeVariableName))
								vtpWriter.print((" " + x));
							vtpWriter.println("");
							vtpWriter.println("\t\t\t\t</DataArray>");
						}
					}
					for (String nodeVariableName : it.getNodeVectors().keySet()) {
						double[][] vectors = it.getNodeVectors().get(nodeVariableName);

						vtpWriter.println("\t\t\t\t<DataArray Name=\"" + nodeVariableName + "\" type=\"Float32\" NumberOfComponents=\"" + vectors[0].length +  "\" format=\"ascii\">");
						for ( double[] vector : vectors) {
							for (double x : vector)
								vtpWriter.print(" " + x);
							vtpWriter.println("");
							vtpWriter.println("\t\t\t\t</DataArray>");
						}
					}
					vtpWriter.println("\t\t\t</PointData>");
				}

				// CELL DATA
				if (it.hasCellData()) {
					vtpWriter.println("\t\t\t<CellData>");
					for ( String cellVariableName : it.getCellScalars().keySet()) {
						{
							vtpWriter.println("\t\t\t\t<DataArray Name=\"" + cellVariableName + "\" type=\"Float32\" format=\"ascii\">");
							for (double x : it.getCellScalars().get(cellVariableName))
								vtpWriter.print(" " + x);
							vtpWriter.println("");
							vtpWriter.println("\t\t\t\t</DataArray>");
						}
					}
					for ( String cellVariableName : it.getCellVectors().keySet()) {
						{
							double[][] vectors = it.getCellVectors().get(cellVariableName);
							vtpWriter.println("\t\t\t\t<DataArray Name=\"" + cellVariableName + "\" type=\"Float32\" NumberOfComponents=\"" + vectors[0].length + "\" format=\"ascii\">");
							for ( double[] vector : vectors) {
								for (double x : vector)
									vtpWriter.print(" " + x);
							}
							vtpWriter.println("");
							vtpWriter.println("\t\t\t\t</DataArray>");
						}
					}
					vtpWriter.println("\t\t\t</CellData>");
				}
				vtpWriter.println("\t\t</Piece>");
				vtpWriter.println("\t</PolyData>");
				vtpWriter.println("</VTKFile>");
				vtpWriter.close();
				this.fileNameByTimes.put(it.getTime(), fileName);

				PrintWriter pvdWriter = new PrintWriter(directoryName + "/" + moduleName + ".pvd", "UTF-8");
				pvdWriter.println("<?xml version=\"1.0\"?>");
				pvdWriter.println("<VTKFile type=\"Collection\" version=\"0.1\">");
				pvdWriter.println("\t\t<Collection>");
				for ( Double t : fileNameByTimes.keySet())
					pvdWriter.println("\t\t\t<DataSet timestep=\"" + formatter.format(t) + "\" group=\"\" part=\"0\" file=\"" + fileNameByTimes.get(t) + "\"/>");
				pvdWriter.println("\t\t</Collection>");
				pvdWriter.println("</VTKFile>");
				pvdWriter.close();
			} 
			catch (FileNotFoundException | UnsupportedEncodingException e) { e.printStackTrace(); }
		}
	}
}
