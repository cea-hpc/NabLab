/*******************************************************************************
 * Copyright (c) 2022 CEA
 * This program and the accompanying materials are made available under the
 * terms of the Eclipse Public License 2.0 which is available at
 * http://www.eclipse.org/legal/epl-2.0.
 *
 * SPDX-License-Identifier: EPL-2.0
 * Contributors: see AUTHORS file
 *******************************************************************************/
package fr.cea.nabla.ir.generator.dace

import fr.cea.nabla.ir.ir.Affectation
import fr.cea.nabla.ir.ir.ConnectivityCall
import fr.cea.nabla.ir.ir.Exit
import fr.cea.nabla.ir.ir.If
import fr.cea.nabla.ir.ir.Instruction
import fr.cea.nabla.ir.ir.InstructionBlock
import fr.cea.nabla.ir.ir.Interval
import fr.cea.nabla.ir.ir.ItemIdDefinition
import fr.cea.nabla.ir.ir.ItemIndexDefinition
import fr.cea.nabla.ir.ir.Iterator
import fr.cea.nabla.ir.ir.Loop
import fr.cea.nabla.ir.ir.ReductionInstruction
import fr.cea.nabla.ir.ir.Return
import fr.cea.nabla.ir.ir.SetDefinition
import fr.cea.nabla.ir.ir.VariableDeclaration
import fr.cea.nabla.ir.ir.While

import static fr.cea.nabla.ir.generator.dace.TypeContentProvider.*

import static extension fr.cea.nabla.ir.ArgOrVarExtensions.*
import static extension fr.cea.nabla.ir.ContainerExtensions.*
import static extension fr.cea.nabla.ir.IrTypeExtensions.*
import static extension fr.cea.nabla.ir.generator.dace.ExpressionContentProvider.*
import static extension fr.cea.nabla.ir.generator.dace.ItemIndexAndIdValueContentProvider.*

class InstructionContentProvider 
{
	static def dispatch CharSequence getContent(VariableDeclaration it)
	'''
		«IF variable.defaultValue === null»
			«IF !variable.type.scalar»
				«variable.name»«getPythonAllocation(variable.type, variable.name)»
			«ENDIF»
		«ELSE»
			«variable.name» = «variable.defaultValue.content»
		«ENDIF»
	'''

	static def dispatch CharSequence getContent(InstructionBlock it)
	'''
		«FOR i : instructions»
			«i.content»
		«ENDFOR»
	'''

	static def dispatch CharSequence getContent(Affectation it)
	{
		if (left.target.linearAlgebra && !(left.iterators.empty && left.indices.empty))
			'''«left.codeName».setValue(«FOR i : left.iterators.map[name] + left.indices.map[content] SEPARATOR ', '»«i»«ENDFOR», «right.content»)'''
		else
			'''«left.content» = «right.content»'''
	}

	static def dispatch CharSequence getContent(ReductionInstruction it)
	{
		throw new RuntimeException("ReductionInstruction must have been replaced before using this code generator")
	}

	static def dispatch CharSequence getContent(Loop it)
	'''
		«IF iterationBlock instanceof Iterator»
			«val iter = iterationBlock as Iterator»
			«val c = iter.container»
			«IF !iter.container.connectivityCall.indexEqualId»
				«IF c instanceof ConnectivityCall»«getSetDefinitionContent(c.uniqueName, c as ConnectivityCall)»«ENDIF»
				«IF !c.connectivityCall.args.empty»«iter.getNbElems» = «c.uniqueName».size«ENDIF»
			«ENDIF»
			«IF c.connectivityCall.connectivity.name == "neighbourCells"»
				startIndex = np.count_nonzero(«c.uniqueName» == -1)
			«ELSE»
				startIndex = 0
			«ENDIF»
		«ELSE»
			startIndex = 0
		«ENDIF»
		for «iterationBlock.indexName» in range(startIndex, «iterationBlock.nbElems»):
			«body.innerContent»
	'''

	static def dispatch CharSequence getContent(If it)
	'''
		if «condition.content»:
			«thenInstruction.content»
		«IF (elseInstruction !== null)»
			else:
				«elseInstruction.content»
		«ENDIF»
	'''

	static def dispatch CharSequence getContent(ItemIndexDefinition it)
	'''
		«index.name» = «value.content»
	'''

	static def dispatch CharSequence getContent(ItemIdDefinition it)
	'''
		«id.name» = «value.content»
	'''

	static def dispatch CharSequence getContent(SetDefinition it)
	{
		getSetDefinitionContent(name, value)
	}

	static def dispatch CharSequence getContent(While it)
	'''
		while «condition.content»:
			«instruction.content»
	'''

	static def dispatch CharSequence getContent(Return it)
	'''
		return «expression.content»
	'''

	static def dispatch CharSequence getContent(Exit it)
	'''
		raise Exception("«message»");
	'''

	static def dispatch getInnerContent(Instruction it)
	{ 
		getContent
	}

	static def dispatch getInnerContent(InstructionBlock it)
	'''
		«FOR i : instructions»
			«i.content»
		«ENDFOR»
	'''

	private static def dispatch getIndexName(Iterator it) { index.name }
	private static def dispatch getIndexName(Interval it) { index.name }

	private static def dispatch getNbElems(Iterator it)
	{
		DaceGeneratorUtils.getNbElemsVar(container)
	}

	private static def dispatch getNbElems(Interval it)
	{
		getNbElems.content
	}

	private static def getSetDefinitionContent(String setName, ConnectivityCall call)
	'''
		«setName» = mesh.«call.accessor»
	'''
}
