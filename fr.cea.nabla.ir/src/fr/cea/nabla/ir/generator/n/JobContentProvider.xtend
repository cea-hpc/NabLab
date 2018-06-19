package fr.cea.nabla.ir.generator.n

import com.google.inject.Inject
import fr.cea.nabla.ir.ir.ArrayVariable
import fr.cea.nabla.ir.ir.Instruction
import fr.cea.nabla.ir.ir.InstructionBlock
import fr.cea.nabla.ir.ir.InstructionJob
import fr.cea.nabla.ir.ir.Job
import fr.cea.nabla.ir.ir.Loop
import fr.cea.nabla.ir.ir.ReductionJob
import fr.cea.nabla.ir.ir.ScalarVariable
import fr.cea.nabla.ir.ir.TimeIterationCopyJob

class JobContentProvider 
{
	@Inject extension Ir2NUtils
	@Inject extension ExpressionContentProvider
	@Inject extension InstructionContentProvider
	
	def dispatch CharSequence getContent(InstructionJob it)
	{
		if (instruction instanceof Loop)
		{
			val loop = instruction as Loop
			getInnerJobContent(loop.body, '''«loop.iterator.content» «header»@ «at»''')
		}
		else 
			getInnerJobContent(instruction, '''«header»@ «at»''')	
	}

	def dispatch CharSequence getContent(TimeIterationCopyJob it)
	'''
		«left.loopHeader» «header»@ «at» { 
			«left.getName» = «right.getName»;
		}
	'''

	/** Les jobs reduction ne doivent pas comporter de label pour l'instant (donc pas d'appel à la méthode header). */
	def dispatch CharSequence getContent(ReductionJob it)
	'''
		«reduction.iterator.content»«variable.variable.name» «reduction.reduction.operator» «reduction.arg.content» @ «at»;
	'''
	
	private def getHeader(Job it)
	'''«IF !name.nullOrEmpty»«name» «ENDIF»'''
	
	private def dispatch getInnerJobContent(Instruction i, CharSequence header)
	'''
		«header» {
			«i.content»
		}
	'''

	private def dispatch getInnerJobContent(InstructionBlock i, CharSequence header)
	'''
		«header» «i.content»
	'''
	
	private def dispatch getLoopHeader(ScalarVariable v) ''''''
	private def dispatch getLoopHeader(ArrayVariable v) { v.dimensions.map[d | '''∀ «d.returnType.type.literal»s'''].join(' ') }
}