package fr.cea.nabla.ir.generator.kmds

import com.google.inject.Inject
import fr.cea.nabla.ir.generator.Utils
import fr.cea.nabla.ir.ir.InstructionJob
import fr.cea.nabla.ir.ir.Job
import fr.cea.nabla.ir.ir.ReductionJob
import fr.cea.nabla.ir.ir.TimeIterationCopyJob

class JobContentProvider 
{
	@Inject extension Utils
	@Inject extension InstructionContentProvider
	@Inject extension VariableExtensions
	
	def getContent(Job it)
	'''
		«comment»
		void «name.toFirstLower»() 
		{
			«innerContent»
		}		
	'''
	
	private def dispatch CharSequence getInnerContent(InstructionJob it)
	'''
		«instruction.content»
	'''
	
	private def dispatch CharSequence getInnerContent(TimeIterationCopyJob it)
	'''
		«left.kmdsType» tmpSwitch = «left.name»;
		«left.name» = «right.name»;
		«right.name» = tmpSwitch;
	'''
	
	private def dispatch CharSequence getInnerContent(ReductionJob it)
	'''

	'''
}