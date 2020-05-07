/*******************************************************************************
 * Copyright (c) 2020 CEA
 * This program and the accompanying materials are made available under the 
 * terms of the Eclipse Public License 2.0 which is available at
 * http://www.eclipse.org/legal/epl-2.0.
 *
 * SPDX-License-Identifier: EPL-2.0
 * Contributors: see AUTHORS file
 *******************************************************************************/
package fr.cea.nabla

import com.google.inject.Inject
import fr.cea.nabla.nabla.Affectation
import fr.cea.nabla.nabla.Arg
import fr.cea.nabla.nabla.ArgOrVar
import fr.cea.nabla.nabla.BaseType
import fr.cea.nabla.nabla.ConnectivityVar
import fr.cea.nabla.nabla.Function
import fr.cea.nabla.nabla.NablaModule
import fr.cea.nabla.nabla.Reduction
import fr.cea.nabla.nabla.SimpleVar
import fr.cea.nabla.nabla.SimpleVarDefinition
import fr.cea.nabla.nabla.TimeIterator
import fr.cea.nabla.nabla.Var
import fr.cea.nabla.nabla.VarGroupDeclaration
import org.eclipse.xtext.EcoreUtil2
import fr.cea.nabla.nabla.Interval
import fr.cea.nabla.nabla.SpaceIterator

/**
 * Allow to access the type of ArgOrVar except SimpleVar
 * that needs a type provider to evaluate its defaultValue.
 */
class ArgOrVarExtensions 
{
	@Inject extension ExpressionExtensions

	def BaseType getType(ConnectivityVar it)
	{
		(eContainer as VarGroupDeclaration).type
	}

	def BaseType getType(Arg it)
	{
		val fOrR = eContainer
		switch (fOrR)
		{
			Function: 
			{
				val i = fOrR.inArgs.indexOf(it)
				fOrR.inTypes.get(i)
			}
			Reduction:
				fOrR.type
		}
	}

	def boolean isConst(Var it)
	{
		switch it
		{
			Arg: true
			TimeIterator: false
			default:
			{
				if (eContainer === null || eContainer instanceof Interval || eContainer instanceof SpaceIterator)
					false
				else
				{
					val module = EcoreUtil2::getContainerOfType(it, NablaModule)
					module.eAllContents.filter(Affectation).forall[x | x.left.target !== it]
				}
			}
		}
	}

	def boolean isConstExpr(ArgOrVar it)
	{
		switch it
		{
			// options are not constexpr because they are initialized by a file in the generated code
			SimpleVar: (!option && value !== null && const && value.constExpr)
			default: false
		}
	}

	def boolean isNablaEvaluable(ArgOrVar it)
	{
		switch it
		{
			SimpleVar: (value !== null && value.nablaEvaluable)
			default: false
		}
	}

	def isGlobal(Var it) 
	{
		(eContainer !== null && eContainer.eContainer !== null && eContainer.eContainer instanceof NablaModule)
	}

	def boolean isOption(ArgOrVar it) 
	{
		(eContainer !== null && eContainer instanceof SimpleVarDefinition && (eContainer as SimpleVarDefinition).option)
	}

	def getValue(Var it)
	{
		val decl = eContainer
		if (decl === null) null
		else switch decl
		{
			SimpleVarDefinition : decl.value
			default : null
		}
	}
}