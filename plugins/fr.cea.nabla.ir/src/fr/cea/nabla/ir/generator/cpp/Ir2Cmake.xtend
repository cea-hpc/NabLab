/*******************************************************************************
 * Copyright (c) 2020 CEA
 * This program and the accompanying materials are made available under the 
 * terms of the Eclipse Public License 2.0 which is available at
 * http://www.eclipse.org/legal/epl-2.0.
 *
 * SPDX-License-Identifier: EPL-2.0
 * Contributors: see AUTHORS file
 *******************************************************************************/
package fr.cea.nabla.ir.generator.cpp

import fr.cea.nabla.ir.ir.IrRoot
import java.util.HashMap

import static extension fr.cea.nabla.ir.IrRootExtensions.*
import static extension fr.cea.nabla.ir.generator.ExtensionProviderExtensions.*
import static extension fr.cea.nabla.ir.generator.Utils.*

abstract class IrRoot2Cmake
{
	protected def CharSequence getLibraryBackend(IrRoot ir) { '''''' }
	protected def Iterable<String> getTargetLinkLibraries(IrRoot ir) { #[] }

	def getContentFor(IrRoot it, String libCppNablaDir, String levelDBPath, HashMap<String, String> variables)
	'''
		«CMakeUtils.fileHeader»

		set(LIBCPPNABLA_DIR «libCppNablaDir» CACHE STRING "")
		«FOR entry : variables.entrySet»
		set(«entry.key» «entry.value»)
		«ENDFOR»
		«val externalProviders = providers.filter[x | x.extensionName != "Math" && x.extensionName != "LinearAlgebra"]»
		«FOR ep : externalProviders»
		set(«ep.extensionName.toUpperCase»_HOME «ep.projectHome»)
		«ENDFOR»

		project(«name»Project CXX)

		«CMakeUtils.setCompiler»

		«libraryBackend»
		add_subdirectory(${LIBCPPNABLA_DIR} ${CMAKE_CURRENT_BINARY_DIR}/libcppnabla EXCLUDE_FROM_ALL)
		«FOR ep : externalProviders»
		add_subdirectory(${«ep.extensionName.toUpperCase»_HOME}/src ${CMAKE_CURRENT_BINARY_DIR}/«ep.extensionName.toLowerCase» EXCLUDE_FROM_ALL)
		«ENDFOR»

		«IF !levelDBPath.nullOrEmpty»
		set(CMAKE_FIND_ROOT_PATH «levelDBPath»)
		find_package(leveldb)
		find_package(Threads REQUIRED)
		if(TARGET leveldb::leveldb)
			message(STATUS "levelDB found")
		else()
			message(STATUS "levelDB NOT found !!!")
		endif()
		«ENDIF»

		add_executable(«name.toLowerCase»«FOR m : modules» «m.className + '.cc'»«ENDFOR»)
		target_include_directories(«name.toLowerCase» PUBLIC ${CMAKE_CURRENT_SOURCE_DIR}/..)
		target_link_libraries(«name.toLowerCase» PUBLIC cppnabla«FOR tll : targetLinkLibraries» «tll»«ENDFOR»«IF !levelDBPath.nullOrEmpty» leveldb::leveldb Threads::Threads«ENDIF»«FOR ep : externalProviders» «ep.libName»«ENDFOR»)

		«CMakeUtils.fileFooter»
	'''
}

class StlCmake extends IrRoot2Cmake
{
	override getTargetLinkLibraries(IrRoot ir)
	{
		#["cppnablastl", "pthread"]
	}
}

class KokkosCmake extends IrRoot2Cmake
{
	override getTargetLinkLibraries(IrRoot ir)
	{
		#["cppnablakokkos"]
	}
}

class SequentialCmake extends IrRoot2Cmake
{
	override getTargetLinkLibraries(IrRoot ir)
	{
		if (ir.linearAlgebra)
			#["cppnablastl", "pthread"]
		else
			#[]
	}
}

class OpenMpCmake extends IrRoot2Cmake
{
	override getLibraryBackend(IrRoot ir)
	'''
		find_package(OpenMP)
	'''

	override getTargetLinkLibraries(IrRoot ir)
	{
		if (ir.linearAlgebra)
			#["OpenMP::OpenMP_CXX", "cppnablastl", "pthread"]
		else
			#["OpenMP::OpenMP_CXX"]
	}
}
