from enum import Enum
import numpy as np
import os

class State(Enum):
    closed = 0
    ready = 1
    onNodes = 2
    nodesFinished = 3
    onCells = 4
    cellsFinished = 5
    onNodeArray = 6
    onCellArray = 7

class PvdFileWriter2D:
    def __init__(self, moduleName, directoryName):
        self.__fileNameByTimes = {}
        self.__moduleName = moduleName
        self.__directoryName = directoryName
        self.__state = State.closed

        if not self.disabled:
            if not os.path.exists(directoryName):
                os.mkdir(directoryName)

    @property
    def disabled(self):
        return not self.__directoryName

    @property
    def outputDirectory(self):
        return self.__directoryName

    def startVtpFile(self, iteration, time, nodes, cells):
        if self.disabled:
            return

        self.__changeState(State.closed, State.ready)

        fileName = self.__moduleName + "." + str(iteration) + ".vtp"
        print("Writing vtp file: " + fileName)

        self.__fileNameByTimes[time] = fileName
        filePath = self.__directoryName + "/" + fileName
        self.__vtpWriter = open(filePath, 'w')

        self.__vtpWriter.write("<?xml version=\"1.0\"?>\n")
        self.__vtpWriter.write("<VTKFile type=\"PolyData\">\n")
        self.__vtpWriter.write("    <PolyData>\n")
        self.__vtpWriter.write("        <Piece NumberOfPoints=\"" + str(len(nodes)) + "\" NumberOfPolys=\"" + str(len(cells)) + "\">\n")
        self.__vtpWriter.write("            <Points>\n")
        self.__vtpWriter.write("                <DataArray type=\"Float32\" NumberOfComponents=\"3\" format=\"ascii\">\n")
        for r in range(len(nodes)):
            self.__vtpWriter.write(" " + str(nodes[r][0]) + " " + str(nodes[r][1]) + " 0.0")
        self.__vtpWriter.write("\n")
        self.__vtpWriter.write("                </DataArray>\n")
        self.__vtpWriter.write("            </Points>\n")
        self.__vtpWriter.write("            <Polys>\n")
        self.__vtpWriter.write("                <DataArray type=\"Int32\" Name=\"connectivity\" format=\"ascii\">\n")
        for j in range(len(cells)):
            self.__vtpWriter.write(" ")
            for nodeId in cells[j]:
                self.__vtpWriter.write(" " + str(nodeId))
        self.__vtpWriter.write("\n")
        self.__vtpWriter.write("                </DataArray>\n")
        self.__vtpWriter.write("                <DataArray type=\"Int32\" Name=\"offsets\" format=\"ascii\">\n")
        for j in range(1, len(cells) + 1):
            self.__vtpWriter.write(" " + str(j * 4))
        self.__vtpWriter.write("\n")
        self.__vtpWriter.write("                </DataArray>\n")
        self.__vtpWriter.write("            </Polys>\n")

    def openNodeData(self):
        if self.disabled:
            return
        self.__changeState(State.ready, State.onNodes)
        self.__vtpWriter.write("            <PointData>\n")

    def openCellData(self):
        if self.disabled:
            return
        self.__changeState(State.nodesFinished, State.onCells)
        self.__vtpWriter.write("            <CellData>\n")

    def openNodeArray(self, name, arraySize):
        if self.disabled:
            return
        self.__changeState(State.onNodes, State.onNodeArray)
        self.__vtpWriter.write("                <DataArray Name=\"" + name + "\" type=\"Float32\" NumberOfComponents=\"" + str(arraySize) + "\" format=\"ascii\">\n")

    def openCellArray(self, name, arraySize):
        if self.disabled:
            return
        self.__changeState(State.onCells, State.onCellArray)
        self.__vtpWriter.write("                <DataArray Name=\"" + name + "\" type=\"Float32\" NumberOfComponents=\"" + str(arraySize) + "\" format=\"ascii\">\n")

    def closeNodeData(self):
        if self.disabled:
            return
        self.__changeState(State.onNodes, State.nodesFinished)
        self.__vtpWriter.write("            </PointData>\n")

    def closeCellData(self):
        if self.disabled:
            return
        self.__changeState(State.onCells, State.cellsFinished)
        self.__vtpWriter.write("            </CellData>\n")

    def closeNodeArray(self):
        if self.disabled:
            return
        self.__changeState(State.onNodeArray, State.onNodes)
        self.__vtpWriter.write("\n")
        self.__vtpWriter.write("                </DataArray>\n")

    def closeCellArray(self):
        if self.disabled:
            return
        self.__changeState(State.onCellArray, State.onCells)
        self.__vtpWriter.write("\n")
        self.__vtpWriter.write("                </DataArray>\n")

    def closeVtpFile(self):
        if self.disabled:
            return
        self.__changeState(State.cellsFinished, State.closed)
        self.__vtpWriter.write("        </Piece>\n")
        self.__vtpWriter.write("    </PolyData>\n")
        self.__vtpWriter.write("</VTKFile>\n")
        self.__vtpWriter.close()

        fileName = self.__directoryName + "/" + self.__moduleName + ".pvd"
        with open(fileName, 'w') as pvdWriter:
            pvdWriter.write("<?xml version=\"1.0\"?>\n")
            pvdWriter.write("<VTKFile type=\"Collection\" version=\"0.1\">\n")
            pvdWriter.write("    <Collection>\n")
            for i, (k, v) in enumerate(self.__fileNameByTimes.items()):
                pvdWriter.write("            <DataSet timestep=\"" + str(k) + "\" group=\"\" part=\"0\" file=\"" + v + "\"/>\n")
            pvdWriter.write("    </Collection>\n")
            pvdWriter.write("</VTKFile>\n")

    def write(self, data):
        if isinstance(data, np.ndarray):
            for i in range(len(data)):
                self.__vtpWriter.write(" " + str(data[i]))
        else:
            self.__vtpWriter.write(" " + str(data))

    def __changeState(self, expectedState, newState):
        if not self.__state == expectedState:
            raise Exception("Unexpected pvd file writer state. Expected: " + expectedState + ", but was: " + self.__state)
        self.__state = newState
