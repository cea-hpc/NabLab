package fr.cea.nabla.ir.interpreter

class NablaValueExtensions 
{
	static def getSize(NV1Int it) { data.size }
	static def getSize(NV1Real it) { data.size }
	
	static def getNbRows(NV2Int it) { data.size }
	static def getNbCols(NV2Int it) { data.get(0).size }
	static def getNbRows(NV2Real it) { data.size }
	static def getNbCols(NV2Real it) { data.get(0).size }
}