package fr.cea.nabla

import com.google.inject.Inject
import fr.cea.nabla.nabla.Affectation
import fr.cea.nabla.nabla.Arg
import fr.cea.nabla.nabla.ArgOrVar
import fr.cea.nabla.nabla.ArgOrVarRef
import fr.cea.nabla.nabla.BaseType
import fr.cea.nabla.nabla.ConnectivityVar
import fr.cea.nabla.nabla.Function
import fr.cea.nabla.nabla.FunctionCall
import fr.cea.nabla.nabla.FunctionOrReduction
import fr.cea.nabla.nabla.NablaRoot
import fr.cea.nabla.nabla.PrimitiveType
import fr.cea.nabla.nabla.SimpleVar
import fr.cea.nabla.nabla.Var
import fr.cea.nabla.nabla.VarDeclaration
import org.eclipse.emf.ecore.EObject
import org.eclipse.xtext.EcoreUtil2

class LinearAlgebraUtils
{
	@Inject extension ArgOrVarExtensions
		
	def boolean isLinearAlgebra(EObject o)
	{
		switch o
		{
			Affectation: o.right.linearAlgebra
			FunctionCall: o.function.linearAlgebra
			Function: o.nablaRoot.name == 'LinearAlgebra'
			Var case o.typeEligibleFor: o.nablaRoot.eAllContents.filter(ArgOrVarRef).exists[x | x.target == o && x.eContainer.isLinearAlgebra]
			Arg case o.typeEligibleFor: (o.eContainer as FunctionOrReduction).linearAlgebra
			default: false 
		}
	}
	
	private def boolean isTypeEligibleFor(ArgOrVar it)
	{
		switch it
		{
			Arg: isLinearAlgebraEligible(type, dimension)
			SimpleVar case eContainer instanceof VarDeclaration: isLinearAlgebraEligible((eContainer as VarDeclaration).type, dimension)
			ConnectivityVar: isLinearAlgebraEligible(type, dimension)
			default: false
		}
	}

	private def boolean isLinearAlgebraEligible(BaseType bt, int dimension)
	{
		bt.primitive == PrimitiveType::REAL && (dimension == 1 || dimension == 2)
	}

	private def getNablaRoot(EObject o)
	{
		EcoreUtil2.getContainerOfType(o, NablaRoot)
	}
}