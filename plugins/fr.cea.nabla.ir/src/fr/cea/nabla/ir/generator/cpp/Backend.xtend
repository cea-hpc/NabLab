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
	@Accessors(PUBLIC_GETTER, PROTECTED_SETTER) Ir2Cmake ir2Cmake
	@Accessors(PUBLIC_GETTER, PROTECTED_SETTER) TraceContentProvider traceContentProvider
	@Accessors(PUBLIC_GETTER, PROTECTED_SETTER) IncludesContentProvider includesContentProvider
	@Accessors(PUBLIC_GETTER, PROTECTED_SETTER) TypeContentProvider typeContentProvider
	@Accessors(PUBLIC_GETTER, PROTECTED_SETTER) ExpressionContentProvider expressionContentProvider
	@Accessors(PUBLIC_GETTER, PROTECTED_SETTER) JsonContentProvider jsonContentProvider
	@Accessors(PUBLIC_GETTER, PROTECTED_SETTER) ArgOrVarContentProvider argOrVarContentProvider
	@Accessors(PUBLIC_GETTER, PROTECTED_SETTER) InstructionContentProvider instructionContentProvider
	@Accessors(PUBLIC_GETTER, PROTECTED_SETTER) FunctionContentProvider functionContentProvider
	@Accessors(PUBLIC_GETTER, PROTECTED_SETTER) JobCallerContentProvider jobCallerContentProvider
	@Accessors(PUBLIC_GETTER, PROTECTED_SETTER) JobContentProvider jobContentProvider
	@Accessors(PUBLIC_GETTER, PROTECTED_SETTER) MainContentProvider mainContentProvider
}

class SequentialBackend extends Backend
{
	new(String maxIterationVarName, String stopTimeVarName, String compiler, String compilerPath, String levelDBPath)
	{
		name = 'Sequential'
		irTransformationStep = new ReplaceReductions(true)
		ir2Cmake = new SequentialIr2Cmake(compiler, compilerPath, levelDBPath)
		traceContentProvider = new TraceContentProvider(maxIterationVarName, stopTimeVarName)
		includesContentProvider = new SequentialIncludesContentProvider(levelDBPath)
		typeContentProvider = new StlTypeContentProvider
		argOrVarContentProvider = new StlArgOrVarContentProvider(typeContentProvider)
		expressionContentProvider = new ExpressionContentProvider(argOrVarContentProvider)
		jsonContentProvider = new JsonContentProvider(expressionContentProvider)
		instructionContentProvider = new SequentialInstructionContentProvider(argOrVarContentProvider, expressionContentProvider)
		functionContentProvider = new FunctionContentProvider(typeContentProvider, instructionContentProvider)
		jobCallerContentProvider = new JobCallerContentProvider
		jobContentProvider = new JobContentProvider(traceContentProvider, expressionContentProvider, instructionContentProvider, getJobCallerContentProvider)
		mainContentProvider = new MainContentProvider(levelDBPath, jsonContentProvider)
	}
}

class StlThreadBackend extends Backend
{
	new(String maxIterationVarName, String stopTimeVarName, String compiler, String compilerPath, String levelDBPath)
	{
		name = 'StlThread'
		ir2Cmake = new StlIr2Cmake(compiler, compilerPath, levelDBPath)
		traceContentProvider = new TraceContentProvider(maxIterationVarName, stopTimeVarName)
		includesContentProvider = new StlThreadIncludesContentProvider(levelDBPath)
		typeContentProvider = new StlTypeContentProvider
		argOrVarContentProvider = new StlArgOrVarContentProvider(typeContentProvider)
		expressionContentProvider = new ExpressionContentProvider(argOrVarContentProvider)
		jsonContentProvider = new JsonContentProvider(expressionContentProvider)
		instructionContentProvider = new StlThreadInstructionContentProvider(argOrVarContentProvider, expressionContentProvider)
		functionContentProvider = new FunctionContentProvider(typeContentProvider, instructionContentProvider)
		jobCallerContentProvider = new JobCallerContentProvider
		jobContentProvider = new JobContentProvider(traceContentProvider, expressionContentProvider, instructionContentProvider, getJobCallerContentProvider)
		mainContentProvider = new MainContentProvider(levelDBPath, jsonContentProvider)
	}
}

