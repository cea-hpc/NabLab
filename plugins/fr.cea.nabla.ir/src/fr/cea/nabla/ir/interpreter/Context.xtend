package fr.cea.nabla.ir.interpreter

import fr.cea.nabla.ir.ir.ArgOrVar
import fr.cea.nabla.ir.ir.ArgOrVarRefIteratorRef
import fr.cea.nabla.ir.ir.Connectivity
import fr.cea.nabla.ir.ir.IrModule
import fr.cea.nabla.ir.ir.Iterator
import fr.cea.nabla.ir.ir.IteratorRef
import fr.cea.nabla.ir.ir.SizeTypeSymbol
import java.util.HashMap
import java.util.TreeSet
import java.util.logging.Level
import java.util.logging.Logger
import org.eclipse.xtend.lib.annotations.Accessors

import static extension fr.cea.nabla.ir.IrModuleExtensions.*
import static extension fr.cea.nabla.ir.generator.IteratorExtensions.*
import static extension fr.cea.nabla.ir.generator.IteratorRefExtensions.*
import static extension fr.cea.nabla.ir.interpreter.NablaValueExtensions.*

class Context
{
	val Context outerContext
	val IrModule module
	val Logger logger
	val indexValues = new HashMap<String, Integer>
	val idValues = new HashMap<String, Integer>
	val dimensionValues = new HashMap<SizeTypeSymbol, Integer>
	val variableValues = new HashMap<ArgOrVar, NablaValue>
	@Accessors(PRIVATE_GETTER, PRIVATE_SETTER) val HashMap<Iterator, TreeSet<ArgOrVarRefIteratorRef>> neededIndices
	@Accessors(PRIVATE_GETTER, PRIVATE_SETTER) val HashMap<Iterator, TreeSet<IteratorRef>> neededIds
	@Accessors val HashMap<Connectivity, Integer> connectivitySizes
	@Accessors(PUBLIC_GETTER, PRIVATE_SETTER) MeshWrapper meshWrapper

	new(IrModule module, Logger logger)
	{
		this.outerContext = null
		this.module = module
		this.logger = logger
		this.connectivitySizes = new HashMap<Connectivity, Integer>
		this.meshWrapper = null
		this.neededIndices = new HashMap<Iterator, TreeSet<ArgOrVarRefIteratorRef>>
		this.neededIds = new HashMap<Iterator, TreeSet<IteratorRef>>
	}

	new(Context outerContext)
	{
		this.outerContext = outerContext
		this.module = outerContext.module
		this.logger = outerContext.logger
		this.connectivitySizes = outerContext.connectivitySizes
		this.meshWrapper = outerContext.meshWrapper
		this.neededIndices = outerContext.neededIndices
		this.neededIds = outerContext.neededIds
	}

	def initMesh(int nbXQuads, int nbYQuads, double xSize, double ySize)
	{
		meshWrapper = new MeshWrapper(nbXQuads, nbYQuads, xSize, ySize)
	}

