package fr.cea.nabla.ir

import fr.cea.nabla.ir.ir.IrFactory
import fr.cea.nabla.ir.ir.IrModule
import fr.cea.nabla.ir.ir.ScalarVariable

class Ir2IrNoDefaultValue implements Ir2IrPass
{
	override getDescription() 
	{
		'Replacing global variables default values by initialization jobs'
	}
	
	/**
	 * Transforme le module m pour qu'il n'y ait plus de variable avec des valeurs par défaut.
	 * Les variables sont initialisées dans des jobs d'initialisation.
	 */
	override transform(IrModule m)
	{
		for (v : m.variables.filter(ScalarVariable).filter[x|!x.const && x.defaultValue!==null])
		{
			m.jobs += IrFactory::eINSTANCE.createInstructionJob =>
			[
				annotations.addAll(v.defaultValue.annotations)
				name = 'Init_' + v.name
				instruction = IrFactory::eINSTANCE.createAffectation =>
				[
					left = IrFactory::eINSTANCE.createVarRef => [ variable = v ]
					operator = '='
					right = v.defaultValue
				]
			]
		}
	}	
}