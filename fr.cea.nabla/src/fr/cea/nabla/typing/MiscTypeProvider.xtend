/*******************************************************************************
 * Copyright (c) 2018 CEA
 * This program and the accompanying materials are made available under the 
 * terms of the Eclipse Public License 2.0 which is available at
 * http://www.eclipse.org/legal/epl-2.0.
 *
 * SPDX-License-Identifier: EPL-2.0
 * Contributors: see AUTHORS file
 *******************************************************************************/
package fr.cea.nabla.typing

import com.google.inject.Inject
import fr.cea.nabla.VarExtensions
import fr.cea.nabla.nabla.BaseType
import fr.cea.nabla.nabla.Connectivity
import fr.cea.nabla.nabla.PrimitiveType
import fr.cea.nabla.nabla.Var

class MiscTypeProvider
{
	@Inject extension VarExtensions
	
 	def AbstractType getTypeFor(PrimitiveType it)
	{
		switch it
		{
			case INT: new IntType(#[])
			case REAL: new RealType(#[])
			case BOOL: new BoolType(#[])
		}
	}

	def AbstractType getTypeFor(BaseType it) { getTypeFor(root, #[], sizes) }
	
	def AbstractType getTypeFor(Var it)
	{
		getTypeFor(baseType.root, dimensions, baseType.sizes)
	}
	
	def AbstractType getTypeFor(PrimitiveType t, Connectivity[] connectivities, int[] baseTypeSizes)
	{
		switch t
		{	
			case BOOL: if (baseTypeSizes.empty) new BoolType(connectivities) else new UndefinedType
			case INT: if (baseTypeSizes.empty) new IntType(connectivities) else new IntArrayType(connectivities, baseTypeSizes)
			case REAL: if (baseTypeSizes.empty) new RealType(connectivities) else new RealArrayType(connectivities, baseTypeSizes)
		}
	}
}
