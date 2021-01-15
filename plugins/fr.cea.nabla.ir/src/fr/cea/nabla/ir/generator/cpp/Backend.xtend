/*******************************************************************************
 * Copyright (c) 2020 CEA
 * This program and the accompanying materials are made available under the 
 * terms of the Eclipse Public License 2.0 which is available at
 * http://www.eclipse.org/legal/epl-2.0.
 *
 * SPDX-License-Identifier: EPL-2.0
 * Contributors: see AUTHORS file
 *******************************************************************************/
package fr.cea.nabla.ir.generator.cpp

import fr.cea.nabla.ir.transformers.IrTransformationStep
import fr.cea.nabla.ir.transformers.ReplaceReductions
import org.eclipse.xtend.lib.annotations.Accessors

abstract class Backend
{
	@Accessors(PUBLIC_GETTER, PROTECTED_SETTER) String name
	@Accessors(PUBLIC_GETTER, PROTECTED_SETTER) IrTransformationStep irTransformationStep = null
	@Accessors(PUBLIC_GETTER, PROTECTED_SETTER) CMakeContentProvider cmakeContentProvider
	@Accessors(PUBLIC_GETTER, PROTECTED_SETTER) TypeContentProvider typeContentProvider
	@Accessors(PUBLIC_GETTER, PROTECTED_SETTER) ExpressionContentProvider expressionContentProvider
	@Accessors(PUBLIC_GETTER, PROTECTED_SETTER) ArgOrVarContentProvider argOrVarContentProvider
	@Accessors(PUBLIC_GETTER, PROTECTED_SETTER) InstructionContentProvider instructionContentProvider
	@Accessors(PUBLIC_GETTER, PROTECTED_SETTER) FunctionContentProvider functionContentProvider
	@Accessors(PUBLIC_GETTER, PROTECTED_SETTER) TraceContentProvider traceContentProvider
	@Accessors(PUBLIC_GETTER, PROTECTED_SETTER) IncludesContentProvider includesContentProvider
	@Accessors(PUBLIC_GETTER, PROTECTED_SETTER) JsonContentProvider jsonContentProvider
	@Accessors(PUBLIC_GETTER, PROTECTED_SETTER) JobCallerContentProvider jobCallerContentProvider
	@Accessors(PUBLIC_GETTER, PROTECTED_SETTER) JobContentProvider jobContentProvider
	@Accessors(PUBLIC_GETTER, PROTECTED_SETTER) MainContentProvider mainContentProvider
}

/** Expected variables: NABLA_CXX_COMPILER */
class SequentialBackend extends Backend
{
	new()
	{
		name = 'Sequential'
		irTransformationStep = new ReplaceReductions(true)
		cmakeContentProvider = new SequentialCMakeContentProvider
		typeContentProvider = new StlTypeContentProvider
		argOrVarContentProvider = new StlArgOrVarContentProvider(typeContentProvider)
		expressionContentProvider = new ExpressionContentProvider(argOrVarContentProvider)
		instructionContentProvider = new SequentialInstructionContentProvider(argOrVarContentProvider, expressionContentProvider)
		functionContentProvider = new FunctionContentProvider(typeContentProvider, instructionContentProvider)
		traceContentProvider = new TraceContentProvider
		includesContentProvider = new SequentialIncludesContentProvider
		jsonContentProvider = new JsonContentProvider(expressionContentProvider)
		jobCallerContentProvider = new JobCallerContentProvider
		jobContentProvider = new JobContentProvider(traceContentProvider, expressionContentProvider, instructionContentProvider, jobCallerContentProvider)
		mainContentProvider = new MainContentProvider(jsonContentProvider)
	}
}

