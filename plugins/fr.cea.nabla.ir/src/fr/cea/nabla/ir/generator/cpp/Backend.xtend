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
		attributesContentProvider = new AttributesContentProvider(argOrVarContentProvider, expressionContentProvider)
		instructionContentProvider = new SequentialInstructionContentProvider(argOrVarContentProvider, expressionContentProvider)
		functionContentProvider = new FunctionContentProvider(typeContentProvider, instructionContentProvider)
		jobContainerContentProvider = new JobContainerContentProvider
		jobContentProvider = new JobContentProvider(traceContentProvider, expressionContentProvider, instructionContentProvider, jobContainerContentProvider)
		privateMethodsContentProvider = new PrivateMethodsContentProvider(jobContentProvider)
		mainContentProvider = new MainContentProvider(levelDBPath)
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
		attributesContentProvider = new AttributesContentProvider(argOrVarContentProvider, expressionContentProvider)
		instructionContentProvider = new StlThreadInstructionContentProvider(argOrVarContentProvider, expressionContentProvider)
		functionContentProvider = new FunctionContentProvider(typeContentProvider, instructionContentProvider)
		jobContainerContentProvider = new JobContainerContentProvider
		jobContentProvider = new JobContentProvider(traceContentProvider, expressionContentProvider, instructionContentProvider, jobContainerContentProvider)
		privateMethodsContentProvider = new PrivateMethodsContentProvider(jobContentProvider)
		mainContentProvider = new MainContentProvider(levelDBPath)
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
		attributesContentProvider = new AttributesContentProvider(argOrVarContentProvider, expressionContentProvider)
		instructionContentProvider = new KokkosInstructionContentProvider(argOrVarContentProvider, expressionContentProvider)
		functionContentProvider = new KokkosFunctionContentProvider(typeContentProvider, instructionContentProvider)
		jobContainerContentProvider = new JobContainerContentProvider
		jobContentProvider = new KokkosJobContentProvider(traceContentProvider, expressionContentProvider, instructionContentProvider, jobContainerContentProvider)
		privateMethodsContentProvider = new PrivateMethodsContentProvider(jobContentProvider)
		mainContentProvider = new KokkosMainContentProvider(levelDBPath)
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
		attributesContentProvider = new KokkosTeamThreadAttributesContentProvider(argOrVarContentProvider, expressionContentProvider)
		instructionContentProvider = new KokkosTeamThreadInstructionContentProvider(argOrVarContentProvider, expressionContentProvider)
		functionContentProvider = new KokkosFunctionContentProvider(typeContentProvider, instructionContentProvider)
		jobContainerContentProvider = new KokkosTeamThreadJobContainerContentProvider
		jobContentProvider = new KokkosTeamThreadJobContentProvider(traceContentProvider, expressionContentProvider, instructionContentProvider, jobContainerContentProvider)
		privateMethodsContentProvider = new KokkosTeamThreadPrivateMethodsContentProvider(jobContentProvider)
		mainContentProvider = new KokkosMainContentProvider(levelDBPath)
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
		attributesContentProvider = new AttributesContentProvider(argOrVarContentProvider, expressionContentProvider)
		instructionContentProvider = new OpenMpInstructionContentProvider(argOrVarContentProvider, expressionContentProvider)
		functionContentProvider = new FunctionContentProvider(typeContentProvider, instructionContentProvider)
		jobContainerContentProvider = new JobContainerContentProvider
		jobContentProvider = new JobContentProvider(traceContentProvider, expressionContentProvider, instructionContentProvider, jobContainerContentProvider)
		privateMethodsContentProvider = new PrivateMethodsContentProvider(jobContentProvider)
		mainContentProvider = new MainContentProvider(levelDBPath)
	}
}

class SyclBackend extends Backend
{
	new(String maxIterationVarName, String stopTimeVarName, String compiler, String compilerPath, String syclPath, String levelDBPath)
	{
		name = 'SYCL'
		ir2Cmake = new SyclIr2Cmake(compiler, compilerPath, syclPath, levelDBPath)
		traceContentProvider = new TraceContentProvider(maxIterationVarName, stopTimeVarName)
		includesContentProvider = new SyclIncludesContentProvider(levelDBPath)
		typeContentProvider = new StlTypeContentProvider  // TODO(FL): Change to its own type provider when/if needed
		argOrVarContentProvider = new StlArgOrVarContentProvider(typeContentProvider)  // TODO(FL): Change to its own type provider when/if needed
		expressionContentProvider = new ExpressionContentProvider(argOrVarContentProvider)
		jsonContentProvider = new JsonContentProvider(expressionContentProvider)
		attributesContentProvider = new AttributesContentProvider(argOrVarContentProvider, expressionContentProvider)
		instructionContentProvider = new StlThreadInstructionContentProvider(argOrVarContentProvider, expressionContentProvider)  // TODO(FL): Change to its own type provider when/if needed
		functionContentProvider = new FunctionContentProvider(typeContentProvider, instructionContentProvider)  // TODO(FL): Change to its own type provider when/if needed
		jobContainerContentProvider = new JobContainerContentProvider
		jobContentProvider = new JobContentProvider(traceContentProvider, expressionContentProvider, instructionContentProvider, jobContainerContentProvider)  // TODO(FL): Change to its own type provider when/if needed
		privateMethodsContentProvider = new PrivateMethodsContentProvider(jobContentProvider)
		mainContentProvider = new MainContentProvider(levelDBPath)  // TODO(FL): Change to its own type provider when/if needed
	}
}
