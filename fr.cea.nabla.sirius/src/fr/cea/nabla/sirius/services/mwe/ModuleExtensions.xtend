package fr.cea.nabla.sirius.services.mwe

import org.eclipse.emf.mwe2.language.mwe2.Component
import org.eclipse.emf.mwe2.language.mwe2.Module

class ModuleExtensions 
{
	def getComponents(Module it)
	{
		root.assignment.map[value].filter(Component).toList
	}
}