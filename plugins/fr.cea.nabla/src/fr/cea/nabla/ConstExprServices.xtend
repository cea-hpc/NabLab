package fr.cea.nabla

import com.google.inject.Inject
import fr.cea.nabla.nabla.And
import fr.cea.nabla.nabla.ArgOrVar
import fr.cea.nabla.nabla.ArgOrVarRef
import fr.cea.nabla.nabla.Cardinality
import fr.cea.nabla.nabla.Comparison
import fr.cea.nabla.nabla.ContractedIf
import fr.cea.nabla.nabla.Div
import fr.cea.nabla.nabla.Equality
import fr.cea.nabla.nabla.Expression
import fr.cea.nabla.nabla.Function
import fr.cea.nabla.nabla.FunctionCall
import fr.cea.nabla.nabla.FunctionOrReduction
import fr.cea.nabla.nabla.Minus
import fr.cea.nabla.nabla.Modulo
import fr.cea.nabla.nabla.Mul
import fr.cea.nabla.nabla.NablaRoot
import fr.cea.nabla.nabla.Not
import fr.cea.nabla.nabla.Or
import fr.cea.nabla.nabla.Parenthesis
import fr.cea.nabla.nabla.Plus
import fr.cea.nabla.nabla.ReductionCall
import fr.cea.nabla.nabla.SimpleVarDeclaration
import fr.cea.nabla.nabla.UnaryMinus
import fr.cea.nabla.nabla.VectorConstant
import org.eclipse.xtext.EcoreUtil2

class ConstExprServices
{
	@Inject extension ArgOrVarExtensions

	def boolean isConstExpr(Expression e)
	{
		switch e
		{
			ArgOrVarRef: e.timeIterators.empty && e.indices.forall[constExpr] && e.target.constExpr
			FunctionCall:
			{
				val nablaRoot = EcoreUtil2.getContainerOfType(e.function, NablaRoot)
				! ((nablaRoot !== null) && e.function.external && (nablaRoot.name != "Math"))
			}
			ReductionCall, Cardinality: false
			ContractedIf: e.condition.constExpr && e.then.constExpr && e.^else.constExpr
			Or: e.left.constExpr && e.right.constExpr
			And: e.left.constExpr && e.right.constExpr
			Equality: e.left.constExpr && e.right.constExpr
			Comparison: e.left.constExpr && e.right.constExpr
			Plus: e.left.constExpr && e.right.constExpr
			Minus: e.left.constExpr && e.right.constExpr
			Mul: e.left.constExpr && e.right.constExpr
			Div: e.left.constExpr && e.right.constExpr
			Modulo: e.left.constExpr && e.right.constExpr
			Parenthesis: e.expression.constExpr
			UnaryMinus: e.expression.constExpr
			Not: e.expression.constExpr
			VectorConstant: e.values.forall[constExpr]
			default: true
		}
	}

	def boolean isConstExpr(ArgOrVar v)
	{
		if (v.eContainer !== null)
		{
			val c = v.eContainer
			switch c
			{
				// options are not constexpr because they are initialized by a file in the generated code
				SimpleVarDeclaration: (c.value !== null && c.variable.const && c.value !== null && c.value.constExpr)
				FunctionOrReduction: true
				default: false
			}
		}
		else
			false
	}

	def boolean isConstExpr(Function f)
	{
		val nablaRoot = EcoreUtil2.getContainerOfType(f, NablaRoot)
		nablaRoot !== null && !f.external
	}
}