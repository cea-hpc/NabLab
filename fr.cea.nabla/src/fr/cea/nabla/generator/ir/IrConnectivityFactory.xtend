/*******************************************************************************
 * Copyright (c) 2018 CEA
 * This program and the accompanying materials are made available under the 
 * terms of the Eclipse Public License 2.0 which is available at
 * http://www.eclipse.org/legal/epl-2.0.
 *
 * SPDX-License-Identifier: EPL-2.0
 * Contributors: see AUTHORS file
 *******************************************************************************/
package fr.cea.nabla.generator.ir

import com.google.inject.Inject
import com.google.inject.Singleton
import fr.cea.nabla.ir.ir.IrFactory
import fr.cea.nabla.nabla.Connectivity

/**
 * Attention : cette classe doit être un singleton car elle utilise des méthodes create.
 * Si elle n'est pas singleton, plusieurs instances d'un même objet seront créées lors
 * deu parcours du graphe d'origine (voir la documentation Xtext).
 */
@Singleton
class IrConnectivityFactory 
{
	@Inject extension Nabla2IrUtils
	@Inject extension IrAnnotationHelper

	def create IrFactory::eINSTANCE.createConnectivity toIrConnectivity(Connectivity c)
	{
		annotations += c.toIrAnnotation
		name = c.name
		returnType = c.returnType.toIrItemArgType
		inTypes += c.inTypes.map[toIrItemType]
	}	
}