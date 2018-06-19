package fr.cea.nabla.ir.generator.n

import com.google.inject.Inject
import fr.cea.nabla.ir.ir.Affectation
import fr.cea.nabla.ir.ir.If
import fr.cea.nabla.ir.ir.InstructionBlock
import fr.cea.nabla.ir.ir.Loop
import fr.cea.nabla.ir.ir.ReductionInstruction
import fr.cea.nabla.ir.ir.ScalarVarDefinition

class InstructionContentProvider 
{
	@Inject extension Ir2NUtils
	@Inject extension ExpressionContentProvider

	def dispatch CharSequence getContent(ReductionInstruction it) 
	{
		throw new Exception('Les instances de ReductionInstruction doivent être supprimées avant de générer le Java')
	}

	def dispatch CharSequence getContent(ScalarVarDefinition it) 
	'''
		«FOR v : variables»
		«v.type.NType» «v.name»«IF v.defaultValue!==null» = «v.defaultValue.content»«ENDIF»;
		«ENDFOR»
	'''
	
	def dispatch CharSequence getContent(InstructionBlock it) 
	'''
		{
			«FOR i : instructions»
			«i.content»
			«ENDFOR»
		}'''

	def dispatch CharSequence getContent(Affectation it) 
	'''«left.content» «operator» «right.content»;'''
	
	def dispatch CharSequence getContent(Loop it) 
	'''
		«iterator.content» {
			«body.content»
		}
	'''
	
	def dispatch CharSequence getContent(If it) 
	'''
		if («condition.content»)
			«thenInstruction.content»
		«IF (elseInstruction !== null)»
		else {
			«elseInstruction.content»
		}
		«ENDIF»
	'''
}