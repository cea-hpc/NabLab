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
import fr.cea.nabla.nabla.FunctionOrReduction
import fr.cea.nabla.nabla.Interval
import fr.cea.nabla.nabla.SimpleVar
import fr.cea.nabla.nabla.SimpleVarDefinition
import fr.cea.nabla.nabla.SpaceIterator
import fr.cea.nabla.nabla.TimeIterator
import fr.cea.nabla.nabla.VarGroupDeclaration

class ArgOrVarTypeProvider
{
	@Inject extension ArgOrVarExtensions
	@Inject extension BaseTypeTypeProvider

	def dispatch NablaType getTypeFor(SimpleVar it)
	{
		val c = eContainer
		switch c
		{
			FunctionOrReduction, Interval, SpaceIterator: new NSTIntScalar
			SimpleVarDefinition case c.type !== null: c.type.typeFor
			VarGroupDeclaration case c.type !== null: c.type.typeFor
			default: null
		}
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