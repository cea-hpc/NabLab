package fr.cea.nabla.ir.generator

import fr.cea.nabla.ir.ir.ArrayVariable
import fr.cea.nabla.ir.ir.Connectivity
import fr.cea.nabla.ir.ir.IrModule
import fr.cea.nabla.ir.ir.Iterator
import fr.cea.nabla.ir.ir.IteratorRef
import fr.cea.nabla.ir.ir.Job
import fr.cea.nabla.ir.ir.Loop
import org.eclipse.emf.ecore.EObject

import static extension fr.cea.nabla.ir.JobExtensions.*

class Utils 
{
	def getDimension() { 2 }
	def getVarName(Iterator it) { name + connectivityName.toFirstUpper }
	def getConnectivityName(Iterator it) { range.connectivity.name }
	def getItemType(Iterator it) { range.connectivity.returnType.type }
	def prev(String s) { 'prev' + s.toFirstUpper }
	def next(String s) { 'next' + s.toFirstUpper }
	def getNbElems(Connectivity it) { 'nb' + name.toFirstUpper}
	
	def indexToId(Iterator i, String indexName)
	{
		if (i.range.connectivity.indexEqualId) indexName
		else i.connectivityName + '[' + indexName + ']'
	}
	
	def idToIndex(Connectivity c, String idName)
	{
		if (c.indexEqualId) idName
		else c.name + '.indexOf(' + idName + ')'
	}

	def getComment(Job it)
	'''
		/**
		 * Job «name» @«at»
		 * In variables: «FOR v : inVars SEPARATOR ', '»«v.getName»«ENDFOR»
		 * Out variables: «FOR v : outVars SEPARATOR ', '»«v.getName»«ENDFOR»
		 */
	'''	

	/**
	 * Retourne la liste des connectivités utilisées par le module,
	 * lors de la déclaration des variables ou des itérateurs.
	 */
	def getUsedConnectivities(IrModule it)
	{
		// connectivités nécessaires pour les variables
		val connectivities = variables.filter(ArrayVariable).map[dimensions].flatten.toSet
		// connectivités utilisées par les itérateurs
		jobs.forEach[j | connectivities += j.eAllContents.filter(Iterator).map[range.connectivity].toSet]

		return connectivities
	}
	
	def boolean isTopLevelLoop(EObject it)
	{
		if (eContainer === null) false
		else if (eContainer instanceof Loop) false
		else if (eContainer instanceof Job) true
		else eContainer.topLevelLoop	
	}
	
	def prefix(IteratorRef it, String name)
	{
		if (prev) 'prev' + name.toFirstUpper
		else if (next) 'next' + name.toFirstUpper
		else name
	}
}