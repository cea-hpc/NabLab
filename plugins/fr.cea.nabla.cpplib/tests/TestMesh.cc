/*******************************************************************************
 * Copyright (c) 2020 CEA
 * This program and the accompanying materials are made available under the
 * terms of the Eclipse Public License 2.0 which is available at
 * http://www.eclipse.org/legal/epl-2.0.
 *
 * SPDX-License-Identifier: EPL-2.0
 * Contributors: see AUTHORS file
 *******************************************************************************/

#include "mesh/CartesianMesh2DGenerator.h"
#include "mesh/CartesianMesh2D.h"
#include "mesh/Utils.h"

int main()
{
	int nbXQuads = 4;
	int nbYQuads = 3;
	double xSize = 5.0;
	double ySize = 10.0;
	auto mesh = nablalib::CartesianMesh2DGenerator::generate(nbXQuads, nbYQuads, xSize, ySize);
	std::cout << mesh << std::endl;
	return 0;
}
