/**
 * Copyright (c) 2020 CEA
 * This program and the accompanying materials are made available under the
 * terms of the Eclipse Public License 2.0 which is available at
 * http://www.eclipse.org/legal/epl-2.0.
 * 
 * SPDX-License-Identifier: EPL-2.0
 * Contributors: see AUTHORS file
 */
package fr.cea.nabla.javalib.mesh;

public class Utils 
{
	public static int indexOf( int[] array,  int value)
	{
		String arrayContent = "";
		for (int i = 0; i < array.length; i++)
		{
			arrayContent += array[i];
			if (i < array.length -1)
				arrayContent += ",";
			if (array[i] == value)
				return i;
		}

		throw new RuntimeException("Value '" + value + "' not in array [" + arrayContent + "]");
	}
}
