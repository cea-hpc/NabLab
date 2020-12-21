/*******************************************************************************
 * Copyright (c) 2020 CEA
 * This program and the accompanying materials are made available under the 
 * terms of the Eclipse Public License 2.0 which is available at
 * http://www.eclipse.org/legal/epl-2.0.
 *
 * SPDX-License-Identifier: EPL-2.0
 * Contributors: see AUTHORS file
 *******************************************************************************/
package fr.cea.nabla.ir

import fr.cea.nabla.ir.ir.Affectation
import fr.cea.nabla.ir.ir.Arg
import fr.cea.nabla.ir.ir.ArgOrVar
import fr.cea.nabla.ir.ir.ArgOrVarRef
import fr.cea.nabla.ir.ir.ConnectivityVariable
import fr.cea.nabla.ir.ir.Function
import fr.cea.nabla.ir.ir.FunctionCall
import fr.cea.nabla.ir.ir.IrModule
import fr.cea.nabla.ir.ir.IrType
import fr.cea.nabla.ir.ir.Iterator
import fr.cea.nabla.ir.ir.SimpleVariable
import fr.cea.nabla.ir.ir.Variable
import org.eclipse.emf.ecore.EObject

import static extension fr.cea.nabla.ir.Utils.*

class ArgOrVarExtensions
{
	static def isIteratorCounter(ArgOrVar it)
	{
		it instanceof SimpleVariable && eContainer instanceof Iterator
	}

	static def IrType getType(ArgOrVar it)
	{
		switch it
		{
			Arg: type
			SimpleVariable: type
			ConnectivityVariable: type
		}
	}

	static def isOption(ArgOrVar it)
	{
		(it instanceof SimpleVariable && (it as SimpleVariable).option)
	}

	static def isGlobal(ArgOrVar it)
	{
		(it instanceof Variable && eContainer instanceof IrModule)
	}

	static def isLinearAlgebra(Function it)
	{
		containsLinearAlgebra
	}

	static def isLinearAlgebra(ArgOrVar it)
	{
		if (it instanceof ConnectivityVariable)
		{
			val references = irModule.eAllContents.filter(ArgOrVarRef).filter[x | x.target == it]
			references.exists[x | x.eContainer.containsLinearAlgebra]
		}
		else
			false
	}

	private static def dispatch boolean containsLinearAlgebra(EObject it)
	{
		false
	}

	private static def dispatch boolean containsLinearAlgebra(Affectation it)
	{
		right.containsLinearAlgebra
	}

	private static def dispatch boolean containsLinearAlgebra(FunctionCall it)
	{
		function.containsLinearAlgebra
	}

	private static def dispatch boolean containsLinearAlgebra(Function it)
	{
		provider.extensionName == 'LinearAlgebra'
	}
}