/*******************************************************************************
 * Copyright (c) 2020 CEA
 * This program and the accompanying materials are made available under the 
 * terms of the Eclipse Public License 2.0 which is available at
 * http://www.eclipse.org/legal/epl-2.0.
 *
 * SPDX-License-Identifier: EPL-2.0
 * Contributors: see AUTHORS file
 *******************************************************************************/
package fr.cea.nabla.ir.interpreter

import fr.cea.nabla.ir.generator.Utils
import fr.cea.nabla.ir.ir.ArgOrVar
import fr.cea.nabla.ir.ir.Connectivity
import fr.cea.nabla.ir.ir.ConnectivityCall
import fr.cea.nabla.ir.ir.Container
import fr.cea.nabla.ir.ir.Function
import fr.cea.nabla.ir.ir.IrModule
import fr.cea.nabla.ir.ir.ItemId
import fr.cea.nabla.ir.ir.ItemIndex
import fr.cea.nabla.ir.ir.SetRef
import java.lang.reflect.Method
import java.util.HashMap
import java.util.logging.Logger
import org.eclipse.xtend.lib.annotations.Accessors

import static extension fr.cea.nabla.ir.ArgOrVarExtensions.*
import static extension fr.cea.nabla.ir.IrModuleExtensions.*
import static extension fr.cea.nabla.ir.IrTypeExtensions.*
import static extension fr.cea.nabla.ir.interpreter.NablaValueExtensions.*

class Context
{
	val Context outerContext
	val IrModule module
	val Logger logger
	val variableValues = new HashMap<ArgOrVar, NablaValue>
	val setValues = new HashMap<String, int[]>
	val indexValues = new HashMap<ItemIndex, Integer>
	val idValues = new HashMap<ItemId, Integer>
	@Accessors(PRIVATE_GETTER, PRIVATE_SETTER) val HashMap<Function, Method> functionToMethod
	@Accessors val HashMap<Connectivity, Integer> connectivitySizes
	@Accessors(PUBLIC_GETTER, PRIVATE_SETTER) MeshWrapper meshWrapper

	new(IrModule module, Logger logger)
	{
		this.outerContext = null
		this.module = module
		this.logger = logger
		this.connectivitySizes = new HashMap<Connectivity, Integer>
		this.meshWrapper = null
		this.functionToMethod = new HashMap<Function, Method>
	}

	new(Context outerContext)
	{
		this.outerContext = outerContext
		this.module = outerContext.module
		this.logger = outerContext.logger
		this.connectivitySizes = outerContext.connectivitySizes
		this.meshWrapper = outerContext.meshWrapper
		this.functionToMethod = outerContext.functionToMethod
	}

	def initMesh(int nbXQuads, int nbYQuads, double xSize, double ySize)
	{
		meshWrapper = new MeshWrapper(nbXQuads, nbYQuads, xSize, ySize)
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

	def getVariableValue(String variableName)
	{
		val variable = module.getVariableByName(variableName)
		getVariableValue(variable)
	}

	def getInt(String variableName)
	{
		return (getVariableValue(variableName) as NV0Int).data
	}

	def getReal(String variableName)
	{
		return (getVariableValue(variableName) as NV0Real).data
	}

	def double getNumber(String variableName)
	{
		val vv = getVariableValue(variableName)
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
		val connectivityName = value.connectivity.name
		val argIds =  value.args.map[x | getIdValue(x)]
		val containerValue = meshWrapper.getElements(connectivityName, argIds)
		setValues.put(setName, containerValue)
	}

	def int[] getConnectivityCallValue(ConnectivityCall it)
	{
		val argIds =  args.map[x | getIdValue(x)]
		meshWrapper.getElements(connectivity.name, argIds)
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
		meshWrapper.getSingleton(connectivity.name, args.map[x | getIdValue(x)])
	}

	def logVariables(String message)
	{
		if (logger.level.intValue <= Context.Level::FINER.intValue)
		{
			if (message !== null) logger.log(Context.Level::FINER, message)
			variableValues.keySet.forEach[v | logger.log(Context.Level::FINER,"	Variable " + v.name + " = " + variableValues.get(v).displayValue)]
		}
	}

	def logConnectivitySizes(String message)
	{
		if (logger.level.intValue <= Context.Level::FINER.intValue)
		{
			if (message !== null) logger.log(Context.Level::FINER, message)
			connectivitySizes.keySet.forEach[k | logger.log(Context.Level::FINER, "	" + k.name + " de taille " + connectivitySizes.get(k))]
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

	def resolveFunction(Function it)
	{
		val tccl = Thread.currentThread().getContextClassLoader()
		val providerClassName = if (provider == "Math") 'java.lang.Math'
			else module.name.toLowerCase + '.' + provider + Utils::FunctionReductionPrefix
		val providerClass = Class.forName(providerClassName, true, tccl)
		val javaTypes = inArgs.map[a | FunctionCallHelper.getJavaType(a.type.primitive, a.type.dimension, linearAlgebra)]
		try 
		{
			val result = providerClass.getDeclaredMethod(name, javaTypes)
			result.setAccessible(true)
			functionToMethod.put(it, result)
		}
		catch (NoSuchMethodException e)
		{
			println("** Method '" + providerClassName + "::" + name + "(" + inArgs.map[type.label + " " + name].join(", ") + ")' not found")
			throw(e);
		}
	}

	def Method getMethod(Function it)
	{
		functionToMethod.get(it)
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
