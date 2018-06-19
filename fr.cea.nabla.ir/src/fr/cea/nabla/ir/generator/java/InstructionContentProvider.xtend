package fr.cea.nabla.ir.generator.java

import com.google.inject.Inject
import fr.cea.nabla.ir.IteratorExtensions
import fr.cea.nabla.ir.generator.Utils
import fr.cea.nabla.ir.ir.Affectation
import fr.cea.nabla.ir.ir.If
import fr.cea.nabla.ir.ir.Instruction
import fr.cea.nabla.ir.ir.InstructionBlock
import fr.cea.nabla.ir.ir.Iterator
import fr.cea.nabla.ir.ir.Loop
import fr.cea.nabla.ir.ir.ReductionInstruction
import fr.cea.nabla.ir.ir.ScalarVarDefinition

class InstructionContentProvider 
{
	@Inject extension Utils
	@Inject extension Ir2JavaUtils
	@Inject extension ExpressionContentProvider
	@Inject extension VariableExtensions
	@Inject extension IteratorExtensions

	def dispatch CharSequence getContent(ReductionInstruction it) 
	{
		throw new Exception('Les instances de ReductionInstruction doivent être supprimées avant de générer le Java')
	}

	def dispatch CharSequence getContent(ScalarVarDefinition it) 
	'''
		«FOR v : variables»
		«v.javaType» «v.name»«IF v.defaultValue !== null» = «v.defaultValue.content»«ENDIF»;
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
	{
		if (left.variable.type.javaBasicType) 
			'''«left.content» «operator» «right.content»;'''
		else 
			'''«left.content».«operator.javaOperator»(«right.content»);'''
	}

	def dispatch CharSequence getContent(Loop it) 
	{
		if (isTopLevelLoop(it)) 
			iterator.addParallelLoop(body)
		else
			iterator.addSequentialLoop(body)
	}
	
	def dispatch CharSequence getContent(If it) 
	'''
		if («condition.content») 
			«thenInstruction.content»
		«IF (elseInstruction !== null)»
		else 
			«elseInstruction.content»
		«ENDIF»
	'''
	
	private def addParallelLoop(Iterator it, Instruction body)
	'''
		«IF !range.connectivity.indexEqualId»int[] «connectivityName» = «range.accessor»;«ENDIF»
		IntStream.range(0, «range.connectivity.nbElems»).parallel().forEach(«varName» -> 
		{
			«IF needIdFor(body)»int «name»Id = «indexToId(varName)»;«ENDIF»
			«FOR c : getRequiredConnectivities(body)»
			int «name»«c.name.toFirstUpper» = «idToIndex(c, name+'Id')»;
			«ENDFOR»
			«IF body instanceof InstructionBlock»
			«FOR i : (body as InstructionBlock).instructions»
			«i.content»
			«ENDFOR»
			«ELSE»
			«body.content»
			«ENDIF»
		});
	'''

	private def addSequentialLoop(Iterator it, Instruction body)
	'''
		int[] «connectivityName» = «range.accessor»;
		for (int «varName»=0; «varName»<«connectivityName».length; «varName»++)
		{
			«IF needPrev(body)»int «prev(varName)» = («varName»-1+«connectivityName».length)%«connectivityName».length;«ENDIF»
			«IF needNext(body)»int «next(varName)» = («varName»+1+«connectivityName».length)%«connectivityName».length;«ENDIF»
			«IF needIdFor(body)»
				«val idName = name + 'Id'»
				int «idName» = «indexToId(varName)»;
				«IF needPrev(body)»int «prev(idName)» = «indexToId(prev(varName))»;«ENDIF»
				«IF needNext(body)»int «next(idName)» = «indexToId(next(varName))»;«ENDIF»
				«FOR c : getRequiredConnectivities(body)»
					«val cName = name + c.name.toFirstUpper»
					int «cName» = «idToIndex(c, idName)»;
					«IF needPrev(body)»int «prev(cName)» = «idToIndex(c, prev(idName))»;«ENDIF»
					«IF needNext(body)»int «next(cName)» = «idToIndex(c, next(idName))»;«ENDIF»
				«ENDFOR»
			«ENDIF»
			«body.content»
		}
	'''
}