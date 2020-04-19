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

import fr.cea.nabla.nabla.Affectation
import fr.cea.nabla.nabla.Arg
import fr.cea.nabla.nabla.ArgOrVar
import fr.cea.nabla.nabla.BaseType
import fr.cea.nabla.nabla.ConnectivityVar
import fr.cea.nabla.nabla.Function
import fr.cea.nabla.nabla.NablaModule
import fr.cea.nabla.nabla.OptDefinition
import fr.cea.nabla.nabla.Reduction
import fr.cea.nabla.nabla.SimpleVarDefinition
import fr.cea.nabla.nabla.TimeIterator
import fr.cea.nabla.nabla.Var
import fr.cea.nabla.nabla.VarGroupDeclaration
import org.eclipse.xtext.EcoreUtil2

/**
 * Allow to access the type of ArgOrVar except SimpleVar
 * that needs a type provider to evaluate its defaultValue.
 */
class ArgOrVarExtensions 
{
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

	def boolean isConst(ArgOrVar it)
	{
		switch it
		{
			Arg: true
			TimeIterator: false
			default: 
			{
				val module = EcoreUtil2::getContainerOfType(it, NablaModule)
				module.eAllContents.filter(Affectation).forall[x | x.left.target !== it]
			}
		}
	}

	def isGlobal(Var it) 
	{ 
		(eContainer !== null && eContainer.eContainer !== null && eContainer.eContainer instanceof NablaModule)
	}

	def getValue(Var it)
	{
		val decl = eContainer
		switch decl
		{
			OptDefinition: decl.value
			SimpleVarDefinition : decl.value
			default : null
		}
	}
}