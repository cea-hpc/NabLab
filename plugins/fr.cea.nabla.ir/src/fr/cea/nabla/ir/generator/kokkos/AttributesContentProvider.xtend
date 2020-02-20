package fr.cea.nabla.ir.generator.kokkos

import fr.cea.nabla.ir.ir.IrModule

import static extension fr.cea.nabla.ir.IrModuleExtensions.*
import static extension fr.cea.nabla.ir.generator.Utils.*
import static extension fr.cea.nabla.ir.generator.kokkos.Ir2KokkosUtils.*

interface AttributesContentProvider 
{
	def CharSequence getContentFor(IrModule m)
}

class DefaultAttributesContentProvider implements AttributesContentProvider
{
	override getContentFor(IrModule m)
	'''
		«IF m.withMesh»
		CartesianMesh2D* mesh;
		PvdFileWriter2D writer;
		«FOR c : m.usedConnectivities BEFORE 'int ' SEPARATOR ', '»«c.nbElems»«ENDFOR»;
		«ENDIF»
		«getGlobalVariablesContent(m)»
		«getConnectivityVariablesContent(m)»
		«getLinearAlgebraVariablesContent(m)»
		utils::Timer global_timer;
		utils::Timer cpu_timer;
		utils::Timer io_timer;
	'''

	protected def getGlobalVariablesContent(IrModule m)
	'''
		«val globals = m.globalVariables»
		«IF !globals.empty»
		
		// Global Variables
		«val globalsByType = globals.groupBy[type.cppType]»
		«FOR type : globalsByType.keySet»
		«type» «FOR v : globalsByType.get(type) SEPARATOR ', '»«v.name»«ENDFOR»;
		«ENDFOR»
		«ENDIF»
	'''

	protected def getConnectivityVariablesContent(IrModule m)
	'''
		«val connectivityVars = m.connectivityVariables»
		«IF !connectivityVars.empty»

		// Connectivity Variables
		«FOR v : connectivityVars»
		«v.cppType» «v.name»;
		«ENDFOR»
		«ENDIF»
	'''

	protected def getLinearAlgebraVariablesContent(IrModule m)
	'''		utils::Timer global_timer;
			utils::Timer cpu_timer;
			utils::Timer io_timer;
	
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

class KokkosTeamThreadAttributesContentProvider extends DefaultAttributesContentProvider
{
	override getContentFor(IrModule m)
	'''
		«super.getContentFor(m)»
		typedef Kokkos::TeamPolicy<Kokkos::DefaultExecutionSpace::scratch_memory_space>::member_type member_type;
	'''
}