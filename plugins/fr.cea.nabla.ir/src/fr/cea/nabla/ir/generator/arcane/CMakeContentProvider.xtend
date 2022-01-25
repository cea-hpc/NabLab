/*******************************************************************************
 * Copyright (c) 2022 CEA
 * This program and the accompanying materials are made available under the
 * terms of the Eclipse Public License 2.0 which is available at
 * http://www.eclipse.org/legal/epl-2.0.
 *
 * SPDX-License-Identifier: EPL-2.0
 * Contributors: see AUTHORS file
 *******************************************************************************/
package fr.cea.nabla.ir.generator.arcane

import fr.cea.nabla.ir.generator.CMakeUtils
import fr.cea.nabla.ir.ir.IrRoot

import static extension fr.cea.nabla.ir.ExtensionProviderExtensions.*
import static extension fr.cea.nabla.ir.IrModuleExtensions.*
import static extension fr.cea.nabla.ir.IrRootExtensions.*

class CMakeContentProvider
{
	static def getContent(IrRoot it, Iterable<Pair<String, String>> variables)
	'''
	«CMakeUtils.getFileHeader(false)»

	«CMakeUtils.setVariables(variables, externalProviders)»

	«CMakeUtils.checkVariables(false, #["Arcane_ROOT"])»

	project(«name» LANGUAGES CXX)

	find_package(Arcane REQUIRED)

	«CMakeUtils.addSubDirectories(true, externalProviders)»

	add_executable(«name»«FOR m : modules» «ArcaneUtils.getModuleName(m)».cc «m.className»_axl.h«ENDFOR» main.cc)

	«FOR m : modules»
	arcane_generate_axl(«m.className»)
	«ENDFOR»
	#arcane_add_arcane_libraries_to_target(«name»)
	target_link_libraries(«name» PRIVATE arcane_full nablalib«FOR e : externalProviders» «e.libName»«ENDFOR»)
	target_include_directories(«name» PUBLIC . ${CMAKE_CURRENT_BINARY_DIR})

	«CMakeUtils.fileFooter»
	'''
}