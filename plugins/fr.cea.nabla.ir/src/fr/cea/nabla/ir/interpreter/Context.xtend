/*******************************************************************************
 * Copyright (c) 2021 CEA
 * This program and the accompanying materials are made available under the 
 * terms of the Eclipse Public License 2.0 which is available at
 * http://www.eclipse.org/legal/epl-2.0.
 *
 * SPDX-License-Identifier: EPL-2.0
 * Contributors: see AUTHORS file
 *******************************************************************************/
package fr.cea.nabla.ir.interpreter

import fr.cea.nabla.ir.ir.ArgOrVar
import fr.cea.nabla.ir.ir.ConnectivityCall
import fr.cea.nabla.ir.ir.Container
import fr.cea.nabla.ir.ir.DefaultExtensionProvider
import fr.cea.nabla.ir.ir.ExtensionProvider
import fr.cea.nabla.ir.ir.IrRoot
import fr.cea.nabla.ir.ir.ItemId
import fr.cea.nabla.ir.ir.ItemIndex
import fr.cea.nabla.ir.ir.MeshExtensionProvider
import fr.cea.nabla.ir.ir.SetRef
import fr.cea.nabla.javalib.mesh.PvdFileWriter2D
import java.util.HashMap
import java.util.logging.Logger
import org.eclipse.xtend.lib.annotations.Accessors

import static extension fr.cea.nabla.ir.IrRootExtensions.*

class Context
{
	val variableValues = new HashMap<ArgOrVar, NablaValue>
	val setValues = new HashMap<String, int[]>
	val indexValues = new HashMap<ItemIndex, Integer>
	val idValues = new HashMap<ItemId, Integer>
	val Context outerContext
	val Logger logger

	@Accessors(PUBLIC_GETTER, PRIVATE_SETTER) val IrRoot ir
	@Accessors(PUBLIC_GETTER, PRIVATE_SETTER) PvdFileWriter2D writer
	@Accessors(PUBLIC_GETTER, PUBLIC_SETTER)  boolean levelDBCompareResult
	@Accessors(PUBLIC_GETTER, PRIVATE_SETTER) val HashMap<ExtensionProvider, ExtensionProviderHelper> providers

	new(Logger logger, IrRoot ir, String wsPath)
	{
		this.outerContext = null
		this.logger = logger
		this.ir = ir
		this.levelDBCompareResult = true
		this.providers = new HashMap<ExtensionProvider, ExtensionProviderHelper>

		// providerName can be null when default option are interpreted for json generation
		// The providerName is set when the target is defined (json generation done before)
		if (wsPath !== null)
		{
			
			for (p : ir.providers)
			{
				try
				{
					switch p
					{
						MeshExtensionProvider:
						{
							val helper = new MeshExtensionProviderHelper
							helper.init(ir.mesh.connectivities)
							providers.put(p, helper)
						}
						DefaultExtensionProvider:
						{
							var CallableExtensionProviderHelper helper
							if (p.extensionName == "Math")
								helper = new MathExtensionProviderHelper
							else if (p.linearAlgebra)
								helper = new LinearAlgebraExtensionProviderHelper(p, wsPath)
							else
								helper = new DefaultExtensionProviderHelper(p, wsPath)
		
							helper.init(p.functions)
							providers.put(p, helper)
						}
					}
				}
				catch (ClassNotFoundException e)
				{
					throw new ExtensionProviderNotFound(p, e)
				}
			}

			if (ir.mesh !== null)
			{
			}
		}
	}

	new(Context outerContext)
	{
		this.outerContext = outerContext
		this.logger = outerContext.logger
		this.ir = outerContext.ir
		this.writer = outerContext.writer
		this.levelDBCompareResult = outerContext.levelDBCompareResult
		this.providers = outerContext.providers
	}

	def getMesh()
	{
		// only one mesh for the moment
		providers.values.filter(MeshExtensionProviderHelper).head
	}

	def initWriter(String outputPath)
	{
		writer = new PvdFileWriter2D(ir.name, outputPath)
		writer.logger = logger;
	}

	def checkInterrupted() throws IrInterpreterException
	{
		if (Thread.currentThread.interrupted)
		{
			logInfo("Request for interruption of interpretation of IR: " + ir.name)
			throw new IrInterpreterException("Interpretation interrupted for IR: " + ir.name)
		}
	}

	// VariableValues
	def NablaValue getVariableValue(ArgOrVar variable)
	{
		val value = variableValues.get(variable)
		if (value === null && outerContext !== null)
			outerContext.getVariableValue(variable)
		else
			value
	}

	def getInt(ArgOrVar variable)
	{
		return (getVariableValue(variable) as NV0Int).data
	}

	def getReal(ArgOrVar variable)
	{
		return (getVariableValue(variable) as NV0Real).data
	}

	def double getNumber(ArgOrVar variable)
	{
		val vv = getVariableValue(variable)
		switch vv
		{
			NV0Real : vv.data
			NV0Int : vv.data as double
			default : 0.0
		}
	}

	def void addVariableValue(ArgOrVar variable, NablaValue value)
	{
		variableValues.put(variable, value)
	}

