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
	static def dispatch CharSequence getContent(InstructionBlock i, String stateName, int compteur)
	//static def dispatch CharSequence getContent(InstructionBlock i, String stateName)
	'''
		«var count=0»
		«FOR innerInstruction : i.instructions SEPARATOR '\n'»
			«getContent(innerInstruction, stateName + "_" + (count++), (count++))»
		«ENDFOR»
	'''

	static def dispatch CharSequence getContent(Affectation i, String stateName, int count)
	//static def dispatch CharSequence getContent(Affectation i, String stateName)
	'''
		
		«getAddState(stateName, count)»
«««		«stateName» = mysdfg.add_state()

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
	
	private static def getAddState(String stateName, int count)
	{
		if(count == 0)
		{
			'''
				«stateName» = mysdfg.add_state()
			'''
		}
		else if(count == 1)
		{
			'''
				«stateName» = mysdfg.add_state("state2",is_start_state=True)
			'''
		}
	}
	private static def getAddMap(Affectation i, IrType t, String stateName)
	{
		switch t
		{
			BaseType:
			{
				switch(t.sizes.size)
				{
					case 1:'''map_entry, map_exit = «stateName».add_map('«stateName»_map', dict(i='«t.arrayDimension»'))'''
					case 2: '''map_entry, map_exit = «stateName».add_map('«stateName»_map', dict(i='0:«Utils.getDaceType(t.sizes.get(0))»',j='0:«Utils.getDaceType(t.sizes.get(1))»'))'''
				}
			}
		}
	}
	private static def getAddMemletPath(Affectation i, IrType t, String stateName)
	{
		switch t
		{
			BaseType:
			{
				switch(t.sizes.size)
				{
					case 1:'''						
						«stateName».add_memlet_path(«stateName».add_read(«FOR iv : getInVars(i) »'«stateName»_«iv.name»'),map_entry, «stateName»_tasklet, dst_conn='«iv.name»',memlet=dace.Memlet('«stateName»_«iv.name»[i]')«ENDFOR»)
						«stateName».add_memlet_path(«stateName»_tasklet, map_exit, «stateName».add_write(«FOR iv : getOutVars(i) »'«stateName»_«iv.name»'), src_conn='«iv.name»',memlet=dace.Memlet('«stateName»_«iv.name»[i]')«ENDFOR»)
					'''
					
					case 2:'''						
						«stateName».add_memlet_path(«stateName».add_read(«FOR iv : getInVars(i) »'«stateName»_«iv.name»'),map_entry, «stateName»_tasklet, dst_conn='«iv.name»',memlet=dace.Memlet('«stateName»_«iv.name»[i,j]')«ENDFOR»)
						«stateName».add_memlet_path(«stateName»_tasklet, map_exit, «stateName».add_write(«FOR iv : getOutVars(i) »'«stateName»_«iv.name»'), src_conn='«iv.name»',memlet=dace.Memlet('«stateName»_«iv.name»[i,j]')«ENDFOR»)
					'''
						
				}
			}
		}
	}

	static def dispatch CharSequence getContent(Instruction i, String stateName, int count)
	{
		throw new RuntimeException("Not yet implemented")
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
			{
				switch (t.sizes.size)
				{
					case 0: '''add_array('«varName»', [«Utils.getDaceType(t.sizes.get(0))»], «Utils.getDaceType(t.primitive)»)'''
					case 1: '''add_array('«varName»', [«Utils.getDaceType(t.sizes.get(0))»], «Utils.getDaceType(t.primitive)»)'''
					case 2: '''add_array('«varName»', [«Utils.getDaceType(t.sizes.get(0))», «Utils.getDaceType(t.sizes.get(1))»], «Utils.getDaceType(t.primitive)»)'''
					default: throw new RuntimeException("Not yet implemented")
				}
			}
			default: throw new RuntimeException("Not yet implemented")
		}
	}

	private static def boolean isArray(IrType t)
	{
		getArrayDimension(t) !== null
	}
	

	private static def getArrayDimension(IrType t)
	{
		switch t
		{
			BaseType:
			{
				switch (t.sizes.size)
				{
					case 1: "0:" + Utils.getDaceType(t.sizes.get(0))
					default: null
				}
			}
			default: null
		}
	}
}