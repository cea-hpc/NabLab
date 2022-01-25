"""
 * Copyright (c) 2022 CEA
 * This program and the accompanying materials are made available under the
 * terms of the Eclipse Public License 2.0 which is available at
 * http://www.eclipse.org/legal/epl-2.0.
 * 
 * SPDX-License-Identifier: EPL-2.0
 * Contributors: see AUTHORS file
"""
class MeshGeometry:
    def __init__(self, nodes, edges, quads):
        self.__nodes = nodes
        self.__edges = edges
        self.__quads = quads
    
    @property
    def nodes(self):
        return self.__nodes
    
    @property
    def edges(self):
        return self.__edges
    
    @property
    def quads(self):
        return self.__quads
    
    def dump(self):
        print("MESH GEOMETRY")
        print()
        print("Nodes (" + str(len(self.__nodes)) + "):")
        print(self.__nodes)
        print()
        print("Edges (" + str(len(self.__edges)) + "):")
        print(self.__edges)
        print()
        print("Quads (" + str(len(self.__quads)) + "):")
        print(self.__quads)
        print()
