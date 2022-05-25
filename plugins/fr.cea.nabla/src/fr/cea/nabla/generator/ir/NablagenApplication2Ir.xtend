/*******************************************************************************
 * Copyright (c) 2022 CEA
 * This program and the accompanying materials are made available under the
 * terms of the Eclipse Public License 2.0 which is available at
 * http://www.eclipse.org/legal/epl-2.0.
 *
 * SPDX-License-Identifier: EPL-2.0
 * Contributors: see AUTHORS file
 *******************************************************************************/
package fr.cea.nabla.generator.ir

import com.google.inject.Inject
import com.google.inject.Provider
import fr.cea.nabla.ir.IrModuleExtensions
import fr.cea.nabla.ir.IrUtils
import fr.cea.nabla.ir.JobDependencies
import fr.cea.nabla.ir.ir.ArgOrVarRef
import fr.cea.nabla.ir.ir.BaseType
import fr.cea.nabla.ir.ir.ConnectivityCall
import fr.cea.nabla.ir.ir.ConnectivityType
import fr.cea.nabla.ir.ir.ExternFunction
import fr.cea.nabla.ir.ir.FunctionCall
import fr.cea.nabla.ir.ir.IrFactory
import fr.cea.nabla.ir.ir.IrModule
import fr.cea.nabla.ir.ir.IrRoot
import fr.cea.nabla.ir.ir.MeshExtensionProvider
import fr.cea.nabla.ir.ir.PrimitiveType
import fr.cea.nabla.ir.ir.Variable
import fr.cea.nabla.nabla.ArgOrVar
import fr.cea.nabla.nabla.NablaModule
import fr.cea.nabla.nabla.TimeIterator
import fr.cea.nabla.nabla.TimeIteratorBlock
import fr.cea.nabla.nablagen.NablagenApplication
import fr.cea.nabla.nablagen.NablagenModule
import java.util.LinkedHashSet
import org.eclipse.emf.ecore.util.EcoreUtil
import org.eclipse.xtext.EcoreUtil2

class NablagenApplication2Ir
{
	@Inject extension NabLabFileAnnotationFactory
	@Inject extension IrBasicFactory
	@Inject extension IrTimeIteratorFactory
	@Inject extension TimeIteratorExtensions
	@Inject Provider<IrModuleFactory> irModuleFactoryProvider

	def create IrFactory::eINSTANCE.createIrRoot toIrRoot(NablagenApplication ngenApp)
	{
		annotations += ngenApp.toNabLabFileAnnotation
		name = ngenApp.name
		main = IrFactory::eINSTANCE.createJobCaller

		// create modules
		val irModuleFactory = irModuleFactoryProvider.get
		createIrModule(it, irModuleFactory, ngenApp.mainModule)
		ngenApp.additionalModules.forEach[x | createIrModule(it, irModuleFactory, x)]

		// variable dependencies: replace additional modules variable
		// with main module referenced variable
		val mainIrModule = modules.head
		for (adModule : ngenApp.additionalModules)
		{
			val adIrModule = modules.findFirst[x | x.name == adModule.name]
			for (vLink : adModule.varLinks)
			{
				val adModuleIrVar = getIrVariable(adIrModule, vLink.additionalVariable, currentTimeIteratorIndex)
				val mainModuleIrVar = getIrVariable(mainIrModule, vLink.mainVariable, currentTimeIteratorIndex)

				for (vRef : eAllContents.filter(ArgOrVarRef).filter[x | x.target == adModuleIrVar].toIterable)
					vRef.target = mainModuleIrVar

				EcoreUtil.delete(adModuleIrVar)
			}
		}

		// set simulation variables
		initNodeCoordVariable = getIrVariable(mainIrModule, ngenApp.mainModule.nodeCoord, initTimeIteratorIndex)
		nodeCoordVariable = getIrVariable(mainIrModule, ngenApp.mainModule.nodeCoord, currentTimeIteratorIndex)
		currentTimeVariable = getIrVariable(mainIrModule, ngenApp.mainModule.time, currentTimeIteratorIndex)
		nextTimeVariable = getIrVariable(mainIrModule, ngenApp.mainModule.time, nextTimeIteratorIndex)
		timeStepVariable = getIrVariable(mainIrModule, ngenApp.mainModule.timeStep, currentTimeIteratorIndex)

		// set providers
		for (m : modules)
		{
			// Default providers: only providers containing external functions are needed in IR
			m.providers += eAllContents.filter(FunctionCall).map[function].filter(ExternFunction).map[provider].toSet
			providers += m.providers

			if (m.main)
			{
				// Mesh provider
				val meshes = new LinkedHashSet<MeshExtensionProvider>
				meshes += eAllContents.filter(ConnectivityCall).map[connectivity.provider].toIterable
				for (t : variables.map[type].filter(ConnectivityType))
					for (s : t.connectivities)
						meshes += s.provider

				if (meshes.size > 1)
					throw new RuntimeException("Multi mesh not yet implemented")
				else if (meshes.size == 1)
					providers += meshes.head
			}
		}

		// post processing
		if (ngenApp.vtkOutput !== null)
		{
			postProcessing = IrFactory.eINSTANCE.createPostProcessing
			val periodReferenceVar = getIrVariable(mainIrModule, ngenApp.vtkOutput.periodReferenceVar, currentTimeIteratorIndex)
			postProcessing.periodReference = periodReferenceVar

			for (outputVar : ngenApp.vtkOutput.vars)
			{
				val v = getIrVariable(mainIrModule, outputVar.varRef, currentTimeIteratorIndex)
				postProcessing.outputVariables += IrFactory.eINSTANCE.createPostProcessedVariable =>
				[
					target = v
					outputName = outputVar.varName
					support = outputVar.varRef.supports.head.returnType.toIrItemType
				]
			}
			// Create a variable to store the last write time
			val periodVariableType = postProcessing.periodReference.type as BaseType
			postProcessing.lastDumpVariable = IrFactory.eINSTANCE.createVariable =>
			[
				name = IrUtils.LastDumpOptionName
				type = EcoreUtil::copy(periodVariableType)
				const = false
				constExpr = false
				option = false
				defaultValue = periodVariableType.primitive.lastDumpDefaultValue
			]
			val pos = mainIrModule.variables.indexOf(postProcessing.periodReference)
			mainIrModule.variables.add(pos, postProcessing.lastDumpVariable)
			variables.add(pos, postProcessing.lastDumpVariable)

			// Create an option to store the output period
			postProcessing.periodValue = IrFactory.eINSTANCE.createVariable =>
			[
				name = IrUtils.OutputPeriodOptionName
				type = EcoreUtil::copy(periodVariableType)
				const = false
				constExpr = false
				option = true
				// no default value : option is mandatory
			]
			mainIrModule.variables.add(0, postProcessing.periodValue)
			variables.add(0, postProcessing.periodValue)
		}

		// set variables/jobs dependencies. 2 loops necessary: allin/out vars needed to computer next/previous jobs
		jobs.forEach[x | JobDependencies.computeAndSetInOutVars(x)]
		jobs.forEach[x | JobDependencies.computeAndSetNextJobs(x)]

		main.calls += jobs.filter(j | j.timeLoopJob).filter[x | x.caller === null]
	}

