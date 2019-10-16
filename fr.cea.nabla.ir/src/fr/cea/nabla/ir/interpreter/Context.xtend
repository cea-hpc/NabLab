package fr.cea.nabla.ir.interpreter

import fr.cea.nabla.ir.ir.Connectivity
import fr.cea.nabla.ir.ir.Iterator
import fr.cea.nabla.ir.ir.IteratorRef
import fr.cea.nabla.ir.ir.VarRefIteratorRef
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
	@Accessors(PUBLIC_GETTER, PRIVATE_SETTER) MeshWrapper meshWrapper

	new()
	{
		this.outerContext = null
		this.connectivitySizes = new HashMap<Connectivity, Integer>
		meshWrapper = null
	}

	new(Context outerContext)
	{
		this.outerContext = outerContext
		this.connectivitySizes = outerContext.connectivitySizes
		meshWrapper = outerContext.meshWrapper
	}

	def initMesh(int nbXQuads, int nbYQuads, double xSize, double ySize)
	{
		meshWrapper = new MeshWrapper(nbXQuads, nbYQuads, xSize, ySize)
	}
	
	def NablaValue getVariableValue(Variable variable)
	{
		variableValues.get(variable) ?: outerContext.getVariableValue(variable)
	}

	def void setVariableValue(Variable variable, NablaValue value)
	{
		variableValues.put(variable, value)
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

	def int getIndexOf(Iterator iterator, int id)
	{
		val container = meshWrapper.getContainer(iterator)
		container.indexOf(id)
	}
	
	def int getSingleton(Iterator iterator)
	{
		val methodName = "get" + iterator.container.connectivity.name.toFirstUpper
		meshWrapper.invokeSingleton(methodName, iterator.container.args.map[getIndexValue(idName)])
	}
}
