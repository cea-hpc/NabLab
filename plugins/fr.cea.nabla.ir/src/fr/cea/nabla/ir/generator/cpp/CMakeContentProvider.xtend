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

import fr.cea.nabla.ir.generator.CMakeUtils
import fr.cea.nabla.ir.ir.IrRoot
import java.util.HashMap

import static extension fr.cea.nabla.ir.IrRootExtensions.*
import static extension fr.cea.nabla.ir.generator.Utils.*

abstract class CMakeContentProvider
{
	protected def CharSequence getLibraryBackend(IrRoot ir) { '''''' }
	protected def Iterable<String> getTargetLinkLibraries(IrRoot ir) { #[] }

	def getContentFor(IrRoot it, String libCppNablaDir, String levelDBPath, HashMap<String, String> variables)
	'''
		«CMakeUtils.fileHeader»

		set(LIBCPPNABLA_DIR «CMakeUtils.formatCMakePath(libCppNablaDir)» CACHE STRING "")
		«FOR entry : variables.entrySet»
		set(«entry.key» «entry.value»)
		«ENDFOR»
		«val externalProviders = providers.filter[x | x.extensionName != "Math"]»
		«FOR ep : externalProviders»
		set(«ep.extensionName.toUpperCase»_DIR «CMakeUtils.formatCMakePath(ep.projectDir)»)
		«ENDFOR»

		project(«name»Project CXX)

		«CMakeUtils.setCompiler»

		«libraryBackend»
		«FOR ep : externalProviders»
		add_subdirectory(${«ep.extensionName.toUpperCase»_DIR}/src ${CMAKE_BINARY_DIR}/«ep.providerName» EXCLUDE_FROM_ALL)
		«ENDFOR»
		if(NOT TARGET cppnabla)
			add_subdirectory(${LIBCPPNABLA_DIR}/src ${CMAKE_BINARY_DIR}/«CppGeneratorUtils::CppLibName» EXCLUDE_FROM_ALL)
		endif()

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

class StlCMakeContentProvider extends CMakeContentProvider
{
	override getTargetLinkLibraries(IrRoot ir)
	{
		#["cppnablastl", "pthread"]
	}
}

class KokkosCMakeContentProvider extends CMakeContentProvider
{
	override getTargetLinkLibraries(IrRoot ir)
	{
		#["cppnablakokkos"]
	}
}

class SequentialCMakeContentProvider extends CMakeContentProvider
{
	override getTargetLinkLibraries(IrRoot ir)
	{
		if (ir.linearAlgebra)
			#["cppnablastl", "pthread"]
		else
			#[]
	}
}

class OpenMpCMakeContentProvider extends CMakeContentProvider
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