/** Expected variables: NABLA_CXX_COMPILER */
class StlThreadBackend extends Backend
{
	new()
	{
		name = 'StlThread'
		cmakeContentProvider = new StlCMakeContentProvider
		typeContentProvider = new StlTypeContentProvider
		argOrVarContentProvider = new StlArgOrVarContentProvider(typeContentProvider)
		expressionContentProvider = new ExpressionContentProvider(argOrVarContentProvider)
		instructionContentProvider = new StlThreadInstructionContentProvider(argOrVarContentProvider, expressionContentProvider)
		functionContentProvider = new FunctionContentProvider(typeContentProvider, instructionContentProvider)
		traceContentProvider = new TraceContentProvider
		includesContentProvider = new StlThreadIncludesContentProvider
		jsonContentProvider = new JsonContentProvider(expressionContentProvider)
		jobCallerContentProvider = new JobCallerContentProvider
		jobContentProvider = new JobContentProvider(traceContentProvider, expressionContentProvider, instructionContentProvider, jobCallerContentProvider)
		mainContentProvider = new MainContentProvider(jsonContentProvider)
	}
}

/** Expected variables: NABLA_CXX_COMPILER, NABLA_KOKKOS_PATH */
class KokkosBackend extends Backend
{
	new()
	{
		name = 'Kokkos'
		cmakeContentProvider = new KokkosCMakeContentProvider
		typeContentProvider = new KokkosTypeContentProvider
		argOrVarContentProvider = new KokkosArgOrVarContentProvider(typeContentProvider)
		expressionContentProvider = new ExpressionContentProvider(argOrVarContentProvider)
		instructionContentProvider = new KokkosInstructionContentProvider(argOrVarContentProvider, expressionContentProvider)
		functionContentProvider = new KokkosFunctionContentProvider(typeContentProvider, instructionContentProvider)
		traceContentProvider = new KokkosTraceContentProvider
		includesContentProvider = new KokkosIncludesContentProvider
		jsonContentProvider = new JsonContentProvider(expressionContentProvider)
		jobCallerContentProvider = new JobCallerContentProvider
		jobContentProvider = new KokkosJobContentProvider(traceContentProvider, expressionContentProvider, instructionContentProvider, jobCallerContentProvider)
		mainContentProvider = new KokkosMainContentProvider(jsonContentProvider)
	}
}

/** Expected variables: NABLA_CXX_COMPILER, NABLA_KOKKOS_PATH */
class KokkosTeamThreadBackend extends Backend
{
	new()
	{
		name = 'Kokkos Team Thread'
		cmakeContentProvider = new KokkosCMakeContentProvider
		typeContentProvider = new KokkosTypeContentProvider
		argOrVarContentProvider = new KokkosArgOrVarContentProvider(typeContentProvider)
		expressionContentProvider = new ExpressionContentProvider(argOrVarContentProvider)
		instructionContentProvider = new KokkosTeamThreadInstructionContentProvider(argOrVarContentProvider, expressionContentProvider)
		functionContentProvider = new KokkosFunctionContentProvider(typeContentProvider, instructionContentProvider)
		traceContentProvider = new KokkosTraceContentProvider
		includesContentProvider = new KokkosIncludesContentProvider
		jsonContentProvider = new JsonContentProvider(expressionContentProvider)
		jobCallerContentProvider = new KokkosTeamThreadJobCallerContentProvider
		jobContentProvider = new KokkosTeamThreadJobContentProvider(traceContentProvider, expressionContentProvider, instructionContentProvider, jobCallerContentProvider)
		mainContentProvider = new KokkosMainContentProvider(jsonContentProvider)
	}
}

/** Expected variables: NABLA_CXX_COMPILER */
class OpenMpBackend extends Backend
{
	new()
	{
		name = 'OpenMP'
		cmakeContentProvider = new OpenMpCMakeContentProvider
		typeContentProvider = new StlTypeContentProvider
		argOrVarContentProvider = new StlArgOrVarContentProvider(typeContentProvider)
		expressionContentProvider = new ExpressionContentProvider(argOrVarContentProvider)
		instructionContentProvider = new OpenMpInstructionContentProvider(argOrVarContentProvider, expressionContentProvider)
		functionContentProvider = new FunctionContentProvider(typeContentProvider, instructionContentProvider)
		traceContentProvider = new TraceContentProvider
		includesContentProvider = new OpenMpIncludesContentProvider
		jsonContentProvider = new JsonContentProvider(expressionContentProvider)
		jobCallerContentProvider = new JobCallerContentProvider
		jobContentProvider = new JobContentProvider(traceContentProvider, expressionContentProvider, instructionContentProvider, jobCallerContentProvider)
		mainContentProvider = new MainContentProvider(jsonContentProvider)
	}
}
