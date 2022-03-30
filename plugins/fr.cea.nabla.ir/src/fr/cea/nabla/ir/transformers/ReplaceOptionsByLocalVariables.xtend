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

import fr.cea.nabla.ir.ir.ArgOrVar
import fr.cea.nabla.ir.ir.ArgOrVarRef
import fr.cea.nabla.ir.ir.DefaultExtensionProvider
import fr.cea.nabla.ir.ir.IrFactory
import fr.cea.nabla.ir.ir.IrRoot
import fr.cea.nabla.ir.ir.IterableInstruction
import fr.cea.nabla.ir.ir.Job
import fr.cea.nabla.ir.ir.Variable
import fr.cea.nabla.ir.ir.VariableDeclaration
import java.util.ArrayList
import java.util.LinkedHashSet
import org.eclipse.emf.ecore.util.EcoreUtil

/**
 * Replace options read in loops by local variables.
 *
 * This transformation step is used for Arcane because options are dereferenced with a function (options()->...).
 * Consequently, when a loop access an option, it is not efficient.
 */
class ReplaceOptionsByLocalVariables extends IrTransformationStep
{
	override getDescription()
	{
		"Replace options accessed in loops by local variables"
	}

	override transform(IrRoot ir, (String)=>void traceNotifier)
	{
		for (m : ir.modules)
		{
			for (j : m.jobs)
			{
				// VarRef instances referencing an option inside an IterableInstruction
				val varRefs = findCandidateVarRefs(j)
				// Options referenced by VarRef instances
				val options = varRefs.map[target].toSet

				// Declare a local variable for each referenced option and keep a list of them
				val declarations = new ArrayList<VariableDeclaration>
				for (o : options)
				{
					declarations += IrFactory::eINSTANCE.createVariableDeclaration =>
					[
						variable = toLocalVariable(j, o)
					]
				}

				// Change VarRef instances to reference local variables
				for (vr : varRefs)
				{
					vr.target = toLocalVariable(j, vr.target)
				}

				IrTransformationUtils.insertBefore(j.instruction, declarations)
			}
		}
	}

	override transform(DefaultExtensionProvider dep, (String)=>void traceNotifier)
	{
		// nothing to do
		// dep only contains functions and functions doe not access global variables
	}

	/** Returns all the VarRef instances referencing an option inside an IterableInstruction */
	private def findCandidateVarRefs(Job it)
	{
		val candidates = new LinkedHashSet<ArgOrVarRef>
		for (ii : eAllContents.filter(IterableInstruction).toIterable)
		{
			for (vv : ii.eAllContents.filter(ArgOrVarRef).toIterable)
			{
				if (vv.target instanceof Variable && (vv.target as Variable).option)
					candidates += vv
			}
		}
		return candidates
	}

	/*
	 * The Job in argument is not used inside the function but it is a primary key
	 * for the Xtend create mechanism: if o is identical for 2 jobs => creation needed
	 */
	private def create IrFactory::eINSTANCE.createVariable toLocalVariable(Job j, ArgOrVar o)
	{
		name = "tmp_" + o.name
		type = EcoreUtil.copy(o.type)
		const = true
		constExpr = false
		option = false
		defaultValue = IrFactory.eINSTANCE.createArgOrVarRef => 
		[
			target = o
			type = EcoreUtil.copy(o.type)
		]
	}
}
