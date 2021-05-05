/*******************************************************************************
 * Copyright (c) 2021 CEA
 * This program and the accompanying materials are made available under the 
 * terms of the Eclipse Public License 2.0 which is available at
 * http://www.eclipse.org/legal/epl-2.0.
 *
 * SPDX-License-Identifier: EPL-2.0
 * Contributors: see AUTHORS file
 *******************************************************************************/
package fr.cea.nabla.validation

import fr.cea.nabla.typing.NSTBoolScalar
import fr.cea.nabla.typing.NSTIntScalar
import fr.cea.nabla.typing.NablaType

class ValidationUtils
{
	public static val BOOL = new NSTBoolScalar
	public static val INT = new NSTIntScalar

	def checkExpectedType(NablaType actualType, NablaType expectedType)
	{
		// si un des 2 types est indéfini, il ne faut rien vérifier pour éviter les erreurs multiples due à la récursion
		return (actualType === null || expectedType === null || actualType == expectedType)
	}

	def getTypeMsg(String actualType, String expectedType) { "Expected " + expectedType + " type, but was " + actualType }
}