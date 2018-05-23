#ifndef MESH_NODEIDCONTAINER_H_
#define MESH_NODEIDCONTAINER_H_

#include <vector>
#include <iostream>

class NodeIdContainer
{
public:
	const vector<int>& getNodeIds() const { return m_nodeIds; }
	virtual ~NodeIdContainer() {};
	friend ostream& operator <<(ostream& s, const string& x)
	{
		if (m_nodeIds.size > 0)
		{
			s << "[" << m_nodeIds[0];
			for (int i=1; i< m_nodeIds.size;  i++)
				s << ", " << m_nodeIds[i];
			s << "]";
		}
		return s;
	}

protected:
	NodeIdContainer() {};
	vector<int> m_nodeIds;
};

class Edge : public NodeIdContainer
{
	Edge(int id1, int id2)
	: m_nodeIds(2)
	{
		m_nodeIds[0] = id1;
		m_nodeIds[1] = id2;
	}
};

class Quad : public NodeIdContainer
{
	Quad(int id1, int id2, int id3, int id4)
	: m_nodeIds(4)
	{
		m_nodeIds[0] = id1;
		m_nodeIds[1] = id2;
		m_nodeIds[2] = id3;
		m_nodeIds[3] = id4;
	}
};

#endif /* MESH_NODEIDCONTAINER_H_ */
