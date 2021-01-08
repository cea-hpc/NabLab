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
import java.util.HashMap
import org.eclipse.xtend.lib.annotations.Accessors

class LightBackend
{
	@Accessors(PUBLIC_GETTER, PROTECTED_SETTER) String name
	@Accessors(PUBLIC_GETTER, PROTECTED_SETTER) TypeContentProvider typeContentProvider
	@Accessors(PUBLIC_GETTER, PROTECTED_SETTER) ExpressionContentProvider expressionContentProvider
	@Accessors(PUBLIC_GETTER, PROTECTED_SETTER) ArgOrVarContentProvider argOrVarContentProvider
	@Accessors(PUBLIC_GETTER, PROTECTED_SETTER) InstructionContentProvider instructionContentProvider
	@Accessors(PUBLIC_GETTER, PROTECTED_SETTER) FunctionContentProvider functionContentProvider
}

class Backend extends LightBackend
{
	@Accessors(PUBLIC_GETTER, PROTECTED_SETTER) Ir2Cmake ir2Cmake
	@Accessors(PUBLIC_GETTER, PROTECTED_SETTER) IrTransformationStep irTransformationStep = null
	@Accessors(PUBLIC_GETTER, PROTECTED_SETTER) TraceContentProvider traceContentProvider
	@Accessors(PUBLIC_GETTER, PROTECTED_SETTER) IncludesContentProvider includesContentProvider
	@Accessors(PUBLIC_GETTER, PROTECTED_SETTER) JsonContentProvider jsonContentProvider
	@Accessors(PUBLIC_GETTER, PROTECTED_SETTER) JobCallerContentProvider jobCallerContentProvider
	@Accessors(PUBLIC_GETTER, PROTECTED_SETTER) JobContentProvider jobContentProvider
	@Accessors(PUBLIC_GETTER, PROTECTED_SETTER) MainContentProvider mainContentProvider
}

abstract class BackendFactory
{
	def LightBackend create()
	{
		val backend = new LightBackend()
		initLight(backend)
		return backend
	}

	def Backend create(String maxIterationVarName, String stopTimeVarName, String levelDBPath, HashMap<String, String> variables)
	{
		val backend = new Backend()
		initLight(backend)
		init(backend, maxIterationVarName, stopTimeVarName, levelDBPath, variables)
		return backend
	}

	abstract def void initLight(LightBackend it)
	abstract def void init(Backend it, String maxIterationVarName, String stopTimeVarName, String levelDBPath, HashMap<String, String> variables)
}

class SequentialBackendFactory extends BackendFactory
{
	public static val NAME = 'Sequential'

	override initLight(LightBackend it)
	{
		name = NAME
		typeContentProvider = new StlTypeContentProvider
		argOrVarContentProvider = new StlArgOrVarContentProvider(typeContentProvider)
		expressionContentProvider = new ExpressionContentProvider(argOrVarContentProvider)
		instructionContentProvider = new SequentialInstructionContentProvider(argOrVarContentProvider, expressionContentProvider)
		functionContentProvider = new FunctionContentProvider(typeContentProvider, instructionContentProvider)
	}

	/** Expected variables: NABLA_CXX_COMPILER */
	override init(Backend it, String maxIterationVarName, String stopTimeVarName, String levelDBPath, HashMap<String, String> variables)
	{
		irTransformationStep = new ReplaceReductions(true)
		ir2Cmake = new SequentialIr2Cmake(levelDBPath, variables)
		traceContentProvider = new TraceContentProvider(maxIterationVarName, stopTimeVarName)
		includesContentProvider = new SequentialIncludesContentProvider(levelDBPath)
		jsonContentProvider = new JsonContentProvider(expressionContentProvider)
		jobCallerContentProvider = new JobCallerContentProvider
		jobContentProvider = new JobContentProvider(traceContentProvider, expressionContentProvider, instructionContentProvider, getJobCallerContentProvider)
		mainContentProvider = new MainContentProvider(levelDBPath, jsonContentProvider)
	}
}

class StlThreadBackendFactory extends BackendFactory
{
	public static val NAME = 'StlThread'

	override initLight(LightBackend it)
	{
		name = NAME
		typeContentProvider = new StlTypeContentProvider
		argOrVarContentProvider = new StlArgOrVarContentProvider(typeContentProvider)
		expressionContentProvider = new ExpressionContentProvider(argOrVarContentProvider)
		instructionContentProvider = new StlThreadInstructionContentProvider(argOrVarContentProvider, expressionContentProvider)
		functionContentProvider = new FunctionContentProvider(typeContentProvider, instructionContentProvider)
	}

