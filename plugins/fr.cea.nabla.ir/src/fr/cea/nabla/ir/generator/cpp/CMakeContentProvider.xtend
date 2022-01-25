/*******************************************************************************
 * Copyright (c) 2022 CEA
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
import fr.cea.nabla.ir.ir.DefaultExtensionProvider
import fr.cea.nabla.ir.ir.IrRoot
import java.util.LinkedHashSet

import static extension fr.cea.nabla.ir.ExtensionProviderExtensions.*
import static extension fr.cea.nabla.ir.IrModuleExtensions.getClassName
import static extension fr.cea.nabla.ir.IrRootExtensions.*
import static extension fr.cea.nabla.ir.IrRootExtensions.getExecName

class CMakeContentProvider
{
	protected def Iterable<String> getNeededVariables()
	{
		#[]
	}

	protected def CharSequence getFindPackageContent(boolean isLinearAlgebra)
	''''''

	protected def Iterable<String> getTargetLinkLibraries(boolean isLinearAlgebra)
	{ 
		#['nablalib']
	}

	protected def Iterable<String> getCompilationOptions()
	{ 
		#['-g', '-Wall', '-O3', '--std=c++17', '-mtune=native']
	}

	def getContentFor(IrRoot it, boolean hasLevelDB, Iterable<Pair<String, String>> variables)
	'''
		«CMakeUtils.getFileHeader(false)»

		«CMakeUtils.setVariables(variables, externalProviders)»

		«CMakeUtils.checkVariables(false, neededVariables)»

		# PROJECT
		project(«name»Project CXX)

		«CMakeUtils.checkCompiler»
		«IF hasLevelDB || getFindPackageContent(linearAlgebra).length != 0»

			# FIND PACKAGES
			«getFindPackageContent(linearAlgebra)»
			«IF hasLevelDB»
			find_package(leveldb REQUIRED)
			find_package(Threads REQUIRED)
			«ENDIF»
		«ENDIF»

		«CMakeUtils.addSubDirectories(true, externalProviders)»

		# EXECUTABLE «execName»
		add_executable(«execName»«FOR m : modules» «m.className + '.cc'»«ENDFOR»)
		target_link_libraries(«execName» PUBLIC«FOR l : getRootTargetLinkLibraries(it, hasLevelDB)» «l»«ENDFOR»)

		«CMakeUtils.fileFooter»
	'''

	def getCMakeFileContent(DefaultExtensionProvider provider)
	'''
		«CMakeUtils.getFileHeader(true)»

		«CMakeUtils.checkVariables(true, #[])»

		«CMakeUtils.addSubDirectories(true, #[])»

		# LIBRARY «provider.libName»
		add_library(«provider.libName» «IF provider.linearAlgebra»«IrTypeExtensions.VectorClass».cc «IrTypeExtensions.MatrixClass».cc «ENDIF»«provider.className».cc)
		set_property(TARGET «provider.libName» PROPERTY POSITION_INDEPENDENT_CODE ON)
		target_compile_options(«provider.libName» PUBLIC -g -Wall -O3 --std=c++17 -mtune=native)
		target_include_directories(«provider.libName» PUBLIC ${CMAKE_CURRENT_SOURCE_DIR})
		target_link_libraries(«provider.libName» PUBLIC«FOR l : getTargetLinkLibraries(provider.linearAlgebra)» «l»«ENDFOR»)

		«CMakeUtils.fileFooter»
	'''

	private def getRootTargetLinkLibraries(IrRoot it, boolean hasLevelDB)
	{
		val libs = new LinkedHashSet<String>
		libs.addAll(getTargetLinkLibraries(linearAlgebra))
		if (hasLevelDB) libs += "leveldb::leveldb Threads::Threads"
		externalProviders.forEach[p | libs += p.libName]
		return libs
	}
}

class StlThreadCMakeContentProvider extends CMakeContentProvider
{
	override Iterable<String> getCompilationOptions()
	{
		super.compilationOptions + #['-fopenmp']
	}

	override getTargetLinkLibraries(boolean isLinearAlgebra)
	{
		super.getTargetLinkLibraries(isLinearAlgebra) + #["pthread"]
	}
}

class KokkosCMakeContentProvider extends CMakeContentProvider
{
	override getNeededVariables()
	{
		#['Kokkos_ROOT']
	}

	override getFindPackageContent(boolean isLinearAlgebra)
	'''
		find_package(Kokkos REQUIRED)
		«IF isLinearAlgebra»find_package(KokkosKernels REQUIRED)«ENDIF»
	'''

	override Iterable<String> getCompilationOptions()
	{
		super.compilationOptions + #['-fopenmp']
	}

	override getTargetLinkLibraries(boolean isLinearAlgebra)
	{
		if (isLinearAlgebra)
			super.getTargetLinkLibraries(isLinearAlgebra) + #['Kokkos::kokkos', 'Kokkos::kokkoskernels']
		else
			super.getTargetLinkLibraries(isLinearAlgebra) + #['Kokkos::kokkos']
	}
}

class OpenMpCMakeContentProvider extends CMakeContentProvider
{
	override getFindPackageContent(boolean isLinearAlgebra)
	'''
		find_package(OpenMP REQUIRED)
	'''

	override Iterable<String> getCompilationOptions()
	{
		super.compilationOptions + #['-fopenmp']
	}

	override getTargetLinkLibraries(boolean isLinearAlgebra)
	{
		super.getTargetLinkLibraries(isLinearAlgebra) + #["OpenMP::OpenMP_CXX"]
	}
}
