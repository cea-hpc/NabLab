package fr.cea.nabla.ir.generator.dace

import fr.cea.nabla.ir.ir.Affectation
import fr.cea.nabla.ir.ir.ArgOrVarRef
import fr.cea.nabla.ir.ir.BaseType
import fr.cea.nabla.ir.ir.Instruction
import fr.cea.nabla.ir.ir.InstructionBlock
import fr.cea.nabla.ir.ir.IrPackage
import fr.cea.nabla.ir.ir.IrType
import fr.cea.nabla.ir.ir.Variable

import static extension fr.cea.nabla.ir.ArgOrVarExtensions.*

class StateContentProvider
{
	static def dispatch CharSequence getContent(InstructionBlock i, String stateName)
	'''
		«FOR instructionIndex : 0..<i.instructions.size SEPARATOR '\n'»
			«getContent(i.instructions.get(instructionIndex), stateName + "_" + instructionIndex+1)»
		«ENDFOR»
	'''

	static def dispatch CharSequence getContent(Affectation i, String stateName)
	'''
		«stateName» = mysdfg.add_state("«stateName»", is_start_state=True)

		«stateName»_tasklet = «stateName».add_tasklet('«stateName»', «FOR v : getInVars(i) + getOutVars(i)»{'«v.name»'}, «ENDFOR»'«i.left.target.name»=«Utils.getLabel(i.right)»')

		«FOR v : getInVars(i) + getOutVars(i)»
			«stateName»_«v.name» = mysdfg.«getTypeContent(v.type, stateName +'_'+ v.name)»
		«ENDFOR»

		«FOR v : getOutVars(i)»
			«getAddMap(i, v.type, stateName)»
			«getAddMemletPath(i, v.type, stateName)»

		«ENDFOR»


		mysdfg(«FOR v : getInVars(i) + getOutVars(i) SEPARATOR ','»«stateName»_«v.name»=«v.name»«ENDFOR»)
	'''

	static def dispatch CharSequence getContent(Instruction i, String stateName)
	{
		throw new RuntimeException("Not yet implemented")
	}

	private static def getAddMap(Affectation i, IrType t, String stateName)
	{
		switch t
		{
			BaseType: '''map_entry, map_exit = «stateName».add_map('«stateName»_map', dict(«FOR sizeIndex : 0..<t.sizes.size SEPARATOR ','»i«sizeIndex»='0:«Utils.getDaceType(t.sizes.get(sizeIndex))»'«ENDFOR»))'''
			default: throw new RuntimeException("Not yet implemented")
		}
	}

	private static def getAddMemletPath(Affectation i, IrType t, String stateName)
	{
		switch t
		{
			BaseType:
			'''
				«stateName».add_memlet_path(«stateName».add_read(«FOR iv : getInVars(i) »'«stateName»_«iv.name»'),map_entry, «stateName»_tasklet, dst_conn='«iv.name»',memlet=dace.Memlet('«stateName»_«iv.name»[«FOR sizeIndex : 0..<t.sizes.size SEPARATOR ','»i«sizeIndex»«ENDFOR»]')«ENDFOR»)
				«stateName».add_memlet_path(«stateName»_tasklet, map_exit, «stateName».add_write(«FOR iv : getOutVars(i) »'«stateName»_«iv.name»'), src_conn='«iv.name»',memlet=dace.Memlet('«stateName»_«iv.name»[«FOR sizeIndex : 0..<t.sizes.size SEPARATOR ','»i«sizeIndex»«ENDFOR»]')«ENDFOR»)
			'''
			default: throw new RuntimeException("Not yet implemented")
		}
	}

	private static def Iterable<Variable> getInVars(Affectation i)
	{
		val allReferencedVars = i.eAllContents.filter(ArgOrVarRef).filter[x|x.eContainingFeature != IrPackage::eINSTANCE.affectation_Left].map[target]
		allReferencedVars.filter(Variable).filter[global].toSet
	}

	private static def Iterable<Variable> getOutVars(Affectation i)
	{
		val v = i.left.target
		if (v.global) #[v as Variable]
		else #[]
	}

	private static def getTypeContent(IrType t, String varName)
	{
		switch t
		{
			BaseType:
			'''add_array('«varName»', «FOR size : t.sizes BEFORE '[' SEPARATOR ',' AFTER '], '»«Utils.getDaceType(size)»«ENDFOR»«Utils.getDaceType(t.primitive)»)'''
			default: throw new RuntimeException("Not yet implemented")
		}
	}
}