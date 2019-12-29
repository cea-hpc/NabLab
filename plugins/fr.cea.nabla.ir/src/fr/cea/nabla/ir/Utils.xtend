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

	static def getDefaultIrVariable(IrModule m, String nablaVariableName)
	{
		var irVariable = m.variables.findFirst[x | x.name == nablaVariableName]
		if (irVariable === null)
		{
			val allTimeVariables = m.variables.filter[x | x.name.startsWith(nablaVariableName + '_')]
			if (!allTimeVariables.empty)
			{
				// take the shortest extension (corresponding to the default variable, i.e. t_n for t)
				irVariable = allTimeVariables.sortBy[name.length].head
				println("Variables for " + nablaVariableName + " : " + allTimeVariables.sortBy[name.length].map[name].join(', '))
			}
		}
		return irVariable
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
}