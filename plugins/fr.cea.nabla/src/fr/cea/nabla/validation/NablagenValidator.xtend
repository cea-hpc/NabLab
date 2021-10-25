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
import fr.cea.nabla.NablaModuleExtensions
import fr.cea.nabla.generator.NablagenExtensionHelper
import fr.cea.nabla.nabla.FunctionCall
import fr.cea.nabla.nabla.NablaExtension
import fr.cea.nabla.nabla.NablaRoot
import fr.cea.nabla.nablagen.AdditionalModule
import fr.cea.nabla.nablagen.NablagenApplication
import fr.cea.nabla.nablagen.NablagenModule
import fr.cea.nabla.nablagen.NablagenPackage
import fr.cea.nabla.nablagen.NablagenProvider
import fr.cea.nabla.nablagen.Target
import fr.cea.nabla.nablagen.TargetType
import fr.cea.nabla.nablagen.VarLink
import fr.cea.nabla.typing.ArgOrVarTypeProvider
import java.util.HashSet
import org.eclipse.xtext.EcoreUtil2
import org.eclipse.xtext.validation.Check
import org.eclipse.xtext.validation.CheckType

/**
 * This class contains custom validation rules. 
 *
 * See https://www.eclipse.org/Xtext/documentation/303_runtime_concepts.html#validation
 */
class NablagenValidator extends AbstractNablagenValidator
{
	@Inject extension ArgOrVarTypeProvider
	@Inject extension NablaModuleExtensions
	@Inject NablagenExtensionHelper nablagenExtensionHelper

	public static val NGEN_ELEMENT_NAME = "NablagenValidator::ElementName"
	public static val NGEN_MODULE_NAME = "NablagenValidator::ModuleName"
	public static val UNIQUE_INTERPRETER = "NablagenValidator::UniqueInterpreter"
	public static val CPP_MANDATORY_VARIABLES = "NablagenValidator::CppMandatoryVariables"
	public static val NO_TIME_ITERATOR_DEFINITION = "NablagenValidator::NoTimeIteratorDefinition"
	public static val VAR_LINK_MAIN_VAR_TYPE = "NablagenValidator::VarLinkMainVarType"
	public static val PROVIDER_FOR_EACH_EXTENSION = "NablagenValidator::ProviderForEachExtension"
	public static val MAIN_MODULE_MESH = "NablagenValidator::MainModuleMesh"

	static def getNgenElementNameMsg() { "Application/Provider name must start with an upper case" }
	static def getNgenModuleNameMsg() { "Nabla module instance name must start with a lower case" }
	static def getUniqueInterpreterMsg() { "Only one interpreter target allowed" }
	static def getCppMandatoryVariablesMsg() { "'iterationMax' and 'timeMax' simulation variables must be defined (after timeStep) when using C++ code generator" }
	static def getNoTimeIteratorDefinitionMsg() { "Iterate keyword not allowed in additional module" }
	static def getVarLinkMainVarTypeMsg(String v1Type, String v2Type) { "Variables must have the same type: " + v1Type + " \u2260 " + v2Type }
	static def getProviderForEachExtensionMsg(String extensionName) { "No provider found for extension: " + extensionName }
	static def getMainModuleMeshMsg(String expectedMesh, String actualMesh) { "Mesh extension must be identical as main module's one. Expected " + expectedMesh + ", but was " + actualMesh }

	@Check(CheckType.FAST)
	def checkName(NablagenApplication it)
	{
		if (!name.nullOrEmpty && Character::isLowerCase(name.charAt(0)))
			error(getNgenElementNameMsg(), NablagenPackage.Literals.NABLAGEN_APPLICATION__NAME, NGEN_ELEMENT_NAME)
	}

	@Check(CheckType.FAST)
	def checkName(NablagenProvider it)
	{
		if (!name.nullOrEmpty && Character::isLowerCase(name.charAt(0)))
			error(getNgenElementNameMsg(), NablagenPackage.Literals.NABLAGEN_PROVIDER__NAME, NGEN_ELEMENT_NAME)
	}

	@Check(CheckType.FAST)
	def checkName(NablagenModule it)
	{
		if (!name.nullOrEmpty && Character::isUpperCase(name.charAt(0)))
			error(getNgenModuleNameMsg(), NablagenPackage.Literals.NABLAGEN_MODULE__NAME, NGEN_MODULE_NAME)
	}

