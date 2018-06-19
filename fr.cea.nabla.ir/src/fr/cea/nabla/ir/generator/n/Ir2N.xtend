package fr.cea.nabla.ir.generator.n

import com.google.inject.Inject
import fr.cea.nabla.ir.ir.ArrayVariable
import fr.cea.nabla.ir.ir.IrModule
import fr.cea.nabla.ir.ir.ScalarVariable

class Ir2N 
{
	@Inject extension Ir2NUtils
	@Inject extension ExpressionContentProvider
	@Inject extension JobContentProvider
	@Inject extension DirtyPatchProvider
	
	def getFileContent(IrModule it)
	'''
		«fileHeader»
		
		options {
			«FOR v : variables.filter(ScalarVariable).filter[const]»
				«v.type.NType» «v.name» = «v.defaultValue.content»;
			«ENDFOR»
		};
		
		global {
			«val varsByType = variables.filter(ScalarVariable).filter[!const].filter[x|!backendImplicitVariables.contains(x.name)].groupBy[type]»
			«FOR type : varsByType.keySet»
				«type.NType» «FOR v : varsByType.get(type) SEPARATOR ', '»«v.name»«ENDFOR»;
			«ENDFOR»
		};
		
		«FOR support : itemVariables.keySet SEPARATOR '\n'»
		«support.literal» {
			«val itemVarsByType = itemVariables.get(support).groupBy[type]»
			«FOR type : itemVarsByType.keySet»
				«type.NType» «FOR v : itemVarsByType.get(type) SEPARATOR ', '»«v.name»«ENDFOR»;
			«ENDFOR»
		};
		«ENDFOR»
		
		«FOR j : jobs.sortBy[at]»
			«j.content»
			
		«ENDFOR»
	'''
	
	private def getItemVariables(IrModule it)
	{
		val msg = "** Unmanaged dimensions of variables: "
		val unmanagedDimvars = variables.filter(ArrayVariable).filter[dimensions.size>2]
		if (!unmanagedDimvars.empty) throw new Exception(msg + unmanagedDimvars.map[name].join(', '))
	
		val dim1Vars = variables.filter(ArrayVariable).filter[dimensions.size==1]
		val wrongDim1Vars = dim1Vars.filter[! (dimensions.head.inTypes.empty && dimensions.head.returnType.multiple)]
		if (!wrongDim1Vars.empty) throw new Exception(msg + wrongDim1Vars.map[name].join(', '))

		val dim2Vars = variables.filter(ArrayVariable).filter[dimensions.size==2]
		val wrongDim2Vars = dim2Vars.filter[! (dimensions.get(1).inTypes.size==1 && dimensions.get(0).returnType.type==dimensions.get(1).inTypes.head)]
		if (!wrongDim2Vars.empty) throw new Exception(msg + wrongDim2Vars.map[name].join(', '))
		
		variables.filter(ArrayVariable).groupBy[dimensions.head.returnType.type]
	}
}