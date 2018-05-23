package fr.cea.nabla.ir.generator.n

class Ir2N 
{
//	@Inject extension ExpressionContentProvider
//	@Inject extension JobContentProvider
//	@Inject extension DirtyPatchProvider
//	
//	def getFileContent(NablaIrFile it)
//	'''
//		«fileHeader»
//		
//		options {
//			«FOR v : options.filter[x|x.defaultValue!==null]»
//				«v.type.literal» «v.name» = «v.defaultValue.content»;
//			«ENDFOR»
//		};
//		
//		global {
//			«val varsByType = globalVariables.filter[x|!backendImplicitVariables.contains(x.name)].groupBy[type]»
//			«FOR type : varsByType.keySet»
//				«type.literal» «FOR v : varsByType.get(type) SEPARATOR ', '»«v.name»«ENDFOR»;
//			«ENDFOR»
//		};
//		
//		«val itemVarsBySupport = itemVariables.groupBy[support]»
//		«FOR support : itemVarsBySupport.keySet SEPARATOR '\n'»
//		«support.literal» {
//			«val itemVarsByType = itemVarsBySupport.get(support).groupBy[type]»
//			«FOR type : itemVarsByType.keySet»
//				«type.literal» «FOR v : itemVarsByType.get(type) SEPARATOR ', '»«v.content»«ENDFOR»;
//			«ENDFOR»
//		};
//		«ENDFOR»
//		
//		«getCopyCoordinatesJob(jobs.map[at].min - 1)»
//		
//		«FOR j : jobs.sortBy[at]»
//			«j.content»
//			
//		«ENDFOR»
//	'''
//	
//	private def getContent(ItemVariable it)
//	'''«getName»«IF innerSupport!=ItemFamily::NONE»[«innerSupport.literal»]«ENDIF»'''
}