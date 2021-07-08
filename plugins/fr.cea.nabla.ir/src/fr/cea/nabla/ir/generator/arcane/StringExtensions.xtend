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

class StringExtensions
{
	public static val LowerCase = '_'
	public static val Dash = '-'

	static def separateWith(String it, String separator) 
	{ 
		if (contains(LowerCase))
			// chaine de la forme mon_nom 
			replace(LowerCase, separator).toLowerCase
		else 
			// chaine de la forme monNom
			Character::toLowerCase(charAt(0)) + toCharArray.tail.map[c | if (Character::isUpperCase(c)) separator + Character::toLowerCase(c) else c  ].join
	}
}