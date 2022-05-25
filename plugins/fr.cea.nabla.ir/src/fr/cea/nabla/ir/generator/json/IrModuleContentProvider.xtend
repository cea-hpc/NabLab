/*******************************************************************************
 * Copyright (c) 2022 CEA
 * This program and the accompanying materials are made available under the
 * terms of the Eclipse Public License 2.0 which is available at
 * http://www.eclipse.org/legal/epl-2.0.
 *
 * SPDX-License-Identifier: EPL-2.0
 * Contributors: see AUTHORS file
 *******************************************************************************/
package fr.cea.nabla.ir.generator.json

import fr.cea.nabla.ir.IrTypeExtensions
import fr.cea.nabla.ir.IrUtils
import fr.cea.nabla.ir.ir.BaseType
import fr.cea.nabla.ir.ir.IrModule
import fr.cea.nabla.ir.ir.PrimitiveType
import java.util.ArrayList

import static extension fr.cea.nabla.ir.ExtensionProviderExtensions.*
import static extension fr.cea.nabla.ir.IrModuleExtensions.*

class IrModuleContentProvider
{
	static val DEFAULT_VALUE = 3

	static def getJsonValues(IrModule irModule, boolean hasLevelDB)
	{
		val values = new ArrayList<Pair<String, String>>
		if (irModule.postProcessing !== null)
		{
			values += new Pair('_outputPath_comment', '"empty outputPath to disable output"')
			values += new Pair(IrUtils.OutputPathNameAndValue.key, '"' + IrUtils.OutputPathNameAndValue.value + '"')
		}
		for (o : irModule.variables.filter[option])
			values += new Pair(o.name, (o.type as BaseType).defaultValue)
		for (extensionProvider : irModule.externalProviders)
			values += new Pair(extensionProvider.instanceName, '{}')
		if (irModule.main && hasLevelDB)
		{
			val value = '"empty value to disable, ' + IrUtils.NonRegressionValues.CreateReference.toString + ' or ' + IrUtils.NonRegressionValues.CompareToReference.toString + ' to take action"'
			values += new Pair('_nonRegression_comment', value)
			values += IrUtils.NonRegressionNameAndValue
			values += IrUtils.NonRegressionToleranceNameAndValue
		}
		return values
	}

	private static def String getDefaultValue(BaseType t)
	{
		val intSizes = ArrayExtensions.clone(t.intSizes as int[])

		if (!t.isStatic)
			// For dynamic dimensions, the default value is also used as a default size
			for (i : 0..<intSizes.length)
				if (intSizes.get(i) == IrTypeExtensions::DYNAMIC_SIZE)
					intSizes.set(i, DEFAULT_VALUE)

		if (intSizes.empty)
			t.primitive.defaultValue
		else
			getArrayContent(t.intSizes, t.primitive).toString
	}

	private static def CharSequence getArrayContent(int[] sizes, PrimitiveType t)
	'''«FOR i : 0..<sizes.head BEFORE '[' SEPARATOR ',' AFTER ']'»«IF sizes.size == 1»«t.defaultValue»«ELSE»«getArrayContent(sizes.tail, t)»«ENDIF»«ENDFOR»'''

	private static def String getDefaultValue(PrimitiveType t)
	{
		switch t
		{
			case BOOL: "true"
			case INT: DEFAULT_VALUE.toString
			case REAL: (DEFAULT_VALUE * 1.0).toString
		}
	}
}
