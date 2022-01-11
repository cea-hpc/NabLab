/*******************************************************************************
 * Copyright (c) 2021 CEA
 * This program and the accompanying materials are made available under the
 * terms of the Eclipse Public License 2.0 which is available at
 * http://www.eclipse.org/legal/epl-2.0.
 *
 * SPDX-License-Identifier: EPL-2.0
 * Contributors: see AUTHORS file
 *******************************************************************************/
package fr.cea.nabla.ir.generator.python

import fr.cea.nabla.ir.IrTypeExtensions
import fr.cea.nabla.ir.IrUtils
import fr.cea.nabla.ir.generator.Utils
import fr.cea.nabla.ir.ir.BaseType
import fr.cea.nabla.ir.ir.Connectivity
import fr.cea.nabla.ir.ir.ConnectivityType
import fr.cea.nabla.ir.ir.IrModule
import fr.cea.nabla.ir.ir.IrRoot
import fr.cea.nabla.ir.ir.Job
import fr.cea.nabla.ir.ir.LinearAlgebraType
import fr.cea.nabla.ir.ir.Variable

import static fr.cea.nabla.ir.generator.python.JsonContentProvider.*
import static fr.cea.nabla.ir.generator.python.TypeContentProvider.*

import static extension fr.cea.nabla.ir.ContainerExtensions.*
import static extension fr.cea.nabla.ir.ExtensionProviderExtensions.*
import static extension fr.cea.nabla.ir.IrModuleExtensions.*
import static extension fr.cea.nabla.ir.IrRootExtensions.*
import static extension fr.cea.nabla.ir.IrTypeExtensions.*
import static extension fr.cea.nabla.ir.generator.python.ExpressionContentProvider.*
import static extension fr.cea.nabla.ir.generator.python.FunctionContentProvider.*
import static extension fr.cea.nabla.ir.generator.python.JobContentProvider.*

