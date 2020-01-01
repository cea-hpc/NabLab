/*******************************************************************************
 * Copyright (c) 2020 CEA
 * This program and the accompanying materials are made available under the 
 * terms of the Eclipse Public License 2.0 which is available at
 * http://www.eclipse.org/legal/epl-2.0.
 *
 * SPDX-License-Identifier: EPL-2.0
 * Contributors: see AUTHORS file
 *******************************************************************************/
package fr.cea.nabla.ir

import fr.cea.nabla.ir.ir.IrModule
import org.eclipse.emf.ecore.EObject

class Utils 
{
	static def IrModule getIrModule(EObject o)
	{
		if (o === null) null
		else if (o instanceof IrModule) o as IrModule
		else o.eContainer.irModule
	}

	static def getUtfExponent(int x)
	{
		val xstring = x.toString
		var utfExponent = ''
		for (xchar : xstring.toCharArray)
		{
			val xValue = Character.getNumericValue(xchar)
			utfExponent += switch xValue
			{
				case 2: '\u00B2'
				case 3: '\u00B3'
				case 4: '\u2074'
				case 5: '\u2075'
				case 6: '\u2076'
				case 7: '\u2077'
				case 8: '\u2078'
				case 9: '\u2079'
				default: ''
			}
		}
		return utfExponent
	}

	static def getCurrentIrVariable(IrModule m, String nablaVariableName) { getIrVariable(m, nablaVariableName, false) }
	static def getInitIrVariable(IrModule m, String nablaVariableName) { getIrVariable(m, nablaVariableName, true) }

	private static def getIrVariable(IrModule m, String nablaVariableName, boolean initTimeIterator)
	{
		var irVariable = m.variables.findFirst[x | x.name == nablaVariableName]
		if (irVariable === null && m.mainTimeLoop !== null) 
		{
			val timeLoopVariable = m.mainTimeLoop.variables.findFirst[x | x.name == nablaVariableName]
			if (timeLoopVariable !== null) 
			{
				if (initTimeIterator && timeLoopVariable.init !== null) 
					irVariable = timeLoopVariable.init
				else
					irVariable = timeLoopVariable.current
			}
		}
		return irVariable
	}
}