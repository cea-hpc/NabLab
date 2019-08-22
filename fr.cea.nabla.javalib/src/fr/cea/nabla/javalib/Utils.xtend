/*******************************************************************************
 * Copyright (c) 2018 CEA
 * This program and the accompanying materials are made available under the 
 * terms of the Eclipse Public License 2.0 which is available at
 * http://www.eclipse.org/legal/epl-2.0.
 *
 * SPDX-License-Identifier: EPL-2.0
 * Contributors: see AUTHORS file
 *******************************************************************************/
package fr.cea.nabla.javalib

class Utils 
{
	static def indexOf(int[] array, int value) 
	{
		for (int i : 0..<array.length)
			if (array.get(i) == value)
				return i
		throw new Exception("Value '" + value.toString + "' not in array [" + array.map[toString].join(',') + ']')
	}
}