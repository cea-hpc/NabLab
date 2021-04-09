/*******************************************************************************
 * Copyright (c) 2020 CEA
 * This program and the accompanying materials are made available under the 
 * terms of the Eclipse Public License 2.0 which is available at
 * http://www.eclipse.org/legal/epl-2.0.
 *
 * SPDX-License-Identifier: EPL-2.0
 * Contributors: see AUTHORS file
 *******************************************************************************/
package fr.cea.nabla.generator.ir

import com.google.inject.Inject
import com.google.inject.Singleton
import fr.cea.nabla.ArgOrVarExtensions
import fr.cea.nabla.ir.ir.Instruction
import fr.cea.nabla.ir.ir.InstructionBlock
import fr.cea.nabla.ir.ir.IrFactory
import fr.cea.nabla.ir.ir.Job
import fr.cea.nabla.ir.ir.PrimitiveType
import fr.cea.nabla.ir.ir.Variable
import fr.cea.nabla.nabla.Arg
import fr.cea.nabla.nabla.ArgOrVar
import fr.cea.nabla.nabla.ArgOrVarRef
import fr.cea.nabla.nabla.BaseType
import fr.cea.nabla.nabla.ConnectivityVar
import fr.cea.nabla.nabla.InitTimeIteratorRef
import fr.cea.nabla.nabla.NablaModule
import fr.cea.nabla.nabla.SimpleVar
import fr.cea.nabla.nabla.TimeIterator
import fr.cea.nabla.nabla.Var
import fr.cea.nabla.typing.ArgOrVarTypeProvider
import fr.cea.nabla.typing.BaseTypeTypeProvider
import java.util.LinkedHashSet
import org.eclipse.emf.ecore.util.EcoreUtil
import org.eclipse.xtext.EcoreUtil2

@Singleton
class IrArgOrVarFactory
{
	@Inject extension ArgOrVarExtensions
	@Inject extension TimeIteratorExtensions
	@Inject extension IrExpressionFactory
	@Inject extension IrJobFactory
	@Inject extension IrAnnotationHelper
	@Inject extension ArgOrVarTypeProvider
	@Inject extension BaseTypeTypeProvider
	@Inject NablaType2IrType nablaType2IrType

	/**
	 * If v variable is referenced with time iterators, create the associated time variables.
	 * If v is referenced with a time iterator n, v_n and v_nplus1 are necessarily created.
	 * If the time iterator is an instance of InitTimeIterator (n=0) then v_n0 is also created.
	 * Note that, if there are several iterators, for example v^{n+1, k}, v_nplus1 and v_n are
	 * created even if there are not directly referenced (useful for variables copy at the end of loop).
	 * Of course, in this case, v_nplus_k and v_nplus1_kplus1 are also created.
	 */
	def Iterable<Variable> createIrVariables(Var v, Iterable<Job> tlJobs)
	{
		val createdVariables = new LinkedHashSet<Variable>

		// Find all v references with time iterators
		val nablaModule = EcoreUtil2.getContainerOfType(v, NablaModule)
		val vRefsWithTimeIterators = nablaModule.eAllContents.filter(ArgOrVarRef).filter[target == v && !timeIterators.empty].toList

		val vTimeIteratorsRef = vRefsWithTimeIterators.map[timeIterators].flatten
		val vTimeIterators = vTimeIteratorsRef.map[target].toSet

		// Is v a time variable ? 
		if (vRefsWithTimeIterators.empty)
			createdVariables += v.toIrVariable
		else
		{
			// Fill time loop variables for all iterators
			val boolean existsInitTi = existsInitTimeIteratorRef(vRefsWithTimeIterators)
			for (ti : vTimeIterators)
			{
				val boolean existsInitTiForTi = existsInitTimeIteratorRefForTimeIterator(vRefsWithTimeIterators, ti)
				val parentTi = ti.parentTimeIterator

				// Create variables
				val currentTiVar = createIrTimeVariable(v, ti, currentTimeIteratorName)
				val nextTiVar = createIrTimeVariable(v, ti, nextTimeIteratorName)
				val	initTiVar = (existsInitTiForTi? createIrTimeVariable(v, ti, initTimeIteratorName) : null)

				// Add variables to the list
				createdVariables += currentTiVar
				createdVariables += nextTiVar
				if (initTiVar !== null) createdVariables += initTiVar

				// Variable copy for SetUpTL job
				// if x^{n+1, k=0} exists, x^{n+1, k} = x^{n+1, k=0}
				// else x^{n+1, k} = x^{n}
				val tiSetUpJob = tlJobs.findFirst[name == ti.setUpTimeLoopJobName]
				if (tiSetUpJob !== null)
				{
					if (initTiVar !== null)
						addAffectation(tiSetUpJob, initTiVar, currentTiVar)
					else if (parentTi !== null && !existsInitTi) // inner time iterator
					{
						val parentCurrentTiVar = createIrTimeVariable(v, parentTi, currentTimeIteratorName)
						addAffectation(tiSetUpJob, parentCurrentTiVar, currentTiVar)
					}
				}

				// Variable copy for ExecuteTL job
				// x^{n+1, k} <---> x^{n+1, k+1}
				val tiExecuteJob = tlJobs.findFirst[name == ti.executeTimeLoopJobName]
				addAffectation(tiExecuteJob, nextTiVar, currentTiVar)

				// Variable copy for TearDownTL job
				// x^{n+1} = x^{n+1, k+1}
				val tiTearDownJob = tlJobs.findFirst[name == ti.tearDownTimeLoopJobName]
				if (tiTearDownJob !== null && parentTi !== null)
				{
					val parentNextTiVar = createIrTimeVariable(v, parentTi, nextTimeIteratorName)
					addAffectation(tiTearDownJob, nextTiVar, parentNextTiVar)
				}
			}
		}
		return createdVariables
	}

