/*******************************************************************************
 * Copyright (c) 2018 CEA
 * This program and the accompanying materials are made available under the
 * terms of the Eclipse Public License 2.0 which is available at
 * http://www.eclipse.org/legal/epl-2.0.
 *
 * SPDX-License-Identifier: EPL-2.0
 * Contributors: see AUTHORS file
 *******************************************************************************/
#ifndef CARTESIAN_MESH_2D_GENERATOR_H_
#define CARTESIAN_MESH_2D_GENERATOR_H_

#include "types/Types.h"

namespace nablalib
{

template<size_t N>
class Mesh;

class CartesianMesh2DGenerator
{
public:
	static Mesh<2>* generate(int nbXQuads, int nbYQuads, double xSize, double ySize);
};

}
#endif /* CARTESIAN_MESH_2D_GENERATOR_H_ */
