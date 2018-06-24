package fr.cea.nabla.ir.generator.java

import com.google.inject.Inject
import fr.cea.nabla.ir.LoopIndexHelper
import fr.cea.nabla.ir.generator.Utils
import fr.cea.nabla.ir.ir.Affectation
import fr.cea.nabla.ir.ir.If
import fr.cea.nabla.ir.ir.InstructionBlock
import fr.cea.nabla.ir.ir.Iterator
import fr.cea.nabla.ir.ir.Loop
import fr.cea.nabla.ir.ir.ReductionCall
import fr.cea.nabla.ir.ir.ReductionInstruction
import fr.cea.nabla.ir.ir.ScalarVarDefinition

class InstructionContentProvider 
{
	@Inject extension Utils
	@Inject extension Ir2JavaUtils
	@Inject extension ExpressionContentProvider
	@Inject extension VariableExtensions
	@Inject extension LoopIndexHelper

	/**
	 * Les réductions à l'intérieur des boucles ont été remplacées dans l'IR par des boucles.
	 * Ne restent que les réductions au niveau des jobs => reduction //
	 */
	def dispatch CharSequence getContent(ReductionInstruction it) 
	'''
		«variable.javaType» «variable.name» = IntStream.range(0, «reduction.iterator.range.connectivity.nbElems»).boxed().parallel().reduce(
			«variable.defaultValue.content», 
			(r, «reduction.iterator.varName») -> «reduction.javaName»(r, «reduction.arg.content»),
			(r1, r2) -> «reduction.javaName»(r1, r2)
		);
	'''

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
			iterator.addParallelLoop(it)
		else
			iterator.addSequentialLoop(it)
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
	
	private def addParallelLoop(Iterator it, Loop l)
	'''
		«IF !range.connectivity.indexEqualId»int[] «connectivityName» = «range.accessor»;«ENDIF»
		IntStream.range(0, «range.connectivity.nbElems»).parallel().forEach(«varName» -> 
		{
			«IF needIdFor(l)»int «name»Id = «indexToId(varName)»;«ENDIF»
			«FOR index : getRequiredIndexes(l)»
			int «index.iterator.name»«index.connectivity.name.toFirstUpper» = «idToIndex(index.connectivity, name+'Id')»;
			«ENDFOR»
			«IF l.body instanceof InstructionBlock»
			«FOR i : (l.body as InstructionBlock).instructions»
			«i.content»
			«ENDFOR»
			«ELSE»
			«l.body.content»
			«ENDIF»
		});
	'''

	private def addSequentialLoop(Iterator it, Loop l)
	'''
		int[] «connectivityName» = «range.accessor»;
		for (int «varName»=0; «varName»<«connectivityName».length; «varName»++)
		{
			«IF needPrev(l)»int «prev(varName)» = («varName»-1+«connectivityName».length)%«connectivityName».length;«ENDIF»
			«IF needNext(l)»int «next(varName)» = («varName»+1+«connectivityName».length)%«connectivityName».length;«ENDIF»
			«IF needIdFor(l)»
				«val idName = name + 'Id'»
				int «idName» = «indexToId(varName)»;
				«IF needPrev(l)»int «prev(idName)» = «indexToId(prev(varName))»;«ENDIF»
				«IF needNext(l)»int «next(idName)» = «indexToId(next(varName))»;«ENDIF»
				«FOR index : getRequiredIndexes(l)»
					«val cName = index.iterator.name + index.connectivity.name.toFirstUpper»
					«val cIdName = index.iterator.name + 'Id'»
					«IF !(index.connectivity.indexEqualId)»«index.idToIndexArray»«ENDIF»
					int «cName» = «idToIndex(index.connectivity, cIdName)»;
					«IF needPrev(l)»int «prev(cName)» = «idToIndex(index.connectivity, prev(cIdName))»;«ENDIF»
					«IF needNext(l)»int «next(cName)» = «idToIndex(index.connectivity, next(cIdName))»;«ENDIF»
				«ENDFOR»
			«ENDIF»
			«l.body.content»
		}
	'''
	
	private def getJavaName(ReductionCall it) '''«reduction.provider»Functions.«reduction.name»'''
}