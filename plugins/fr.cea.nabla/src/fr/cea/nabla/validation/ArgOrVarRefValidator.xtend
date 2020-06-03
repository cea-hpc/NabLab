/*******************************************************************************
 * Copyright (c) 2020 CEA
 * This program and the accompanying materials are made available under the 
 * terms of the Eclipse Public License 2.0 which is available at
 * http://www.eclipse.org/legal/epl-2.0.
 *
 * SPDX-License-Identifier: EPL-2.0
 * Contributors: see AUTHORS file
 *******************************************************************************/
package fr.cea.nabla.validation

import com.google.inject.Inject
import fr.cea.nabla.ItemExtensions
import fr.cea.nabla.nabla.ArgOrVarRef
import fr.cea.nabla.nabla.ConnectivityVar
import fr.cea.nabla.nabla.NablaModule
import fr.cea.nabla.nabla.NablaPackage
import fr.cea.nabla.typing.ArgOrVarTypeProvider
import fr.cea.nabla.typing.NablaConnectivityType
import fr.cea.nabla.typing.NablaSimpleType
import org.eclipse.xtext.EcoreUtil2
import org.eclipse.xtext.validation.Check
import org.eclipse.xtext.validation.CheckType

class ArgOrVarRefValidator extends InstructionValidator
{
	@Inject extension ValidationUtils
	@Inject extension ItemExtensions
	@Inject extension ArgOrVarTypeProvider

	public static val INDICES_NUMBER = "ArgOrVarRef::IndicesNumber"
	public static val SPACE_ITERATOR_NUMBER = "ArgOrVarRef::SpaceIteratorNumber"
	public static val SPACE_ITERATOR_TYPE = "ArgOrVarRef::SpaceIteratorType"
	public static val TIME_ITERATOR_USAGE = 'ArgOrVarRef::TimeIteratorUsage'

	static def getIndicesNumberMsg(int expectedSize, int actualSize) { "Wrong number of indices. Expected " + expectedSize + ", but was " + actualSize }
	static def getSpaceIteratorNumberMsg(int expectedSize, int actualSize) { "Wrong number of space iterators. Expected " + expectedSize + ", but was " + actualSize }
	static def getTimeIteratorUsageMsg() { "Time iterator must be specified" }

	@Check(CheckType.NORMAL)
	def checkIndicesNumber(ArgOrVarRef it)
	{
		if (target === null || target.eIsProxy) return
		val vTypeSize = target.typeFor
		val dimension = if (vTypeSize instanceof NablaConnectivityType) vTypeSize.simple.dimension 
			else (vTypeSize as NablaSimpleType).dimension
		if (indices.size > 0 && indices.size != dimension)
			error(getIndicesNumberMsg(dimension, indices.size), NablaPackage.Literals::ARG_OR_VAR_REF__INDICES, INDICES_NUMBER)
	}

	@Check(CheckType.NORMAL)
	def checkSpaceIteratorNumberAndType(ArgOrVarRef it)
	{
		if (target instanceof ConnectivityVar)
		{
			val dimensions = (target as ConnectivityVar).supports

			if (spaceIterators.size >  0 && spaceIterators.size != dimensions.size)
				error(getSpaceIteratorNumberMsg(dimensions.size, spaceIterators.size), NablaPackage.Literals::ARG_OR_VAR_REF__SPACE_ITERATORS, SPACE_ITERATOR_NUMBER)
			else
			{
				for (i : 0..<spaceIterators.length)
				{
					val spaceIteratorRefI = spaceIterators.get(i)
					val dimensionI = dimensions.get(i)
					val actualT = spaceIteratorRefI.target.type
					val expectedT = dimensionI.returnType
					if (actualT != expectedT)
						error(getTypeMsg(expectedT.name, actualT.name), NablaPackage.Literals::ARG_OR_VAR_REF__SPACE_ITERATORS, i, SPACE_ITERATOR_TYPE)
				}
			}
		}
		else
		{
			if (!spaceIterators.empty)
				error(getSpaceIteratorNumberMsg(0, spaceIterators.size), NablaPackage.Literals::ARG_OR_VAR_REF__SPACE_ITERATORS, SPACE_ITERATOR_NUMBER)
		}
	}

	@Check(CheckType.NORMAL)
	def checkTimeIteratorUsage(ArgOrVarRef it)
	{
		if (timeIterators.empty)
		{
			val module = EcoreUtil2::getContainerOfType(it, NablaModule)
			val argOrVarRefs = EcoreUtil2.getAllContentsOfType(module, ArgOrVarRef)
			if (argOrVarRefs.exists[x | !x.timeIterators.empty && x.target === target])
				error(getTimeIteratorUsageMsg(), NablaPackage.Literals::ARG_OR_VAR_REF__TIME_ITERATORS, TIME_ITERATOR_USAGE)
		}
	}

	@Check(CheckType.NORMAL)
	def checkIndicesExpressionAndType(ArgOrVarRef it)
	{
		for (i : 0..<indices.size)
			checkExpressionValidityAndType(indices.get(i), NablaPackage.Literals.ARG_OR_VAR_REF__INDICES, i)
	}
}