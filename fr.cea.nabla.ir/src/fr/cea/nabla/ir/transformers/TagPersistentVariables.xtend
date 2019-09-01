package fr.cea.nabla.ir.transformers

import fr.cea.nabla.ir.ir.ConnectivityVariable
import fr.cea.nabla.ir.ir.IrModule
import java.util.HashMap
import fr.cea.nabla.ir.ir.IrFactory

/**
 * Attend des propriétés de type <nom_de_variable> = <nom_de_persistence>.
 * Le <nom_de_variable> représente lae nom de la vraible du code.
 * Le <nom_de_persistence> représente un alias qui sera généralement donné en dépouillement. 
 */
class TagPersistentVariables implements IrTransformationStep 
{
	val HashMap<String, String> variables
	
	new(HashMap<String, String> variables)
	{
		this.variables = variables
	}
	
	override getDescription() 
	{
		'Tag variables as persistent'
	}
	
	override transform(IrModule m) 
	{
		val candidates = m.variables.filter(ConnectivityVariable)
		val inSituJob = IrFactory.eINSTANCE.createInSituJob => [ name = 'dumpVariables' ]
		for (key : variables.keySet)
		{
			val v = candidates.findFirst[x | x.name == key]
			if (v !== null) 
			{
				v.persistenceName = variables.get(key)
				inSituJob.variables += v	
			}
		}
		m.jobs += inSituJob
		return true
	}
	
	override getOutputTraces() 
	{
		#[]
	}
}