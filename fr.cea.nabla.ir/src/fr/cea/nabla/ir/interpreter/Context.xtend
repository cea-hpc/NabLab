package fr.cea.nabla.ir.interpreter

import fr.cea.nabla.ir.ir.Connectivity
import fr.cea.nabla.ir.ir.Iterator
import fr.cea.nabla.ir.ir.IteratorRef
import fr.cea.nabla.ir.ir.Variable
import java.util.HashMap
import org.eclipse.xtend.lib.annotations.Accessors

import static extension fr.cea.nabla.ir.generator.IteratorExtensions.*
import static extension fr.cea.nabla.ir.generator.IteratorRefExtensions.*

class Context
{
	val Context outerContext
	val indexValues = new HashMap<String, Integer>
	val idValues = new HashMap<String, Integer>
	val variableValues = new HashMap<Variable, NablaValue>
	@Accessors val HashMap<Connectivity, Integer> connectivitySizes
	@Accessors val MeshWrapper meshWrapper

	new()
	{
		this.outerContext = null
		this.connectivitySizes = new HashMap<Connectivity, Integer>
		meshWrapper = new MeshWrapper
	}

	new(Context outerContext)
	{
		this.outerContext = outerContext
		this.connectivitySizes = outerContext.connectivitySizes
		meshWrapper = outerContext.meshWrapper
	}

	def NablaValue getVariableValue(Variable variable)
	{
		variableValues.get(variable) ?: outerContext.getVariableValue(variable)
	}

	def void setVariableValue(Variable variable, NablaValue value)
	{
		variableValues.put(variable, value)
	}

	def int getIndexValue(IteratorRef it) { getIndexValue(indexName) }
	def int getIndexValue(Iterator it) { getIndexValue(indexName) }
	def void setIndexValue(IteratorRef it, int value) { indexValues.put(indexName, value) }
	def void setIndexValue(Iterator it, int value) { indexValues.put(indexName, value) }

	private def int getIndexValue(String indexName)
	{
		indexValues.get(indexName) ?: outerContext.getIndexValue(indexName)
	}

	def int getIdValue(IteratorRef it) { getIdValue(idName) }
	def int getIdValue(Iterator it) { getIdValue(getIdName) }
	def void setIdValue(IteratorRef it, int value) { idValues.put(idName, value) }
	def void setIdValue(Iterator it, int value) { idValues.put(getIdName, value) }

	private def int getIdValue(String id)
	{
		idValues.get(id) ?: outerContext.getIdValue(id)
	}

	def int getIndexOf(Iterator iterator, int id)
	{
		val container = meshWrapper.getContainer(iterator)
		container.indexOf(id)
	}
	
	def int getSingleton(Iterator iterator)
	{
		val methodName = "get" + iterator.container.connectivity.name.toFirstUpper
		meshWrapper.invokeSingleton(methodName, iterator.container.args.map[getIdValue(idName)])
	}
}
