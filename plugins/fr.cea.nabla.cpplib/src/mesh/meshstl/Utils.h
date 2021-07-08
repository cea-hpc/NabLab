/*******************************************************************************
 * Copyright (c) 2021 CEA
 * This program and the accompanying materials are made available under the
 * terms of the Eclipse Public License 2.0 which is available at
 * http://www.eclipse.org/legal/epl-2.0.
 *
 * SPDX-License-Identifier: EPL-2.0
 * Contributors: see AUTHORS file
 *******************************************************************************/
#ifndef _UTILS_H_
#define _UTILS_H_

#include <vector>
#include <algorithm>

#include "CartesianMesh2D.h"
#include "MeshGeometry.h"

using namespace std;

template <class T>
std::ostream& operator<< (std::ostream& out, const std::vector<T>& v) 
{
	out << "[";
	size_t last = v.size() - 1;
	for(size_t i = 0; i < v.size(); ++i) 
	{
		out << v[i];
		if (i != last) out << ", ";
	}
	out << "]";
	return out;
}

std::ostream& operator<< (std::ostream& out, const std::array<double, 2>& v)
{
	out << "[" << v[0] << "," << v[1] << "]";
	return out;
}

template<size_t N>
std::ostream& operator<< (std::ostream& out, MeshGeometry<N>* mg)
{
	out << "Mesh Geometry" << endl;
	out << "  nodes (" << mg->getNodes().size() << ") : " << mg->getNodes() << endl;
	out << "  edges (" << mg->getEdges().size() << ") : " << mg->getEdges() << endl;
	out << "  quads (" << mg->getQuads().size() << ") : " << mg->getQuads() << endl;
	return out;
}

std::ostream& operator<< (std::ostream& out, CartesianMesh2D* cm)
{
	out << cm->getGeometry();
	out << "Mesh Topology" << endl;
	out << "  inner nodes  : " << cm->getInnerNodes() << endl;
	out << "  top nodes    : " << cm->getTopNodes() << endl;
	out << "  bottom nodes : " << cm->getBottomNodes() << endl;
	out << "  left nodes   : " << cm->getLeftNodes() << endl;
	out << "  right nodes  : " << cm->getRightNodes() << endl;
	out << "  outer faces  : " << cm->getOuterFaces() << endl;
	return out;
}

#endif /* _MESHGEOMETRY_H_ */
