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
 * 	Jean-Sylvan Camier - Nabla generation support
 *******************************************************************************/
package fr.cea.nabla.ir.generator.kokkos

import com.google.inject.Inject
import fr.cea.nabla.ir.ir.ArrayVariable
import fr.cea.nabla.ir.ir.ScalarVariable

class VariableExtensions 
{
	@Inject extension Ir2KokkosUtils

	def dispatch getKokkosType(ScalarVariable it) 
	{ 
		type.kokkosType
	}
	
	def dispatch getKokkosType(ArrayVariable it)
	{
		var t = getType.kokkosType
		return t
	}

	def getKokkosAllocation(ArrayVariable it)
	'''//mesh.createVariable<«kokkosType»>(kmds::KMDS_CELL, "«name»")'''
}