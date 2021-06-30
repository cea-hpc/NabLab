/*******************************************************************************
 * Copyright (c) 2021 CEA
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
	@Accessors(PUBLIC_GETTER, PROTECTED_SETTER) InstructionContentProvider instructionContentProvider
	@Accessors(PUBLIC_GETTER, PROTECTED_SETTER) FunctionContentProvider functionContentProvider
	@Accessors(PUBLIC_GETTER, PROTECTED_SETTER) TraceContentProvider traceContentProvider
	@Accessors(PUBLIC_GETTER, PROTECTED_SETTER) IncludesContentProvider includesContentProvider
	@Accessors(PUBLIC_GETTER, PROTECTED_SETTER) JsonContentProvider jsonContentProvider
	@Accessors(PUBLIC_GETTER, PROTECTED_SETTER) JobCallerContentProvider jobCallerContentProvider
	@Accessors(PUBLIC_GETTER, PROTECTED_SETTER) JobContentProvider jobContentProvider
	@Accessors(PUBLIC_GETTER, PROTECTED_SETTER) MainContentProvider mainContentProvider
}

/** Expected variables: N_CXX_COMPILER */
class SequentialBackend extends Backend
{
	new()
	{
		name = 'Sequential'
		irTransformationStep = new ReplaceReductions(true)
		cmakeContentProvider = new CMakeContentProvider
		typeContentProvider = new StlThreadTypeContentProvider
		expressionContentProvider = new ExpressionContentProvider(typeContentProvider)
		instructionContentProvider = new SequentialInstructionContentProvider(typeContentProvider, expressionContentProvider)
		functionContentProvider = new FunctionContentProvider(typeContentProvider, expressionContentProvider, instructionContentProvider)
		traceContentProvider = new TraceContentProvider
		includesContentProvider = new IncludesContentProvider
		jsonContentProvider = new JsonContentProvider(expressionContentProvider)
		jobCallerContentProvider = new JobCallerContentProvider
		jobContentProvider = new StlThreadJobContentProvider(traceContentProvider, expressionContentProvider, instructionContentProvider, jobCallerContentProvider)
		mainContentProvider = new MainContentProvider(jsonContentProvider)
	}
}

/** Expected variables: N_CXX_COMPILER */
class StlThreadBackend extends Backend
{
	new()
	{
		name = 'StlThread'
		cmakeContentProvider = new StlThreadCMakeContentProvider
		typeContentProvider = new StlThreadTypeContentProvider
		expressionContentProvider = new ExpressionContentProvider(typeContentProvider)
		instructionContentProvider = new StlThreadInstructionContentProvider(typeContentProvider, expressionContentProvider)
		functionContentProvider = new FunctionContentProvider(typeContentProvider, expressionContentProvider, instructionContentProvider)
		traceContentProvider = new TraceContentProvider
		includesContentProvider = new StlThreadIncludesContentProvider
		jsonContentProvider = new JsonContentProvider(expressionContentProvider)
		jobCallerContentProvider = new JobCallerContentProvider
		jobContentProvider = new StlThreadJobContentProvider(traceContentProvider, expressionContentProvider, instructionContentProvider, jobCallerContentProvider)
		mainContentProvider = new MainContentProvider(jsonContentProvider)
	}
}

/** Expected variables: N_CXX_COMPILER, Kokkos_ROOT */
class KokkosBackend extends Backend
{
	new()
	{
		name = 'Kokkos'
		cmakeContentProvider = new KokkosCMakeContentProvider
		typeContentProvider = new KokkosTypeContentProvider
		expressionContentProvider = new ExpressionContentProvider(typeContentProvider)
		instructionContentProvider = new KokkosInstructionContentProvider(typeContentProvider, expressionContentProvider)
		functionContentProvider = new KokkosFunctionContentProvider(typeContentProvider, expressionContentProvider, instructionContentProvider)
		traceContentProvider = new KokkosTraceContentProvider
		includesContentProvider = new KokkosIncludesContentProvider
		jsonContentProvider = new JsonContentProvider(expressionContentProvider)
		jobCallerContentProvider = new JobCallerContentProvider
		jobContentProvider = new KokkosJobContentProvider(traceContentProvider, expressionContentProvider, instructionContentProvider, jobCallerContentProvider)
		mainContentProvider = new KokkosMainContentProvider(jsonContentProvider)
	}
}

/** Expected variables: N_CXX_COMPILER, Kokkos_ROOT */
class KokkosTeamThreadBackend extends Backend
{
	new()
	{
		name = 'Kokkos Team Thread'
		cmakeContentProvider = new KokkosCMakeContentProvider
		typeContentProvider = new KokkosTypeContentProvider
		expressionContentProvider = new ExpressionContentProvider(typeContentProvider)
		instructionContentProvider = new KokkosTeamThreadInstructionContentProvider(typeContentProvider, expressionContentProvider)
		functionContentProvider = new KokkosFunctionContentProvider(typeContentProvider, expressionContentProvider, instructionContentProvider)
		traceContentProvider = new KokkosTraceContentProvider
		includesContentProvider = new KokkosIncludesContentProvider
		jsonContentProvider = new JsonContentProvider(expressionContentProvider)
		jobCallerContentProvider = new KokkosTeamThreadJobCallerContentProvider
		jobContentProvider = new KokkosTeamThreadJobContentProvider(traceContentProvider, expressionContentProvider, instructionContentProvider, jobCallerContentProvider)
		mainContentProvider = new KokkosMainContentProvider(jsonContentProvider)
	}
}

/** Expected variables: N_CXX_COMPILER */
class OpenMpBackend extends Backend
{
	new()
	{
		name = 'OpenMP'
		cmakeContentProvider = new OpenMpCMakeContentProvider
		typeContentProvider = new StlThreadTypeContentProvider
		expressionContentProvider = new ExpressionContentProvider(typeContentProvider)
		instructionContentProvider = new OpenMpInstructionContentProvider(typeContentProvider, expressionContentProvider)
		functionContentProvider = new FunctionContentProvider(typeContentProvider, expressionContentProvider, instructionContentProvider)
		traceContentProvider = new TraceContentProvider
		includesContentProvider = new OpenMpIncludesContentProvider
		jsonContentProvider = new JsonContentProvider(expressionContentProvider)
		jobCallerContentProvider = new JobCallerContentProvider
		jobContentProvider = new StlThreadJobContentProvider(traceContentProvider, expressionContentProvider, instructionContentProvider, jobCallerContentProvider)
		mainContentProvider = new MainContentProvider(jsonContentProvider)
	}
}
