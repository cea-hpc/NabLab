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

import fr.cea.nabla.ir.ir.IrModule
import org.eclipse.xtend.lib.annotations.Data

import static extension fr.cea.nabla.ir.IrModuleExtensions.*
import static extension fr.cea.nabla.ir.generator.Utils.*

@Data
class AttributesContentProvider
{
	protected val extension ArgOrVarContentProvider
	protected val extension ExpressionContentProvider
	protected def CharSequence getAdditionalContent() { null }

	def getContentFor(IrModule m)
	'''
		// Mesh and mesh variables
		«m.meshClassName»* mesh;
		«FOR c : m.connectivities.filter[multiple] BEFORE 'size_t ' SEPARATOR ', '»«c.nbElemsVar»«ENDFOR»;

		// User options and external classes
		const Options& options;
		«FOR s : m.allProviders»
		«s»& «s.toFirstLower»;
		«ENDFOR»
		«IF m.postProcessingInfo !== null»PvdFileWriter2D writer;«ENDIF»

		// Global definitions
		«FOR v : m.allDefinitions»
			«IF v.constExpr»
				static constexpr «v.cppType» «v.name» = «v.defaultValue.content»;
			«ELSE»
				«IF v.const»const «ENDIF»«v.cppType» «v.name»;
			«ENDIF»
		«ENDFOR»

		// Global declarations
		«FOR v : m.declarations»
			«v.cppType» «v.name»;
		«ENDFOR»
		«IF m.linearAlgebra»LinearAlgebraFunctions::CGInfo cg_info; // CG details«ENDIF»
		utils::Timer globalTimer;
		utils::Timer cpuTimer;
		utils::Timer ioTimer;
		«IF additionalContent !== null»
		«additionalContent»
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