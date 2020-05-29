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
import fr.cea.nabla.ir.MandatoryVariables
import fr.cea.nabla.nabla.ArgOrVarRef
import fr.cea.nabla.nabla.Connectivity
import fr.cea.nabla.nabla.ConnectivityCall
import fr.cea.nabla.nabla.ConnectivityVar
import fr.cea.nabla.nabla.Function
import fr.cea.nabla.nabla.FunctionCall
import fr.cea.nabla.nabla.Item
import fr.cea.nabla.nabla.ItemRef
import fr.cea.nabla.nabla.ItemType
import fr.cea.nabla.nabla.NablaModule
import fr.cea.nabla.nabla.NablaPackage
import fr.cea.nabla.nabla.Reduction
import fr.cea.nabla.nabla.ReductionCall
import fr.cea.nabla.nabla.SetDefinition
import fr.cea.nabla.nabla.SetRef
import fr.cea.nabla.nabla.TimeIterator
import fr.cea.nabla.nabla.TimeIteratorRef
import fr.cea.nabla.nabla.Var
import fr.cea.nabla.overloading.DeclarationProvider
import org.eclipse.emf.ecore.EClass
import org.eclipse.xtext.EcoreUtil2
import org.eclipse.xtext.validation.Check
import org.eclipse.xtext.validation.CheckType

import static extension fr.cea.nabla.ConnectivityCallExtensions.*

class UnusedValidator extends UniqueNameValidator
{
	@Inject extension DeclarationProvider

	public static val UNUSED = "Unused"
	static def getUnusedMsg(EClass objectClass, String objectName) { "Unused " + objectClass.name + ": " + objectName }

	@Check(CheckType.NORMAL)
	def checkUnusedTimeIterator(TimeIterator it)
	{
		val m = EcoreUtil2::getContainerOfType(it, NablaModule)
		if (m !== null)
		{
			val timeIterRefs = EcoreUtil2.getAllContentsOfType(m, TimeIteratorRef)
			val hasItRef = timeIterRefs.exists[x | x.target === it]
			if (!hasItRef)
				warning(getUnusedMsg(NablaPackage.Literals.TIME_ITERATOR, name), NablaPackage.Literals.ARG_OR_VAR__NAME, UNUSED)
		}
	}

	@Check(CheckType.NORMAL)
	def checkUnusedVariable(Var it)
	{
		val mandatories = (MandatoryVariables::NAMES).toList
		val module = EcoreUtil2.getContainerOfType(it, NablaModule)
		val argOrVarRefs = EcoreUtil2.getAllContentsOfType(module, ArgOrVarRef)
		val referenced = mandatories.contains(name) || argOrVarRefs.exists[x | x.target === it]
		if (!referenced)
			warning(getUnusedMsg(NablaPackage.Literals.VAR, name), NablaPackage.Literals::ARG_OR_VAR__NAME, UNUSED)
	}

	@Check(CheckType.NORMAL)
	def checkUnusedConnectivity(Connectivity it)
	{
		val module = EcoreUtil2.getContainerOfType(it, NablaModule)
		val cCalls = EcoreUtil2.getAllContentsOfType(module, ConnectivityCall)
		val cVars = EcoreUtil2.getAllContentsOfType(module, ConnectivityVar)
		val referenced = cCalls.exists[x | x.connectivity === it] || cVars.exists[x | x.supports.contains(it)]
		if (!referenced)
			warning(getUnusedMsg(NablaPackage.Literals.CONNECTIVITY, name), NablaPackage.Literals::CONNECTIVITY__NAME, UNUSED)
	}

	@Check(CheckType.NORMAL)
	def checkUnusedItemType(ItemType it)
	{
		val m = EcoreUtil2.getContainerOfType(it, NablaModule)
		val referenced = EcoreUtil2.getAllContentsOfType(m, Connectivity).exists[x | x.inTypes.contains(it) || x.returnType === it]
		if (!referenced)
			warning(getUnusedMsg(NablaPackage.Literals.ITEM_TYPE, name), NablaPackage.Literals::ITEM_TYPE__NAME, UNUSED)
	}

	@Check(CheckType.NORMAL)
	def checkUnusedItem(Item it)
	{
		val m = EcoreUtil2.getContainerOfType(it, NablaModule)
		val referenced = EcoreUtil2.getAllContentsOfType(m, ItemRef).exists[x|x.target === it]
		if (!referenced)
			warning(getUnusedMsg(NablaPackage.Literals.ITEM, name), NablaPackage.Literals::ITEM__NAME, UNUSED)
	}

	@Check(CheckType.NORMAL)
	def checkUnusedSet(SetDefinition it)
	{
		val m = EcoreUtil2.getContainerOfType(it, NablaModule)
		val referenced = EcoreUtil2.getAllContentsOfType(m, SetRef).exists[x|x.target === it]
		if (!referenced)
			warning(getUnusedMsg(NablaPackage.Literals.SET_DEFINITION, name), NablaPackage.Literals::SET_DEFINITION__NAME, UNUSED)
	}

	@Check(CheckType.NORMAL)
	def checkUnusedFunction(Function it)
	{
		val m = EcoreUtil2.getContainerOfType(it, NablaModule)
		// If the module does not contain options and jobs, no unused warning.
		// It avoids warning on libraries: module with only functions/reductions.
		if (! (m.definitions.filter[option].empty && m.jobs.empty))
		{
			val allCalls = EcoreUtil2.getAllContentsOfType(m, FunctionCall)
			var referenced = false
			for (c : allCalls)
			{
				val matchingDeclaration = c.declaration
				if (matchingDeclaration !== null && matchingDeclaration.model === it)
					referenced = true
			}
			if (!referenced)
				warning(getUnusedMsg(NablaPackage.Literals.FUNCTION, name), NablaPackage.Literals::FUNCTION_OR_REDUCTION__NAME, UNUSED)
		}
	}

	@Check(CheckType.NORMAL)
	def checkUnusedReduction(Reduction it)
	{
		val m = EcoreUtil2.getContainerOfType(it, NablaModule)
		// If the module does not contain options and jobs, no unused warning.
		// It avoids warning on libraries: module with only functions/reductions.
		if (! (m.definitions.filter[option].empty && m.jobs.empty))
		{
			val allMatchingDeclarations = EcoreUtil2.getAllContentsOfType(m, ReductionCall).map[declaration]
			val referenced = allMatchingDeclarations.exists[x | x !== null && x.model === it]
			if (!referenced)
				warning(getUnusedMsg(NablaPackage.Literals.REDUCTION, name), NablaPackage.Literals::FUNCTION_OR_REDUCTION__NAME, UNUSED)
		}
	}
}