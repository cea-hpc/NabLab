#ifndef MESH_MESH_H_
#define MESH_MESH_H_

#include <vector.h>

// Kokkos headers
#include <Kokkos_Core.hpp>

#include "mesh/NodeIdContainer.h"

using namespace Kokkos;

namespace nablalib
{
	template<class T>
	class Mesh
	{
	public:
		Mesh();
		virtual ~Mesh();

		void getQuadIdsOfNode(int nodeId)
		{
			int size = quads.filter[q|q.nodeIds.contains(nodeId)].size
					val candidateQuadIds = newIntArrayOfSize(size)
					var int quadId = 0
					var int candidateQuadId = 0
					for (q : quads)
					{
						if (q.nodeIds.contains(nodeId))
						{
							candidateQuadIds.set(candidateQuadId, quadId)
							candidateQuadId++
						}
						quadId++
					}
					return candidateQuadIds
		}

	private:
		View<T> m_nodes;
		vector<Edge> m_edges;
		m_quads;
		m_innerNodeIds;

};

}
#endif /* MESH_MESH_H_ */
