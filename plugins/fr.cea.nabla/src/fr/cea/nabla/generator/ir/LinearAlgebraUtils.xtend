package fr.cea.nabla.generator.ir

import fr.cea.nabla.nabla.Affectation
import fr.cea.nabla.nabla.ArgOrVar
import fr.cea.nabla.nabla.ArgOrVarRef
import fr.cea.nabla.nabla.ConnectivityVar
import fr.cea.nabla.nabla.Function
import fr.cea.nabla.nabla.FunctionCall
import fr.cea.nabla.nabla.NablaModule
import org.eclipse.emf.ecore.EObject
import org.eclipse.xtext.EcoreUtil2

class LinearAlgebraUtils
{
	def isLinearAlgebra(Function it)
	{
		containsLinearAlgebra
	}

	def isLinearAlgebra(ArgOrVar it)
	{
		if (it instanceof ConnectivityVar)
		{
			val references = nablaModule.eAllContents.filter(ArgOrVarRef).filter[x | x.target == it]
			references.exists[x | x.eContainer.containsLinearAlgebra]
		}
		else
			false
	}

	private def boolean containsLinearAlgebra(EObject o)
	{
		switch o
		{
			Affectation: o.right.containsLinearAlgebra
			FunctionCall: o.function.containsLinearAlgebra
			Function: o.nablaModule.name == 'LinearAlgebra'
			default: false 
		}
	}
	
	private def getNablaModule(EObject o)
	{
		EcoreUtil2.getContainerOfType(o, NablaModule)
	}
}