/*******************************************************************************
 * Copyright (c) 2020 CEA
 * This program and the accompanying materials are made available under the 
 * terms of the Eclipse Public License 2.0 which is available at
 * http://www.eclipse.org/legal/epl-2.0.
 *
 * SPDX-License-Identifier: EPL-2.0
 * Contributors: see AUTHORS file
 *******************************************************************************/
package fr.cea.nabla.typing

import com.google.inject.Inject
import fr.cea.nabla.ArgOrVarExtensions
import fr.cea.nabla.nabla.Arg
import fr.cea.nabla.nabla.ConnectivityVar
import fr.cea.nabla.nabla.SimpleVar
import fr.cea.nabla.nabla.TimeIterator

class VarTypeProvider
{
	@Inject extension ArgOrVarExtensions
	@Inject extension BaseTypeTypeProvider

	def dispatch NablaType getTypeFor(SimpleVar it)
	{
		type.typeFor
	}

	def dispatch NablaType getTypeFor(ConnectivityVar it)
	{
		new NablaConnectivityType(supports, type.typeFor)
	}

	def dispatch NablaType getTypeFor(Arg it)
	{
		type.typeFor
	}

	def dispatch NablaType getTypeFor(TimeIterator it)
	{
		new NSTIntScalar
	}
}