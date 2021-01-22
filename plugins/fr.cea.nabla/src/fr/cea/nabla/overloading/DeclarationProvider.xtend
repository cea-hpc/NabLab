/*******************************************************************************
 * Copyright (c) 2020 CEA
 * This program and the accompanying materials are made available under the 
 * terms of the Eclipse Public License 2.0 which is available at
 * http://www.eclipse.org/legal/epl-2.0.
 *
 * SPDX-License-Identifier: EPL-2.0
 * Contributors: see AUTHORS file
 *******************************************************************************/
package fr.cea.nabla.overloading

import com.google.inject.Inject
import fr.cea.nabla.nabla.BaseType
import fr.cea.nabla.nabla.Function
import fr.cea.nabla.nabla.FunctionCall
import fr.cea.nabla.nabla.NablaRoot
import fr.cea.nabla.nabla.Reduction
import fr.cea.nabla.nabla.ReductionCall
import fr.cea.nabla.typing.BaseTypeTypeProvider
import fr.cea.nabla.typing.ExpressionTypeProvider
import fr.cea.nabla.typing.NSTScalar
import fr.cea.nabla.typing.NablaConnectivityType
import fr.cea.nabla.typing.NablaSimpleType
import fr.cea.nabla.typing.NablaType
import fr.cea.nabla.typing.PrimitiveTypeTypeProvider
import java.util.List
import org.eclipse.xtext.EcoreUtil2

class DeclarationProvider 
{
	@Inject extension ExpressionTypeProvider
	@Inject BaseTypeTypeProvider baseTypeTP
	@Inject PrimitiveTypeTypeProvider primitiveTypeTP

	/**
	 * Return the ReductionDeclaration instance containing
	 * the first Reduction matching the call or null if no match.
	 */
	def ReductionDeclaration getDeclaration(ReductionCall it)
	{
		val argType = arg.typeFor
		val finder = getDeclarationFinder(#[argType])
		if (finder === null) return null

		val candidates = getCandidates(reduction, argType)
		return finder.findReduction(candidates)
	}

	/**
	 * Return the FunctionDeclaration instance containing
	 * the first Function matching the call or null if no match.
	 */
	def FunctionDeclaration getDeclaration(FunctionCall it)
	{
		val argTypes = args.map[typeFor]
		val finder = getDeclarationFinder(argTypes)
		if (finder === null) return null

		val candidates = getCandidates(function, argTypes)
		return finder.findFunction(candidates)
	}

	/**
	 * Return the correct instance of IDeclarationFinder in checking
	 * the type of the caller's args provided in the argTypes argument.
	 * All the types must be either NablaSimpleType or NablaConnectivityType.
	 * If they are instance of NablaSimpleType it is a "classical function call"
	 * and a SimpleDeclarationFinder is returned else it is a "linear algebra call". 
	 * In this case, the associated base type must be scalar and 
	 * a ConnectivityDeclarationFinder is returned.
	 */
	private def getDeclarationFinder(List<NablaType> argTypes)
	{
		if (argTypes.forall[x | x instanceof NablaSimpleType]) 
			return new SimpleTypeDeclarationFinder(baseTypeTP, argTypes.map[ x | x as NablaSimpleType])

		/*
		 * Almost one argType is NablaConnectivityType =>
		 * other NablaSimpleType elements must be scalar.
		 * Because all arrays must be of the same type,
		 * even NablaSimpleType or NablaConnectivityType.
		 */
		if (argTypes.filter(NablaSimpleType).exists[x | x.dimension > 0])
			return null

		if (argTypes.filter(NablaConnectivityType).forall[simple instanceof NSTScalar])
			return new ConnectivityTypeDeclarationFinder(baseTypeTP, primitiveTypeTP, argTypes)

		// no finder found
		return null
	}

	/**
	 * Return a list of Reduction instances matching the name
	 * and the primitive type of argument.
	 */
	private def Iterable<Reduction> getCandidates(Reduction r, NablaType callerInType)
	{
		val root = EcoreUtil2.getContainerOfType(r, NablaRoot)
		if (root === null) return #[]
		val candidates = root.reductions.filter[x | x.name == r.name]
		return candidates.filter[argsMatch(#[typeDeclaration.type], #[callerInType])]
	}

	/**
	 * Return a list of Function instances matching the name,
	 * the number of arguments and the primitive type of arguments.
	 */
	private def Iterable<Function> getCandidates(Function f, List<NablaType> callerInTypes)
	{
		val r = EcoreUtil2.getContainerOfType(f, NablaRoot)
		val candidates = r.functions.filter[x | x.name == f.name]
		return candidates.filter[argsMatch(typeDeclaration.inTypes, callerInTypes)]
	}

	private def boolean argsMatch(List<BaseType> la, List<NablaType> lb) 
	{
		if (la.size !== lb.size) return false
		for (i : 0..< la.size)
		{
			val a = la.get(i)
			val b = lb.get(i)
			if (a === null || b === null || a.primitive != b.primitive)
				return false
		}
		return true
	}
}