	// VariableValues
	def NablaValue getVariableValue(ArgOrVar variable)
	{
		variableValues.get(variable) ?: outerContext.getVariableValue(variable)
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

	// IndexValues
	def int getIndexValue(ArgOrVarRefIteratorRef it) { getIndexValue(indexName) }
	def int getIndexValue(Iterator it) { getIndexValue(indexName) }
	def void addIndexValue(ArgOrVarRefIteratorRef it, int value) { indexValues.put(indexName, value) }
	def void addIndexValue(Iterator it, int value) { indexValues.put(indexName, value) }

	def void setIndexValue(Iterator it, int value)
	{
		if (indexValues.get(indexName) !== null)
			indexValues.replace(indexName, value)
		else
			if (outerContext !== null)
				outerContext.setIndexValue(it, value)
			else
				throw new RuntimeException('Iterator not found ' + indexName)
	}

	// IdValues
	def int getIdValue(IteratorRef it) { getIdValue(idName) }
	def void addIdValue(IteratorRef it, int value) { idValues.put(idName, value) }

	def void setIdValue(IteratorRef it, int value)
	{
		if (idValues.get(idName) !== null)
			idValues.replace(idName, value)
		else
			if (outerContext !== null)
				outerContext.setIdValue(it, value)
			else
				throw new RuntimeException('IteratorRef not found ' + idName)
	}

	// DimensionValues
	def int getDimensionValue(SizeTypeSymbol it) 
	{
		dimensionValues.get(it) ?: outerContext.getDimensionValue(it)
	}

	def addDimensionValue(SizeTypeSymbol it, int value)
	{
		dimensionValues.put(it, value)
	}

	def void setDimensionValue(SizeTypeSymbol it, int value)
	{
		if (dimensionValues.get(it) !== null)
			dimensionValues.replace(it, value)
		else
			if (outerContext !== null)
				outerContext.setDimensionValue(it, value)
			else
				throw new RuntimeException('Dimension Symbol not found ' + name)
	}

	def int getIndexOf(ArgOrVarRefIteratorRef it, int id)
	{
		//TODO : Plus efficace de faire une méthode pour getindexOfId in container ?
		val connectivityName = varContainer.name
		val args =  varArgs.map[x | getIdValue(x)]
		val container = meshWrapper.getElements(connectivityName, args)
		container.indexOf(id)
	}

	def int getSingleton(Iterator iterator)
	{
		meshWrapper.getSingleton(iterator.container.connectivity.name, iterator.container.args.map[getIdValue(idName)])
	}

	def logVariables(String message)
	{
		if (message !== null) logger.log(Level::INFO, message)
		variableValues.keySet.forEach[v | logger.log(Level::INFO,"	Variable " + v.name + " = " + variableValues.get(v).displayValue)]
	}

	def logConnectivitySizes(String message)
	{
		if (message !== null) logger.log(Level::INFO, message)
		connectivitySizes.keySet.forEach[k | logger.log(Level::INFO, "	" + k.name + " de taille " + connectivitySizes.get(k))]
	}

	def logIndexvalues(String message)
	{
		if (message !== null) logger.log(Level::INFO, message)
		indexValues.keySet.forEach[k | logger.log(Level::INFO, "	" + k + " = " + indexValues.get(k))]
	}

	def logIdvalues(String message)
	{
		if (!idValues.empty)
		{
			if (message !== null) logger.log(Level::INFO, message)
			idValues.keySet.forEach[k | logger.log(Level::INFO, "	" + k + " = " + idValues.get(k))]
		}
	}

	def logIdsAndIndicesValues(String message)
	{
		if (!idValues.empty || !indexValues.empty)
		{
			if (message !== null) logger.log(Level::INFO, message)
			idValues.keySet.forEach[k | logger.log(Level::INFO, "	" + k + " = " + idValues.get(k))]
			indexValues.keySet.forEach[k | logger.log(Level::INFO, "	" + k + " = " + indexValues.get(k))]
		}
	}

	def logDimensions(String message)
	{
		if (message !== null) logger.log(Level::INFO, message)
		dimensionValues.keySet.forEach[d | logger.log(Level::INFO, "	Dimension " + d.name + " = " + dimensionValues.get(d))]
	}
	
	def logFinest(String message)
	{
		logger.log(Level::FINEST, message)
	}

	def setNeededIndicesAndNeededIdsInContext(Iterator iterator)
	{
		neededIndices.put(iterator, iterator.neededIndices)
		neededIds.put(iterator, iterator.neededIds)
	}

	def getNeededIndicesInContext(Iterator iterator)
	{
		neededIndices.get(iterator)
	}

	def getNeededIdsInContext(Iterator iterator)
	{
		neededIds.get(iterator)
	}

	private def int getIndexValue(String indexName)
	{
		indexValues.get(indexName) ?: outerContext.getIndexValue(indexName)
	}

	private def int getIdValue(String id)
	{
		idValues.get(id) ?: outerContext.getIdValue(id)
	}
}
