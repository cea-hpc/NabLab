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
import com.google.inject.Provider
import fr.cea.nabla.ir.IrModuleExtensions
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
	@Inject extension IrAnnotationHelper
	@Inject extension IrBasicFactory
	@Inject extension TimeIteratorExtensions
	@Inject Provider<IrModuleFactory> irModuleFactoryProvider

	def create IrFactory::eINSTANCE.createIrRoot toIrRoot(NablagenApplication ngenApp)
	{
		annotations += ngenApp.toIrAnnotation
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
				val adModuleIrVar = getCurrentIrVariable(adIrModule, vLink.additionalVariable)
				val mainModuleIrVar = getCurrentIrVariable(mainIrModule, vLink.mainVariable)

				for (vRef : eAllContents.filter(ArgOrVarRef).filter[x | x.target == adModuleIrVar].toIterable)
					vRef.target = mainModuleIrVar

				EcoreUtil.delete(adModuleIrVar)
			}
		}

		// set simulation variables
		initNodeCoordVariable = getInitIrVariable(mainIrModule, ngenApp.mainModule.nodeCoord)
		nodeCoordVariable = getCurrentIrVariable(mainIrModule, ngenApp.mainModule.nodeCoord)
		currentTimeVariable = getCurrentIrVariable(mainIrModule, ngenApp.mainModule.time)
		nextTimeVariable = getNextIrVariable(mainIrModule, ngenApp.mainModule.time)
		timeStepVariable = getCurrentIrVariable(mainIrModule, ngenApp.mainModule.timeStep)

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
					throw new Exception("Not yet implemented")
				else if (meshes.size == 1)
					mesh = meshes.head
			}
		}

		// post processing
		if (ngenApp.vtkOutput !== null)
		{
			postProcessing = IrFactory.eINSTANCE.createPostProcessing
			val periodReferenceVar = getCurrentIrVariable(mainIrModule, ngenApp.vtkOutput.periodReferenceVar)
			postProcessing.periodReference = periodReferenceVar

			for (outputVar : ngenApp.vtkOutput.vars)
			{
				val v = getCurrentIrVariable(mainIrModule, outputVar.varRef)
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
				name = "lastDump"
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
				name = "outputPeriod"
				type = EcoreUtil::copy(periodVariableType)
				const = false
				constExpr = false
				option = true
				// no default value : option is mandatory
			]
			mainIrModule.variables.add(0, postProcessing.periodValue)
			variables.add(0, postProcessing.periodValue)
		}

		main.calls += jobs.filter(j | j.timeLoopJob).filter[x | x.caller === null]
	}

	private def createIrModule(IrRoot root, IrModuleFactory irModuleFactory, NablagenModule ngenModule)
	{
		val m = irModuleFactory.toIrModule(ngenModule)
		root.modules += m
		root.variables += m.variables
		root.jobs += m.jobs
	}

	private def getCurrentIrVariable(IrModule m, ArgOrVar nablaVar) { getIrVariable(m, nablaVar, currentTimeIteratorName) }
	private def getInitIrVariable(IrModule m, ArgOrVar nablaVar) { getIrVariable(m, nablaVar, initTimeIteratorName) }
	private def getNextIrVariable(IrModule m, ArgOrVar nablaVar) { getIrVariable(m, nablaVar, nextTimeIteratorName) }

	private def getIrVariable(IrModule irModule, ArgOrVar nablaVar, String timeIteratorName)
	{
		// Look for an IR variable named "nablaVar.name"
		val irVariable = IrModuleExtensions.getVariableByName(irModule, nablaVar.name)
		if (irVariable !== null) return irVariable

		// No IR variable named "nablaVar.name".
		// Look for an IR variable named "nablaVar.name_n" or "nablaVar.name_n0" if initTimeIterator=true
		val nablaModule = EcoreUtil2.getContainerOfType(nablaVar, NablaModule)
		return getIrVariable(nablaModule.iteration.iterator, irModule, nablaVar, timeIteratorName)
	}

	private def dispatch Variable getIrVariable(TimeIteratorBlock ti, IrModule irModule, ArgOrVar nablaVar, String timeIteratorName)
	{
		for (childTi : ti.iterators)
		{
			val irVar = getIrVariable(childTi, irModule, nablaVar, timeIteratorName)
			if (irVar !== null) return irVar
		}
	}

	private def dispatch Variable getIrVariable(TimeIterator ti, IrModule irModule, ArgOrVar nablaVar, String timeIteratorName)
	{
		if (timeIteratorName !== currentTimeIteratorName)
		{
			// First try to find an init/next variable like "X_n0"/"X_nplus1" if it exists
			val irVarName = nablaVar.name + getIrVarTimeSuffix(ti, timeIteratorName)
			val irVar = IrModuleExtensions.getVariableByName(irModule, irVarName)
			if (irVar !== null) return irVar
			// Variable not found. No init variable like "X_n0"/"X_nplus1" => looking for "X_n"
		}

		// Try to find a current time step variable like "X_n" if it exists
		val irVarName = nablaVar.name + getIrVarTimeSuffix(ti, currentTimeIteratorName)
		val irVar = IrModuleExtensions.getVariableByName(irModule, irVarName)
		if (irVar !== null) return irVar

		// No variable found
		if (ti.innerIterator === null) return null
		else return getIrVariable(ti.innerIterator, irModule, nablaVar, timeIteratorName)
	}

	private def getLastDumpDefaultValue(PrimitiveType t)
	{
		val f =  IrFactory.eINSTANCE
		switch t
		{
			case BOOL: f.createBoolConstant => [ value = false ]
			default: f.createMinConstant => [ type = f.createBaseType => [ primitive = t] ]
		}
	}
}