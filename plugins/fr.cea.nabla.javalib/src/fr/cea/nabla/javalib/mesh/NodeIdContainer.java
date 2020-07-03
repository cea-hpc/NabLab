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

public abstract class NodeIdContainer {
  private int[] nodeIds;
   
  public NodeIdContainer(int[] nodeIds) {
    this.nodeIds = nodeIds;
  }
  
  public int[] getNodeIds() {
    return this.nodeIds;
  }
  
  @Override
  public String toString() {
	  String s = "[";
	  for (int i = 0; i < nodeIds.length; i++)
		  s += nodeIds[i] + (i < nodeIds.length -1 ? "," : "");
	  return s + "]";
  }
}
