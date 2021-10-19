/*******************************************************************************
 * Copyright (c) 2021 CEA
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
import fr.cea.nabla.ir.generator.ApplicationGenerator
import fr.cea.nabla.ir.generator.GenerationContent
import fr.cea.nabla.ir.ir.BaseType
import fr.cea.nabla.ir.ir.IrModule
import fr.cea.nabla.ir.ir.IrRoot
import fr.cea.nabla.ir.ir.PrimitiveType
import java.util.ArrayList

import static extension fr.cea.nabla.ir.ExtensionProviderExtensions.*
import static extension fr.cea.nabla.ir.IrModuleExtensions.*

class JsonGenerator implements ApplicationGenerator
{
	val boolean levelDB

	new(boolean levelDB)
	{
		this.levelDB = levelDB
	}

	override getName() { 'Json' }

	override getIrTransformationStep() { null }

	override getGenerationContents(IrRoot ir)
	{
		#{ new GenerationContent(ir.name + 'Default.json', getJsonFileContent(ir), false) }
	}

	private def getJsonFileContent(IrRoot rootModel)
	'''
		{
			"_comment": "GENERATED FILE - DO NOT OVERWRITE",
			«FOR irModule : rootModel.modules»
				"«irModule.name.toFirstLower»":
				{
					«FOR jsonValue : getJsonValues(irModule) SEPARATOR ","»
						"«jsonValue.key»":«jsonValue.value»
					«ENDFOR»
				},
			«ENDFOR»
			"mesh":
			{
			}
		}
	'''

	private def getJsonValues(IrModule irModule)
	{
		val values = new ArrayList<Pair<String, String>>
		if (irModule.postProcessing !== null)
		{
			values += new Pair('_outputPath_comment', '"empty outputPath to disable output"')
			values += new Pair(IrUtils.OutputPathNameAndValue.key, '"' + IrUtils.OutputPathNameAndValue.value + '"')
		}
		for (mandatoryOption : irModule.options.filter[x | x.defaultValue === null])
			values += new Pair(mandatoryOption.name, (mandatoryOption.type as BaseType).defaultValue)
		for (extensionProvider : irModule.externalProviders)
			values += new Pair(extensionProvider.instanceName, '{}')
		if (irModule.main && levelDB)
		{
			val value = '"empty value to disable, " + Utils.NonRegressionValues.CreateReference.toString + " or " + Utils.NonRegressionValues.CompareToReference.toString + " to take action"'
			values += new Pair('_nonRegression_comment', value)
			values += IrUtils.NonRegressionNameAndValue
		}
		return values
	}

	static val DEFAULT_VALUE = 3

	private def String getDefaultValue(BaseType t)
	{
		val intSizes = ArrayExtensions.clone(t.intSizes as int[])

		if (t.isStatic)
			// For dynamic dimensions, the default value is also used as a default size
			for (i : 0..<intSizes.length)
				if (intSizes.get(i) == IrTypeExtensions::DYNAMIC_SIZE)
					intSizes.set(i, DEFAULT_VALUE)

		if (intSizes.empty)
			t.primitive.defaultValue
		else
			getArrayContent(t.intSizes, t.primitive).toString
	}

	private def CharSequence getArrayContent(int[] sizes, PrimitiveType t)
	'''«FOR i : 0..<sizes.head BEFORE '[' SEPARATOR ',' AFTER ']'»«IF sizes.size == 1»«t.defaultValue»«ELSE»«getArrayContent(sizes.tail, t)»«ENDIF»«ENDFOR»'''

	private def String getDefaultValue(PrimitiveType t)
	{
		switch t
		{
			case BOOL: "true"
			case INT: DEFAULT_VALUE.toString
			case REAL: (DEFAULT_VALUE * 1.0).toString
		}
	}
}
