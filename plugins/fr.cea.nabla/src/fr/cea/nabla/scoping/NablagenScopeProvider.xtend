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
import fr.cea.nabla.nabla.NablaModule
import fr.cea.nabla.nabla.OptionDeclaration
import fr.cea.nabla.nabla.PrimitiveType
import fr.cea.nabla.nabla.SimpleVarDeclaration
import fr.cea.nabla.nabla.TimeIterator
import fr.cea.nabla.nabla.Var
import fr.cea.nabla.nablagen.AdditionalModule
import fr.cea.nabla.nablagen.NablagenModule
import fr.cea.nabla.nablagen.NablagenPackage
import fr.cea.nabla.nablagen.NablagenRoot
import fr.cea.nabla.nablagen.OutputVar
import fr.cea.nabla.nablagen.VtkOutput
import java.util.ArrayList
import java.util.List
import org.eclipse.emf.ecore.EObject
import org.eclipse.emf.ecore.EReference
import org.eclipse.xtext.EcoreUtil2
import org.eclipse.xtext.scoping.IScope
import org.eclipse.xtext.scoping.Scopes
import org.eclipse.xtext.scoping.impl.FilteringScope

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
			case NablagenPackage.Literals.MAIN_MODULE__NODE_COORD: getNodeCoordVarScope(context, r)
			case NablagenPackage.Literals.MAIN_MODULE__TIME: getNgenModuleScalarVarScope(context, r, #[PrimitiveType::REAL])
			case NablagenPackage.Literals.MAIN_MODULE__TIME_STEP: getNgenModuleScalarVarScope(context, r, #[PrimitiveType::REAL])
			case NablagenPackage.Literals.MAIN_MODULE__ITERATION_MAX: getNgenModuleScalarVarScope(context, r, #[PrimitiveType::INT])
			case NablagenPackage.Literals.MAIN_MODULE__TIME_MAX: getNgenModuleScalarVarScope(context, r, #[PrimitiveType::REAL])
			case NablagenPackage.Literals.VTK_OUTPUT__PERIOD_REFERENCE_VAR: getPeriodRefScalarVarScope(context, r)
			case NablagenPackage.Literals.OUTPUT_VAR__VAR_REF: getOutputVarScope(context, r)
			case NablagenPackage.Literals.NABLAGEN_MODULE__TYPE:
			{
				val existingScope = super.getScope(context, r)
				val ngen = EcoreUtil2.getContainerOfType(context, NablagenRoot)
				if (context instanceof AdditionalModule && ngen !== null && ngen.mainModule !== null && ngen.mainModule.type !== null)
					new FilteringScope(existingScope, [e | e.name.toString != ngen.mainModule.type.name])
				else
					existingScope
			}
			case NablagenPackage.Literals.VAR_LINK__ADDITIONAL_MODULE:
			{
				val additionalModule = EcoreUtil2.getContainerOfType(context, AdditionalModule)
				if (additionalModule !== null)
					Scopes::scopeFor(#[additionalModule])
				else
					IScope.NULLSCOPE
			}
			case NablagenPackage.Literals.VAR_LINK__ADDITIONAL_VARIABLE:
			{
				val additionalModule = EcoreUtil2.getContainerOfType(context, AdditionalModule)
				if (additionalModule !== null && additionalModule.type !== null)
					Scopes::scopeFor(additionalModule.type.allVars.filter(Var))
				else
					IScope.NULLSCOPE
			}
			case NablagenPackage.Literals.VAR_LINK__MAIN_MODULE:
			{
				val ngen = EcoreUtil2.getContainerOfType(context, NablagenRoot)
				if (ngen !== null && ngen.mainModule !== null)
					Scopes::scopeFor(#[ngen.mainModule])
				else
					IScope.NULLSCOPE
			}
			case NablagenPackage.Literals.VAR_LINK__MAIN_VARIABLE:
			{
				val ngen = EcoreUtil2.getContainerOfType(context, NablagenRoot)
				if (ngen !== null && ngen.mainModule !== null && ngen.mainModule.type !== null)
					Scopes::scopeFor(ngen.mainModule.type.allVars.filter(Var))
				else
					IScope.NULLSCOPE
			}
			default: super.getScope(context, r)
		}
	}

	private def IScope getNodeCoordVarScope(EObject context, EReference reference)
	{
		val ngenModule = EcoreUtil2.getContainerOfType(context, NablagenModule)
		if (ngenModule !== null && ngenModule.type !== null)
		{
			val candidates = ngenModule.type.allVars.filter(ConnectivityVar).filter[x | x.supports.size == 1 && x.type.sizes.size == 1 && x.type.primitive == PrimitiveType::REAL]
			Scopes::scopeFor(candidates)
		}
		else
			IScope.NULLSCOPE
	}

	private def IScope getOutputVarScope(EObject context, EReference reference)
	{
		val outputVar = EcoreUtil2.getContainerOfType(context, OutputVar)
		if (outputVar !== null && outputVar.moduleRef !== null)
		{
			val nablaModule = outputVar.moduleRef.type
			val candidates = nablaModule.allVars.filter(ConnectivityVar).filter[x | x.supports.size == 1]
			Scopes::scopeFor(candidates)
		}
		else
			IScope.NULLSCOPE
	}

	private def getPeriodRefScalarVarScope(EObject context, EReference reference)
	{
		val vtkOutput = EcoreUtil2.getContainerOfType(context, VtkOutput)
		if (vtkOutput !== null && vtkOutput.periodReferenceModule !== null)
			getScalarVarScope(vtkOutput.periodReferenceModule.type, #[PrimitiveType::INT, PrimitiveType::REAL])
		else
			IScope.NULLSCOPE
	}

	private def getNgenModuleScalarVarScope(EObject context, EReference reference, List<PrimitiveType> primitiveTypes)
	{
		val ngenModule = EcoreUtil2.getContainerOfType(context, NablagenModule)
		if (ngenModule !== null && ngenModule.type !== null)
			getScalarVarScope(ngenModule.type, primitiveTypes)
		else
			IScope.NULLSCOPE
	}

	private def getScalarVarScope(NablaModule nablaModule, List<PrimitiveType> primitiveTypes)
	{
		val declarations = nablaModule.declarations
		val scalarRealOptionDeclarations = declarations.filter(OptionDeclaration).filter[checkScalar(type, primitiveTypes)]
		val scalarRealSimpleVarDeclarations = declarations.filter(SimpleVarDeclaration).filter[checkScalar(type, primitiveTypes)]
		val candidates = new ArrayList<ArgOrVar>
		candidates += scalarRealOptionDeclarations.map[variable]
		candidates += scalarRealSimpleVarDeclarations.map[variable]
		if (nablaModule.iteration !== null && primitiveTypes.exists[x | x == PrimitiveType::INT])
		{
				val iterators = nablaModule.iteration.eAllContents.filter(TimeIterator)
				candidates += iterators.toList
		}
		Scopes::scopeFor(candidates)
	}

	private def checkScalar(BaseType t, List<PrimitiveType> primitiveTypes)
	{
		t.sizes.empty  && primitiveTypes.exists[x | x == t.primitive]
	}
}
