package fr.cea.nabla.ir.generator.n

class InstructionContentProvider 
{
//	@Inject extension ExpressionContentProvider
//
//	def dispatch CharSequence getContent(VariableDeclaration it) 
//	'''
//		«variable.type.literal» «variable.name»«IF variable.defaultValue!==null» = «variable.defaultValue.content»«ENDIF»;
//	'''
//	
//	def dispatch CharSequence getContent(Loop it) 
//	'''
//		«iterator.iteratorContent»{
//			«FOR i : instructions»
//				«i.content»
//			«ENDFOR»
//		}
//	'''
//	
//	def dispatch CharSequence getContent(If it) 
//	'''
//		if («condition.content») {
//			«FOR i : thenInstructions»
//				«i.content»
//			«ENDFOR»
//		}
//		«IF !elseInstructions.empty»
//		else {
//			«FOR i : elseInstructions»
//				«i.content»
//			«ENDFOR»			
//		}
//		«ENDIF»
//	'''
//	
//	def dispatch CharSequence getContent(Affectation it) 
//	{
//		switch operator
//		{
//			case MIN : '''min(«left.content», «right.content»);'''
//			case MAX : '''max(«left.content», «right.content»);'''
//			default : '''«left.content» «operator.literal» «right.content»;'''
//		}
//	}
//	
//	def getIteratorContent(Iterator it)
//	'''«IF it!==null»∀ «IF modifier!=ItemFamilyModifier::NONE»«modifier.literal » «ENDIF»«itemFamily.literal» «ENDIF»'''
}