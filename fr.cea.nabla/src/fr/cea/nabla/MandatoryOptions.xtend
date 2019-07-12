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
 * 	Jean-Sylvain Camier - Nabla generation support
 *******************************************************************************/
package fr.cea.nabla

import fr.cea.nabla.nabla.NablaFactory
import fr.cea.nabla.nabla.PrimitiveType

class MandatoryOptions 
{
	public static val COORD = 'X'
	public static val X_EDGE_LENGTH = 'X_EDGE_LENGTH'
	public static val Y_EDGE_LENGTH = 'Y_EDGE_LENGTH'
	public static val X_EDGE_ELEMS = 'X_EDGE_ELEMS'
	public static val Y_EDGE_ELEMS = 'Y_EDGE_ELEMS'
	public static val Z_EDGE_ELEMS = 'Z_EDGE_ELEMS'
	public static val STOP_TIME = 'option_stoptime'
	public static val MAX_ITERATIONS = 'option_max_iterations'
	
	public static val OPTION_NAMES = #[X_EDGE_LENGTH, Y_EDGE_LENGTH, X_EDGE_ELEMS, Y_EDGE_ELEMS, Z_EDGE_ELEMS, STOP_TIME, MAX_ITERATIONS]

	def getOptions() { #[XEdgeLength, YEdgeLength, XEdgeElem, YEdgeElem, ZEdgeElem, stopTime, maxIterations] }
	
	def getXEdgeLength() { getRealOption(X_EDGE_LENGTH, 1.0) }
	def getYEdgeLength() { getRealOption(Y_EDGE_LENGTH, 1.0) }
	def getStopTime() { getRealOption(STOP_TIME, 0.1) }
	def getMaxIterations() { getIntOption(MAX_ITERATIONS, 48) }

	def getXEdgeElem() { getIntOption(X_EDGE_ELEMS, 8) }
	def getYEdgeElem() { getIntOption(Y_EDGE_ELEMS, 8) }
	def getZEdgeElem() { getIntOption(Z_EDGE_ELEMS, 1) }
	
	private def getIntOption(String optionName, int optionValue)
	{
		val f = NablaFactory::eINSTANCE
		val edgeElem = f.createScalarVarDefinition
		edgeElem.variable = f.createSimpleVar => [ name=optionName ]
		edgeElem.type = f.createBaseType => [ root=PrimitiveType::INT ]
		edgeElem.defaultValue = f.createIntConstant => [ value=optionValue ]
		return edgeElem
	}
	
	private def getRealOption(String optionName, double optionValue)
	{
		val f = NablaFactory::eINSTANCE
		val length = f.createScalarVarDefinition
		length.variable = f.createSimpleVar => [ name=optionName ]
		length.type = f.createBaseType => [ root=PrimitiveType::REAL ]
		length.defaultValue = f.createRealConstant => [ value=optionValue ]
		return length
	}
}