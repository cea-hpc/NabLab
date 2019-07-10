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
import fr.cea.nabla.nabla.Affectation
import fr.cea.nabla.nabla.InstructionBlock
import fr.cea.nabla.nabla.Loop
import fr.cea.nabla.nabla.NablaModule
import fr.cea.nabla.nabla.NablaPackage
import org.eclipse.emf.ecore.EObject
import org.eclipse.emf.ecore.EReference
import org.eclipse.xtext.scoping.IScopeProvider
import org.eclipse.xtext.testing.InjectWith
import org.eclipse.xtext.testing.XtextRunner
import org.eclipse.xtext.testing.util.ParseHelper
import org.eclipse.xtext.testing.validation.ValidationTestHelper
import org.junit.Assert
import org.junit.Test
import org.junit.runner.RunWith

@RunWith(XtextRunner)
@InjectWith(NablaInjectorProvider)
class NablaScopeProviderTest 
{
	@Inject ParseHelper<NablaModule> parseHelper;
	@Inject extension ValidationTestHelper
	@Inject extension IScopeProvider
	@Inject extension TestUtils

	@Test 
	def void testScopeProviderForVars() 
	{
		val result = parseHelper.parse('''
			module test;
			
			sets { 
				cells; 
			}
			
			global {
				ℝ o = 4.0;
				ℝ  b;
			}
			
			cells {
				ℝ  a1, a2;
			}

			j1: ∀ j∈cells, {
				a1{j} = o * 2;
				ℝ c = 6.0;
				a2{j} = 2 * c;
			}
		''')

		val eref = NablaPackage::eINSTANCE.varRef_Variable


		println("initialisation de variable globale")
		val oDeclaration = result.declarationBlocks.filter(GlobalVariableDeclarationBlock).head.declarations.head
		oDeclaration.assertScope(eref, "")		
		
		println("job sur maille avant la déclaration d'une variable locale")
		val instructions = (result.getLoopBodyOfJob(0) as InstructionBlock).instructions
		val affectation1 = instructions.head
		affectation1.assertScope(eref, "o, b, a1, a2")

		println("job sur maille après la déclaration d'une variable locale")
		val affectation2 = instructions.last
		affectation2.assertScope(eref, "c, o, b, a1, a2")
	}
	
	@Test 
	def void testScopeProviderForVarIterators() 
	{
		val result = parseHelper.parse('''
			module test;
			
			sets { 
				cells; 
				nodes;
			}

			cells { ℝ  a, b[nodes], c; }
			nodes { ℝ  d; }

			j1 : ∀ j ∈ cells, a{j} = 0.0;
			j2 : ∀j ∈ cells, c{j} = 0.25 * ∑{r ∈ nodes}(d{r});
			j3 : ∀j ∈ cells, ∀r ∈ nodes(j), b{j,r} = 0;
			j4 : ∀j ∈ cells, a{j} = ∑{r∈nodes(j)}(b{j, r});
		''')
		
		val eref = NablaPackage::eINSTANCE.spaceIteratorRef_Iterator
		testPrint("job sur maille")
		val affectation1 = result.getLoopBodyOfJob(0) as Affectation
		affectation1.expression.assertScope(eref, "j")

		testPrint("job sur maille et somme sur noeud (mais pas de la maille)")
		val affectation2 = result.getLoopBodyOfJob(1) as Affectation
		affectation2.expression.assertScope(eref, "j")
		val sum = affectation2.expression.eContents.filter(ReductionFunctionCall).head
		sum.arg.assertScope(eref, "r, j")
		
		testPrint("job sur maille et boucle sur noeud de la maille)")
		val affectation3 = (result.getLoopBodyOfJob(2) as Loop).body as Affectation
		affectation3.expression.assertScope(eref, "r, j")

		testPrint("job sur maille et somme sur noeud de la maille")
		val affectation4 = result.getLoopBodyOfJob(3) as Affectation
		affectation4.expression.assertScope(eref, "j")
		val sum2 = affectation4.expression as ReductionFunctionCall
		sum2.assertScope(eref, "j")
		sum2.arg.assertScope(eref, "r, j")
	}
	
	@Test 
	def void testScopeProviderForIteratorIterators() 
	{
		val result = parseHelper.parse('''
			module test;
			
			sets { 
				cells; 
				nodes;
			}

			cells { ℝ  b[nodes]; }
			
			j1 : ∀j ∈ cells, ∀r ∈ nodes(j), b{j, r} = 6.0;
		''')
		
		testPrint("itérateur d'itérateur")
		val nodeLoop = result.getLoopBodyOfJob(0) as Loop
		val eref = NablaPackage::eINSTANCE.spaceIteratorRange_Arg
		nodeLoop.assertScope(eref, "j")
	}
	
	def private assertScope(EObject context, EReference reference, CharSequence expected) 
	{
		context.assertNoErrors
		val elementNames = context.getScope(reference).allElements.map[name].join(", ")
		println('elementNames : ' + elementNames)
		Assert.assertEquals(expected.toString, elementNames)
	}

	private def getJobInstruction(NablaModule it, int jobIndex)
	{
		val job = jobs.get(jobIndex)
		(job as InstructionJob).instruction 
	}
	
	private def getLoopBodyOfJob(NablaModule it, int index)
	{
		(getJobInstruction(index) as Loop).body
	}
}