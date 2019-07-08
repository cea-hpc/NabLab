/*******************************************************************************
 * Copyright (c) 2018 CEA
 * This program and the accompanying materials are made available under the 
 * terms of the Eclipse Public License 2.0 which is available at
 * http://www.eclipse.org/legal/epl-2.0.
 *
 * SPDX-License-Identifier: EPL-2.0
 *
 * Contributors:
 * 	Benoit Lelandais - initial implementation
 * 	Marie-Pierre Oudot - initial implementation
 * 	Jean-Sylvan Camier - Nabla generation support
 *******************************************************************************/
package fr.cea.nabla.tests

import com.google.inject.Inject
import fr.cea.nabla.nabla.InstructionBlock
import fr.cea.nabla.nabla.Loop
import fr.cea.nabla.nabla.NablaModule
import fr.cea.nabla.nabla.PrimitiveType
import fr.cea.nabla.nabla.ScalarVarDefinition
import fr.cea.nabla.typing.ExpressionTypeProvider
import org.eclipse.xtext.testing.InjectWith
import org.eclipse.xtext.testing.XtextRunner
import org.eclipse.xtext.testing.util.ParseHelper
import org.junit.Test
import org.junit.runner.RunWith

@RunWith(XtextRunner)
@InjectWith(NablaInjectorProvider)
class NablaTypeProviderTest 
{
	@Inject ParseHelper<NablaModule> parseHelper
	@Inject extension ExpressionTypeProvider
	
	@Test 
	def void testGetTypeForExpression() 
	{
		val module = parseHelper.parse('''
			module test;
			
			j1: ∀ j∈cells, {
				ℕ a = 1;
				ℝ b = 2.0;
				ℝ[2] c = [1.0, 2.0];
				ℝ[3] d = [1.0, 2.0, 3.0];
			}
		''')
		
		val aVal = getVarDefaultValue(module, 0)
		TestUtils.assertEquals(PrimitiveType::INT, #[], aVal.typeFor)
		val bVal = getVarDefaultValue(module, 1)
		TestUtils.assertEquals(PrimitiveType::REAL, #[], bVal.typeFor)
		val cVal = getVarDefaultValue(module, 2)
		TestUtils.assertEquals(PrimitiveType::REAL, #[2], cVal.typeFor)
		val dVal = getVarDefaultValue(module, 3)
		TestUtils.assertEquals(PrimitiveType::REAL, #[3], dVal.typeFor)
	}
	
	private def getVarDefaultValue(NablaModule it, int index)
	{
		val block = (jobs.head.instruction as Loop).body as InstructionBlock
		val definition = block.instructions.get(index) as ScalarVarDefinition
		return definition.defaultValue
	}
}