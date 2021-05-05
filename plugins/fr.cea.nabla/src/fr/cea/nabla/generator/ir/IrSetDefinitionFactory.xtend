/*******************************************************************************
 * Copyright (c) 2021 CEA
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
import fr.cea.nabla.nabla.ItemSet

@Singleton
class IrSetDefinitionFactory
{
	@Inject extension IrAnnotationHelper
	@Inject extension IrContainerFactory

	def create IrFactory::eINSTANCE.createSetDefinition toIrSetDefinition(ItemSet sd)
	{
			annotations += sd.toIrAnnotation
			name = sd.name
			value = sd.value.toIrConnectivityCall
	}
}