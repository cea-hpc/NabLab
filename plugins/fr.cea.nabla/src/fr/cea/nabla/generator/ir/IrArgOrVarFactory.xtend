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
import fr.cea.nabla.ir.ir.IrFactory
import fr.cea.nabla.ir.ir.PrimitiveType
import fr.cea.nabla.ir.ir.TimeLoopJob
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
import fr.cea.nabla.typing.NablaSimpleType
import java.util.ArrayList
import org.eclipse.xtext.EcoreUtil2

@Singleton
class IrArgOrVarFactory
{
	@Inject extension ArgOrVarExtensions
	@Inject extension TimeIteratorExtensions
	@Inject extension IrExpressionFactory
	@Inject extension IrJobFactory
	@Inject extension IrBasicFactory
	@Inject extension IrAnnotationHelper
	@Inject extension ArgOrVarTypeProvider
	@Inject extension LinearAlgebraUtils
	@Inject NablaType2IrType nablaType2IrType

	/**
	 * If v variable is referenced with time iterators, create the associated time variables.
	 * If v is referenced with a time iterator n, v_n and v_nplus1 are necessarily created.
	 * If the time iterator is an instance of InitTimeIterator (n=0) then v_n0 is also created.
	 * Note that, if there are several iterators, for example v^{n+1, k}, v_nplus1 and v_n are
	 * created even if there are not directly referenced (useful for variables copy at the end of loop).
	 * Of course, in this case, v_nplus_k and v_nplus1_kplus1 are also created.
	 */
	def Iterable<Variable> createIrVariables(Var v, Iterable<TimeLoopJob> tlJobs)
	{
		val createdVariables = new ArrayList<Variable>

		// Find all v references with time iterators
		val nablaModule = EcoreUtil2.getContainerOfType(v, NablaModule)
		val vRefsWithTimeIterators = nablaModule.eAllContents.filter(ArgOrVarRef).filter[target == v && !timeIterators.empty].toList

		// Is v a time variable ? 
		if (vRefsWithTimeIterators.empty)
			createdVariables += v.toIrVariable
		else
		{
			// Fill time loop variables for all iterators
			for (vRefsWithTimeIterator : vRefsWithTimeIterators)
			{
				for (tiRef : vRefsWithTimeIterator.timeIterators)
				{
					val ti = tiRef.target
					val parentTi = ti.parentTimeIterator

					// Create variables
					val currentTiVar = createIrTimeVariable(v, ti, currentTimeIteratorName)
					val nextTiVar = createIrTimeVariable(v, ti, nextTimeIteratorName)
					val initTiVar = (tiRef instanceof InitTimeIteratorRef ? createIrTimeVariable(v, ti, initTimeIteratorName) : null)

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
							tiSetUpJob.copies += toIrCopy(initTiVar, currentTiVar)
						else if (parentTi !== null) // inner time iterator
						{
							val parentCurrentTiVar = createIrTimeVariable(v, parentTi, currentTimeIteratorName)
							tiSetUpJob.copies += toIrCopy(parentCurrentTiVar, currentTiVar)
						}
					}

					// Variable copy for ExecuteTL job
					// x^{n+1, k} <---> x^{n+1, k+1}
					val tiExecuteJob = tlJobs.findFirst[name == ti.executeTimeLoopJobName]
					tiExecuteJob.copies += toIrCopy(nextTiVar, currentTiVar)

					// Variable copy for TearDownTL job
					// x^{n+1} = x^{n+1, k+1}
					val tiTearDownJob = tlJobs.findFirst[name == ti.tearDownTimeLoopJobName]
					if (tiTearDownJob !== null && parentTi !== null)
					{
						val parentNextTiVar = createIrTimeVariable(v, parentTi, nextTimeIteratorName)
						tiTearDownJob.copies += toIrCopy(nextTiVar, parentNextTiVar)
					}
				}
			}
		}
		return createdVariables
	}

	def toIrArgOrVar(ArgOrVar v, String timeSuffix)
	{
		val name = v.name + timeSuffix
		switch v
		{
			SimpleVar : toIrSimpleVariable(v, name)
			ConnectivityVar : toIrConnectivityVariable(v, name)
			Arg: toIrArg(v, name)
			TimeIterator: toIrIterationCounter(v)
		}
	}

	// fonctions générales retournent des Var
	def dispatch Variable toIrVariable(SimpleVar v) { toIrSimpleVariable(v, v.name) }
	def dispatch Variable toIrVariable(ConnectivityVar v) { toIrConnectivityVariable(v, v.name) }

	def create IrFactory::eINSTANCE.createArg toIrArg(BaseType nablaType, String nablaName)
	{
		annotations += nablaType.toIrAnnotation
		name = nablaName
		type = nablaType.toIrBaseType
	}

	def create IrFactory::eINSTANCE.createArg toIrArg(Arg v, String varName)
	{
		annotations += v.toIrAnnotation
		name = varName
		type = v.type.toIrBaseType
	}

	def create IrFactory::eINSTANCE.createSimpleVariable toIrSimpleVariable(SimpleVar v, String varName)
	{
		annotations += v.toIrAnnotation
		name = varName
		type = nablaType2IrType.toIrBaseType(v.typeFor as NablaSimpleType)
		const = v.const
		constExpr = v.constExpr
		option = false
		val value = v.value
		if (value !== null) defaultValue = value.toIrExpression
	}

	def create IrFactory::eINSTANCE.createConnectivityVariable toIrConnectivityVariable(ConnectivityVar v, String varName)
	{
		annotations += v.toIrAnnotation
		name = varName
		type = toIrConnectivityType(v.type, v.supports)
		linearAlgebra = false
	}

	def create IrFactory::eINSTANCE.createSimpleVariable toIrIterationCounter(TimeIterator t)
	{
		annotations += t.toIrAnnotation
		name = t.name
		type = IrFactory.eINSTANCE.createBaseType => [ primitive = PrimitiveType::INT ]
		const = false
		constExpr = false
		option = false
	}

	private def create IrFactory::eINSTANCE.createTimeLoopCopy toIrCopy(Variable from, Variable to)
	{
		source = from
		destination = to
	}

	private def createIrTimeVariable(Var v, TimeIterator ti, String timeIteratorSuffix)
	{
		val name = v.name + getIrVarTimeSuffix(ti, timeIteratorSuffix)
		return switch v
		{
			SimpleVar : toIrSimpleVariable(v, name) => [const = false]
			ConnectivityVar : toIrConnectivityVariable(v, name) => [linearAlgebra = v.linearAlgebra]
		}
	}
}