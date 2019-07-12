/*******************************************************************************
 * Copyright (c) 2018 CEA
 * This program and the accompanying materials are made available under the 
 * terms of the Eclipse Public License 2.0 which is available at
 * http://www.eclipse.org/legal/epl-2.0.
 *
 * SPDX-License-Identifier: EPL-2.0
 *
 * Contributors:
 * 	Benoit Lelandais - initial implementation
 * 	Marie-Pierre Oudot - initial implementation
 * 	Jean-Sylvain Camier - Nabla generation support
 *******************************************************************************/
package fr.cea.nabla.ir.transformers

import fr.cea.nabla.ir.ir.IrFactory
import fr.cea.nabla.ir.ir.IrModule
import fr.cea.nabla.ir.ir.SimpleVariable

class ReplaceDefaultValues implements IrTransformationStep
{
	override getDescription() 
	{
		'Replace global variables default values by initialization jobs'
	}
	
	/**
	 * Transforme le module m pour qu'il n'y ait plus de variable avec des valeurs par défaut.
	 * Les variables sont initialisées dans des jobs d'initialisation.
	 */
	override transform(IrModule m)
	{
		for (v : m.variables.filter(SimpleVariable).filter[x|!x.const && x.defaultValue!==null])
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
		return true
	}
	
	override getOutputTraces() 
	{
		#[]
	}
}