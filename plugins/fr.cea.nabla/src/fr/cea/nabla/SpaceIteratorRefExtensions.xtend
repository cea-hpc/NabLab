/*******************************************************************************
 * Copyright (c) 2021 CEA
 * This program and the accompanying materials are made available under the
 * terms of the Eclipse Public License 2.0 which is available at
 * http://www.eclipse.org/legal/epl-2.0.
 *
 * SPDX-License-Identifier: EPL-2.0
 * Contributors: see AUTHORS file
 *******************************************************************************/
package fr.cea.nabla

import fr.cea.nabla.nabla.SpaceIteratorRef

class SpaceIteratorRefExtensions
{
	static def getShift(SpaceIteratorRef it)
	{
		if (dec > 0) -dec
		else if (inc > 0) inc
		else 0
	}

	static def getName(SpaceIteratorRef it)
	{
		if (dec > 0) target.name + 'Minus' + dec
		else if (inc > 0) target.name + 'Plus' + inc
		else target.name
	}
}

