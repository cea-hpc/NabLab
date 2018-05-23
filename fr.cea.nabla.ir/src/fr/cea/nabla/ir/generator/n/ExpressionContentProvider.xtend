package fr.cea.nabla.ir.generator.n

class ExpressionContentProvider
{
//	def CharSequence getContent(Expression it)
//	{
//		if (parenthesis) '''(«innerContent»)'''
//		else innerContent
//	}
//	
//	private def dispatch CharSequence getInnerContent(BinaryExpression it) '''«left.content» «operator.literal» «right.content»'''
//	private def dispatch CharSequence getInnerContent(UnaryExpression it) '''«operator.literal»«expression.content»'''
//	private def dispatch CharSequence getInnerContent(IntConstant it) '''«value»'''
//	private def dispatch CharSequence getInnerContent(RealConstant it) '''«value»'''
//	private def dispatch CharSequence getInnerContent(Real2Constant it) '''«BasicType.REAL2.literal»(«x», «y»)'''
//	private def dispatch CharSequence getInnerContent(Real3Constant it) '''«BasicType.REAL3.literal»(«x», «y», «z»)'''
//	private def dispatch CharSequence getInnerContent(BoolConstant it) '''«value»'''
//	
//	private def dispatch CharSequence getInnerContent(NumericalStringConstant it) 
//	{
//		switch type.base
//		{
//			case INT, case REAL: value.literal
//			// possible d'inititaliser un Real2x2 avec un Real2 en Nabla
//			case REAL2, case REAL2X2: '''«BasicType::REAL2.literal»(«value.literal», «value.literal»)'''
//			// possible d'inititaliser un Real3x3 avec un Real3 en Nabla
//			case REAL3, case REAL3X3: '''«BasicType::REAL3.literal»(«value.literal», «value.literal», «value.literal»)'''
//			default: throw new Exception('Who has put a non numerical type in a NumericalStringConstant !')
//		}
//	}
//
//	private def dispatch CharSequence getInnerContent(FunctionCall it) 
//	'''«function.name»(«FOR a:args SEPARATOR ', '»«a.content»«ENDFOR»)'''
//	
//	private def dispatch CharSequence getInnerContent(VarRef it) '''«variable.getName»«FOR f:fields BEFORE '.' SEPARATOR '.'»«f.literal»«ENDFOR»«IF iteratorShift!=0»[#«iteratorShift.content»]«ENDIF»'''
//	private def dispatch CharSequence getInnerContent(IteratorRef it) '''#«shift.content»'''
//	
//	private def getContent(int shift)
//	{
//		if (shift == 0) ''
//		else if (shift > 0) '+' + shift
//		else shift.toString
//	}
}