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
import fr.cea.nabla.LinearAlgebraUtils
import fr.cea.nabla.nabla.Arg
import fr.cea.nabla.nabla.Connectivity
import fr.cea.nabla.nabla.ConnectivityVar
import fr.cea.nabla.nabla.FunctionOrReduction
import fr.cea.nabla.nabla.Interval
import fr.cea.nabla.nabla.NablaFactory
import fr.cea.nabla.nabla.SimpleVar
import fr.cea.nabla.nabla.SpaceIterator
import fr.cea.nabla.nabla.TimeIterator
import fr.cea.nabla.nabla.VarDeclaration

class ArgOrVarTypeProvider
{
	@Inject extension ArgOrVarExtensions
	@Inject extension BaseTypeTypeProvider
	@Inject extension LinearAlgebraUtils

	def dispatch NablaType getTypeFor(SimpleVar it)
	{
		val c = eContainer
		switch c
		{
			FunctionOrReduction, Interval, SpaceIterator: new NSTIntScalar
			VarDeclaration case c.type !== null:
			{
				if (linearAlgebra)
				{
					// LinearAlgebra -> dimension 1 or 2
					if (dimension == 1)
						new NLATVector(c.type.sizes.get(0))
					else if (dimension == 2)
						new NLATMatrix(c.type.sizes.get(0), c.type.sizes.get(1))
				}
				else
					c.type.typeFor
			}
			default: null
		}
	}

	def dispatch NablaType getTypeFor(ConnectivityVar it)
	{
		println(name + " linearAlebgra ? " + linearAlgebra + " dimension ? " + dimension)
		if (linearAlgebra)
		{
			if (dimension == 1)
				// Dimension == 1 && ConnectivityVar -> dimension = supports.size
				new NLATVector(getCardinality(supports.get(0)))
			else if (dimension == 2)
			{
				if (supports.size > 1)
					new NLATMatrix(getCardinality(supports.get(0)), getCardinality(supports.get(1)))
				else
					new NLATMatrix(getCardinality(supports.get(0)),	type.getSizes.get(0))
			}
		}
		else
			new NablaConnectivityType(supports, type.typeFor)
	}

	private def getCardinality(Connectivity c)
	{
		val connectivityCall = NablaFactory.eINSTANCE.createConnectivityCall => [ connectivity = c ]
		NablaFactory.eINSTANCE.createCardinality => [ container = connectivityCall ]
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