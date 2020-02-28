package fr.cea.nabla.ir.generator.cpp

import fr.cea.nabla.ir.ir.IrModule
import org.eclipse.xtend.lib.annotations.Data

import static extension fr.cea.nabla.ir.IrModuleExtensions.*
import static extension fr.cea.nabla.ir.generator.Utils.*

@Data
class AttributesContentProvider
{
	protected val extension ArgOrVarContentProvider
	protected def CharSequence getAdditionalContent() { null }

	def getContentFor(IrModule m)
	'''
		«IF m.withMesh»
		CartesianMesh2D* mesh;
		PvdFileWriter2D writer;
		«FOR c : m.usedConnectivities BEFORE 'int ' SEPARATOR ', '»«c.nbElems»«ENDFOR»;
		«ENDIF»
		«getGlobalVariablesContent(m)»
		«getConnectivityVariablesContent(m)»
		«getLinearAlgebraVariablesContent(m)»
		utils::Timer globalTimer;
		utils::Timer cpuTimer;
		utils::Timer ioTimer;
		«IF additionalContent !== null»
		«additionalContent»
		«ENDIF»
	'''

	private def getGlobalVariablesContent(IrModule m)
	'''
		«val globals = m.globalVariables»
		«IF !globals.empty»

		// Global Variables
		«val globalsByType = globals.groupBy[cppType]»
		«FOR type : globalsByType.keySet»
		«type» «FOR v : globalsByType.get(type) SEPARATOR ', '»«v.name»«ENDFOR»;
		«ENDFOR»
		«ENDIF»
	'''

	private def getConnectivityVariablesContent(IrModule m)
	'''
		«val connectivityVars = m.connectivityVariables»
		«IF !connectivityVars.empty»

		// Connectivity Variables
		«FOR v : connectivityVars»
		«v.cppType» «v.name»;
		«ENDFOR»
		«ENDIF»
	'''

	private def getLinearAlgebraVariablesContent(IrModule m)
	'''
		«val linearAlgebraVars = m.linearAlgebraVariables»
		«IF !linearAlgebraVars.empty»

		// Linear Algebra Variables
		«FOR v : linearAlgebraVars»
		«v.cppType» «v.name»;
		«ENDFOR»
		// CG details
		LinearAlgebraFunctions::CGInfo cg_info;
		«ENDIF»
	'''
}

@Data
class KokkosTeamThreadAttributesContentProvider extends AttributesContentProvider
{
	override getAdditionalContent()
	'''
		typedef Kokkos::TeamPolicy<Kokkos::DefaultExecutionSpace::scratch_memory_space>::member_type member_type;
	'''
}