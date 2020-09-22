/*******************************************************************************
 * Copyright (c) 2020 CEA
 * This program and the accompanying materials are made available under the 
 * terms of the Eclipse Public License 2.0 which is available at
 * http://www.eclipse.org/legal/epl-2.0.
 *
 * SPDX-License-Identifier: EPL-2.0
 * Contributors: see AUTHORS file
 *******************************************************************************/
package fr.cea.nabla.scoping

import com.google.inject.Inject
import fr.cea.nabla.ArgOrVarExtensions
import fr.cea.nabla.NablaModuleExtensions
import fr.cea.nabla.nabla.ArgOrVar
import fr.cea.nabla.nabla.BaseType
import fr.cea.nabla.nabla.ConnectivityVar
import fr.cea.nabla.nabla.OptionDeclaration
import fr.cea.nabla.nabla.PrimitiveType
import fr.cea.nabla.nabla.SimpleVarDeclaration
import fr.cea.nabla.nabla.TimeIterator
import fr.cea.nabla.nablagen.NablagenConfig
import fr.cea.nabla.nablagen.NablagenPackage
import java.util.ArrayList
import java.util.List
import org.eclipse.emf.ecore.EObject
import org.eclipse.emf.ecore.EReference
import org.eclipse.xtext.EcoreUtil2
import org.eclipse.xtext.scoping.IScope
import org.eclipse.xtext.scoping.Scopes

/**
 * This class contains custom scoping description.
 * 
 * See https://www.eclipse.org/Xtext/documentation/303_runtime_concepts.html#scoping
 * on how and when to use it.
 */
class NablagenScopeProvider extends AbstractNablagenScopeProvider
{
	@Inject extension NablaModuleExtensions
	@Inject extension ArgOrVarExtensions

	override IScope getScope(EObject context, EReference r)
	{
		switch r
		{
			case NablagenPackage.Literals.SIMULATION__NODE_COORD: getRealArrayConnectivityVarScope(context, r)
			case NablagenPackage.Literals.SIMULATION__TIME: getScalarVarScope(context, r, #[PrimitiveType::REAL])
			case NablagenPackage.Literals.SIMULATION__TIME_STEP: getScalarVarScope(context, r, #[PrimitiveType::REAL])
			case NablagenPackage.Literals.SIMULATION__ITERATION_MAX: getScalarVarScope(context, r, #[PrimitiveType::INT])
			case NablagenPackage.Literals.SIMULATION__TIME_MAX: getScalarVarScope(context, r, #[PrimitiveType::REAL])
			case NablagenPackage.Literals.VTK_OUTPUT__PERIOD_REFERENCE: getScalarVarScope(context, r, #[PrimitiveType::INT, PrimitiveType::REAL])
			case NablagenPackage.Literals.OUTPUT_VAR__VAR_REF: getConnectivityVarScope(context, r)
			default: super.getScope(context, r)
		}
	}

	private def IScope getRealArrayConnectivityVarScope(EObject context, EReference reference)
	{
		val config = EcoreUtil2.getContainerOfType(context, NablagenConfig)
		if (config !== null && config.nablaModule !== null)
		{
			val candidates = config.nablaModule.allVars.filter(ConnectivityVar).filter[x | x.supports.size == 1 && x.type.sizes.size == 1 && x.type.primitive == PrimitiveType::REAL]
			Scopes::scopeFor(candidates)
		}
		else
			IScope.NULLSCOPE
	}

	private def IScope getConnectivityVarScope(EObject context, EReference reference)
	{
		val config = EcoreUtil2.getContainerOfType(context, NablagenConfig)
		if (config !== null && config.nablaModule !== null)
		{
			val candidates = config.nablaModule.allVars.filter(ConnectivityVar).filter[x | x.supports.size == 1]
			Scopes::scopeFor(candidates)
		}
		else
			IScope.NULLSCOPE
	}

	private def getScalarVarScope(EObject context, EReference reference, List<PrimitiveType> primitiveTypes)
	{
		val config = EcoreUtil2.getContainerOfType(context, NablagenConfig)
		if (config !== null && config.nablaModule !== null)
		{
			val declarations = config.nablaModule.declarations
			val scalarRealOptionDeclarations = declarations.filter(OptionDeclaration).filter[checkScalar(type, primitiveTypes)]
			val scalarRealSimpleVarDeclarations = declarations.filter(SimpleVarDeclaration).filter[checkScalar(type, primitiveTypes)]
			val candidates = new ArrayList<ArgOrVar>
			candidates += scalarRealOptionDeclarations.map[variable]
			candidates += scalarRealSimpleVarDeclarations.map[variable]
			if (config.nablaModule.iteration !== null && primitiveTypes.exists[x | x == PrimitiveType::INT])
			{
					val iterators = config.nablaModule.iteration.eAllContents.filter(TimeIterator)
					candidates += iterators.toList
			}
			Scopes::scopeFor(candidates)
		}
		else
			IScope.NULLSCOPE
	}

	private def checkScalar(BaseType t, List<PrimitiveType> primitiveTypes)
	{
		t.sizes.empty  && primitiveTypes.exists[x | x == t.primitive]
	}
}
