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
import fr.cea.nabla.ir.MandatoryOptions
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

import static extension fr.cea.nabla.ConnectivityCallExtensions.*

class UnusedValidator extends UniqueNameValidator
{
	@Inject extension DeclarationProvider

	public static val UNUSED = "Unused"
	static def getUnusedMsg(EClass objectClass, String objectName) { "Unused " + objectClass.name + ": " + objectName }

	@Check 
	def checkUnusedTimeIterator(TimeIterator it)
	{
		val m = EcoreUtil2::getContainerOfType(it, NablaModule)
		if (m !== null)
		{
			val timeIterRefs =  m.eAllContents.filter(TimeIteratorRef).toList
			val hasItRef = timeIterRefs.exists[x | x.target === it]
			if (!hasItRef)
				warning(getUnusedMsg(NablaPackage.Literals.TIME_ITERATOR, name), NablaPackage.Literals.ARG_OR_VAR__NAME, UNUSED)
		}
	}

	@Check
	def checkUnusedVariable(Var it)
	{
		val m = EcoreUtil2.getContainerOfType(it, NablaModule)
		val mandatories = (MandatoryOptions::NAMES).toList
		val referenced = mandatories.contains(name) || m.eAllContents.filter(ArgOrVarRef).exists[x | x.target===it]
		if (!referenced)
			warning(getUnusedMsg(NablaPackage.Literals.VAR, name), NablaPackage.Literals::ARG_OR_VAR__NAME, UNUSED)
	}

	@Check
	def checkUnusedConnectivity(Connectivity it)
	{
		val m = EcoreUtil2.getContainerOfType(it, NablaModule)
		val referenced = m.eAllContents.filter(ConnectivityCall).exists[x | x.connectivity===it]
			|| m.eAllContents.filter(ConnectivityVar).exists[x | x.supports.contains(it)]
		if (!referenced)
			warning(getUnusedMsg(NablaPackage.Literals.CONNECTIVITY, name), NablaPackage.Literals::CONNECTIVITY__NAME, UNUSED)
	}

	@Check
	def checkUnusedItemType(ItemType it)
	{
		val m = EcoreUtil2.getContainerOfType(it, NablaModule)
		val referenced = m.eAllContents.filter(Connectivity).exists[x | x.inTypes.contains(it) || x.returnType === it]
		if (!referenced)
			warning(getUnusedMsg(NablaPackage.Literals.ITEM_TYPE, name), NablaPackage.Literals::ITEM_TYPE__NAME, UNUSED)
	}

	@Check
	def checkUnusedItem(Item it)
	{
		val m = EcoreUtil2.getContainerOfType(it, NablaModule)
		val referenced = m.eAllContents.filter(ItemRef).exists[x|x.target === it]
		if (!referenced)
			warning(getUnusedMsg(NablaPackage.Literals.ITEM, name), NablaPackage.Literals::ITEM__NAME, UNUSED)
	}

	@Check
	def checkUnusedSet(SetDefinition it)
	{
		val m = EcoreUtil2.getContainerOfType(it, NablaModule)
		val referenced = m.eAllContents.filter(SetRef).exists[x|x.target === it]
		if (!referenced)
			warning(getUnusedMsg(NablaPackage.Literals.SET_DEFINITION, name), NablaPackage.Literals::SET_DEFINITION__NAME, UNUSED)
	}

	@Check
	def checkUnusedFunction(Function it)
	{
		val m = EcoreUtil2.getContainerOfType(it, NablaModule)
		// If the module does not contain options and jobs, no unused warning.
		// It avoids warning on libraries: module with only functions/reductions.
		if (! (m.options.empty && m.jobs.empty))
		{
			val allCalls = m.eAllContents.filter(FunctionCall)
			var referenced = false
			for (c : allCalls.toIterable)
			{
				val matchingDeclaration = c.declaration
				if (matchingDeclaration !== null && matchingDeclaration.model === it)
					referenced = true
			}
			if (!referenced)
				warning(getUnusedMsg(NablaPackage.Literals.FUNCTION, name), NablaPackage.Literals::FUNCTION_OR_REDUCTION__NAME, UNUSED)
		}
	}

	@Check
	def checkUnusedReduction(Reduction it)
	{
		val m = EcoreUtil2.getContainerOfType(it, NablaModule)
		// If the module does not contain options and jobs, no unused warning.
		// It avoids warning on libraries: module with only functions/reductions.
		if (! (m.options.empty && m.jobs.empty))
		{
			val allCalls = m.eAllContents.filter(ReductionCall)
			val allMatchingDeclarations = allCalls.map[declaration]
			val referenced = allMatchingDeclarations.exists[x | x !== null && x.model===it]
			if (!referenced)
				warning(getUnusedMsg(NablaPackage.Literals.REDUCTION, name), NablaPackage.Literals::FUNCTION_OR_REDUCTION__NAME, UNUSED)
		}
	}
}