	def void setVariableValue(ArgOrVar it, NablaValue value)
	{
		if (variableValues.get(it) !== null)
			variableValues.replace(it, value)
		else
			if (outerContext !== null)
				outerContext.setVariableValue(it, value)
			else
				throw new RuntimeException('Variable not found ' + name)
	}

	// ContainerValues
	def int[] getContainerValue(Container c) 
	{
		switch c
		{
			ConnectivityCall: c.connectivityCallValue
			SetRef: setValues.get(c.target.name) ?: outerContext.getContainerValue(c)
		}
	}

	def void addSetValue(String setName, ConnectivityCall value) 
	{ 
		val argIds =  value.args.map[x | getIdValue(x)]
		val containerValue = mesh.getElements(value.connectivity, argIds)
		setValues.put(setName, containerValue)
	}

	def int[] getConnectivityCallValue(ConnectivityCall it)
	{
		val argIds =  args.map[x | getIdValue(x)]
		mesh.getElements(connectivity, argIds)
	}

	// IndexValues
	def int getIndexValue(ItemIndex index) 
	{ 
		indexValues.get(index) ?: outerContext.getIndexValue(index)
	}

	def void addIndexValue(ItemIndex index, int value) 
	{ 
		indexValues.put(index, value)
	}

	def void setIndexValue(ItemIndex index, int value)
	{
		// Store indexName to avoid retrieving it in the map repetitively
		if (indexValues.get(index) !== null)
			indexValues.replace(index, value)
		else
			if (outerContext !== null)
				outerContext.setIndexValue(index, value)
			else
				throw new RuntimeException('Index not found ' + index.name)
	}

	// IdValues
	def int getIdValue(ItemId id) 
	{ 
		idValues.get(id) ?: outerContext.getIdValue(id)
	}

	def void addIdValue(ItemId id, int value) 
	{ 
		idValues.put(id, value)
	}

	def void setIdValue(ItemId id, int value)
	{
		if (idValues.get(id) !== null)
			idValues.replace(id, value)
		else
			if (outerContext !== null)
				outerContext.setIdValue(id, value)
			else
				throw new RuntimeException('Unique identifier not found ' + id.name)
	}

	def int getSingleton(ConnectivityCall it)
	{
		mesh.getSingleton(connectivity, args.map[x | getIdValue(x)])
	}

	def logVariables(String message)
	{
		if (logger.level.intValue <= Context.Level::FINER.intValue)
		{
			if (message !== null) logger.log(Context.Level::FINER, message)
			variableValues.keySet.forEach[v | logger.log(Context.Level::FINER,"	Variable " + v.name + " = " + variableValues.get(v))]
		}
	}

	def logConnectivitySizes(String message)
	{
		if (logger.level.intValue <= Context.Level::FINER.intValue)
		{
			if (message !== null) logger.log(Context.Level::FINER, message)
			mesh.logSizes(logger, Context.Level::FINER)
		}
	}

	def logIndexvalues(String message)
	{
		if (logger.level.intValue <= Context.Level::FINER.intValue)
		{
			if (message !== null) logger.log(Context.Level::FINER, message)
			indexValues.keySet.forEach[k | logger.log(Context.Level::FINER, "	" + k + " = " + indexValues.get(k))]
		}
	}

	def logIdvalues(String message)
	{
		if (!idValues.empty && logger.level.intValue <= Context.Level::FINER.intValue)
		{
			if (message !== null) logger.log(Context.Level::FINER, message)
			idValues.keySet.forEach[k | logger.log(Context.Level::FINER, "	" + k + " = " + idValues.get(k))]
		}
	}

	def logIdsAndIndicesValues(String message)
	{
		if (!idValues.empty || !indexValues.empty && logger.level.intValue <= Context.Level::FINER.intValue)
		{
			if (message !== null) logger.log(Context.Level::FINER, message)
			idValues.keySet.forEach[k | logger.log(Context.Level::FINER, "	" + k + " = " + idValues.get(k))]
			indexValues.keySet.forEach[k | logger.log(Context.Level::FINER, "	" + k + " = " + indexValues.get(k))]
		}
	}

	def logFinest(String message)
	{
		logger.log(Context.Level::FINEST, message)
	}

	def logFiner(String message)
	{
		logger.log(Context.Level::FINER, message)
	}

	def logFine(String message)
	{
		logger.log(Context.Level::FINE, message)
	}

	def logInfo(String message)
	{
		logger.log(Context.Level::INFO, message)
	}

	static class Level extends java.util.logging.Level
	{
		//static val OFF = new fr.cea.nabla.ir.interpreter.Context.Level("OFF", Integer.MAX_VALUE)
		//static val SEVERE = new fr.cea.nabla.ir.interpreter.Context.Level("SEVERE", 1000)
		//static val WARNING = new fr.cea.nabla.ir.interpreter.Context.Level("WARNING", 900)
		static val INFO = new Context.Level("INFO", 800)
		//static val CONFIG = new fr.cea.nabla.ir.interpreter.Context.Level("CONFIG", 700)
		static val FINE = new Context.Level("FINE", 500)
		static val FINER = new Context.Level("FINER", 400)
		static val FINEST = new Context.Level("FINEST", 300)
		//static val ALL = new fr.cea.nabla.ir.interpreter.Context.Level("ALL", Integer.MIN_VALUE)

		new(String name, int value) { super(name, value) }
	}
}
