/*******************************************************************************
 * Copyright (c) 2022 CEA
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
import fr.cea.nabla.nabla.PrimitiveType
import fr.cea.nabla.nabla.SimpleVar
import fr.cea.nabla.nabla.SimpleVarDeclaration
import fr.cea.nabla.nabla.TimeIterator
import fr.cea.nabla.nabla.Var
import fr.cea.nabla.nabla.VarGroupDeclaration
import fr.cea.nabla.nablagen.AdditionalModule
import fr.cea.nabla.nablagen.ExtensionConfig
import fr.cea.nabla.nablagen.NablagenApplication
import fr.cea.nabla.nablagen.NablagenModule
import fr.cea.nabla.nablagen.NablagenPackage
import fr.cea.nabla.nablagen.NablagenProvider
import fr.cea.nabla.nablagen.OutputVar
import fr.cea.nabla.nablagen.VtkOutput
import java.util.ArrayList
import java.util.List
import org.eclipse.emf.ecore.EObject
import org.eclipse.emf.ecore.EReference
import org.eclipse.emf.ecore.util.EcoreUtil
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
				val ngenApp = EcoreUtil2.getContainerOfType(context, NablagenApplication)
				if (context instanceof AdditionalModule && ngenApp !== null && ngenApp.mainModule !== null && ngenApp.mainModule.type !== null)
					new FilteringScope(existingScope, [e | e.name.toString != ngenApp.mainModule.type.name])
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
				val ngenApp = EcoreUtil2.getContainerOfType(context, NablagenApplication)
				if (ngenApp !== null && ngenApp.mainModule !== null)
					Scopes::scopeFor(#[ngenApp.mainModule])
				else
					IScope.NULLSCOPE
			}
			case NablagenPackage.Literals.VAR_LINK__MAIN_VARIABLE:
			{
				val ngenApp = EcoreUtil2.getContainerOfType(context, NablagenApplication)
				if (ngenApp !== null && ngenApp.mainModule !== null && ngenApp.mainModule.type !== null)
					Scopes::scopeFor(ngenApp.mainModule.type.allVars.filter(Var))
				else
					IScope.NULLSCOPE
			}
			case NablagenPackage.Literals.EXTENSION_CONFIG__PROVIDER:
			{
				val existingScope = super.getScope(context, r)
				if (context instanceof ExtensionConfig)
				{
					val extensionConfig = context as ExtensionConfig
					new FilteringScope(existingScope, [e |
						var t = e.EObjectOrProxy as NablagenProvider
						if (t.eIsProxy)
							t = EcoreUtil.resolve(e.EObjectOrProxy, context) as NablagenProvider
						if (t.eIsProxy)
							// no proxy resolution => no filter
							true
						else
							t.extension.name == extensionConfig.extension.name
					])
				}
				else
					existingScope
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
			if (nablaModule !== null)
			{
				val candidates = nablaModule.allVars.filter(ConnectivityVar).filter[x | x.supports.size == 1]
				Scopes::scopeFor(candidates)
			}
			else
				IScope.NULLSCOPE
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
		val candidates = new ArrayList<ArgOrVar>
		for (d : nablaModule.declarations)
		{
			switch d
			{
				SimpleVarDeclaration case checkScalar(d.type, primitiveTypes): candidates += d.variable
				VarGroupDeclaration case checkScalar(d.type, primitiveTypes): candidates += d.variables.filter(SimpleVar)
			}
		}
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
