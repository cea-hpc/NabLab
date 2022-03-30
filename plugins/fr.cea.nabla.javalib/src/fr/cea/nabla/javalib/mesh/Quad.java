/**
 * Copyright (c) 2022 CEA
 * This program and the accompanying materials are made available under the
 * terms of the Eclipse Public License 2.0 which is available at
 * http://www.eclipse.org/legal/epl-2.0.
 * 
 * SPDX-License-Identifier: EPL-2.0
 * Contributors: see AUTHORS file
 */
package fr.cea.nabla.javalib.mesh;

public class Quad extends NodeIdContainer
{
	public Quad( int id1,  int id2,  int id3,  int id4)
	{
		super(new int[] { id1, id2, id3, id4 });
	}
}
