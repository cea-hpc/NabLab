package fr.cea.nabla.ir

import fr.cea.nabla.ir.ir.IrModule
import fr.cea.nabla.ir.ir.ConnectivityVariable
import fr.cea.nabla.ir.ir.ConnectivityCall

class IrModuleExtensions
{
	static def getJobByName(IrModule it, String jobName)
	{
		jobs.findFirst[j | j.name == jobName]
	}

	/**
	 * Retourne la liste des connectivités utilisées par le module,
	 * lors de la déclaration des variables ou des itérateurs.
	 */
	static def getUsedConnectivities(IrModule it)
	{
		// connectivités nécessaires pour les variables
		val connectivities = variables.filter(ConnectivityVariable).map[type.connectivities].flatten.toSet
		// connectivités utilisées dans le code
		jobs.forEach[j | connectivities += j.eAllContents.filter(ConnectivityCall).map[connectivity].toSet]

		return connectivities.filter[c | c.returnType.multiple]
	}
	
	static def getVariableByName(IrModule it, String varName)
	{
		variables.findFirst[j | j.name == varName]
	}
}
