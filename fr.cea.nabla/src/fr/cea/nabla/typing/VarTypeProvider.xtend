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
package fr.cea.nabla.typing

import com.google.inject.Inject
import fr.cea.nabla.VarExtensions
import fr.cea.nabla.nabla.ArrayVar
import fr.cea.nabla.nabla.ScalarVar

class VarTypeProvider 
{
	@Inject extension VarExtensions
	
	def dispatch NablaType getTypeFor(ScalarVar it) 
	{ 
		new NablaType(basicType, 0)
	}
	
	def dispatch NablaType getTypeFor(ArrayVar it) 
	{ 
		new NablaType(basicType, dimensions.length)
	}
}
