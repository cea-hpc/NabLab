/*******************************************************************************
 * Copyright (c) 2020 CEA
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
import fr.cea.nabla.ir.ir.ConnectivityVariable
import fr.cea.nabla.ir.ir.ExternFunction
import fr.cea.nabla.ir.ir.IrFactory
import fr.cea.nabla.ir.ir.IrModule
import fr.cea.nabla.ir.ir.IrRoot
import fr.cea.nabla.ir.ir.PrimitiveType
import fr.cea.nabla.ir.ir.SimpleVariable
import fr.cea.nabla.ir.ir.TimeLoopJob
import fr.cea.nabla.ir.ir.Variable
import fr.cea.nabla.nabla.ArgOrVar
import fr.cea.nabla.nabla.NablaModule
import fr.cea.nabla.nabla.TimeIterator
import fr.cea.nabla.nabla.TimeIteratorBlock
import fr.cea.nabla.nablagen.NablagenModule
import fr.cea.nabla.nablagen.NablagenRoot
import org.eclipse.emf.ecore.util.EcoreUtil
import org.eclipse.xtext.EcoreUtil2

class Nablagen2Ir
{
	@Inject extension IrAnnotationHelper
	@Inject extension IrBasicFactory
	@Inject extension TimeIteratorExtensions
	@Inject Provider<Nabla2Ir> nabla2IrProvider

	def create IrFactory::eINSTANCE.createIrRoot toIrRoot(NablagenRoot ngen)
	{
		annotations += ngen.toIrAnnotation
		name = ngen.name
		main = IrFactory::eINSTANCE.createJobCaller

		// create language extension providers
		ngen.mainModule.type.imports.forEach[x | providers += x.importedNamespace.moduleName.toIrExtensionProvider]
		for (adModule : ngen.additionalModules)
			adModule.type.imports.forEach[x | providers += x.importedNamespace.moduleName.toIrExtensionProvider]

		// create modules
		val nabla2ir = nabla2IrProvider.get
		createIrModule(it, nabla2ir, ngen.mainModule)
		ngen.additionalModules.forEach[x | createIrModule(it, nabla2ir, x)]

		// variable dependencies: replace additional modules variable
		// with main module referenced variable
		val mainIrModule = modules.head
		for (adModule : ngen.additionalModules)
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
		meshClassName= ngen.mainModule.meshClassName
		initNodeCoordVariable = getInitIrVariable(mainIrModule, ngen.mainModule.nodeCoord) as ConnectivityVariable
		nodeCoordVariable = getCurrentIrVariable(mainIrModule, ngen.mainModule.nodeCoord) as ConnectivityVariable
		timeVariable = getCurrentIrVariable(mainIrModule, ngen.mainModule.time) as SimpleVariable
		timeStepVariable = getCurrentIrVariable(mainIrModule, ngen.mainModule.timeStep) as SimpleVariable

		// set providers
		for (f : functions.filter(ExternFunction))
			providers += f.provider

		// post processing
		if (ngen.vtkOutput !== null)
		{
			postProcessing = IrFactory.eINSTANCE.createPostProcessing
			val periodReferenceVar = getCurrentIrVariable(mainIrModule, ngen.vtkOutput.periodReferenceVar)
			postProcessing.periodReference = periodReferenceVar as SimpleVariable

			for (outputVar : ngen.vtkOutput.vars)
			{
				val v = getCurrentIrVariable(mainIrModule, outputVar.varRef)
				v.outputName = outputVar.varName
				postProcessing.outputVariables += v
			}

			// Create a variable to store the last write time
			val periodVariableType = postProcessing.periodReference.type
			postProcessing.lastDumpVariable = IrFactory.eINSTANCE.createSimpleVariable =>
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
			postProcessing.periodValue = IrFactory.eINSTANCE.createSimpleVariable =>
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

		main.calls += jobs.filter(TimeLoopJob).filter[x | x.caller === null]
	}

	private def createIrModule(IrRoot root, Nabla2Ir nabla2ir, NablagenModule ngenModule)
	{
		ngenModule.type.itemTypes.forEach[x | root.itemTypes += x.toIrItemType]
		ngenModule.type.connectivities.forEach[x | root.connectivities += x.toIrConnectivity]
		val m = nabla2ir.createIrModule(ngenModule)
		root.modules += m
		root.variables += m.variables
		root.functions += m.functions
		root.jobs += m.jobs
	}

	private def getCurrentIrVariable(IrModule m, ArgOrVar nablaVar) { getIrVariable(m, nablaVar, false) }
	private def getInitIrVariable(IrModule m, ArgOrVar nablaVar) { getIrVariable(m, nablaVar, true) }

	private def getIrVariable(IrModule irModule, ArgOrVar nablaVar, boolean initTimeIterator)
	{
		// Look for an IR variable named "nablaVar.name"
		val irVariable = IrModuleExtensions.getVariableByName(irModule, nablaVar.name)
		if (irVariable !== null) return irVariable

		// No IR variable named "nablaVar.name".
		// Look for an IR variable named "nablaVar.name_n" or "nablaVar.name_n0" if initTimeIterator=true
		val nablaModule = EcoreUtil2.getContainerOfType(nablaVar, NablaModule)
		return getIrVariable(nablaModule.iteration.iterator, irModule, nablaVar, initTimeIterator)
	}

	private def dispatch Variable getIrVariable(TimeIteratorBlock ti, IrModule irModule, ArgOrVar nablaVar, boolean initTimeIterator)
	{
		for (childTi : ti.iterators)
		{
			val irVar = getIrVariable(childTi, irModule, nablaVar, initTimeIterator)
			if (irVar !== null) return irVar
		}
	}

	private def dispatch Variable getIrVariable(TimeIterator ti, IrModule irModule, ArgOrVar nablaVar, boolean initTimeIterator)
	{
		if (initTimeIterator)
		{
			// First try to find an init variable like "X_n0" if it exists
			val irVarName = nablaVar.name + getIrVarTimeSuffix(ti, initTimeIteratorName)
			val irVar = IrModuleExtensions.getVariableByName(irModule, irVarName)
			if (irVar !== null) return irVar
			// Variable not found. No init variable like "X_n0" => looking for "X_n"
		}

		// Try to find a current time step variable like "X_n" if it exists
		val irVarName = nablaVar.name + getIrVarTimeSuffix(ti, currentTimeIteratorName)
		val irVar = IrModuleExtensions.getVariableByName(irModule, irVarName)
		if (irVar !== null) return irVar

		// No variable found
		if (ti.innerIterator === null) return null
		else return getIrVariable(ti.innerIterator, irModule, nablaVar, initTimeIterator)
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

	private def getModuleName(String qualifiedNameWithWildcards)
	{
		if (qualifiedNameWithWildcards.contains('.'))
			qualifiedNameWithWildcards.split('\\.').head
		else
			qualifiedNameWithWildcards
	}
}