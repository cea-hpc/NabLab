package fr.cea.nabla

import com.google.inject.Inject
import fr.cea.nabla.nabla.BasicType
import fr.cea.nabla.nabla.Expression
import fr.cea.nabla.nabla.FunctionArg
import fr.cea.nabla.nabla.FunctionCall
import fr.cea.nabla.nabla.ReductionArg
import fr.cea.nabla.nabla.ReductionCall
import fr.cea.nabla.typing.ExpressionTypeProvider
import fr.cea.nabla.typing.NablaType
import java.util.List

class FunctionCallExtensions 
{
	@Inject extension ExpressionTypeProvider
	
	def FunctionArg getDeclaration(FunctionCall it)
	{
		function.argGroups.findFirst[x | match(x.inTypes, args)]
	}

	def ReductionArg getDeclaration(ReductionCall it)
	{
		reduction.argGroups.findFirst[x | match(x.collectionType, arg)]
	}

	private def boolean match(List<BasicType> a, List<Expression> b) 
	{
		if (a.length != b.length) return false
		for (i : 0..<a.length)
			if (!match(a.get(i), b.get(i))) return false
		return true
	}
	
	private def boolean match(BasicType a, Expression b)
	{
		val bType = b.typeFor
		return (bType!==NablaType::UNDEFINED && bType.dimension==0 && bType.base==a)
	}
}