	private def addAffectation(Job tlj, Variable from, Variable to)
	{
		val affectation = createAffectation(from, to)

		if (tlj.instruction === null)
			tlj.instruction = affectation
		else if (tlj.instruction instanceof InstructionBlock)
			(tlj.instruction as InstructionBlock).instructions += affectation
		else if (tlj.instruction instanceof Instruction)
		{
			val prevAffectation = tlj.instruction
			tlj.instruction = IrFactory::eINSTANCE.createInstructionBlock =>
			[
				annotations += tlj.toIrAnnotation
				instructions+= prevAffectation
				instructions+= affectation
			]
		}
	}

	private def createAffectation(Variable from, Variable to)
	{
		val lhs = IrFactory::eINSTANCE.createArgOrVarRef =>
			[
				type = EcoreUtil::copy(to.type)
				target = to
			]
		val rhs = IrFactory::eINSTANCE.createArgOrVarRef =>
			[
				type = EcoreUtil::copy(from.type)
				target = from
			]
		IrFactory::eINSTANCE.createAffectation =>
		[
			left = lhs
			right = rhs
		]
	}

	def toIrArgOrVar(ArgOrVar v, String timeSuffix)
	{
		val name = v.name + timeSuffix
		switch v
		{
			SimpleVar : toIrVariable(v, name)
			ConnectivityVar : toIrVariable(v, name)
			Arg: toIrArg(v, name)
			TimeIterator: toIrIterationCounter(v)
		}
	}

	def dispatch Variable toIrVariable(SimpleVar v) { toIrVariable(v, v.name) }
	def dispatch Variable toIrVariable(ConnectivityVar v) { toIrVariable(v, v.name) }

	def create IrFactory::eINSTANCE.createArg toIrArg(BaseType nablaType, String nablaName)
	{
		annotations += nablaType.toIrAnnotation
		name = nablaName
		type = nablaType2IrType.toIrType(nablaType.typeFor)
	}

	def create IrFactory::eINSTANCE.createArg toIrArg(Arg v, String varName)
	{
		annotations += v.toIrAnnotation
		name = varName
		type = nablaType2IrType.toIrType(v.typeFor)
	}

	def create IrFactory::eINSTANCE.createVariable toIrVariable(SimpleVar v, String varName)
	{
		annotations += v.toIrAnnotation
		name = varName
		type = nablaType2IrType.toIrType(v.typeFor)
		const = v.const
		constExpr = v.constExpr
		option = false
		val value = v.value
		if (value !== null) defaultValue = value.toIrExpression
	}

	def create IrFactory::eINSTANCE.createVariable toIrVariable(ConnectivityVar v, String varName)
	{
		annotations += v.toIrAnnotation
		name = varName
		type = nablaType2IrType.toIrType(v.typeFor)
		const = false
		constExpr = false
		option = false
	}

	def create IrFactory::eINSTANCE.createVariable toIrIterationCounter(TimeIterator t)
	{
		annotations += t.toIrAnnotation
		name = t.name
		type = IrFactory.eINSTANCE.createBaseType => [ primitive = PrimitiveType::INT ]
		const = false
		constExpr = false
		option = false
	}

	private def createIrTimeVariable(Var v, TimeIterator ti, String timeIteratorSuffix)
	{
		val name = v.name + getIrVarTimeSuffix(ti, timeIteratorSuffix)
		return switch v
		{
			SimpleVar : toIrVariable(v, name) => [const = false]
			ConnectivityVar : toIrVariable(v, name)
		}
	}

	private def existsInitTimeIteratorRef(Iterable<ArgOrVarRef> l)
	{
		for (argOrVarRef : l)
			if (argOrVarRef.timeIterators.exists[x | x instanceof InitTimeIteratorRef])
				return true
		return false
	}

	private def existsInitTimeIteratorRefForTimeIterator(Iterable<ArgOrVarRef> l, TimeIterator ti)
	{
		for (argOrVarRef : l)
			if (argOrVarRef.timeIterators.exists[x | x instanceof InitTimeIteratorRef && x.target === ti])
				return true
		return false
	}
}