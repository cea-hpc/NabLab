/*******************************************************************************
 * Copyright (c) 2018 CEA
 * This program and the accompanying materials are made available under the 
 * terms of the Eclipse Public License 2.0 which is available at
 * http://www.eclipse.org/legal/epl-2.0.
 *
 * SPDX-License-Identifier: EPL-2.0
 * Contributors: see AUTHORS file
 *******************************************************************************/
package fr.cea.nabla.javalib.mesh

import org.eclipse.xtend.lib.annotations.Data

@Data
abstract class NodeIdContainer 
{
	val int[] nodeIds
	
	override toString()
	{
		'[' + nodeIds.join(',') + ']'
	}
}

class Edge extends NodeIdContainer 
{ 
	new(int id1, int id2) { super(#[id1, id2]) }
}

class Quad extends NodeIdContainer 
{
	new(int id1, int id2, int id3, int id4) { super(#[id1, id2, id3, id4]) }
}
