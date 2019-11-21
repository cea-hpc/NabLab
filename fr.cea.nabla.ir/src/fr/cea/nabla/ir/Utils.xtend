package fr.cea.nabla.ir

import fr.cea.nabla.ir.ir.IrModule
import org.apache.commons.lang3.builder.HashCodeBuilder
import org.eclipse.emf.common.util.EList
import org.eclipse.emf.ecore.EAttribute
import org.eclipse.emf.ecore.EObject
import org.eclipse.emf.ecore.EReference
import org.eclipse.emf.ecore.EStructuralFeature

class Utils 
{
	static def IrModule getIrModule(EObject o)
	{
		if (o === null) null
		else if (o instanceof IrModule) o as IrModule
		else o.eContainer.irModule
	}
	
	static def hashString(Object object)
	{
		val hash = object.hash
		if (hash < 0)
			return '_' + Math::abs(hash).toString
		else
			return hash.toString	
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

	private static def dispatch int hash(EObject object)
	{
		if (object === null)
			return 0
	
		// Get the class and package
		val eclass = object.eClass
		val epackage = eclass.EPackage
		
		// Initialize hash based on class ID and package nsURI
		var hash = eclass.classifierID + 23
		if (epackage !== null && epackage.nsURI !== null)
			hash = hash * epackage.nsURI.hash + 47
			
		// Add the feature hash codes
		for (feature : eclass.EAllStructuralFeatures)	
		{
			// Compute the hash code of the values
			var valueHash = 0
			if (feature.many)
			{
				val list = object.eGet(feature) as EList<?>
				for (item : list)
					valueHash += item.hash(feature)
			}
			else
			{
				val value = object.eGet(feature)
				if (value !== null)
					valueHash += value.hash
			}
			// Include feature ID
			hash += valueHash * (feature.featureID + 17)
		}
		
		return hash
	}
		
	private static def dispatch int hash(Object object)
	{
		if (object === null)
			return 0
		else
			return HashCodeBuilder.reflectionHashCode(object)
	}
	
	private static def hash(Object value, EStructuralFeature feature)
	{
		if (value === null)
			return 0
			
		if (feature instanceof EAttribute)
			return value.hash
			
		if (feature instanceof EReference)
		{
			if ((feature as EReference).containment)
				return (value as EObject).hash
			else
				return value.hash	
		}		
		
		throw new IllegalArgumentException("Unknown feature type: " + feature)
	}
}