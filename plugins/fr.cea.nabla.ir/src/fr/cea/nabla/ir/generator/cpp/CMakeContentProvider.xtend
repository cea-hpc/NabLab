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

import fr.cea.nabla.ir.IrTypeExtensions
import fr.cea.nabla.ir.generator.CMakeUtils
import fr.cea.nabla.ir.ir.ExtensionProvider
import fr.cea.nabla.ir.ir.IrRoot
import java.util.LinkedHashSet

import static extension fr.cea.nabla.ir.ExtensionProviderExtensions.*
import static extension fr.cea.nabla.ir.IrModuleExtensions.getClassName
import static extension fr.cea.nabla.ir.IrRootExtensions.getExecName

class CMakeContentProvider
{
	public static val WS_PATH = 'N_WS_PATH'

	protected def Iterable<String> getNeededVariables()
	{
		#[WS_PATH]
	}

	protected def CharSequence getFindPackageContent()
	''''''

	protected def Iterable<String> getTargetLinkLibraries()
	{ 
		#['nablalib']
	}

	protected def Iterable<String> getCompilationOptions()
	{ 
		#['-g', '-Wall', '-O3', '--std=c++17', '-mtune=native']
	}

	def getContentFor(IrRoot it, String levelDBPath, Iterable<Pair<String, String>> variables)
	'''
		«CMakeUtils.getFileHeader(false)»

		project(«name»Project CXX)

		«CMakeUtils.setVariables(variables, externalProviders)»

		«CMakeUtils.checkVariables(neededVariables)»

		«CMakeUtils.setCompiler»
		«IF !(levelDBPath.nullOrEmpty && findPackageContent.length == 0)»

			# FIND PACKAGES
			«findPackageContent»
			«IF !levelDBPath.nullOrEmpty»
			set(CMAKE_FIND_ROOT_PATH «levelDBPath»)
			find_package(leveldb REQUIRED)
			find_package(Threads REQUIRED)
			«ENDIF»
		«ENDIF»

		«CMakeUtils.addSubDirectories(true, externalProviders)»

		# EXECUTABLE «execName»
		add_executable(«execName»«FOR m : modules» «m.className + '.cc'»«ENDFOR»)
		target_link_libraries(«execName» PUBLIC«FOR l : getTargetLinkLibs(it, (!levelDBPath.nullOrEmpty))» «l»«ENDFOR»)

		«CMakeUtils.fileFooter»
	'''

	def getCMakeFileContent(ExtensionProvider provider)
	'''
		«CMakeUtils.getFileHeader(true)»

		«CMakeUtils.checkVariables(neededVariables)»

		«CMakeUtils.addSubDirectories(true, #[])»

		# LIBRARY «provider.libName»
		add_library(«provider.libName» «IF provider.linearAlgebra»«IrTypeExtensions.VectorClass».cc «IrTypeExtensions.MatrixClass».cc «ENDIF»«provider.className».cc)
		set_property(TARGET «provider.libName» PROPERTY POSITION_INDEPENDENT_CODE ON)
		target_compile_options(«provider.libName» PUBLIC -g -Wall -O3 --std=c++17 -mtune=native)
		target_include_directories(«provider.libName» PUBLIC ${CMAKE_CURRENT_SOURCE_DIR})
		target_link_libraries(«provider.libName» PUBLIC«FOR l : targetLinkLibraries» «l»«ENDFOR»)

		«CMakeUtils.fileFooter»
	'''

	private def getTargetLinkLibs(IrRoot it, boolean hasLevelDB)
	{
		val libs = new LinkedHashSet<String>
		libs.addAll(targetLinkLibraries)
		if (hasLevelDB) libs += "leveldb::leveldb Threads::Threads"
		externalProviders.forEach[p | libs += p.libName]
		return libs
	}

	private def getExternalProviders(IrRoot it)
	{
		providers.filter[x | x.extensionName != "Math"]
	}
}

class StlThreadCMakeContentProvider extends CMakeContentProvider
{
	override Iterable<String> getCompilationOptions()
	{
		super.compilationOptions + #['-fopenmp']
	}

	override getTargetLinkLibraries()
	{
		super.targetLinkLibraries + #["pthread"]
	}
}

class KokkosCMakeContentProvider extends CMakeContentProvider
{
	override Iterable<String> getNeededVariables()
	{
		 #['N_KOKKOS_PATH'] + super.neededVariables
	}

	override getFindPackageContent()
	'''
		set(CMAKE_FIND_ROOT_PATH ${N_KOKKOS_PATH})
		find_package(Kokkos REQUIRED)
		find_package(KokkosKernels REQUIRED)
	'''

	override Iterable<String> getCompilationOptions()
	{
		super.compilationOptions + #['-fopenmp']
	}

	override getTargetLinkLibraries()
	{
		super.targetLinkLibraries + #['Kokkos::kokkos', 'Kokkos::kokkoskernels']
	}
}

class OpenMpCMakeContentProvider extends CMakeContentProvider
{
	override getFindPackageContent()
	'''
		find_package(OpenMP REQUIRED)
	'''

	override Iterable<String> getCompilationOptions()
	{
		super.compilationOptions + #['-fopenmp']
	}

	override getTargetLinkLibraries()
	{
		super.targetLinkLibraries + #["OpenMP::OpenMP_CXX"]
	}
}