	@Check(CheckType.FAST)
	def checkUniqueInterpreter(Target it)
	{
		if (interpreter)
		{
			val app = EcoreUtil2.getContainerOfType(it, NablagenApplication)
			if (app !== null && app.targets.exists[x | x.interpreter && x !== it])
				error(getUniqueInterpreterMsg(), NablagenPackage.Literals.TARGET__INTERPRETER, UNIQUE_INTERPRETER)
		}
	}

	@Check(CheckType.FAST)
	def void checkCppMandatoryVariables(NablagenApplication it)
	{
		if (targets.exists[x | x.type != TargetType::JAVA] && (mainModule !== null && mainModule.iterationMax === null || mainModule.timeMax === null))
			error(getCppMandatoryVariablesMsg(), NablagenPackage.Literals::NABLAGEN_APPLICATION__MAIN_MODULE, CPP_MANDATORY_VARIABLES)
	}

	@Check(CheckType.FAST)
	def void checkNoTimeIteratorDefinition(AdditionalModule it)
	{
		if (type.iteration !== null)
			error(getNoTimeIteratorDefinitionMsg(), NablagenPackage.Literals::NABLAGEN_MODULE__NAME, NO_TIME_ITERATOR_DEFINITION)
	}

	@Check(CheckType.FAST)
	def void checkVarLinkMainVarType(VarLink it)
	{
		if (additionalVariable !== null && !additionalVariable.eIsProxy
			&& mainVariable !== null && !mainVariable.eIsProxy)
		{
			val avType = additionalVariable.typeFor
			val mvType = mainVariable.typeFor
			if (avType !== null && mvType !== null)
			{
				// Types are different because they come from different NablaModule instances
				// ==> comparing type labels
				val avTypeLabel = avType.label
				val mvTypeLabel = mvType.label
				if (avTypeLabel != mvTypeLabel)
					error(getVarLinkMainVarTypeMsg(avTypeLabel, mvTypeLabel), NablagenPackage.Literals::VAR_LINK__MAIN_VARIABLE, VAR_LINK_MAIN_VAR_TYPE)
			}
		}
	}

	@Check(CheckType.FAST)
	def void checkProviderForEachExtension(Target it)
	{
		val ngen = eContainer as NablagenApplication
		val neededExtensionNames = new HashSet<String>
		neededExtensionNames += ngen.mainModule.type.extensionNames
		ngen.additionalModules.forEach[x | neededExtensionNames += x.type.extensionNames]
		for (neededExtensionName : neededExtensionNames.filter[x | x != "Math"])
			if (nablagenExtensionHelper.getTargetProvider(it, neededExtensionName) === null)
			{
				val structuralFeature = (interpreter ? NablagenPackage.Literals::TARGET__INTERPRETER : NablagenPackage.Literals::TARGET__TYPE)
				warning(getProviderForEachExtensionMsg(neededExtensionName), structuralFeature, PROVIDER_FOR_EACH_EXTENSION)
			}
	}

	@Check(CheckType.FAST)
	def void checkMainModuleMesh(AdditionalModule it)
	{
		val ngen = eContainer as NablagenApplication
		val mainModule = ngen.mainModule
		if (mainModule !== null && mainModule.type !== null && type !== null)
		{
			val mainMeshes = mainModule.type.meshExtensions
			val addMeshes = type.meshExtensions
			if (mainMeshes.size > 0 && addMeshes.size > 0 && mainMeshes.head != addMeshes.head)
				error(getMainModuleMeshMsg(mainMeshes.head.name, addMeshes.head.name), NablagenPackage.Literals::NABLAGEN_MODULE__TYPE, MAIN_MODULE_MESH)
		}
	}

	private def getExtensionNames(NablaRoot it)
	{
		val usedFunctions = eAllContents.filter(FunctionCall).map[function].filter[external]
		val extensionNames = new HashSet<String>
		for (f : usedFunctions.toIterable)
		{
			val ext = EcoreUtil2.getContainerOfType(f, NablaExtension)
			if (ext !== null)
				extensionNames += ext.name
		}
		return extensionNames
	}
}
