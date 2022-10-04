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

import fr.cea.nabla.ir.annotations.AcceleratorAnnotation
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

	project(«name» LANGUAGES C CXX)

	find_package(Arcane REQUIRED)

	«CMakeUtils.addSubDirectories(true, externalProviders)»

	add_executable(«execName»«FOR m : modules» «ArcaneUtils.getClassName(m)».cc «m.className»_axl.h«ENDFOR» main.cc)

	«FOR m : modules»
		arcane_generate_axl(«m.className»)
	«ENDFOR»
	configure_file(«name».config ${CMAKE_CURRENT_BINARY_DIR} @ONLY)
	#arcane_add_arcane_libraries_to_target(«execName»)
	«IF AcceleratorAnnotation.tryToGet(it) !== null»
		arcane_accelerator_enable()
		«FOR m : modules.filter[x | AcceleratorAnnotation.tryToGet(x) !== null]»
			arcane_accelerator_add_source_files(«ArcaneUtils.getClassName(m)».cc)
		«ENDFOR»
		arcane_accelerator_add_to_target(«execName»)
	«ENDIF»
	target_link_libraries(«execName» PRIVATE arcane_full nablalib«FOR e : externalProviders» «e.libName»«ENDFOR»)
	target_include_directories(«execName» PUBLIC . ${CMAKE_CURRENT_BINARY_DIR})

	«CMakeUtils.fileFooter»
	'''
}