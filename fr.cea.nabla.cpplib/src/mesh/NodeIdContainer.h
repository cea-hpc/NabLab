/*******************************************************************************
 * Copyright (c) 2018 CEA
 * This program and the accompanying materials are made available under the 
 * terms of the Eclipse Public License 2.0 which is available at
 * http://www.eclipse.org/legal/epl-2.0.
 *
 * SPDX-License-Identifier: EPL-2.0
 *
 * Contributors:
 * 	Benoit Lelandais - initial implementation
 * 	Marie-Pierre Oudot - initial implementation
 * 	Jean-Sylvan Camier - Nabla generation support
 *******************************************************************************/
#ifndef MESH_NODEIDCONTAINER_H_
#define MESH_NODEIDCONTAINER_H_

#include <vector>
#include <iostream>

using namespace std;

namespace nablalib
{

class NodeIdContainer
{
public:
	const vector<int>& getNodeIds() const { return m_nodeIds; }
	virtual ~NodeIdContainer() {};
	friend ostream& operator <<(ostream& s, const NodeIdContainer& x)
	{
		if (x.m_nodeIds.size() > 0)
		{
			s << "[" << x.m_nodeIds[0];
			for (int i=1; i< x.m_nodeIds.size();  i++)
				s << ", " << x.m_nodeIds[i];
			s << "]";
		}
		return s;
	}

protected:
	NodeIdContainer(int nbNodes) : m_nodeIds(nbNodes) {};
	vector<int> m_nodeIds;
};

struct Edge : public NodeIdContainer
{
	Edge()
	: NodeIdContainer(2)
	{}

	Edge(const Edge& e)
	: NodeIdContainer(2)
	{
		m_nodeIds[0] = e.m_nodeIds[0];
		m_nodeIds[1] = e.m_nodeIds[1];
	}

	Edge(int id1, int id2)
	: NodeIdContainer(2)
	{
		m_nodeIds[0] = id1;
		m_nodeIds[1] = id2;
	}
};

struct Quad : public NodeIdContainer
{
	Quad()
	: NodeIdContainer(4)
	{}

	Quad(const Quad& q)
	: NodeIdContainer(4)
	{
		m_nodeIds[0] = q.m_nodeIds[0];
		m_nodeIds[1] = q.m_nodeIds[1];
		m_nodeIds[2] = q.m_nodeIds[2];
		m_nodeIds[3] = q.m_nodeIds[3];
	}

	Quad(int id1, int id2, int id3, int id4)
	: NodeIdContainer(4)
	{
		m_nodeIds[0] = id1;
		m_nodeIds[1] = id2;
		m_nodeIds[2] = id3;
		m_nodeIds[3] = id4;
	}
};

}
#endif /* MESH_NODEIDCONTAINER_H_ */
