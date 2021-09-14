/*******************************************************************************
 * Copyright (c) 2021 CEA
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
import fr.cea.nabla.nabla.NablaRoot
import fr.cea.nabla.nabla.OptionDeclaration
import fr.cea.nabla.nabla.Reduction
import fr.cea.nabla.nabla.SimpleVar
import fr.cea.nabla.nabla.SimpleVarDeclaration
import fr.cea.nabla.nabla.Var
import fr.cea.nabla.nabla.VarDeclaration
import fr.cea.nabla.nabla.VarGroupDeclaration
import org.eclipse.xtext.EcoreUtil2

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
				fOrR.typeDeclaration.inTypes.get(i)
			}
			Reduction:
				fOrR.typeDeclaration.type
		}
	}

	def int getDimension(ArgOrVar it)
	{
		switch it
		{
			Arg: type.sizes.size
			SimpleVar case eContainer instanceof VarDeclaration: (eContainer as VarDeclaration).type.sizes.size
			ConnectivityVar: type.sizes.size + supports.size
			default: 1
		}
	}

	/** Return true if 'it' has a default value and is never affected */
	def boolean isConst(Var it)
	{
		// Only SimpleVar defined with a value can be const
		if (it instanceof SimpleVar && eContainer !== null && eContainer instanceof SimpleVarDeclaration && (eContainer as SimpleVarDeclaration).value !== null)
		{
			val root = EcoreUtil2::getContainerOfType(it, NablaRoot)
			root.eAllContents.filter(Affectation).forall[x | x.left.target !== it]
		}
		else
			false
	}

	def boolean isConstExpr(ArgOrVar it)
	{
		if (eContainer !== null)
		{
			val c = eContainer
			switch c
			{
				// options are not constexpr because they are initialized by a file in the generated code
				SimpleVarDeclaration: (c.value !== null && c.variable.const && c.value.constExpr)
				Function, Reduction: true
				default: false
			}
		}
		else
			false
	}

	def boolean isNablaEvaluable(ArgOrVar it)
	{
		switch it
		{
			SimpleVar: (option && value === null) || (value !== null && value.nablaEvaluable)
			default: false
		}
	}

	def isGlobal(Var it) 
	{
		(eContainer !== null && eContainer.eContainer !== null && eContainer.eContainer instanceof NablaModule)
	}

	def boolean isOption(ArgOrVar it) 
	{
		(eContainer !== null && eContainer instanceof OptionDeclaration)
	}

	def getValue(Var it)
	{
		val decl = eContainer
		if (decl === null) null
		else switch decl
		{
			SimpleVarDeclaration : decl.value
			OptionDeclaration : decl.value
			default : null
		}
	}
}