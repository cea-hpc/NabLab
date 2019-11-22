package fr.cea.nabla.ir.interpreter

import fr.cea.nabla.ir.ir.Connectivity
import fr.cea.nabla.ir.ir.IrModule
import fr.cea.nabla.ir.ir.Iterator
import fr.cea.nabla.ir.ir.IteratorRef
import fr.cea.nabla.ir.ir.VarRefIteratorRef
import fr.cea.nabla.ir.ir.Variable
import java.util.HashMap
import org.eclipse.xtend.lib.annotations.Accessors

import static extension fr.cea.nabla.ir.IrModuleExtensions.*
import static extension fr.cea.nabla.ir.generator.IteratorExtensions.*
import static extension fr.cea.nabla.ir.generator.IteratorRefExtensions.*
import static extension fr.cea.nabla.ir.interpreter.NablaValueExtensions.*

class Context
{
	val Context outerContext
	val IrModule module
	val indexValues = new HashMap<String, Integer>
	val idValues = new HashMap<String, Integer>
	val variableValues = new HashMap<Variable, NablaValue>
	@Accessors val HashMap<Connectivity, Integer> connectivitySizes
	@Accessors(PUBLIC_GETTER, PRIVATE_SETTER) MeshWrapper meshWrapper

	new(IrModule module)
	{
		this.outerContext = null
		this.module = module
		this.connectivitySizes = new HashMap<Connectivity, Integer>
		this.meshWrapper = null
	}

	new(Context outerContext)
	{
		this.outerContext = outerContext
		this.module = outerContext.module
		this.connectivitySizes = outerContext.connectivitySizes
		this.meshWrapper = outerContext.meshWrapper
	}

	def initMesh(int nbXQuads, int nbYQuads, double xSize, double ySize)
	{
		meshWrapper = new MeshWrapper(nbXQuads, nbYQuads, xSize, ySize)
	}
	
	def NablaValue getVariableValue(Variable variable)
	{
		variableValues.get(variable) ?: outerContext.getVariableValue(variable)
	}

	def getInt(Variable variable)
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

	def void setVariableValue(Variable variable, NablaValue value)
	{
		variableValues.put(variable, value)
	}

	def void setVariableValue(String variableName, NablaValue value)
	{
		val variable = module.getVariableByName(variableName)
		setVariableValue(variable, value)
	}

	def int getIndexValue(VarRefIteratorRef it) { getIndexValue(indexName) }
	def int getIndexValue(Iterator it) { getIndexValue(indexName) }
	def void setIndexValue(VarRefIteratorRef it, int value) { indexValues.put(indexName, value) }
	def void setIndexValue(Iterator it, int value) { indexValues.put(indexName, value) }

	private def int getIndexValue(String indexName)
	{
		indexValues.get(indexName) ?: outerContext.getIndexValue(indexName)
	}

	def int getIdValue(IteratorRef it) { getIdValue(idName) }
	def void setIdValue(IteratorRef it, int value) { idValues.put(idName, value) }

	private def int getIdValue(String id)
	{
		idValues.get(id) ?: outerContext.getIdValue(id)
	}

	def int getIndexOf(VarRefIteratorRef it, int id)
	{
		//TODO : Plus efficace de faire une méthode pour getindexOfId in container ?
		val connectivityName = varContainer.name
		val args =  varArgs.map[x | getIdValue(x)]
		val container = meshWrapper.getElements(connectivityName, args)
		container.indexOf(id)
	}
	
	def int getSingleton(Iterator iterator)
	{
		val methodName = "get" + iterator.container.connectivity.name.toFirstUpper
		meshWrapper.invokeSingleton(methodName, iterator.container.args.map[getIndexValue(idName)])
	}

	def showVariables(String message)
	{
		if (message !== null) println(message)
		variableValues.keySet.forEach[v | println("	Variable " + v.name + " = " + variableValues.get(v).displayValue)]
	}

	def showConnectivitySizes(String message)
	{
		if (message !== null) println(message)
		connectivitySizes.keySet.forEach[k | println("	" + k.name + " de taille " + connectivitySizes.get(k))]
	}

	def showIndexvalues(String message)
	{
		if (message !== null) println(message)
		indexValues.keySet.forEach[k | println("	" + k + " = " + indexValues.get(k))]
	}

	def showIdvalues(String message)
	{
		if (!idValues.empty)
		{
			if (message !== null) println(message)
			idValues.keySet.forEach[k | println("	" + k + " = " + idValues.get(k))]
		}
	}

	def showIdsAndIndicesValues(String message)
	{
		if (!idValues.empty || !indexValues.empty)
		{
			if (message !== null) println(message)
			idValues.keySet.forEach[k | println("	" + k + " = " + idValues.get(k))]
			indexValues.keySet.forEach[k | println("	" + k + " = " + indexValues.get(k))]		
		}
	}
}
