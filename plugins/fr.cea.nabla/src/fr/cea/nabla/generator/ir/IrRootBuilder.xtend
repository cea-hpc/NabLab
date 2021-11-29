/*******************************************************************************
 * Copyright (c) 2021 CEA
 * This program and the accompanying materials are made available under the
 * terms of the Eclipse Public License 2.0 which is available at
 * http://www.eclipse.org/legal/epl-2.0.
 *
 * SPDX-License-Identifier: EPL-2.0
 * Contributors: see AUTHORS file
 *******************************************************************************/
package fr.cea.nabla.generator.ir

import com.google.inject.Inject
import fr.cea.nabla.generator.NablaGeneratorMessageDispatcher
import fr.cea.nabla.generator.NablaGeneratorMessageDispatcher.MessageType
import fr.cea.nabla.generator.NablagenExtensionHelper
import fr.cea.nabla.ir.ir.DefaultExtensionProvider
import fr.cea.nabla.ir.ir.IrRoot
import fr.cea.nabla.ir.transformers.CreateArrayOperators
import fr.cea.nabla.ir.transformers.FillJobHLTs
import fr.cea.nabla.ir.transformers.IrTransformationStep
import fr.cea.nabla.ir.transformers.OptimizeConnectivities
import fr.cea.nabla.ir.transformers.ReplaceAffectations
import fr.cea.nabla.ir.transformers.ReplaceReductions
import fr.cea.nabla.ir.transformers.ReplaceUtf8Chars
import fr.cea.nabla.nabla.DefaultExtension
import fr.cea.nabla.nablagen.NablagenApplication
import fr.cea.nabla.nablagen.TargetType
import org.eclipse.emf.ecore.EObject

class IrRootBuilder
{
	@Inject NablaGeneratorMessageDispatcher dispatcher
	@Inject NablagenApplication2Ir nablagen2Ir
	@Inject NablagenExtensionHelper ngenExtHelper

	/**
	 * Validation checks that there is one interpreter target max.
	 * Consequently, no need to identify the interpreter.
	 * If several interpreter are needed, the outputPath can be used as an id.
	 */
	def IrRoot buildInterpreterIr(NablagenApplication ngenApp, String wsPath)
	{
		try
		{
			val ir = buildIr(ngenApp, getCommonTransformation(true))

			val target = ngenApp.targets.findFirst[x | x.interpreter]
			var ok = false
			if (target === null)
				ok = setDefaultInterpreterProviders(ngenApp, ir)
			else
				ok = ngenExtHelper.setExtensionProviders(ir, wsPath, target, false)
			if (!ok) throw new RuntimeException("Can not build an IR for interpretation: missing providers")

			return ir
		}
		catch(Exception e)
		{
			dispatcher.post(MessageType::Error, '\n***' + e.class.name + ': ' + e.message)
			if (e.stackTrace !== null && !e.stackTrace.empty)
			{
				val stack = e.stackTrace.head
				dispatcher.post(MessageType::Error, 'at ' + stack.className + '.' + stack.methodName + '(' + stack.fileName + ':' + stack.lineNumber + ')')
			}
			if (e instanceof NullPointerException)
			{
				dispatcher.post(MessageType::Error, "Try to rebuild the entire project (Project menu in main menu bar) and to relaunch the generation")
			}
			throw(e)
		}
	}

	/**
	 * Build a generic IR for all generators.
	 * This IR will be completed depending on target and providers
	 */
	def IrRoot buildGeneratorGenericIr(NablagenApplication ngenApp)
	{
		buildIr(ngenApp, getCommonTransformation(false))
	}

	/**
	 * Build a raw IR: an IR built from the NabLab model with no transformation step applied.
	 */
	def IrRoot buildRawIr(NablagenApplication ngenApp)
	{
		buildIr(ngenApp, #[])
	}

	private def IrRoot buildIr(NablagenApplication ngenApp, IrTransformationStep[] transformationSteps)
	{
		dispatcher.post(MessageType.Exec, "Starting NabLab to IR model transformation")
		val startTime = System.currentTimeMillis
		val ir = nablagen2Ir.toIrRoot(ngenApp)
		for (s : transformationSteps) s.transformIr(ir, [msg | dispatcher.post(MessageType::Exec, msg)])
		val endTime = System.currentTimeMillis
		dispatcher.post(MessageType.Exec, "NabLab to IR model transformation ended in " + (endTime-startTime)/1000.0 + "s")
		return ir
	}

	private def getCommonTransformation(boolean replaceAllReductions)
	{
		#[
			new ReplaceUtf8Chars,
			new OptimizeConnectivities(#['cells', 'nodes', 'faces']),
			new ReplaceReductions(replaceAllReductions),
			new ReplaceAffectations,
			new CreateArrayOperators,
			new FillJobHLTs
		]
	}

	private def boolean setDefaultInterpreterProviders(EObject ngenContext, IrRoot ir)
	{
		// Browse IrRoot model providers which need to be filled with Nablaext providers
		for (irProvider : ir.providers.filter[x | x.extensionName != "Math"])
		{
			val provider = ngenExtHelper.getDefaultProvider(ngenContext, TargetType::JAVA, irProvider.extensionName)
			if (provider === null)
			{
				dispatcher.post(MessageType::Error, '    No provider found for extension: ' + irProvider.extensionName)
				return false
			}

			irProvider.providerName = provider.name
			irProvider.outputPath = provider.outputPath
			if (provider.extension instanceof DefaultExtension && irProvider instanceof DefaultExtensionProvider)
				(irProvider as DefaultExtensionProvider).linearAlgebra = (provider.extension as DefaultExtension).linearAlgebra
		}

		return true
	}
}

