package fr.cea.nabla.ir.interpreter

import java.util.Arrays

class NablaValueExtensions 
{
	static def getSize(NV1Int it) { data.size }
	static def getSize(NV1Real it) { data.size }
	
	static def getNbRows(NV2Int it) { data.size }
	static def getNbCols(NV2Int it) { data.get(0).size }
	static def getNbRows(NV2Real it) { data.size }
	static def getNbCols(NV2Real it) { data.get(0).size }

	static def dispatch isEqualsTo(NablaValue it, NablaValue value) { return false }
	
	static def dispatch isEqualsTo(NV0Bool it, NablaValue value) { 
		if (value instanceof NV0Bool && ((value as NV0Bool).data != it.data))
			println(it.data + " != " + (value as NV0Bool).data)
		return (value instanceof NV0Bool && (value as NV0Bool).data == it.data)
	}
	static def dispatch isEqualsTo(NV0Int it, NablaValue value) {
		if (value instanceof NV0Int && ((value as NV0Int).data != it.data))
			println(it.data + " != " + (value as NV0Int).data)
		 
		return (value instanceof NV0Int && (value as NV0Int).data === it.data)
	}
	static def dispatch isEqualsTo(NV0Real it, NablaValue value) { return (value instanceof NV0Real && (value as NV0Real).data === it.data) }
	
	static def dispatch isEqualsTo(NV1Bool it, NablaValue value) { return (value instanceof NV1Bool && Arrays.equals((value as NV1Bool).data, it.data)) }
	static def dispatch isEqualsTo(NV1Int it, NablaValue value) {return (value instanceof NV1Int && Arrays.equals((value as NV1Int).data, it.data)) }
	static def dispatch isEqualsTo(NV1Real it, NablaValue value) { return (value instanceof NV1Real && Arrays.equals((value as NV1Real).data, it.data)) }

	static def dispatch isEqualsTo(NV2Bool it, NablaValue value) { return (value instanceof NV2Bool && Arrays.equals((value as NV2Bool).data, it.data)) }
	static def dispatch isEqualsTo(NV2Int it, NablaValue value) { return (value instanceof NV2Int &&  Arrays.equals((value as NV2Int).data, it.data)) }
	static def dispatch isEqualsTo(NV2Real it, NablaValue value) { return (value instanceof NV2Real && Arrays.equals((value as NV2Real).data, it.data)) }
	
	static def dispatch isEqualsTo(NV3Bool it, NablaValue value) { return (value instanceof NV3Bool && Arrays.equals((value as NV3Bool).data, it.data)) }
	static def dispatch isEqualsTo(NV3Int it, NablaValue value) { return (value instanceof NV3Int && Arrays.equals((value as NV3Int).data, it.data)) }
	static def dispatch isEqualsTo(NV3Real it, NablaValue value) { return (value instanceof NV3Real && Arrays.equals((value as NV3Real).data, it.data)) }

}