class KokkosBackend extends Backend
{
	new(String maxIterationVarName, String stopTimeVarName, String compiler, String compilerPath, String kokkosPath, String levelDBPath)
	{
		name = 'Kokkos'
		ir2Cmake = new KokkosIr2Cmake(compiler, compilerPath, kokkosPath, levelDBPath)
		traceContentProvider = new KokkosTraceContentProvider(maxIterationVarName, stopTimeVarName)
		includesContentProvider = new KokkosIncludesContentProvider(levelDBPath)
		typeContentProvider = new KokkosTypeContentProvider
		argOrVarContentProvider = new KokkosArgOrVarContentProvider(typeContentProvider)
		expressionContentProvider = new ExpressionContentProvider(argOrVarContentProvider)
		jsonContentProvider = new JsonContentProvider(expressionContentProvider)
		instructionContentProvider = new KokkosInstructionContentProvider(argOrVarContentProvider, expressionContentProvider)
		functionContentProvider = new KokkosFunctionContentProvider(typeContentProvider, instructionContentProvider)
		jobCallerContentProvider = new JobCallerContentProvider
		jobContentProvider = new KokkosJobContentProvider(traceContentProvider, expressionContentProvider, instructionContentProvider, getJobCallerContentProvider)
		mainContentProvider = new KokkosMainContentProvider(levelDBPath, jsonContentProvider)
	}
}

class KokkosTeamThreadBackend extends Backend
{
	new(String maxIterationVarName, String stopTimeVarName, String compiler, String compilerPath, String kokkosPath, String levelDBPath)
	{
		name = 'Kokkos Team Thread'
		ir2Cmake = new KokkosIr2Cmake(compiler, compilerPath, kokkosPath, levelDBPath)
		traceContentProvider = new KokkosTraceContentProvider(maxIterationVarName, stopTimeVarName)
		includesContentProvider = new KokkosIncludesContentProvider(levelDBPath)
		typeContentProvider = new KokkosTypeContentProvider
		argOrVarContentProvider = new KokkosArgOrVarContentProvider(typeContentProvider)
		expressionContentProvider = new ExpressionContentProvider(argOrVarContentProvider)
		jsonContentProvider = new JsonContentProvider(expressionContentProvider)
		instructionContentProvider = new KokkosTeamThreadInstructionContentProvider(argOrVarContentProvider, expressionContentProvider)
		functionContentProvider = new KokkosFunctionContentProvider(typeContentProvider, instructionContentProvider)
		jobCallerContentProvider = new KokkosTeamThreadJobCallerContentProvider
		jobContentProvider = new KokkosTeamThreadJobContentProvider(traceContentProvider, expressionContentProvider, instructionContentProvider, getJobCallerContentProvider)
		mainContentProvider = new KokkosMainContentProvider(levelDBPath, jsonContentProvider)
	}
}

class OpenMpBackend extends Backend
{
	new(String maxIterationVarName, String stopTimeVarName, String compiler, String compilerPath, String levelDBPath)
	{
		name = 'OpenMP'
		ir2Cmake = new OpenMpCmake(compiler, compilerPath, levelDBPath)
		traceContentProvider = new TraceContentProvider(maxIterationVarName, stopTimeVarName)
		includesContentProvider = new OpenMpIncludesContentProvider(levelDBPath)
		typeContentProvider = new StlTypeContentProvider
		argOrVarContentProvider = new StlArgOrVarContentProvider(typeContentProvider)
		expressionContentProvider = new ExpressionContentProvider(argOrVarContentProvider)
		jsonContentProvider = new JsonContentProvider(expressionContentProvider)
		instructionContentProvider = new OpenMpInstructionContentProvider(argOrVarContentProvider, expressionContentProvider)
		functionContentProvider = new FunctionContentProvider(typeContentProvider, instructionContentProvider)
		jobCallerContentProvider = new JobCallerContentProvider
		jobContentProvider = new JobContentProvider(traceContentProvider, expressionContentProvider, instructionContentProvider, getJobCallerContentProvider)
		mainContentProvider = new MainContentProvider(levelDBPath, jsonContentProvider)
	}
}

