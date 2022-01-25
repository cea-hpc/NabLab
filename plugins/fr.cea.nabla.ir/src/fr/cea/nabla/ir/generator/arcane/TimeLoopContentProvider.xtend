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

import fr.cea.nabla.ir.generator.Utils
import fr.cea.nabla.ir.ir.IrRoot

import static extension fr.cea.nabla.ir.IrModuleExtensions.*

class TimeLoopContentProvider
{
	static def getContent(IrRoot it)
	'''
	<?xml version="1.0" ?>
	<!-- «Utils::doNotEditWarning» -->
	<arcane-config code-name="«name»">
		<time-loops>
			<time-loop name="«name»Loop">
				<title>«name»Loop</title>
				<description>Default timeloop for «name» (generated by NabLab)</description>

				<modules>
					<module name="ArcanePostProcessing" need="required"/>
					«FOR m : modules»
						<module name="«m.className»" need="required"/>
					«ENDFOR»
				</modules>

				<entry-points where="init">
					«FOR m : modules»
						<entry-point name="«m.className».Init"/>
					«ENDFOR»
				</entry-points>

				<entry-points where="compute-loop">
					«FOR m : modules»
						«FOR j : ArcaneUtils.getComputeLoopEntryPointJobs(m)»
							<entry-point name="«m.className».«j.name.toFirstUpper»"/>
						«ENDFOR»
					«ENDFOR»
				</entry-points>
			</time-loop>
		</time-loops>
	</arcane-config>
	'''
}