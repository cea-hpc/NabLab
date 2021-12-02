/*******************************************************************************
 * Copyright (c) 2021 CEA
 * This program and the accompanying materials are made available under the
 * terms of the Eclipse Public License 2.0 which is available at
 * http://www.eclipse.org/legal/epl-2.0.
 *
 * SPDX-License-Identifier: EPL-2.0
 * Contributors: see AUTHORS file
 *******************************************************************************/
package fr.cea.nabla.ir.generator.arcane

import fr.cea.nabla.ir.ir.IrModule

/**
 * @TODO IR transformation step to rename Arcane reserved variables like NodeCoord
 * @TODO What about item types? Fixed in NabLab ? Mapping Arcane ?
 * @TODO Linear Algebra with Alien
 * @TODO Comments in .n file generated in code (Doxygen) and AXL description field
 * @TODO Is there a way to enter an array in AXL (not only with min/max occurs) ?
 * @TODO Support module coupling
 * @TODO Support composed time loops: n + m
 * @TODO What happens if levelDB asked ?
 */
class ArcaneUtils
{
	static def getModuleName(IrModule it)
	{
		name.toFirstUpper + "Module"
	}
}