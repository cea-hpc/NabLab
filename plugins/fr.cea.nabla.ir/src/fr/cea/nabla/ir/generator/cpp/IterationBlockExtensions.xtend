/*******************************************************************************
 * Copyright (c) 2020 CEA
 * This program and the accompanying materials are made available under the 
 * terms of the Eclipse Public License 2.0 which is available at
 * http://www.eclipse.org/legal/epl-2.0.
 *
 * SPDX-License-Identifier: EPL-2.0
 * Contributors: see AUTHORS file
 *******************************************************************************/
package fr.cea.nabla.ir.generator.cpp

import fr.cea.nabla.ir.ir.Interval
import fr.cea.nabla.ir.ir.Iterator

import static extension fr.cea.nabla.ir.generator.IterationBlockExtensions.*
import static extension fr.cea.nabla.ir.generator.ConnectivityCallExtensions.*

class IterationBlockExtensions
{
	static def dispatch defineInterval(Iterator it, CharSequence innerContent)
	{
		if (container.connectivity.indexEqualId)
			innerContent
		else
		'''
		{
			const auto «container.name»(mesh->«container.accessor»);
			const size_t «nbElems»(«container.name».size());
			«innerContent»
		}
		'''
	}

	static def dispatch defineInterval(Interval it, CharSequence innerContent)
	{
		innerContent
	}
}