	/** Expected variables: NABLA_CXX_COMPILER */
	override init(Backend it, String maxIterationVarName, String stopTimeVarName, String levelDBPath, HashMap<String, String> variables)
	{
		ir2Cmake = new StlIr2Cmake(levelDBPath, variables)
		traceContentProvider = new TraceContentProvider(maxIterationVarName, stopTimeVarName)
		includesContentProvider = new StlThreadIncludesContentProvider(levelDBPath)
		jsonContentProvider = new JsonContentProvider(expressionContentProvider)
		jobCallerContentProvider = new JobCallerContentProvider
		jobContentProvider = new JobContentProvider(traceContentProvider, expressionContentProvider, instructionContentProvider, getJobCallerContentProvider)
		mainContentProvider = new MainContentProvider(levelDBPath, jsonContentProvider)
	}
}

class KokkosBackendFactory extends BackendFactory
{
	public static val NAME = 'Kokkos'

	override initLight(LightBackend it)
	{
		name = NAME
		typeContentProvider = new KokkosTypeContentProvider
		argOrVarContentProvider = new KokkosArgOrVarContentProvider(typeContentProvider)
		expressionContentProvider = new ExpressionContentProvider(argOrVarContentProvider)
		instructionContentProvider = new KokkosInstructionContentProvider(argOrVarContentProvider, expressionContentProvider)
		functionContentProvider = new KokkosFunctionContentProvider(typeContentProvider, instructionContentProvider)
	}

	/** Expected variables: NABLA_CXX_COMPILER, NABLA_KOKKOS_PATH */
	override init(Backend it, String maxIterationVarName, String stopTimeVarName, String levelDBPath, HashMap<String, String> variables)
	{
		ir2Cmake = new KokkosIr2Cmake(levelDBPath, variables)
		traceContentProvider = new KokkosTraceContentProvider(maxIterationVarName, stopTimeVarName)
		includesContentProvider = new KokkosIncludesContentProvider(levelDBPath)
		jsonContentProvider = new JsonContentProvider(expressionContentProvider)
		jobCallerContentProvider = new JobCallerContentProvider
		jobContentProvider = new KokkosJobContentProvider(traceContentProvider, expressionContentProvider, instructionContentProvider, getJobCallerContentProvider)
		mainContentProvider = new KokkosMainContentProvider(levelDBPath, jsonContentProvider)
	}
}

class KokkosTeamThreadBackendFactory extends BackendFactory
{
	public static val NAME = 'Kokkos Team Thread'

	override initLight(LightBackend it)
	{
		name = NAME
		typeContentProvider = new KokkosTypeContentProvider
		argOrVarContentProvider = new KokkosArgOrVarContentProvider(typeContentProvider)
		expressionContentProvider = new ExpressionContentProvider(argOrVarContentProvider)
		instructionContentProvider = new KokkosTeamThreadInstructionContentProvider(argOrVarContentProvider, expressionContentProvider)
		functionContentProvider = new KokkosFunctionContentProvider(typeContentProvider, instructionContentProvider)
	}

	/** Expected variables: NABLA_CXX_COMPILER, NABLA_KOKKOS_PATH */
	override init(Backend it, String maxIterationVarName, String stopTimeVarName, String levelDBPath, HashMap<String, String> variables)
	{
		ir2Cmake = new KokkosIr2Cmake(levelDBPath, variables)
		traceContentProvider = new KokkosTraceContentProvider(maxIterationVarName, stopTimeVarName)
		includesContentProvider = new KokkosIncludesContentProvider(levelDBPath)
		jsonContentProvider = new JsonContentProvider(expressionContentProvider)
		jobCallerContentProvider = new KokkosTeamThreadJobCallerContentProvider
		jobContentProvider = new KokkosTeamThreadJobContentProvider(traceContentProvider, expressionContentProvider, instructionContentProvider, getJobCallerContentProvider)
		mainContentProvider = new KokkosMainContentProvider(levelDBPath, jsonContentProvider)
	}
}

class OpenMpBackendFactory extends BackendFactory
{
	public static val NAME = 'OpenMP'

	override initLight(LightBackend it)
	{
		name = NAME
		typeContentProvider = new StlTypeContentProvider
		argOrVarContentProvider = new StlArgOrVarContentProvider(typeContentProvider)
		expressionContentProvider = new ExpressionContentProvider(argOrVarContentProvider)
		instructionContentProvider = new OpenMpInstructionContentProvider(argOrVarContentProvider, expressionContentProvider)
		functionContentProvider = new FunctionContentProvider(typeContentProvider, instructionContentProvider)
	}

	/** Expected variables: NABLA_CXX_COMPILER */
	override init(Backend it, String maxIterationVarName, String stopTimeVarName, String levelDBPath, HashMap<String, String> variables)
	{
		ir2Cmake = new OpenMpCmake(levelDBPath, variables)
		traceContentProvider = new TraceContentProvider(maxIterationVarName, stopTimeVarName)
		includesContentProvider = new OpenMpIncludesContentProvider(levelDBPath)
		jsonContentProvider = new JsonContentProvider(expressionContentProvider)
		jobCallerContentProvider = new JobCallerContentProvider
		jobContentProvider = new JobContentProvider(traceContentProvider, expressionContentProvider, instructionContentProvider, getJobCallerContentProvider)
		mainContentProvider = new MainContentProvider(levelDBPath, jsonContentProvider)
	}
}
