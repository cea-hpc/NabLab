/*******************************************************************************
 * Copyright (c) 2021 CEA
 * This program and the accompanying materials are made available under the 
 * terms of the Eclipse Public License 2.0 which is available at
 * http://www.eclipse.org/legal/epl-2.0.
 *
 * SPDX-License-Identifier: EPL-2.0
 * Contributors: see AUTHORS file
 *******************************************************************************/
package fr.cea.nabla.typing

import fr.cea.nabla.nabla.PrimitiveType

class PrimitiveTypeTypeProvider
{
 	def NablaSimpleType getTypeFor(PrimitiveType it)
	{
		switch it
		{
			case INT: new NSTIntScalar
			case REAL: new NSTRealScalar
			case BOOL: new NSTBoolScalar
		}
	}
}
