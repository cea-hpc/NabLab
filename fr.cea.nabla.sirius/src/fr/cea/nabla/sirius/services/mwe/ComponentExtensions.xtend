package fr.cea.nabla.sirius.services.mwe

import org.eclipse.emf.mwe2.language.mwe2.Component
import org.eclipse.emf.mwe2.language.mwe2.Reference
import org.eclipse.emf.mwe2.language.mwe2.DeclaredProperty

class ComponentExtensions 
{
	def getLabel(Component it)
	{
		if (type === null)
			println('AAA type null')
		else
			println("AAA : " + type.simpleName)
		name
	}	
	
	def getColor(Component it)
	{
		println("Sur component " + name)
		println("  " + assignment.filter[a | a.featureName == "active"].map[value])
		assignment.filter[a | a.featureName == "active"].map[value].filter(Reference).map[referable].filter(DeclaredProperty)
	}
	
	def getPrevious(Component it)
	{
		assignment.filter[a | a.featureName == "previous"].map[value].filter(Reference).map[referable].filter(Component).toList
	}
}