/*******************************************************************************
 * Copyright (c) 2022 CEA
 * This program and the accompanying materials are made available under the
 * terms of the Eclipse Public License 2.0 which is available at
 * http://www.eclipse.org/legal/epl-2.0.
 *
 * SPDX-License-Identifier: EPL-2.0
 * Contributors: see AUTHORS file
 *******************************************************************************/
package fr.cea.nabla.ir.transformers

import fr.cea.nabla.ir.IrUtils
import fr.cea.nabla.ir.annotations.AcceleratorAnnotation
import fr.cea.nabla.ir.annotations.AcceleratorAnnotation.ViewDirection
import fr.cea.nabla.ir.ir.ArgOrVar
import fr.cea.nabla.ir.ir.ArgOrVarRef
import fr.cea.nabla.ir.ir.DefaultExtensionProvider
import fr.cea.nabla.ir.ir.IrFactory
import fr.cea.nabla.ir.ir.IrRoot
import fr.cea.nabla.ir.ir.IterableInstruction
import fr.cea.nabla.ir.ir.LinearAlgebraType
import fr.cea.nabla.ir.ir.Loop
import fr.cea.nabla.ir.ir.ReductionInstruction
import org.eclipse.emf.ecore.util.EcoreUtil

/**
 * For each loop candidate to Arcane accelerator API: 
 * - create a block and tag it,
 * - create local variables representing views.
 */
class PrepareLoopsForAccelerators extends IrTransformationStep
{
	override getDescription()
	{
		"Prepare loops for Arcane accelerator API"
	}

	override transform(IrRoot ir, (String)=>void traceNotifier)
	{
		// tag the IR
		ir.annotations += createAcceleratorAnnotation()

		for (m : ir.modules)
		{
			// tag the module
			m.annotations += createAcceleratorAnnotation()

			// No accelerator loops on functions because functions are generated outside the class
			// (freefuncs namespace) and consequently can not see the m_command attribute.
			for (j : m.jobs)
			{
				val iterableInstrs = j.eAllContents.filter(IterableInstruction).toIterable

				// keep only reductions and parallel loops
				for (l : iterableInstrs.filter[x | !(x instanceof Loop) || (x as Loop).multithreadable])
				{
					val inVars = IrUtils.getInVars(l)
					val outVars = IrUtils.getOutVars(l)

					if (inVars.exists[x | x.type instanceof LinearAlgebraType] || outVars.exists[x | x.type instanceof LinearAlgebraType])
					{
						// the loop is kept outside Accelerator preparation.
						// It will keep the traditional API (not forced to sequential)
						// nothing to do
					}
					else
					{
						/**
						 * For the moment, iterable instruction containing linear algebra are ignored.
						 * See what to do if a GPU solver is plugged.
						 */
						// tag the loop
						l.annotations += createAcceleratorAnnotation()

						// for ReductionInstruction instances, create a variable
						// to store the result of reduction outside the block.
						if (l instanceof ReductionInstruction)
						{
							val decl = IrFactory.eINSTANCE.createVariableDeclaration
							decl.variable = EcoreUtil.copy(l.result)
							IrTransformationUtils.insertBefore(l, #[decl])
						}

						// create a block
						val block = IrFactory.eINSTANCE.createInstructionBlock
						block.annotations += createAcceleratorAnnotation()

						// find all loop variable references
						val varRefs = l.eAllContents.filter(ArgOrVarRef).toList

						// declare the in views
						for (v : inVars)
							block.instructions += createVariableDeclaration(l, v, true, varRefs)

						// declare the out views
						for (v : outVars)
							block.instructions += createVariableDeclaration(l, v, false, varRefs)

						EcoreUtil.replace(l, block)
						block.instructions += l
					}
				}
			}
		}
	}

	override transform(DefaultExtensionProvider dep, (String)=>void traceNotifier)
	{
		// nothing to do
		// dep only contains functions and functions doe not access global variables
	}

	private def create IrFactory::eINSTANCE.createVariableDeclaration createVariableDeclaration(IterableInstruction l, ArgOrVar v, boolean isIn, Iterable<ArgOrVarRef> varRefs)
	{
		// create a local variable declaration for the loop var
		variable = toLocalVariable(l, v, isIn)
		val annot = createAcceleratorAnnotation()
		val annotValue = (isIn ? ViewDirection.In : ViewDirection.Out)
		annot.details.put(AcceleratorAnnotation.ANNOTATION_VIEW_DIRECTION_DETAIL, annotValue.toString)
		variable.annotations += annot

		// change reference target to loop var by the previously created local variable
		for (vr : varRefs)
			if (vr.target == v)
				vr.target = variable
	}

	/*
	 * The Loop in argument is not used inside the function but it is a primary key
	 * for the Xtend create mechanism: if o is identical for 2 loops => creation needed
	 */
	private def create IrFactory::eINSTANCE.createVariable toLocalVariable(IterableInstruction l, ArgOrVar v, boolean isIn)
	{
		val prefix = (isIn ? "in_" : "out_") 
		name = prefix + v.name
		type = EcoreUtil.copy(v.type)
		const = true
		constExpr = false
		option = false
		defaultValue = IrFactory.eINSTANCE.createArgOrVarRef => 
		[
			target = v
			type = EcoreUtil.copy(v.type)
		]
	}

	private def createAcceleratorAnnotation()
	{
		IrFactory::eINSTANCE.createIrAnnotation => 
		[
			source = AcceleratorAnnotation.ANNOTATION_SOURCE
		]
	}
}
