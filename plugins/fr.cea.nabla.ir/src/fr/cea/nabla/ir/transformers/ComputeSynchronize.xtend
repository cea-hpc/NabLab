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

import fr.cea.nabla.ir.ir.ArgOrVarRef
import fr.cea.nabla.ir.ir.ConnectivityType
import fr.cea.nabla.ir.ir.DefaultExtensionProvider
import fr.cea.nabla.ir.ir.ExecuteTimeLoopJob
import fr.cea.nabla.ir.ir.IrFactory
import fr.cea.nabla.ir.ir.IrPackage
import fr.cea.nabla.ir.ir.IrRoot
import fr.cea.nabla.ir.ir.Iterator
import fr.cea.nabla.ir.ir.Loop
import fr.cea.nabla.ir.ir.Variable
import java.util.ArrayList
import java.util.LinkedHashSet

import static extension fr.cea.nabla.ir.ArgOrVarExtensions.isGlobal
import static extension fr.cea.nabla.ir.ContainerExtensions.*
import fr.cea.nabla.ir.ir.ItemIndex

class ComputeSynchronize extends IrTransformationStep
{
	override getDescription()
	{
		"Compute when we need to synchronize"
	}

	override transform(IrRoot ir, (String)=>void traceNotifier)
	{
		for(m : ir.modules)
		{
			for(j : m.jobs.filter[x | !(x instanceof ExecuteTimeLoopJob)])
			{
				val inVars = new LinkedHashSet<Variable>
				
				for(l : j.eAllContents.filter(Loop).toIterable)
				{
					if(l.iterationBlock instanceof Iterator)
					{
						val iterator = l.iterationBlock as Iterator
						if(iterator.container.connectivityCall.args.empty)
							fillInVarRefs(l, inVars, iterator.index)
					}
				}
				val synchronizes = new ArrayList
				for(v : inVars)
					synchronizes += IrFactory.eINSTANCE.createSynchronize => [variable = v]
				IrTransformationUtils.insertBefore(j.instruction, synchronizes)
			}
		}
	}

	override transform(DefaultExtensionProvider dep, (String)=>void traceNotifier)
	{
		throw new RuntimeException("Not yet implemented")
	}
	
	private static def void fillInVarRefs(Loop l, LinkedHashSet<Variable> varSet, ItemIndex index)
	{
		for(x : l.eAllContents.filter(ArgOrVarRef).filter[x | x.eContainingFeature != IrPackage::eINSTANCE.affectation_Left].toIterable)
		{
			if(x.target instanceof Variable && !x.iterators.empty)
			{
				val v = x.target as Variable
				if(v.global && v.type instanceof ConnectivityType && x.iterators.head.itemName !== index.itemName)
					varSet += v
			}	
		}
	}
}
