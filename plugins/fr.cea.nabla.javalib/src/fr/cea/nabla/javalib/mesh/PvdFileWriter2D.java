/**
 * Copyright (c) 2021 CEA
 * This program and the accompanying materials are made available under the
 * terms of the Eclipse Public License 2.0 which is available at
 * http://www.eclipse.org/legal/epl-2.0.
 * 
 * SPDX-License-Identifier: EPL-2.0
 * Contributors: see AUTHORS file
 */
package fr.cea.nabla.javalib.mesh;

import java.io.File;
import java.io.FileNotFoundException;
import java.io.PrintWriter;
import java.util.LinkedHashMap;
import java.util.Map;
import java.util.logging.Level;
import java.util.logging.Logger;

public class PvdFileWriter2D
{
	enum State { closed, ready, onNodes, nodesFinished, onCells, cellsFinished, onNodeArray, onCellArray };

	private PrintWriter vtpWriter;
	private LinkedHashMap<Double, String> fileNameByTimes;
	private String moduleName;
	private String directoryName;
	private State state;
	private Logger logger;

	public PvdFileWriter2D(final String moduleName, final String directoryName)
	{
		this.fileNameByTimes = new LinkedHashMap<Double, String>();
		this.moduleName = moduleName;
		this.directoryName = directoryName;
		this.state = State.closed;

		if (!isDisabled())
		{
			File outputDir = new File(directoryName);
			if (!outputDir.exists())
				outputDir.mkdir();
		}
	}

	public void setLogger(Logger value)
	{
		this.logger = value;
	}

	public boolean isDisabled()
	{
		return (directoryName == null || directoryName.isEmpty());
	}

	public String getOutputDirectory()
	{
		return directoryName;
	}

	public void startVtpFile(final int iteration, final double time, final double[][] nodes, final Quad[] cells) throws FileNotFoundException
	{
		if (isDisabled()) return;
		changeState(State.closed, State.ready);

		final String fileName = moduleName + "." + iteration + ".vtp";
		if (logger == null)
			System.out.println("Writing vtp file: " + fileName);
		else
			logger.log(Level.INFO, "Writing vtp file: " + fileName);

		fileNameByTimes.put(time, fileName);
		vtpWriter = new PrintWriter(directoryName + "/" + fileName);

		vtpWriter.println("<?xml version=\"1.0\"?>");
		vtpWriter.println("<VTKFile type=\"PolyData\">");
		vtpWriter.println("	<PolyData>");
		vtpWriter.println("		<Piece NumberOfPoints=\"" + nodes.length + "\" NumberOfPolys=\"" + cells.length + "\">");
		vtpWriter.println("			<Points>");
		vtpWriter.println("				<DataArray type=\"Float32\" NumberOfComponents=\"3\" format=\"ascii\">");
		for (int r=0 ; r<nodes.length ; ++r)
			vtpWriter.print(" " + nodes[r][0] + " " + nodes[r][1] + " " + 0.0);
		vtpWriter.println();
		vtpWriter.println("				</DataArray>");
		vtpWriter.println("			</Points>");
		vtpWriter.println("			<Polys>");
		vtpWriter.println("				<DataArray type=\"Int32\" Name=\"connectivity\" format=\"ascii\">");
		for (int j=0 ; j<cells.length ; ++j)
		{
			vtpWriter.print(" ");
			for (int nodeId : cells[j].getNodeIds())
				vtpWriter.print(" " + nodeId);
		}
		vtpWriter.println();
		vtpWriter.println("				</DataArray>");
		vtpWriter.println("				<DataArray type=\"Int32\" Name=\"offsets\" format=\"ascii\">");
		for (int j=1 ; j<=cells.length ; ++j)
			vtpWriter.print(" " + j * 4);
		vtpWriter.println();
		vtpWriter.println("				</DataArray>");
		vtpWriter.println("			</Polys>");
	}

	public void openNodeData()
	{
		if (isDisabled()) return;
		changeState(State.ready, State.onNodes);
		vtpWriter.println("			<PointData>");
	}

	public void openCellData()
	{
		if (isDisabled()) return;
		changeState(State.nodesFinished, State.onCells);
		vtpWriter.println("			<CellData>");
	}

	public void openNodeArray(final String name, final int arraySize)
	{
		if (isDisabled()) return;
		changeState(State.onNodes, State.onNodeArray);
		vtpWriter.println("				<DataArray Name=\"" + name + "\" type=\"Float32\" NumberOfComponents=\"" + arraySize + "\" format=\"ascii\">");
	}

	public void openCellArray(final String name, final int arraySize)
	{
		if (isDisabled()) return;
		changeState(State.onCells, State.onCellArray);
		vtpWriter.println("				<DataArray Name=\"" + name + "\" type=\"Float32\" NumberOfComponents=\"" + arraySize + "\" format=\"ascii\">");
	}

	public void closeNodeData()
	{
		if (isDisabled()) return;
		changeState(State.onNodes, State.nodesFinished);
		vtpWriter.println("			</PointData>");
	}

	public void closeCellData()
	{
		if (isDisabled()) return;
		changeState(State.onCells, State.cellsFinished);
		vtpWriter.println("			</CellData>");
	}

	public void closeNodeArray()
	{
		if (isDisabled()) return;
		changeState(State.onNodeArray, State.onNodes);
		vtpWriter.println();
		vtpWriter.println("				</DataArray>");
	}

	public void closeCellArray()
	{
		if (isDisabled()) return;
		changeState(State.onCellArray, State.onCells);
		vtpWriter.println();
		vtpWriter.println("				</DataArray>");
	}

	public void closeVtpFile() throws FileNotFoundException
	{
		if (isDisabled()) return;
		changeState(State.cellsFinished, State.closed);
		vtpWriter.println("		</Piece>");
		vtpWriter.println("	</PolyData>");
		vtpWriter.println("</VTKFile>");
		vtpWriter.close();

		String fileName = directoryName + "/" + moduleName + ".pvd";
		PrintWriter pvdWriter = new PrintWriter(fileName);
		pvdWriter.println("<?xml version=\"1.0\"?>");
		pvdWriter.println("<VTKFile type=\"Collection\" version=\"0.1\">");
		pvdWriter.println("	<Collection>");
		for (Map.Entry<Double, String> e : fileNameByTimes.entrySet())
			pvdWriter.println("			<DataSet timestep=\"" + e.getKey() + "\" group=\"\" part=\"0\" file=\"" + e.getValue() + "\"/>");
		pvdWriter.println("	</Collection>");
		pvdWriter.println("</VTKFile>");
		pvdWriter.close();
	}

	public void write(final double data)
	{
		vtpWriter.print(" " + data);
	}

	public void write(final double[] data)
	{
		for (int i=0 ; i<data.length ; ++i)
			vtpWriter.print(" " + data[i]);
	}

	private void changeState(final State expectedState, final State newState)
	{
		if (state != expectedState)
			throw new RuntimeException("Unexpected pvd file writer state. Expected: " + expectedState + ", but was: " + state);
		state = newState;
	}
}
