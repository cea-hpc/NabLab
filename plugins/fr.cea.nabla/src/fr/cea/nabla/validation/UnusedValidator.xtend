/*******************************************************************************
 * Copyright (c) 2021 CEA
 * This program and the accompanying materials are made available under the 
 * terms of the Eclipse Public License 2.0 which is available at
 * http://www.eclipse.org/legal/epl-2.0.
 *
 * SPDX-License-Identifier: EPL-2.0
 * Contributors: see AUTHORS file
 *******************************************************************************/
package fr.cea.nabla.validation

import com.google.inject.Inject
import fr.cea.nabla.nabla.ArgOrVarRef
import fr.cea.nabla.nabla.Function
import fr.cea.nabla.nabla.FunctionCall
import fr.cea.nabla.nabla.ItemSet
import fr.cea.nabla.nabla.ItemSetRef
import fr.cea.nabla.nabla.NablaModule
import fr.cea.nabla.nabla.NablaPackage
import fr.cea.nabla.nabla.NablaRoot
import fr.cea.nabla.nabla.Reduction
import fr.cea.nabla.nabla.ReductionCall
import fr.cea.nabla.nabla.SpaceIterator
import fr.cea.nabla.nabla.SpaceIteratorRef
import fr.cea.nabla.nabla.TimeIterator
import fr.cea.nabla.nabla.TimeIteratorRef
import fr.cea.nabla.nabla.Var
import fr.cea.nabla.overloading.DeclarationProvider
import org.eclipse.emf.ecore.EClass
import org.eclipse.xtext.EcoreUtil2
import org.eclipse.xtext.validation.Check
import org.eclipse.xtext.validation.CheckType

class UnusedValidator extends UniqueNameValidator
{
	@Inject extension DeclarationProvider

	public static val UNUSED = "Unused"
	static def getUnusedMsg(EClass objectClass, String objectName) { "Unused " + objectClass.name + ": " + objectName }

	@Check(CheckType.NORMAL)
	def checkUnusedTimeIterator(TimeIterator it)
	{
		val root = EcoreUtil2::getContainerOfType(it, NablaRoot)
		if (root !== null)
		{
			val elements = EcoreUtil2.getAllContentsOfType(root, TimeIteratorRef)
			val hasItRef = elements.exists[x | x.target === it]
			if (!hasItRef)
				warning(getUnusedMsg(NablaPackage.Literals.TIME_ITERATOR, name), NablaPackage.Literals.ARG_OR_VAR__NAME, UNUSED)
		}
	}

	@Check(CheckType.NORMAL)
	def checkUnusedVariable(Var it)
	{
		val root = EcoreUtil2::getContainerOfType(it, NablaRoot)
		if (root !== null)
		{
			val elements = EcoreUtil2.getAllContentsOfType(root, ArgOrVarRef)
			val referenced = elements.exists[x | x.target === it]
			if (!referenced)
				warning(getUnusedMsg(NablaPackage.Literals.VAR, name), NablaPackage.Literals::ARG_OR_VAR__NAME, UNUSED)
		}
	}

	@Check(CheckType.NORMAL)
	def checkUnusedSpaceIterator(SpaceIterator it)
	{
		val root = EcoreUtil2::getContainerOfType(it, NablaRoot)
		if (root !== null)
		{
			val elements = EcoreUtil2.getAllContentsOfType(root, SpaceIteratorRef)
			val referenced = elements.exists[x|x.target === it]
			if (!referenced)
				warning(getUnusedMsg(NablaPackage.Literals.SPACE_ITERATOR, name), NablaPackage.Literals::SPACE_ITERATOR__NAME, UNUSED)
		}
	}

	@Check(CheckType.NORMAL)
	def checkUnusedItemSet(ItemSet it)
	{
		val root = EcoreUtil2::getContainerOfType(it, NablaRoot)
		if (root !== null)
		{
			val elements = EcoreUtil2.getAllContentsOfType(root, ItemSetRef)
			val referenced = elements.exists[x|x.target === it]
			if (!referenced)
				warning(getUnusedMsg(NablaPackage.Literals.ITEM_SET, name), NablaPackage.Literals::ITEM_SET__NAME, UNUSED)
		}
	}

	@Check(CheckType.NORMAL)
	def checkUnusedFunction(Function it)
	{
		val m = EcoreUtil2::getContainerOfType(it, NablaModule)
		if (m !== null)
		{
			val allCalls = EcoreUtil2.getAllContentsOfType(m, FunctionCall)
			val referenced = allCalls.exists[x | x.declaration !== null && x.declaration.model === it]
			if (!referenced)
				warning(getUnusedMsg(NablaPackage.Literals.FUNCTION, name), NablaPackage.Literals::FUNCTION_OR_REDUCTION__NAME, UNUSED)
		}
	}

	@Check(CheckType.NORMAL)
	def checkUnusedReduction(Reduction it)
	{
		val m = EcoreUtil2.getContainerOfType(it, NablaModule)
		if (m !== null)
		{
			val allCalls = EcoreUtil2.getAllContentsOfType(m, ReductionCall)
			val referenced = allCalls.exists[x | x.declaration !== null && x.declaration.model === it]
			if (!referenced)
				warning(getUnusedMsg(NablaPackage.Literals.REDUCTION, name), NablaPackage.Literals::FUNCTION_OR_REDUCTION__NAME, UNUSED)
		}
	}
}