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

import org.eclipse.xtend.lib.annotations.Accessors

abstract class Backend
{
	@Accessors(PUBLIC_GETTER, PROTECTED_SETTER) String name
	@Accessors(PUBLIC_GETTER, PROTECTED_SETTER) Ir2Cmake ir2Cmake
	@Accessors(PUBLIC_GETTER, PROTECTED_SETTER) TraceContentProvider traceContentProvider
	@Accessors(PUBLIC_GETTER, PROTECTED_SETTER) IncludesContentProvider includesContentProvider
	@Accessors(PUBLIC_GETTER, PROTECTED_SETTER) TypeContentProvider typeContentProvider
	@Accessors(PUBLIC_GETTER, PROTECTED_SETTER) ExpressionContentProvider expressionContentProvider
	@Accessors(PUBLIC_GETTER, PROTECTED_SETTER) ArgOrVarContentProvider argOrVarContentProvider
	@Accessors(PUBLIC_GETTER, PROTECTED_SETTER) AttributesContentProvider attributesContentProvider
	@Accessors(PUBLIC_GETTER, PROTECTED_SETTER) InstructionContentProvider instructionContentProvider
	@Accessors(PUBLIC_GETTER, PROTECTED_SETTER) FunctionContentProvider functionContentProvider
	@Accessors(PUBLIC_GETTER, PROTECTED_SETTER) JobContainerContentProvider jobContainerContentProvider
	@Accessors(PUBLIC_GETTER, PROTECTED_SETTER) JobContentProvider jobContentProvider
	@Accessors(PUBLIC_GETTER, PROTECTED_SETTER) PrivateMethodsContentProvider privateMethodsContentProvider
	@Accessors(PUBLIC_GETTER, PROTECTED_SETTER) MainContentProvider mainContentProvider
}

class SequentialBackend extends Backend
{
	new(String maxIterationVarName, String stopTimeVarName, String compiler, String compilerPath)
	{
		name = 'Sequential'
		ir2Cmake = new StlIr2Cmake(compiler, compilerPath)
		traceContentProvider = new TraceContentProvider(maxIterationVarName, stopTimeVarName)
		includesContentProvider = new IncludesContentProvider
		typeContentProvider = new StlTypeContentProvider
		argOrVarContentProvider = new StlArgOrVarContentProvider(typeContentProvider)
		expressionContentProvider = new ExpressionContentProvider(argOrVarContentProvider)
		attributesContentProvider = new AttributesContentProvider(argOrVarContentProvider)
		instructionContentProvider = new SequentialInstructionContentProvider(argOrVarContentProvider, expressionContentProvider)
		functionContentProvider = new FunctionContentProvider(typeContentProvider, instructionContentProvider)
		jobContainerContentProvider = new JobContainerContentProvider
		jobContentProvider = new JobContentProvider(traceContentProvider, expressionContentProvider, instructionContentProvider, jobContainerContentProvider)
		privateMethodsContentProvider = new PrivateMethodsContentProvider(jobContentProvider, functionContentProvider)
		mainContentProvider = new MainContentProvider
	}
}

class StlThreadBackend extends Backend
{
	new(String maxIterationVarName, String stopTimeVarName, String compiler, String compilerPath)
	{
		name = 'StlThread'
		ir2Cmake = new StlIr2Cmake(compiler, compilerPath)
		traceContentProvider = new TraceContentProvider(maxIterationVarName, stopTimeVarName)
		includesContentProvider = new StlThreadIncludesContentProvider
		typeContentProvider = new StlTypeContentProvider
		argOrVarContentProvider = new StlArgOrVarContentProvider(typeContentProvider)
		expressionContentProvider = new ExpressionContentProvider(argOrVarContentProvider)
		attributesContentProvider = new AttributesContentProvider(argOrVarContentProvider)
		instructionContentProvider = new StlThreadInstructionContentProvider(argOrVarContentProvider, expressionContentProvider)
		functionContentProvider = new FunctionContentProvider(typeContentProvider, instructionContentProvider)
		jobContainerContentProvider = new JobContainerContentProvider
		jobContentProvider = new JobContentProvider(traceContentProvider, expressionContentProvider, instructionContentProvider, jobContainerContentProvider)
		privateMethodsContentProvider = new PrivateMethodsContentProvider(jobContentProvider, functionContentProvider)
		mainContentProvider = new MainContentProvider
	}
}

class KokkosBackend extends Backend
{
	new(String maxIterationVarName, String stopTimeVarName, String compiler, String compilerPath)
	{
		name = 'Kokkos'
		ir2Cmake = new KokkosIr2Cmake(compiler, compilerPath)
		traceContentProvider = new KokkosTraceContentProvider(maxIterationVarName, stopTimeVarName)
		includesContentProvider = new KokkosIncludesContentProvider
		typeContentProvider = new KokkosTypeContentProvider
		argOrVarContentProvider = new KokkosArgOrVarContentProvider(typeContentProvider)
		expressionContentProvider = new ExpressionContentProvider(argOrVarContentProvider)
		attributesContentProvider = new AttributesContentProvider(argOrVarContentProvider)
		instructionContentProvider = new KokkosInstructionContentProvider(argOrVarContentProvider, expressionContentProvider)
		functionContentProvider = new KokkosFunctionContentProvider(typeContentProvider, instructionContentProvider)
		jobContainerContentProvider = new JobContainerContentProvider
		jobContentProvider = new KokkosJobContentProvider(traceContentProvider, expressionContentProvider, instructionContentProvider, jobContainerContentProvider)
		privateMethodsContentProvider = new PrivateMethodsContentProvider(jobContentProvider, functionContentProvider)
		mainContentProvider = new KokkosMainContentProvider
	}
}

class KokkosTeamThreadBackend extends Backend
{
	new(String maxIterationVarName, String stopTimeVarName, String compiler, String compilerPath)
	{
		name = 'Kokkos Team Thread'
		ir2Cmake = new KokkosIr2Cmake(compiler, compilerPath)
		traceContentProvider = new KokkosTraceContentProvider(maxIterationVarName, stopTimeVarName)
		includesContentProvider = new KokkosIncludesContentProvider
		typeContentProvider = new KokkosTypeContentProvider
		argOrVarContentProvider = new KokkosArgOrVarContentProvider(typeContentProvider)
		expressionContentProvider = new ExpressionContentProvider(argOrVarContentProvider)
		attributesContentProvider = new KokkosTeamThreadAttributesContentProvider(argOrVarContentProvider)
		instructionContentProvider = new KokkosTeamThreadInstructionContentProvider(argOrVarContentProvider, expressionContentProvider)
		functionContentProvider = new KokkosFunctionContentProvider(typeContentProvider, instructionContentProvider)
		jobContainerContentProvider = new KokkosTeamThreadJobContainerContentProvider
		jobContentProvider = new KokkosTeamThreadJobContentProvider(traceContentProvider, expressionContentProvider, instructionContentProvider, jobContainerContentProvider)
		privateMethodsContentProvider = new KokkosTeamThreadPrivateMethodsContentProvider(jobContentProvider, functionContentProvider)
		mainContentProvider = new KokkosMainContentProvider
	}
}

