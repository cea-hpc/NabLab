/*******************************************************************************
 * Copyright (c) 2020 CEA
 * This program and the accompanying materials are made available under the
 * terms of the Eclipse Public License 2.0 which is available at
 * http://www.eclipse.org/legal/epl-2.0.
 *
 * SPDX-License-Identifier: EPL-2.0
 * Contributors: see AUTHORS file
 *******************************************************************************/
#ifndef MESH_CARTESIANMESH2DFACTORY_H_
#define MESH_CARTESIANMESH2DFACTORY_H_

#include <rapidjson/document.h>
#include "types/Types.h"

namespace nablalib
{

class CartesianMesh2D;

class CartesianMesh2DFactory
{
public:
	void jsonInit(const rapidjson::Value& json);
	CartesianMesh2D* create();

private:
	size_t nbXQuads;
	size_t nbYQuads;
	double xSize;
	double ySize;
};

}
#endif /* MESH_CARTESIANMESH2DFACTORY_H_ */
