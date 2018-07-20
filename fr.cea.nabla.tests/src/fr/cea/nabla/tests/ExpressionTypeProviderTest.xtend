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
import fr.cea.nabla.nabla.Expression
import fr.cea.nabla.nabla.InstructionBlock
import fr.cea.nabla.nabla.InstructionJob
import fr.cea.nabla.nabla.Loop
import fr.cea.nabla.nabla.NablaModule
import fr.cea.nabla.nabla.VarDeclaration
import fr.cea.nabla.typing.BasicTypeProvider
import fr.cea.nabla.typing.ExpressionTypeProvider
import fr.cea.nabla.typing.NablaType
import org.eclipse.xtext.testing.InjectWith
import org.eclipse.xtext.testing.XtextRunner
import org.eclipse.xtext.testing.util.ParseHelper
import org.eclipse.xtext.testing.validation.ValidationTestHelper
import org.junit.Assert
import org.junit.Test
import org.junit.runner.RunWith

import static extension fr.cea.nabla.typing.NablaType.*

@RunWith(XtextRunner)
@InjectWith(NablaInjectorProvider)
class ExpressionTypeProviderTest 
{
	@Inject ParseHelper<NablaModule> parseHelper;
	@Inject extension ValidationTestHelper
	@Inject extension ExpressionTypeProvider
	@Inject extension TestUtils
	
	@Test 
	def void testGetTypeForExpression() 
	{
		val result = parseHelper.parse('''
			module test;
			
			sets { 
				cells; 
			}
			
			global {
			}
			
			cells {
			}

			j1: ∀ j∈cells, {
				ℕ a = 1;
				ℝ b = 2.0;
				ℝ² c = { 1.0, 2.0 };
				ℝ³ d = { 1.0, 2.0, 3.0 };
			}
		''')
		
		testPrint('Test des types des constantes')
		result.getVarDeclaration(0).expression.assertType(BasicTypeProvider::INT)
		result.getVarDeclaration(1).expression.assertType(BasicTypeProvider::REAL)
		result.getVarDeclaration(2).expression.assertType(BasicTypeProvider::REAL2)
		result.getVarDeclaration(3).expression.assertType(BasicTypeProvider::REAL3)
	}
	
	private def getVarDeclaration(NablaModule it, int index)
	{
		val block = ((jobs.head as InstructionJob).instruction as Loop).body as InstructionBlock
		block.instructions.get(index) as VarDeclaration
	}
	
	private def assertType(Expression e, NablaType t)
	{
		e.assertNoErrors
		val eType = e.typeFor
		Assert.assertTrue('expected:<' + t.label + '> but was:<' + eType.label + '>', eType.match(t))
	}
}