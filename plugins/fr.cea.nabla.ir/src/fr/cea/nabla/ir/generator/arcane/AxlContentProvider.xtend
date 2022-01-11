/*******************************************************************************
 * Copyright (c) 2021 CEA
 * This program and the accompanying materials are made available under the
 * terms of the Eclipse Public License 2.0 which is available at
 * http://www.eclipse.org/legal/epl-2.0.
 *
 * SPDX-License-Identifier: EPL-2.0
 * Contributors: see AUTHORS file
 *******************************************************************************/
package fr.cea.nabla.ir.generator.arcane

import fr.cea.nabla.ir.generator.Utils
import fr.cea.nabla.ir.ir.BaseType
import fr.cea.nabla.ir.ir.BoolConstant
import fr.cea.nabla.ir.ir.ConnectivityType
import fr.cea.nabla.ir.ir.IntConstant
import fr.cea.nabla.ir.ir.IrModule
import fr.cea.nabla.ir.ir.LinearAlgebraType
import fr.cea.nabla.ir.ir.MaxConstant
import fr.cea.nabla.ir.ir.MinConstant
import fr.cea.nabla.ir.ir.RealConstant
import fr.cea.nabla.ir.ir.Variable

import static extension fr.cea.nabla.ir.IrModuleExtensions.*
import static extension fr.cea.nabla.ir.IrTypeExtensions.*
import static extension fr.cea.nabla.ir.generator.arcane.StringExtensions.*
import static extension fr.cea.nabla.ir.generator.arcane.VariableExtensions.*

class AxlContentProvider
{
	static def getContent(IrModule it)
	'''
	<?xml version="1.0" ?>
	<!-- «Utils::doNotEditWarning» -->
	<module name="«className»" version="1.0">
		<description>«className» module designed and implemented thanks to the NabLab environment.</description>

		<variables>
			«FOR v : variables.filter[x | !(x.option || x.type instanceof LinearAlgebraType)] SEPARATOR '\n'»
			<variable
				field-name="«v.name.separateWith(StringExtensions.LowerCase)»"
				name="«IF irRoot.nodeCoordVariable === v»NodeCoord«ELSE»«v.name»«ENDIF»"
				data-type="«v.dataType»"
				item-kind="«v.itemKind»"
				dim="«v.dimension»"
				dump="true"
				need-sync="true"/>
			«ENDFOR»
		</variables>

		<options>
			«FOR v : variables.filter[option]»
				«val df = v.arcaneDefaultValue»
				<simple name="«v.optionName»" type="«v.dataType»"«IF df !== null» default="«df»"«ENDIF» «v.bounds»>
					<description/>
				</simple>
			«ENDFOR»
		</options>

		<entry-points>
			<entry-point method-name="init" name="Init" where="start-init" property="none" />
			<entry-point method-name="compute" name="Compute" where="compute-loop" property="none" />
		</entry-points>
	</module>
	'''

	private static def getDataType(Variable it)
	{
		val t = type
		switch t
		{
			BaseType: TypeContentProvider.getTypeNameAndDimension(t).key.toLowerCase
			ConnectivityType: TypeContentProvider.getTypeNameAndDimension(t.base).key.toLowerCase
		}
	}

	private static def getItemKind(Variable it)
	{
		val t = type
		switch t
		{
			BaseType: "none"
			ConnectivityType: t.connectivities.head.returnType.name.toLowerCase
		}
	}

	private static def getDimension(Variable it)
	{
		val t = type
		switch t
		{
			BaseType: TypeContentProvider.getTypeNameAndDimension(t).value
			ConnectivityType: t.connectivities.size - 1 + TypeContentProvider.getTypeNameAndDimension(t.base).value
		}
	}

	private static def String getArcaneDefaultValue(Variable it)
	{
		val d = defaultValue
		switch d
		{
			case null: null
			IntConstant: d.value.toString
			RealConstant: d.value.toString
			BoolConstant: d.value.toString.toLowerCase
			MinConstant: switch type.primitive
			{
				case BOOL: null
				case INT: Integer.MIN_VALUE.toString
				case REAL: Double.MIN_VALUE.toString
			}
			MaxConstant: switch type.primitive
			{
				case BOOL: null
				case INT: Integer.MAX_VALUE.toString
				case REAL: Double.MAX_VALUE.toString
			}
		}
	}

	private static def getBounds(Variable it)
	{
		val d = type.dimension
		val optional = (arcaneDefaultValue !== null)
		switch d
		{
			case 0: (optional ? '''optional="true"''' : '''minOccurs="1" maxOccurs="1"''')
			case 1 : '''minOccurs="«IF optional»0«ELSE»1«ENDIF»" maxOccurs="unbounded"'''
			default : throw new RuntimeException("Dimension greater than 1 not yet suported in options: " + d)
		}
	}
}