package fr.cea.nabla.ir.transformers

import fr.cea.nabla.ir.ir.IrModule
import java.util.Properties

/**
 * Attend des propriétés de type <nom_de_variable> = <nom_de_persistence>.
 * Le <nom_de_variable> représente lae nom de la vraible du code.
 * Le <nom_de_persistence> représente un alias qui sera généralement donné en dépouillement. 
 */
class TagPersistentVariables implements IrTransformationStep 
{
	val Properties variables
	
	new(Properties variables)
	{
		this.variables = variables
	}
	
	override getDescription() 
	{
		'Tag variables as persistent'
	}
	
	override transform(IrModule m) 
	{
		for (key : variables.stringPropertyNames)
		{
			val v = m.variables.findFirst[x | x.name == key]
			if (v !== null) 
			{
				v.persist = true
				v.persistenceName = variables.getProperty(key)
			}
		}
	}
}