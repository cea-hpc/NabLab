/*******************************************************************************
 * Copyright (c) 2020 CEA
 * This program and the accompanying materials are made available under the 
 * terms of the Eclipse Public License 2.0 which is available at
 * http://www.eclipse.org/legal/epl-2.0.
 *
 * SPDX-License-Identifier: EPL-2.0
 * Contributors: see AUTHORS file
 *******************************************************************************/
package fr.cea.nabla.ir.interpreter

class NablaValueExtensions 
{
	static def getSize(NV1Int it) { data.size }
	static def getSize(NV1Real it) { data.size }
	
	static def getNbRows(NV2Int it) { data.size }
	static def getNbCols(NV2Int it) { data.get(0).size }
	static def getNbRows(NV2Real it) { data.size }
	static def getNbCols(NV2Real it) { data.get(0).size }

	static def dispatch displayValue(NV0Bool it) { data }
	static def dispatch displayValue(NV1Bool it) { '[' + data.join(',') + ']'  }
	static def dispatch displayValue(NV2Bool it) { data.map[d | d.map[ dd | dd]]   }
	static def dispatch displayValue(NV3Bool it) { data.map[d | d.map[ dd | dd.map[ddd | ddd]]] }
	static def dispatch displayValue(NV4Bool it) { data.map[d | d.map[ dd | dd.map[ddd | ddd.map[dddd | dddd]]]] }

	static def dispatch displayValue(NV0Int it) { data }
	static def dispatch displayValue(NV1Int it) { '[' + data.join(',') + ']' }
	static def dispatch displayValue(NV2Int it) { data.map[d | d.map[ dd | dd]]  }
	static def dispatch displayValue(NV3Int it) { data.map[d | d.map[ dd | dd.map[ddd | ddd]]] }
	static def dispatch displayValue(NV4Int it) { data.map[d | d.map[ dd | dd.map[ddd | ddd.map[dddd | dddd]]]] }

	static def dispatch displayValue(NV0Real it) { data }
	static def dispatch displayValue(NV1Real it)  { data.map[d | d] }
	static def dispatch displayValue(NVVector it)  { data.toArray.map[d | d] }
	static def dispatch displayValue(NV2Real it) { data.map[d | d.map[ dd | dd]] }
	static def dispatch displayValue(NVMatrix it)  { 'not yet implemented' }
	static def dispatch displayValue(NV3Real it) { data.map[d | d.map[ dd | dd.map[ddd | ddd]]] }
	static def dispatch displayValue(NV4Real it) { data.map[d | d.map[ dd | dd.map[ddd | ddd.map[dddd | dddd]]]] }
}