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

import fr.cea.nabla.ir.IrUtils
import fr.cea.nabla.ir.generator.Utils
import fr.cea.nabla.ir.ir.ExecuteTimeLoopJob
import fr.cea.nabla.ir.ir.IrModule
import fr.cea.nabla.ir.ir.Job

import static extension fr.cea.nabla.ir.JobCallerExtensions.*
import static extension fr.cea.nabla.ir.generator.arcane.ExpressionContentProvider.*
import static extension fr.cea.nabla.ir.generator.arcane.InstructionContentProvider.*

class JobContentProvider
{
	static def getDeclarationContent(Job it)
	'''virtual void «Utils.getCodeName(it)»()'''

	static def getDefinitionContent(Job it)
	'''
		«Utils.getComment(it)»
		void «ArcaneUtils.getClassName(IrUtils.getContainerOfType(it, IrModule))»::«Utils.getCodeName(it)»()
		{
			«getInnerContent(it)»
		}
	'''

	private static def getInnerContent(Job it)
	{
		switch it
		{
			ExecuteTimeLoopJob case caller.main:
			// main loop (n) manage by Arcane
			'''
				«val itVar = ArcaneUtils.getCodeName(iterationCounter)»
				«itVar»++;
				«FOR c : calls»
					«ArcaneUtils.getCallName(c)»(); // @«c.at»
				«ENDFOR»

				// Evaluate loop condition with variables at time n
				bool continueLoop = («whileCondition.content»);

				«instruction.innerContent»

				if (!continueLoop)
					subDomain()->timeLoopMng()->stopComputeLoop(true);
			'''
			ExecuteTimeLoopJob case !caller.main:
			// inner loop (k)
			'''
				«val itVar = ArcaneUtils.getCodeName(iterationCounter)»
				«itVar» = 0;
				bool continueLoop = true;
				do
				{
					«itVar»++;
					info() << "Start iteration «iterationCounter.name»: " << std::setprecision(5) << «itVar»;
					«FOR c : calls»
						«ArcaneUtils.getCallName(c)»(); // @«c.at»
					«ENDFOR»

					// Evaluate loop condition with variables at time n
					continueLoop = («whileCondition.content»);

					«instruction.innerContent»
				} while (continueLoop);
			'''
			default:
				InstructionContentProvider.getInnerContent(instruction)
		}
	}
}
