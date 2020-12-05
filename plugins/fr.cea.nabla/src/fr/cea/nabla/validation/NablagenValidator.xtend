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
import fr.cea.nabla.nabla.Connectivity
import fr.cea.nabla.nabla.NablaModule
import fr.cea.nabla.nablagen.AdditionalModule
import fr.cea.nabla.nablagen.Application
import fr.cea.nabla.nablagen.NablagenModule
import fr.cea.nabla.nablagen.NablagenPackage
import fr.cea.nabla.nablagen.NablagenRoot
import fr.cea.nabla.nablagen.TargetType
import fr.cea.nabla.nablagen.VarLink
import fr.cea.nabla.typing.ArgOrVarTypeProvider
import java.util.HashSet
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

	public static val NGEN_APPLICATION_NAME = "NablagenValidator::ApplicationName"
	public static val NGEN_MODULE_NAME = "NablagenValidator::ModuleName"
	public static val CPP_MANDATORY_VARIABLES = "NablagenValidator::CppMandatoryVariables"
	public static val CONNECTIVITY_CONSISTENCY = "NablagenValidator::ConnectivityConsistency"
	public static val VAR_LINK_MAIN_VAR_TYPE = "NablagenValidator::VarLinkMainVarType"

	static def getNgenApplicationNameMsg() { "Application name must start with an upper case" }
	static def getNgenModuleNameMsg() { "Nabla module instance name must start with a lower case" }
	static def getCppMandatoryVariablesMsg() { "'iterationMax' and 'timeMax' simulation variables must be defined (after timeStep) when using C++ code generator" }
	static def getConnectivityConsistencyMsg(String a, String b) { "Connectivities with same name must be identical: " + a + " \u2260 " + b}
	static def getVarLinkMainVarTypeMsg(String v1Type, String v2Type) { "Variables must have the same type: " + v1Type + " \u2260 " + v2Type }

	@Check(CheckType.FAST)
	def checkName(NablagenRoot it)
	{
		if (!name.nullOrEmpty && Character::isLowerCase(name.charAt(0)))
			error(getNgenApplicationNameMsg(), NablagenPackage.Literals.NABLAGEN_ROOT__NAME, NGEN_APPLICATION_NAME)
	}

	@Check(CheckType.FAST)
	def checkName(NablagenModule it)
	{
		if (!name.nullOrEmpty && Character::isUpperCase(name.charAt(0)))
			error(getNgenModuleNameMsg(), NablagenPackage.Literals.NABLAGEN_MODULE__NAME, NGEN_MODULE_NAME)
	}

	@Check(CheckType.FAST)
	def void checkCppMandatoryVariables(Application it)
	{
		if (targets.exists[x | x.type != TargetType::JAVA] && (mainModule !== null && mainModule.iterationMax === null || mainModule.timeMax === null))
			error(getCppMandatoryVariablesMsg(), NablagenPackage.Literals::APPLICATION__MAIN_MODULE, CPP_MANDATORY_VARIABLES)
	}

	@Check(CheckType.FAST)
	def void checkConnectivityConsistency(AdditionalModule it)
	{
		// Look for all referenced NablaModule 
		val root = eContainer as Application
		val otherNablaModules = new HashSet<NablaModule>
		if (root.mainModule.type !== null && root.mainModule.type !== type)
			otherNablaModules += root.mainModule.type
		for (am : root.additionalModules)
			if (am !== it && am.type !== null && am.type !== type)
				otherNablaModules += am.type

		// Check that connectivities with same names are identical
		for (a : type.connectivities)
			for (nablaModule : otherNablaModules)
				for (b : nablaModule.connectivities)
					if (!areConsistent(a, b))
						error(getConnectivityConsistencyMsg(a.msgId, b.msgId), NablagenPackage.Literals::NABLAGEN_MODULE__NAME, CONNECTIVITY_CONSISTENCY)
	}

	@Check(CheckType.FAST)
	def void checkVarLinkMainVarType(VarLink it)
	{
		if (additionalVariable !== null && mainVariable !== null)
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

	/**
	 * Return true if a and b have different names or are identical
	 * false otherwise.
	 */
	private def areConsistent(Connectivity a, Connectivity b)
	{
		if (a.name != b.name) return true

		// a and b have the same name => they must be identical
		if (a.multiple != b.multiple) return false
		if (a.returnType.name != b.returnType.name) return false
		if (a.inTypes.size != b.inTypes.size) return false
		for (i : 0..<a.inTypes.size)
			if (a.inTypes.get(i).name != b.inTypes.get(i).name) return false
		return true
	}

	private def getMsgId(Connectivity it)
	{
		(eContainer as NablaModule).name + "::" + name
	}
}
