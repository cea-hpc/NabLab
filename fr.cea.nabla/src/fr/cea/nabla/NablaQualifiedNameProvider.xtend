package fr.cea.nabla

import fr.cea.nabla.nabla.Function
import fr.cea.nabla.nabla.FunctionArg
import fr.cea.nabla.nabla.Reduction
import fr.cea.nabla.nabla.ReductionArg
import org.eclipse.emf.ecore.EObject
import org.eclipse.xtext.naming.DefaultDeclarativeQualifiedNameProvider
import org.eclipse.xtext.naming.QualifiedName

/**
 * The qualified name provider must be overriden for DimensionVar.
 * The aim is to check unique names for one FunctionArg but to 
 * enable same names in two different FunctionArg: a unique qualified name is
 * built for the FunctionArg. (idem for ReductionArg)
 */
class NablaQualifiedNameProvider extends DefaultDeclarativeQualifiedNameProvider 
{
	override QualifiedName getFullyQualifiedName(EObject obj) 
	{
		switch obj
		{
			FunctionArg :
			{
				val f = obj.eContainer as Function
				val fqn = getOrComputeFullyQualifiedName(f)
				val index = f.argGroups.indexOf(obj)
				return fqn.append('_arg_' + index.toString)
			}
			ReductionArg :
			{
				val r = obj.eContainer as Reduction
				val rqn = getOrComputeFullyQualifiedName(r)
				val index = r.argGroups.indexOf(obj)
				return rqn.append('_arg_' + index.toString)
			}
			default: 
				return getOrComputeFullyQualifiedName(obj)
		}
	}
}