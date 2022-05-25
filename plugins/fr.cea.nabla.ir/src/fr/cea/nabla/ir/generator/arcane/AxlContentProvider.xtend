/*******************************************************************************
 * Copyright (c) 2022 CEA
 * This program and the accompanying materials are made available under the
 * terms of the Eclipse Public License 2.0 which is available at
 * http://www.eclipse.org/legal/epl-2.0.
 *
 * SPDX-License-Identifier: EPL-2.0
 * Contributors: see AUTHORS file
 *******************************************************************************/
package fr.cea.nabla.ir.generator.arcane

import fr.cea.nabla.ir.IrUtils
import fr.cea.nabla.ir.generator.Utils
import fr.cea.nabla.ir.ir.ArgOrVarRef
import fr.cea.nabla.ir.ir.BaseType
import fr.cea.nabla.ir.ir.ConnectivityType
import fr.cea.nabla.ir.ir.ExtensionProvider
import fr.cea.nabla.ir.ir.IrModule
import fr.cea.nabla.ir.ir.IrType
import fr.cea.nabla.ir.ir.Variable
import java.util.ArrayList

import static extension fr.cea.nabla.ir.IrModuleExtensions.*
import static extension fr.cea.nabla.ir.generator.arcane.StringExtensions.*

class AxlContentProvider
{
	static def getContent(IrModule it)
	'''
	<?xml version="1.0" ?>
	<!-- «Utils::doNotEditWarning» -->
	«IF ArcaneUtils.isArcaneModule(it)»
	<module name="«className»" version="1.0">
	«ELSE»
	<service name="«className»" version="1.0" type="caseoption">
		<interface name="«ArcaneUtils.getInterfaceName(it)»" />
	«ENDIF»
		<description>«className» designed and generated thanks to the NabLab environment</description>

		<variables>
			«FOR v : variablesToDeclare SEPARATOR '\n'»
			«val type = v.type as ConnectivityType»
			<variable
				field-name="«v.name»"
				name="«IF irRoot.nodeCoordVariable === v»NodeCoord«ELSE»«v.name»«ENDIF»"
				data-type="«IF irRoot.nodeCoordVariable === v»real3«ELSE»«type.dataType»«ENDIF»"
				item-kind="«type.itemKind»"
				dim="«type.dimension»"
				dump="true"
				need-sync="true"/>
			«ENDFOR»
		</variables>

		<options>
			«FOR v : variables.filter[option].reject[x | x.name == IrUtils.OutputPeriodOptionName]»
				<simple name="«v.optionName»" type="«v.type.dataType»«IF !TypeContentProvider.isArcaneScalarType(v.type as BaseType)»[]«ENDIF»" minOccurs="1" maxOccurs="1">
					<description/>
				</simple>
			«ENDFOR»
			«FOR p : externalProviders»
				<simple name="«p.optionName»" type="string" optional="true">
					<description/>
				</simple>
			«ENDFOR»
			«FOR s : ArcaneUtils.getServices(it)»
				<service-instance name="«StringExtensions.separateWith(s.name, StringExtensions.Dash)»" type="«ArcaneUtils.getInterfaceName(s)»">
					<description/>
				</service-instance>
			«ENDFOR»
		</options>
	«IF ArcaneUtils.isArcaneModule(it)»

		<entry-points>
			<entry-point method-name="init" name="Init" where="init" property="none" />
			«FOR j : ArcaneUtils.getComputeLoopEntryPointJobs(it)»
				<entry-point method-name="«j.name.toFirstLower»" name="«j.name.toFirstUpper»" where="compute-loop" property="none" />
			«ENDFOR»
		</entry-points>
	</module>
	«ELSE»
	</service>
	«ENDIF»
	'''

	static def getOptionName(Variable it)
	{
		name.separateWith(StringExtensions.Dash)
	}

	static def getOptionName(ExtensionProvider it)
	{
		extensionName.separateWith(StringExtensions.Dash)
	}

	private static def getDataType(IrType it)
	{
		switch it
		{
			BaseType: TypeContentProvider.getTypeNameAndDimension(it).key.toLowerCase
			ConnectivityType: TypeContentProvider.getTypeNameAndDimension(base).key.toLowerCase
			default: throw new RuntimeException("Not yet implemented")
		}
	}

	private static def getItemKind(ConnectivityType it)
	{
		connectivities.head.returnType.name.toLowerCase
	}

	private static def getDimension(ConnectivityType it)
	{
		connectivities.size - 1 + TypeContentProvider.getTypeNameAndDimension(base).value
	}

	private static def getVariablesToDeclare(IrModule it)
	{
		val variablesToDeclare = new ArrayList<Variable>
		for (v : variables.filter[x | ArcaneUtils.isArcaneManaged(x)])
			variablesToDeclare += v
		if (!main)
		{
			for (refVar : eAllContents.filter(ArgOrVarRef).map[target].filter(Variable).toSet)
				if (ArcaneUtils.isArcaneManaged(refVar) && IrUtils.getContainerOfType(refVar, IrModule) !== it)
					variablesToDeclare += refVar
		}
		return variablesToDeclare
	}
}