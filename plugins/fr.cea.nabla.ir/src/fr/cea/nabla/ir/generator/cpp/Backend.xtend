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

import fr.cea.nabla.ir.generator.jni.Jniable
import fr.cea.nabla.ir.ir.ExtensionProvider
import fr.cea.nabla.ir.ir.ExternFunction
import fr.cea.nabla.ir.transformers.CompositeTransformationStep
import fr.cea.nabla.ir.transformers.GpuDispatchStrategyOptions
import fr.cea.nabla.ir.transformers.IrTransformationStep
import fr.cea.nabla.ir.transformers.OptimistGpuDispatchStrategy
import fr.cea.nabla.ir.transformers.PutGpuAnnotations
import fr.cea.nabla.ir.transformers.ReplaceReductions
import java.util.ArrayList
import org.eclipse.xtend.lib.annotations.Accessors

abstract class Backend implements Jniable
{
	new(ArrayList<Pair<String, String>> options)
	{
		this.options = options
		options.forEach[pair | println(pair.key + " -> " + pair.value)]
	}
	
	protected ArrayList<Pair<String, String>> options
	
	protected def boolean checkForFlagOption(String key, boolean flag)
	{
		val filtered = options.filter[ pair | pair.key == key ]
		if (filtered.size <= 0)
			return false
		val opt = filtered.head.value.toLowerCase
		
		return flag
			? (opt == "true" || opt == "1" || opt == "ok" || opt == "yes")
			: (opt == "false" || opt == "0" || opt == "ack" || opt == "no")
	}

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

	override getJniDefinitionContent(ExternFunction f, ExtensionProvider provider)
	{
		functionContentProvider.getJniDefinitionContent(f, provider)
	}
}

class SequentialBackend extends Backend
{
	new(ArrayList<Pair<String, String>> options)
	{
		super(options)

		name = 'Sequential'
		irTransformationStep = new ReplaceReductions(true)
		cmakeContentProvider = new CMakeContentProvider
		typeContentProvider = new StlThreadTypeContentProvider
		expressionContentProvider = new ExpressionContentProvider(typeContentProvider)
		instructionContentProvider = new SequentialInstructionContentProvider(typeContentProvider, expressionContentProvider)
		functionContentProvider = new DefaultFunctionContentProvider(typeContentProvider, expressionContentProvider, instructionContentProvider)
		traceContentProvider = new TraceContentProvider
		includesContentProvider = new IncludesContentProvider
		jsonContentProvider = new JsonContentProvider(expressionContentProvider)
		jobCallerContentProvider = new JobCallerContentProvider
		jobContentProvider = new StlThreadJobContentProvider(traceContentProvider, expressionContentProvider, instructionContentProvider, jobCallerContentProvider)
		mainContentProvider = new MainContentProvider(jsonContentProvider)
	}
}

class StlThreadBackend extends Backend
{
	new(ArrayList<Pair<String, String>> options)
	{
		super(options)

		name = 'StlThread'
		cmakeContentProvider = new StlThreadCMakeContentProvider
		typeContentProvider = new StlThreadTypeContentProvider
		expressionContentProvider = new ExpressionContentProvider(typeContentProvider)
		instructionContentProvider = new StlThreadInstructionContentProvider(typeContentProvider, expressionContentProvider)
		functionContentProvider = new DefaultFunctionContentProvider(typeContentProvider, expressionContentProvider, instructionContentProvider)
		traceContentProvider = new TraceContentProvider
		includesContentProvider = new StlThreadIncludesContentProvider
		jsonContentProvider = new JsonContentProvider(expressionContentProvider)
		jobCallerContentProvider = new JobCallerContentProvider
		jobContentProvider = new StlThreadJobContentProvider(traceContentProvider, expressionContentProvider, instructionContentProvider, jobCallerContentProvider)
		mainContentProvider = new MainContentProvider(jsonContentProvider)
	}
}

class KokkosBackend extends Backend
{
	new(ArrayList<Pair<String, String>> options)
	{
		super(options)

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

class KokkosTeamThreadBackend extends Backend
{
	new(ArrayList<Pair<String, String>> options)
	{
		super(options)

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

class OpenMpBackend extends Backend
{
	new(ArrayList<Pair<String, String>> options)
	{
		super(options)

		name = 'OpenMP'
		cmakeContentProvider = new OpenMpCMakeContentProvider
		typeContentProvider = new StlThreadTypeContentProvider
		expressionContentProvider = new ExpressionContentProvider(typeContentProvider)
		instructionContentProvider = new OpenMpInstructionContentProvider(typeContentProvider, expressionContentProvider)
		functionContentProvider = new DefaultFunctionContentProvider(typeContentProvider, expressionContentProvider, instructionContentProvider)
		traceContentProvider = new TraceContentProvider
		includesContentProvider = new OpenMpIncludesContentProvider
		jsonContentProvider = new JsonContentProvider(expressionContentProvider)
		jobCallerContentProvider = new JobCallerContentProvider
		jobContentProvider = new StlThreadJobContentProvider(traceContentProvider, expressionContentProvider, instructionContentProvider, jobCallerContentProvider)
		mainContentProvider = new MainContentProvider(jsonContentProvider)
	}
}

class OpenMpTaskBackend extends Backend
{
	new(ArrayList<Pair<String, String>> options)
	{
		super(options)

		name = 'OpenMPTask'
		cmakeContentProvider = new OpenMpCMakeContentProvider
		typeContentProvider = new OpenMpTaskTypeContentProvider
		expressionContentProvider = new ExpressionContentProvider(typeContentProvider)
		instructionContentProvider = new OpenMpTaskInstructionContentProvider(typeContentProvider, expressionContentProvider)
		functionContentProvider = new DefaultFunctionContentProvider(typeContentProvider, expressionContentProvider, instructionContentProvider)
		traceContentProvider = new TraceContentProvider
		includesContentProvider = new OpenMpTaskIncludesContentProvider
		jsonContentProvider = new JsonContentProvider(expressionContentProvider)
		jobCallerContentProvider = new JobCallerContentProvider
		jobContentProvider = new OpenMpTaskJobContentProvider(traceContentProvider, expressionContentProvider, instructionContentProvider, jobCallerContentProvider)
		mainContentProvider = new MainContentProvider(jsonContentProvider)

		// Build the transformation steps from the options
		var opt = new GpuDispatchStrategyOptions(
			checkForFlagOption("GPU_PERMIT_IF_STATEMENTS", true) // Permit IF statements on GPU
		)
		
		irTransformationStep = new CompositeTransformationStep('OpenMPTask specific transformations', #[
			new PutGpuAnnotations(new OptimistGpuDispatchStrategy(opt))
		])
	}
}