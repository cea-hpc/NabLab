package fr.cea.nabla.ir.generator.n

class JobContentProvider 
{
//	@Inject extension ExpressionContentProvider
//	@Inject extension InstructionContentProvider
//	
//	def dispatch CharSequence getContent(InstructionJob it)
//	'''
//		«header»@ «at» {
//			«FOR i : instructions»
//				«i.content»
//			«ENDFOR»
//		}
//	'''
//	
//	/** Les jobs reduction ne doivent pas comporter de label pour l'instant (donc pas d'appel à la méthode header). */
//	def dispatch CharSequence getContent(ReductionJob it)
//	'''
//		«iterator.iteratorContent»«variable.name» «operator.literal» «expression.content» @ «at»;
//	'''
//	
//	def dispatch CharSequence getContent(TimeIterationCopyJob it)
//	'''
//		«header»@ «at» { 
//			«left.getName» = «right.getName»;
//		}
//	'''
//	
//	private def getHeader(Job it)
//	'''«iterator.iteratorContent»«IF !label.nullOrEmpty»«label» «ENDIF»'''
}