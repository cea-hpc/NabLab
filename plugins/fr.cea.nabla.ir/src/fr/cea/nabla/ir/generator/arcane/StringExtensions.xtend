/*******************************************************************************
 * Copyright (c) 2022 CEA
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
		if (contains(fr.cea.nabla.ir.generator.arcane.StringExtensions.LowerCase))
			// chaine de la forme mon_nom 
			replace(fr.cea.nabla.ir.generator.arcane.StringExtensions.LowerCase, separator).toLowerCase
		else 
			// chaine de la forme monNom
			Character::toLowerCase(charAt(0)) + toCharArray.tail.map[c | if (Character::isUpperCase(c)) separator + Character::toLowerCase(c) else c  ].join
	}

	/** Convert a string using '_' as separator to camel case string, i.e. my_pty_name -> myPtyName */
	static def separateWithUpperCase(String it) 
	{
		val l = split(LowerCase)
		if (l.size == 1) toFirstLower
		else l.map[t | t.toLowerCase.toFirstUpper].join.toFirstLower
	}
}