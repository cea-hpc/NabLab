/*******************************************************************************
 * Copyright (c) 2020 CEA
 * This program and the accompanying materials are made available under the 
 * terms of the Eclipse Public License 2.0 which is available at
 * http://www.eclipse.org/legal/epl-2.0.
 *
 * SPDX-License-Identifier: EPL-2.0
 * Contributors: see AUTHORS file
 *******************************************************************************/
package fr.cea.nabla.overloading

import fr.cea.nabla.nabla.Reduction
import fr.cea.nabla.typing.NablaSimpleType
import org.eclipse.xtend.lib.annotations.Data

@Data
class ReductionDeclaration
{
	val Reduction model
	val NablaSimpleType type // no reduction on ConnectivityVar => SimpleType only
}
