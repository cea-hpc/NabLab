package fr.cea.nabla.ir.generator.kokkos

import com.google.inject.Inject
import fr.cea.nabla.ir.generator.LoopIndexHelper
import fr.cea.nabla.ir.generator.Utils
import fr.cea.nabla.ir.ir.Affectation
import fr.cea.nabla.ir.ir.If
import fr.cea.nabla.ir.ir.InstructionBlock
import fr.cea.nabla.ir.ir.Iterator
import fr.cea.nabla.ir.ir.Loop
import fr.cea.nabla.ir.ir.ReductionInstruction
import fr.cea.nabla.ir.ir.ScalarVarDefinition

class InstructionContentProvider 
{
	@Inject extension Utils
	@Inject extension Ir2KokkosUtils
	@Inject extension ExpressionContentProvider
	@Inject extension VariableExtensions
	@Inject extension LoopIndexHelper

	def dispatch CharSequence getContent(ReductionInstruction it) 
	{
		throw new Exception('Les instances de ReductionInstruction doivent être supprimées avant de générer le C++ Kokkos')
	}

	def dispatch CharSequence getContent(ScalarVarDefinition it) 
	'''
		«FOR v : variables»
		«v.kokkosType» «v.name»«IF v.defaultValue !== null» = «v.defaultValue.content»«ENDIF»;
		«ENDFOR»
	'''
	
	def dispatch CharSequence getContent(InstructionBlock it) 
	'''
		{
			«FOR i : instructions»
			«i.content»
			«ENDFOR»
		}
	'''
	
	def dispatch CharSequence getContent(Affectation it) 
	'''«left.content» «operator» «right.content»;'''

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
		Kokkos::parallel_for(«range.connectivity.nbElems», KOKKOS_LAMBDA(const int «varName»)
		{
			«IF needIdFor(l)»int «name»Id = «indexToId(varName)»;«ENDIF»
			«FOR c : getRequiredConnectivities(l)»
			int «name»«c.name.toFirstUpper» = «idToIndex(c, name+'Id')»;
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
		auto «connectivityName» = «range.accessor»;
		for (int «varName»=0; «varName»<«connectivityName».size(); «varName»++)
		{
			«IF needPrev(l)»int «prev(varName)» = («varName»-1+«connectivityName».size())%«connectivityName».size();«ENDIF»
			«IF needNext(l)»int «next(varName)» = («varName»+1+«connectivityName».size())%«connectivityName».size();«ENDIF»
			«IF needIdFor(l)»
				«val idName = name + 'Id'»
				int «idName» = «indexToId(varName)»;
				«IF needPrev(l)»int «prev(idName)» = «indexToId(prev(varName))»;«ENDIF»
				«IF needNext(l)»int «next(idName)» = «indexToId(next(varName))»;«ENDIF»
				«FOR c : getRequiredConnectivities(l)»
					«val cName = name + c.name.toFirstUpper»
					int «cName» = «idToIndex(c, idName)»;
					«IF needPrev(l)»int «prev(cName)» = «idToIndex(c, prev(idName))»;«ENDIF»
					«IF needNext(l)»int «next(cName)» = «idToIndex(c, next(idName))»;«ENDIF»
				«ENDFOR»
			«ENDIF»
			«l.body.content»
		}
	'''
}