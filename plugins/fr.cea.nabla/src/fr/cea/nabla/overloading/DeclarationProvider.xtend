/*******************************************************************************
 * Copyright (c) 2022 CEA
 * This program and the accompanying materials are made available under the
 * terms of the Eclipse Public License 2.0 which is available at
 * http://www.eclipse.org/legal/epl-2.0.
 *
 * SPDX-License-Identifier: EPL-2.0
 * Contributors: see AUTHORS file
 *******************************************************************************/
package fr.cea.nabla.overloading

import com.google.inject.Inject
import com.google.inject.Provider
import fr.cea.nabla.nabla.DefaultExtension
import fr.cea.nabla.nabla.Function
import fr.cea.nabla.nabla.FunctionCall
import fr.cea.nabla.nabla.NablaModule
import fr.cea.nabla.nabla.NablaRoot
import fr.cea.nabla.nabla.Reduction
import fr.cea.nabla.nabla.ReductionCall
import fr.cea.nabla.typing.ExpressionTypeProvider
import fr.cea.nabla.typing.NablaType
import java.util.List
import org.eclipse.xtext.EcoreUtil2

class DeclarationProvider 
{
	@Inject extension ExpressionTypeProvider
	@Inject Provider<DeclarationBuilder> declarationBuilderProvider

	/**
	 * Return the ReductionDeclaration instance containing
	 * the first Reduction matching the call or null if no match.
	 */
	def ReductionDeclaration getDeclaration(ReductionCall it)
	{
		val argType = arg.typeFor
		for (c : getCandidates(reduction, argType))
		{
			val declarationBuilder = declarationBuilderProvider.get
			val declaration = declarationBuilder.tryToBuildDeclaration(c, argType)
			if (declaration !== null) return declaration
		}
		return null
	}

	/**
	 * Return the FunctionDeclaration instance containing
	 * the first Function matching the call or null if no match.
	 */
	def FunctionDeclaration getDeclaration(FunctionCall it)
	{
		val argTypes = args.map[typeFor]
		for (c : getCandidates(function, argTypes))
		{
			val declarationBuilder = declarationBuilderProvider.get
			val declaration = declarationBuilder.tryToBuildDeclaration(c, argTypes)
			if (declaration !== null) return declaration
		}
		return null
	}

	/**
	 * Return a list of Reduction instances matching the name
	 * and the primitive type of argument.
	 */
	private def Iterable<Reduction> getCandidates(Reduction r, NablaType callerInType)
	{
		val root = EcoreUtil2.getContainerOfType(r, NablaRoot)
		switch root
		{
			case null: #[]
			NablaModule: root.reductions.filter[x | x.name == r.name]
			DefaultExtension: root.reductions.filter[x | x.name == r.name]
			default: #[]
		}
	}

	/**
	 * Return a list of Function instances matching the name,
	 * the number of arguments and the primitive type of arguments.
	 */
	private def Iterable<Function> getCandidates(Function f, List<NablaType> callerInTypes)
	{
		val root = EcoreUtil2.getContainerOfType(f, NablaRoot)
		if (root === null) return #[]
		switch root
		{
			case null: #[]
			NablaModule: root.functions.filter[x | x.name == f.name && x.intypesDeclaration.size == callerInTypes.size]
			DefaultExtension: root.functions.filter[x | x.name == f.name && x.intypesDeclaration.size == callerInTypes.size]
			default: #[]
		}
	}
}