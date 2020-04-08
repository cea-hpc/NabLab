/*******************************************************************************
 * Copyright (c) 2020 CEA
 * This program and the accompanying materials are made available under the
 * terms of the Eclipse Public License 2.0 which is available at
 * http://www.eclipse.org/legal/epl-2.0.
 *
 * SPDX-License-Identifier: EPL-2.0
 * Contributors: see AUTHORS file
 *******************************************************************************/
#ifndef MESH_CARTESIANMESH2DGENERATOR_H_
#define MESH_CARTESIANMESH2DGENERATOR_H_

#include "types/Types.h"

namespace nablalib
{

class CartesianMesh2D;

class CartesianMesh2DGenerator
{
public:
	static CartesianMesh2D* generate(size_t nbXQuads, size_t nbYQuads, double xSize, double ySize);
};

}
#endif /* CARTESIAN_MESH_2D_GENERATOR_H_ */