	private def createIrModule(IrRoot root, IrModuleFactory irModuleFactory, NablagenModule ngenModule)
	{
		val m = irModuleFactory.toIrModule(ngenModule)
		root.modules += m
		root.variables += m.variables
		root.jobs += m.jobs

		if (ngenModule.type.iteration !== null && ngenModule.type.iteration.iterator !== null)
			root.timeIterators += createIrTimeIterators(ngenModule.type.iteration.iterator)
	}

	private def Variable getIrVariable(IrModule irModule, ArgOrVar nablaVar, int timeIteratorIndex)
	{
		// Look for an IR variable named "nablaVar.name"
		val irVariable = IrModuleExtensions.getVariableByName(irModule, nablaVar.name)
		if (irVariable !== null) return irVariable

		// No IR variable named "nablaVar.name".
		// Look for an IR variable named "nablaVar.name_n" or "nablaVar.name_n0" if initTimeIterator=true
		val nablaModule = EcoreUtil2.getContainerOfType(nablaVar, NablaModule)
		if (nablaModule.iteration === null) return null

		return getIrVariable(nablaModule.iteration.iterator, irModule, nablaVar, timeIteratorIndex)
	}

	private def dispatch Variable getIrVariable(TimeIteratorBlock ti, IrModule irModule, ArgOrVar nablaVar, int timeIteratorIndex)
	{
		for (childTi : ti.iterators)
		{
			val irVar = getIrVariable(childTi, irModule, nablaVar, timeIteratorIndex)
			if (irVar !== null) return irVar
		}
	}

	private def dispatch Variable getIrVariable(TimeIterator ti, IrModule irModule, ArgOrVar nablaVar, int timeIteratorIndex)
	{
		if (timeIteratorIndex !== currentTimeIteratorIndex)
		{
			// First try to find an init/next variable like "X_n0"/"X_nplus1" if it exists
			val irVarName = nablaVar.name + getIrVarTimeSuffix(ti, timeIteratorIndex)
			val irVar = IrModuleExtensions.getVariableByName(irModule, irVarName)
			if (irVar !== null) return irVar
			// Variable not found. No init variable like "X_n0"/"X_nplus1" => looking for "X_n"
		}

		// Try to find a current time step variable like "X_n" if it exists
		val irVarName = nablaVar.name + getIrVarTimeSuffix(ti, currentTimeIteratorIndex)
		val irVar = IrModuleExtensions.getVariableByName(irModule, irVarName)
		if (irVar !== null) return irVar

		// No variable found
		if (ti.innerIterator === null) return null
		else return getIrVariable(ti.innerIterator, irModule, nablaVar, timeIteratorIndex)
	}

	private def getLastDumpDefaultValue(PrimitiveType t)
	{
		val f =  IrFactory.eINSTANCE
		switch t
		{
			case BOOL: f.createBoolConstant => [ value = false ]
			default: f.createMinConstant =>
			[
				type = f.createBaseType =>
				[
					primitive = t
					isStatic = true
				]
			]
		}
	}
}