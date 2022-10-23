/*******************************************************************************
 * Copyright (c) 2022 CEA
 * This program and the accompanying materials are made available under the
 * terms of the Eclipse Public License 2.0 which is available at
 * http://www.eclipse.org/legal/epl-2.0.
 *
 * SPDX-License-Identifier: EPL-2.0
 * Contributors: see AUTHORS file
 *******************************************************************************/
package fr.cea.nabla.validation

import com.google.inject.Inject
import fr.cea.nabla.ArgOrVarExtensions
import fr.cea.nabla.SpaceIteratorExtensions
import fr.cea.nabla.nabla.ArgOrVarRef
import fr.cea.nabla.nabla.ConnectivityVar
import fr.cea.nabla.nabla.NablaPackage
import fr.cea.nabla.nabla.NablaRoot
import fr.cea.nabla.nabla.Var
import fr.cea.nabla.nabla.VarGroupDeclaration
import fr.cea.nabla.typing.ExpressionTypeProvider
import org.eclipse.xtext.EcoreUtil2
import org.eclipse.xtext.validation.Check
import org.eclipse.xtext.validation.CheckType

class ArgOrVarRefValidator extends InstructionValidator
{
	@Inject extension ValidationUtils
	@Inject extension SpaceIteratorExtensions
	@Inject extension ArgOrVarExtensions
	@Inject extension ExpressionTypeProvider

	public static val INDICES_NUMBER = "ArgOrVarRef::IndicesNumber"
	public static val SPACE_ITERATOR_NUMBER = "ArgOrVarRef::SpaceIteratorNumber"
	public static val SPACE_ITERATOR_TYPE = "ArgOrVarRef::SpaceIteratorType"
	public static val REQUIRED_TIME_ITERATOR = 'ArgOrVarRef::RequiredTimeIterator'
	public static val ILLEGAL_TIME_ITERATOR = 'ArgOrVarRef::IllegalTimeIterator'
	public static val NULL_TYPE = 'ArgOrVarRef::NullType'

	static def getIndicesNumberMsg(int expectedSize, int actualSize) { "Wrong number of indices. Expected " + expectedSize + ", but was " + actualSize }
	static def getSpaceIteratorNumberMsg(int expectedSize, int actualSize) { "Wrong number of space iterators. Expected " + expectedSize + ", but was " + actualSize }
	static def getRequiredTimeIteratorMsg() { "Time iterator must be specified" }
	static def getIllegalTimeIteratorMsg() { "Time iterators only allowed on global variables with no default value" }
	static def getNullTypeMsg() { "Null type: check iterators/indices" }

	@Check(CheckType.NORMAL)
	def checkIndicesNumber(ArgOrVarRef it)
	{
		if (target === null || target.eIsProxy) return
		val dimension =	if (target instanceof ConnectivityVar) (target as ConnectivityVar).type.sizes.size 
			else target.dimension
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
					if (actualT !== null && expectedT !== null && actualT != expectedT)
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
	def checkRequiredTimeIterator(ArgOrVarRef it)
	{
		if (target !== null && timeIterators.empty)
		{
			val module = EcoreUtil2::getContainerOfType(it, NablaRoot)
			if(module !== null)
			{
				val argOrVarRefs = EcoreUtil2.getAllContentsOfType(module, ArgOrVarRef)
				if (argOrVarRefs.exists[x | !x.timeIterators.empty && x.target === target])
					error(getRequiredTimeIteratorMsg(), NablaPackage.Literals::ARG_OR_VAR_REF__TIME_ITERATORS, REQUIRED_TIME_ITERATOR)
			}
		}
	}

	/**
	 * Only global variables with no default value can have a time iterator.
	 * A global variable with a default value can not because, 
	 * if it is the only time variable, the job graph can not be built.
	 */
	@Check(CheckType.NORMAL)
	def checkIllegalTimeIterator(ArgOrVarRef it)
	{
		if (target !== null && !timeIterators.empty)
		{
			if (!(target instanceof Var 
				&& (target as Var).global 
				&& (target.eContainer instanceof VarGroupDeclaration)))
					error(getIllegalTimeIteratorMsg(), NablaPackage.Literals::ARG_OR_VAR_REF__TIME_ITERATORS, ILLEGAL_TIME_ITERATOR)
		}
	}

	@Check(CheckType.NORMAL)
	def checkIndicesExpressionAndType(ArgOrVarRef it)
	{
		for (i : 0..<indices.size)
			checkSizeExpressionValidityAndType(indices.get(i), NablaPackage.Literals.ARG_OR_VAR_REF__INDICES, i)
	}

	@Check(CheckType.NORMAL)
	def checkNullType(ArgOrVarRef it)
	{
		if (typeFor === null)
			error(getNullTypeMsg(), NablaPackage.Literals::ARG_OR_VAR_REF__TARGET, NULL_TYPE)
	}
}