class IrModuleContentProvider
{
	static def getFileContent(IrModule it)
	'''
	"""
	«Utils.doNotEditWarning»
	"""
	import sys
	import json
	import numpy as np
	«IF providers.exists[x | x.extensionName == "Math"]»import math«ENDIF»
	from «irRoot.mesh.className.toLowerCase» import «irRoot.mesh.className»
	«IF irRoot.postProcessing !== null»from pvdfilewriter2d import PvdFileWriter2D«ENDIF»
	«FOR provider : externalProviders»
	from «provider.className.toLowerCase» import «provider.className»
	«IF provider.linearAlgebra»
	from «IrTypeExtensions.VectorClass.toLowerCase» import «IrTypeExtensions.VectorClass»
	from «IrTypeExtensions.MatrixClass.toLowerCase» import «IrTypeExtensions.MatrixClass»
	«ENDIF»
	«ENDFOR»

	class «className»:
		«FOR v : variables.filter[constExpr]»
			«v.name» = «v.defaultValue.content»
		«ENDFOR»

		def __init__(self, mesh):
			self.__mesh = mesh
			«FOR c : irRoot.mesh.connectivities.filter[multiple]»
				«PythonGeneratorUtils.getNbElemsVar(c)» = mesh.«c.connectivityAccessor»
			«ENDFOR»

		def jsonInit(self, jsonContent):
			«IF postProcessing !== null»
				«val opName = IrUtils.OutputPathNameAndValue.key»
				self.__«opName» = jsonContent["«opName»"]
				self.__writer = PvdFileWriter2D("«irRoot.name»", self.__«opName»)
			«ENDIF»
			«FOR v : variables.filter[!constExpr]»
				«IF !v.type.scalar»
					«PythonGeneratorUtils.getCodeName(v)»«getPythonAllocation(v.type, v.name)»
				«ENDIF»
				«IF v.option»
					«getJsonContent(v.name, v.type as BaseType)»
				«ELSEIF v.defaultValue !== null»
					«PythonGeneratorUtils.getCodeName(v)» = «getContent(v.defaultValue)»
				«ENDIF»
			«ENDFOR»
			«FOR v : externalProviders»
				«val vName = v.instanceName»
				# «vName»
				self.«vName» = «v.className»()
				if jsonContent["«vName»"]:
					«vName».jsonInit(jsonContent["«vName»"])
			«ENDFOR»
			«IF main»

				# Copy node coordinates
				gNodes = mesh.geometry.nodes
				for rNodes in range(self.__nbNodes):
					self.«irRoot.initNodeCoordVariable.name»[rNodes] = gNodes[rNodes]
			«ENDIF»
		«FOR j : jobs»

			«j.content»
		«ENDFOR»
		«FOR f : functions»

			«f.content»
		«ENDFOR»

		«IF main»
			def «Utils.getCodeName(irRoot.main)»(self):
				print("Start execution of «name»")
				«FOR j : irRoot.main.calls»
					«getCallName(j)»() # @«j.at»
				«ENDFOR»
				print("End of execution of «name»")
		«ELSE /* !main */»
			@property
			def mainModule(value):
				self._mainModule = value
				self._mainModule._«name» = self
		«ENDIF»
		«IF postProcessing !== null»

			def __dumpVariables(self, iteration):
				if not self.__writer.disabled:
					quads = mesh.geometry.quads
					self.__writer.startVtpFile(iteration, «PythonGeneratorUtils.getCodeName(irRoot.currentTimeVariable)», «PythonGeneratorUtils.getCodeName(irRoot.nodeCoordVariable)», quads)
					self.__writer.openNodeData()
					«val outputVarsByConnectivities = irRoot.postProcessing.outputVariables.groupBy(x | x.support.name)»
					«val nodeVariables = outputVarsByConnectivities.get("node")»
					«IF !nodeVariables.nullOrEmpty»
						«FOR v : nodeVariables»
							self.__writer.openNodeArray("«v.outputName»", «v.target.type.baseSizes.size»);
							for i in range(self.__nbNodes):
								self.__writer.write(«getWriteCallContent(v.target)»)
							self.__writer.closeNodeArray()
						«ENDFOR»
					«ENDIF»
					self.__writer.closeNodeData()
					self.__writer.openCellData()
					«val cellVariables = outputVarsByConnectivities.get("cell")»
					«IF !cellVariables.nullOrEmpty»
						«FOR v : cellVariables»
							self.__writer.openCellArray("«v.outputName»", «v.target.type.baseSizes.size»);
							for i in range(self.__nbCells):
								self.__writer.write(«getWriteCallContent(v.target)»)
							self.__writer.closeCellArray()
						«ENDFOR»
					«ENDIF»
					self.__writer.closeCellData()
					self.__writer.closeVtpFile()
					«PythonGeneratorUtils.getCodeName(postProcessing.lastDumpVariable)» = «PythonGeneratorUtils.getCodeName(postProcessing.periodReference)»
		«ENDIF»

	«IF main»
		if __name__ == '__main__':
			args = sys.argv[1:]
			
			if len(args) == 1:
				f = open(args[0])
				data = json.load(f)
				f.close()

				# Mesh instanciation
				mesh = «irRoot.mesh.className»()
				mesh.jsonInit(data["mesh"])

				# Module instanciation
				«FOR m : irRoot.modules»
					«m.name» = «m.className»(mesh)
					«m.name»Data = data["«m.name»"]
					if («m.name»Data):
						«m.name».jsonInit(«m.name»Data)
						«IF !m.main»«m.name».mainModule = «irRoot.mainModule.name»«ENDIF»
				«ENDFOR»

				# Start simulation
				«name».simulate()
			else:
				print("[ERROR] Wrong number of arguments: expected 1, actual " + str(len(args)), file=sys.stderr)
				print("        Expecting user data file name, for example «irRoot.name».json", file=sys.stderr)
				exit(1)
	«ENDIF»
	'''

	private static def getConnectivityAccessor(Connectivity c)
	{
		if (c.inTypes.empty) c.nbElemsVar
		else c.nbElemsVar.toFirstUpper
	}

	private static def getCallName(Job it)
	{
		val jobModule = IrUtils.getContainerOfType(it, IrModule)
		val callerModule = if (caller.eContainer instanceof IrRoot)
				(caller.eContainer as IrRoot).mainModule
			else
				IrUtils.getContainerOfType(caller, IrModule)
		if (jobModule === callerModule)
			'self._' + Utils.getCodeName(it)
		else
			'self.' + jobModule.name + '.self._' + Utils.getCodeName(it)
	}

	private static def getWriteCallContent(Variable v)
	{
		val t = v.type
		switch t
		{
			ConnectivityType: '''«PythonGeneratorUtils.getCodeName(v)»[i]'''
			LinearAlgebraType: '''«PythonGeneratorUtils.getCodeName(v)».getValue(i)'''
			default: throw new RuntimeException("Unexpected type: " + t.class.name)
		}
	}
}