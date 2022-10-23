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
import fr.cea.nabla.nabla.Arg
import fr.cea.nabla.nabla.Connectivity
import fr.cea.nabla.nabla.Function
import fr.cea.nabla.nabla.FunctionOrReduction
import fr.cea.nabla.nabla.ItemSet
import fr.cea.nabla.nabla.ItemType
import fr.cea.nabla.nabla.Job
import fr.cea.nabla.nabla.NablaModule
import fr.cea.nabla.nabla.NablaPackage
import fr.cea.nabla.nabla.NablaRoot
import fr.cea.nabla.nabla.SpaceIterator
import fr.cea.nabla.nabla.TimeIterator
import fr.cea.nabla.nabla.Var
import fr.cea.nabla.nabla.VarGroupDeclaration
import org.eclipse.emf.ecore.EClass
import org.eclipse.emf.ecore.EObject
import org.eclipse.emf.ecore.EStructuralFeature
import org.eclipse.xtext.EcoreUtil2
import org.eclipse.xtext.scoping.IScopeProvider
import org.eclipse.xtext.util.SimpleAttributeResolver
import org.eclipse.xtext.validation.Check
import org.eclipse.xtext.validation.CheckType

class UniqueNameValidator extends AbstractNablaValidator
{
	@Inject IScopeProvider scopeProvider

	public static val DUPLICATE_NAME = "DuplicateName"
	static def getDuplicateNameMsg(EClass objectClass, String objectName) { "Duplicate " + objectClass.name + ": " + objectName }

	@Check(CheckType.NORMAL)
	def void checkDuplicate(Arg it)
	{
		if (eContainer instanceof Function && (eContainer as Function).inArgs.size>0)
		{
			val args = (eContainer as Function).inArgs
			val duplicate = args.findFirst[x | x.name == name && x != it]
			if (duplicate !== null)
				error(getDuplicateNameMsg(NablaPackage.Literals.ARG, duplicate.name), NablaPackage.Literals.ARG_OR_VAR__NAME, DUPLICATE_NAME);
		}
	}

	@Check(CheckType.NORMAL)
	def void checkDuplicate(Var it)
	{
		if (eContainer instanceof VarGroupDeclaration)
		{
			val variables = (eContainer as VarGroupDeclaration).variables
			val duplicate = variables.findFirst[x | x.name == name && x != it]
			if (duplicate !== null)
				error(getDuplicateNameMsg(NablaPackage.Literals.VAR, duplicate.name), NablaPackage.Literals.ARG_OR_VAR__NAME, DUPLICATE_NAME);
		}
		else if (eContainer instanceof FunctionOrReduction || eContainer instanceof Function)
		{
			val variables = (eContainer as FunctionOrReduction).variables
			val duplicate = variables.findFirst[x | x.name == name && x != it]
			if (duplicate !== null)
				error(getDuplicateNameMsg(NablaPackage.Literals.VAR, duplicate.name), NablaPackage.Literals.ARG_OR_VAR__NAME, DUPLICATE_NAME);
		}

		val scope = scopeProvider.getScope(it, NablaPackage.Literals.ARG_OR_VAR_REF__TARGET)
		val duplicated = scope.allElements.exists[x | x.name.lastSegment == name]
		scope.getAllElements()
		if (duplicated)
		{
			error(getDuplicateNameMsg(NablaPackage.Literals.ARG_OR_VAR, name), NablaPackage.Literals.ARG_OR_VAR__NAME, DUPLICATE_NAME);
		}
		else
		{
			val module = EcoreUtil2.getContainerOfType(it, NablaModule)
			if (module !== null && module.iteration !== null && module.iteration.eAllContents.filter(TimeIterator).exists[x | x.name == name])
				error(getDuplicateNameMsg(NablaPackage.Literals.ARG_OR_VAR, name + " (iterator)"), NablaPackage.Literals.ARG_OR_VAR__NAME, DUPLICATE_NAME);
		}
	}

	@Check(CheckType.NORMAL)
	def void checkDuplicate(SpaceIterator it)
	{
		val scope = scopeProvider.getScope(it, NablaPackage.Literals.SPACE_ITERATOR_REF__TARGET)
		//println('checkDuplicate(' + it + ') : ' + scope.allElements.map[name.segments.join('.')].join(', '))
		val duplicated = scope.allElements.exists[x | x.name.lastSegment == name]
		if (duplicated)
			error(getDuplicateNameMsg(NablaPackage.Literals.SPACE_ITERATOR, name), NablaPackage.Literals.SPACE_ITERATOR__NAME, DUPLICATE_NAME);
	}

	@Check(CheckType.NORMAL)
	def void checkDuplicate(ItemSet it)
	{
		val scope = scopeProvider.getScope(it, NablaPackage.Literals.ITEM_SET_REF__TARGET)
		//println('checkDuplicate(' + it + ') : ' + scope.allElements.map[name.segments.join('.')].join(', '))
		val duplicated = scope.allElements.exists[x | x.name.lastSegment == name]
		if (duplicated)
			error(getDuplicateNameMsg(NablaPackage.Literals.ITEM_SET, name), NablaPackage.Literals.ITEM_SET__NAME, DUPLICATE_NAME);
	}

	@Check(CheckType.NORMAL)
	def void checkDuplicate(ItemType it) { checkDuplicates(NablaPackage.Literals.ITEM_TYPE__NAME) }

	@Check(CheckType.NORMAL)
	def void checkDuplicate(Connectivity it) { checkDuplicates(NablaPackage.Literals.CONNECTIVITY__NAME) }

	@Check(CheckType.NORMAL)
	def void checkDuplicate(Job it) { checkDuplicates(NablaPackage.Literals.JOB__NAME) }

	@Check(CheckType.NORMAL)
	def void checkDuplicate(TimeIterator it) {  checkDuplicates(NablaPackage.Literals.ARG_OR_VAR__NAME) }

	private def <T extends EObject> checkDuplicates(T t, EStructuralFeature f)
	{
		val name = SimpleAttributeResolver.NAME_RESOLVER.apply(t)
		//println('checkDuplicates(' + t + ', ' + f.name + ', ' + name + ')')
		val module = EcoreUtil2.getContainerOfType(t, NablaRoot)
		if (module !== null)
		{
			val contents = EcoreUtil2.getAllContentsOfType(module, t.class)
			for (tx : contents)
			{
				val tx_name = SimpleAttributeResolver.NAME_RESOLVER.apply(tx)
				if (tx_name.equals(name) && tx !== t)
					error(getDuplicateNameMsg(t.eClass, name), f, DUPLICATE_NAME);
			}
		}
	}
}