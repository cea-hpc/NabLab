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
import fr.cea.nabla.ir.ir.SimpleVariable
import fr.cea.nabla.ir.ir.Variable
import org.eclipse.xtend.lib.annotations.Data

import static extension fr.cea.nabla.ir.ArgOrVarExtensions.*
import static extension fr.cea.nabla.ir.IrModuleExtensions.*
import static extension fr.cea.nabla.ir.IrRootExtensions.*
import static extension fr.cea.nabla.ir.generator.Utils.*

@Data
class AttributesContentProvider
{
	protected val extension ArgOrVarContentProvider
	protected val extension ExpressionContentProvider
	protected def CharSequence getAdditionalContent() { null }

	def getContentFor(IrModule it)
	'''
		// Mesh and mesh variables
		«meshClassName»* mesh;
		«FOR c : irRoot.connectivities.filter[multiple] BEFORE 'size_t ' SEPARATOR ', '»«c.nbElemsVar»«ENDFOR»;

		// User options
		Options& options;
		«IF postProcessing !== null»PvdFileWriter2D writer;«ENDIF»

		«IF irRoot.modules.size > 1»
			«IF main»
				// Additional modules
				«FOR m : irRoot.modules.filter[x | x !== it]»
					«m.className»* «m.name»;
				«ENDFOR»
			«ELSE»
				// Main module
				«irRoot.mainModule.className»* mainModule;
			«ENDIF»

		«ENDIF»
		// Global variables
		«FOR v : variables.filter[!option]»
			«v.variableDeclaration»
		«ENDFOR»

		utils::Timer globalTimer;
		utils::Timer cpuTimer;
		utils::Timer ioTimer;
		«IF additionalContent !== null»
		«additionalContent»
		«ENDIF»
	'''

	private def CharSequence getVariableDeclaration(Variable v)
	{
		switch (v)
		{
			 SimpleVariable case v.constExpr: '''static constexpr «v.cppType» «v.name» = «v.defaultValue.content»;'''
			 SimpleVariable case v.const: '''const «v.cppType» «v.name»;'''
			 default: '''«v.cppType» «v.name»;'''
		}
	}
}

@Data
class KokkosTeamThreadAttributesContentProvider extends AttributesContentProvider
{
	override getAdditionalContent()
	'''
		typedef Kokkos::TeamPolicy<Kokkos::DefaultExecutionSpace::scratch_memory_space>::member_type member_type;
	'''
}