package fr.cea.nabla

import com.google.inject.Inject
import fr.cea.nabla.nabla.Affectation
import fr.cea.nabla.nabla.Arg
import fr.cea.nabla.nabla.ArgOrVarRef
import fr.cea.nabla.nabla.BaseType
import fr.cea.nabla.nabla.ConnectivityVar
import fr.cea.nabla.nabla.Function
import fr.cea.nabla.nabla.FunctionCall
import fr.cea.nabla.nabla.FunctionTypeDeclaration
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
			case null: false
			Affectation: o.right.linearAlgebra
			FunctionCall: o.function.linearAlgebra
			Function: o.nablaRoot.name == 'LinearAlgebra'
			Var case o.linearAlgebraEligible: o.nablaRoot.eAllContents.filter(ArgOrVarRef).exists[x | x.target == o && x.eContainer.isLinearAlgebra]
			Arg case o.linearAlgebraEligible: o.eContainer.linearAlgebra
			BaseType case o.linearAlgebraEligible: o.eContainer.linearAlgebra
			FunctionTypeDeclaration: o.eContainer.linearAlgebra
			default: false
		}
	}
	
	private def boolean isLinearAlgebraEligible(EObject it)
	{
		switch it
		{
			case null: false
			Arg: isLinearAlgebraEligible(type.primitive, dimension)
			SimpleVar case eContainer instanceof VarDeclaration: isLinearAlgebraEligible((eContainer as VarDeclaration).type.primitive, dimension)
			ConnectivityVar: isLinearAlgebraEligible(type.primitive, dimension)
			BaseType: isLinearAlgebraEligible(primitive, sizes.size)
			default: false
		}
	}

	private def boolean isLinearAlgebraEligible(PrimitiveType p, int dimension)
	{
		p == PrimitiveType::REAL && (dimension == 1 || dimension == 2)
	}

	private def getNablaRoot(EObject o)
	{
		EcoreUtil2.getContainerOfType(o, NablaRoot)
	}
}