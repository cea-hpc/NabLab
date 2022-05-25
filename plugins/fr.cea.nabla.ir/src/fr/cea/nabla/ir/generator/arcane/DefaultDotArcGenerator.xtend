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

import fr.cea.nabla.ir.IrTypeExtensions
import fr.cea.nabla.ir.IrUtils
import fr.cea.nabla.ir.generator.GenerationContent
import fr.cea.nabla.ir.generator.IrCodeGenerator
import fr.cea.nabla.ir.ir.BaseType
import fr.cea.nabla.ir.ir.DefaultExtensionProvider
import fr.cea.nabla.ir.ir.IrModule
import fr.cea.nabla.ir.ir.IrRoot
import fr.cea.nabla.ir.ir.PrimitiveType
import java.util.Arrays
import org.eclipse.xtend.lib.annotations.Data

import static extension fr.cea.nabla.ir.IrModuleExtensions.*

@Data
class DefaultDotArcGenerator implements IrCodeGenerator
{
	static val DEFAULT_VALUE = 3

	override getName() { "'.arc'" }

	override getIrTransformationSteps() { #[] }

	override getGenerationContents(IrRoot ir, (String)=>void traceNotifier)
	{
		#{ new GenerationContent(ir.name + 'Default.arc', getContent(ir), false) }
	}

	override getGenerationContents(DefaultExtensionProvider provider, (String)=>void traceNotifier)
	{
		// nothing to do
	}

	private def getContent(IrRoot it)
	'''
		<?xml version="1.0"?>
		<case codename="«name»" codeversion="1.0" xml:lang="en">
			<arcane>
				<title>«StringExtensions.separateWith(name, ' ')»</title>
				<timeloop>«name»Loop</timeloop>
			</arcane>
			«IF postProcessing !== null»

				<arcane-post-processing>
					«IF postProcessing.periodReference == currentTimeVariable»
						<output-frequency>«postProcessing.periodValue»</output-frequency>
					«ELSEIF !timeIterators.empty && postProcessing.periodReference.name == timeIterators.get(0).name»
						<output-period>«getDefaultValues(postProcessing.periodValue.type as BaseType).join(" ")»</output-period>
					«ENDIF»
					<output>
						«FOR v : postProcessing.outputVariables»
							<variable>«v.target.name»</variable>
						«ENDFOR»
					</output>
				</arcane-post-processing>
			«ENDIF»

			<!-- Example of mesh generator -->
			<meshes>
				<mesh>
					<generator name="Cartesian2D">
						<nb-part-x>1</nb-part-x>
						<nb-part-y>1</nb-part-y>
						<face-numbering-version>4</face-numbering-version>
						<origin>0.0 0.0</origin>
						<x><n>40</n><length>2.0</length></x>
						<y><n>40</n><length>2.0</length></y>
					</generator>
				</mesh>
			</meshes>

			<!-- User options -->
			«FOR m : modules»
				<«StringExtensions.separateWith(name, StringExtensions.Dash)»>
					«getOptionsContent(m)»
				</«StringExtensions.separateWith(name, StringExtensions.Dash)»>
			«ENDFOR»
		</case>
	'''

	private def CharSequence getOptionsContent(IrModule m)
	'''
		«FOR o : m.variables.filter[option].reject[x | x.name == IrUtils.OutputPeriodOptionName]»
			<«AxlContentProvider.getOptionName(o)»>«getDefaultValues(o.type as BaseType).join(' ')»</«AxlContentProvider.getOptionName(o)»>
		«ENDFOR»
		«FOR s : ArcaneUtils.getServices(m)»
			<«StringExtensions.separateWith(s.name, StringExtensions.Dash)» name="«m.className»">
				«getOptionsContent(s)»
			</«StringExtensions.separateWith(s.name, StringExtensions.Dash)»>
		«ENDFOR»
	'''

	private static def String[] getDefaultValues(BaseType t)
	{
		var nbValues = 1
		for (s : t.intSizes)
			if (s == IrTypeExtensions::DYNAMIC_SIZE)
				nbValues *= DEFAULT_VALUE
			else
				nbValues *= s

		val String[] values = newArrayOfSize(nbValues)
		Arrays.fill(values, t.primitive.defaultValue)
		return values
	}

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
