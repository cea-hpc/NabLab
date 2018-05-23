#ifndef PARALLEL_NUMERIC_MESH_2D_H_
#define PARALLEL_NUMERIC_MESH_2D_H_

// GMDS headers
#include <KM/DS/Mesh.h>
#include <KM/Utils/KTypes.h>

using namespace kmds;

namespace nablalib
{
	class ParallelNumericMesh2D : public Mesh
	{
	public:
		ParallelNumericMesh2D() {}

//		Mesh* getGeometricMesh() { return m_mesh; }
//		TSize getNbNodes() { return getNbNodes(); }
		TSize getNbCells() const { return Mesh::getNbFaces(); }
		TSize getNbFaces() const { return getNbEdges(); }

		static const int MaxNbNodesPerCell = 4;
		static const int MaxNbNodesPerFaces = 2;

		void getNodesOfCell(const TCellID AId, Kokkos::View<TCellID*>& AV)
		{
			getFace(AId).nodeIds(AV);
		}

		void getNodesOfFace(const TCellID AId, Kokkos::View<TCellID*>& AV)
		{
			getEdge(AId).nodeIds(AV);
		}

		void getNeighbourCells(const TCellID AId, Kokkos::View<TCellID*>& AV)
		{
			Kokkos::View<TCellID*> nodesOfCell;
			getNodesOfCell(AId, nodesOfCell);

			std::vector<TCellID> neighbourCells;
			// parcours des noeuds de la maille pour trouver les mailles adjacentes
			for (auto i_n = 0; i_n < nodesOfCell.size(); i_n++)
			{
				TCellID nodeId = nodesOfCell(i_n);
				Kokkos::View<TCellID*> adjacentCells;
				getNode(nodeId).faceIds(adjacentCells);
				for (auto i_ac = 0; i_ac < adjacentCells.size(); i_ac++)
				{
					TCellID adjacentCellId = adjacentCells(i_ac);
					if (adjacentCellId != AId)
					{
						// la maille adjacente n'est voisine que si elle a 2 noeuds en commun
						Kokkos::View<TCellID*> nodesOfAdjacentCell;
						getNodesOfCell(adjacentCellId, nodesOfAdjacentCell);
						if (getNbCommonIds(nodesOfCell, nodesOfAdjacentCell) == 2)
							neighbourCells.push_back(adjacentCellId);
					}
				}
			}

			resize(AV, neighbourCells.size());
			for (auto i=0 ; i<neighbourCells.size() ; ++i) AV(i) = neighbourCells[i];
		}

		TCellID getCommonFace(const TCellID AId1, const TCellID AId2)
		{
			//TODO connectivité kmds ?
			Kokkos::View<TCellID*> facesOfCell1;
//			getFace(AId1).edgeIds(facesOfCell1);

			Kokkos::View<TCellID*> facesOfCell2;
//			getFace(AId1).edgeIds(facesOfCell2);

			return -1;
		}

	private:
		int getNbCommonIds(Kokkos::View<TCellID*>& Aa, Kokkos::View<TCellID*>& Ab)
		{
			int nbCommonIds = 0;
			for (auto i_a = 0; i_a < Aa.size(); i_a++)
			{
				TCellID a = Aa(i_a);
				for (auto i_b = 0; i_b < Ab.size(); i_b++)
				{
					TCellID b = Ab(i_b);
					if (a == b) nbCommonIds++;
				}
			}
			return nbCommonIds;
		}

	};
}



#endif /* PARALLEL_NUMERIC_MESH_2D_H_ */
