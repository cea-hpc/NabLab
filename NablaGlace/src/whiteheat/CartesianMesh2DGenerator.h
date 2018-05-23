#ifndef CARTESIAN_MESH_2D_GENERATOR_H_
#define CARTESIAN_MESH_2D_GENERATOR_H_

#include <KM/DS/Mesh.h>

namespace nablalib
{
	class CartesianMesh2DGenerator
	{
	public:
		static void generate(kmds::Mesh* AMesh, int nbXQuads, int nbYQuads, double xSize, double ySize)
		{

	        const int nb_x = nbXQuads + 1; 	// nbNodesX
	        const int nb_y = nbYQuads + 1; 	// nbNodesY
	        const int nb_z = 1; 			// nbNodesZ
	        const int nb_i = nbXQuads;		// nbQuadsX
	        const int nb_j = nbYQuads;		// nbQuadsY

	        AMesh->updateNodeCapacity(nb_x*nb_y);
	        AMesh->updateFaceCapacity(nb_i*nb_j);

	        int indexNode = AMesh->addNodes(nb_x*nb_y*nb_z);
            for(int j=0; j<nb_y; j++) {
            	for(int i=0; i<nb_x; i++) {
	                AMesh->setNodeLocation(indexNode,xSize*i,ySize*j,0.);
	                // inner Nodes ?
	                indexNode++;
	            }
	        }


            kmds::TCellID indexCell = AMesh->addQuads(nb_i*nb_j);
			for(int i=0; i<nb_i; i++) 
			{
				for(int j=0; j<nb_j; j++) 
				{
					kmds::Face q = AMesh->getFace(indexCell);
					kmds::TCellID v[4];
					v[0] = i*nb_y + j;
					v[1] = (i+1)*nb_y + j;
					v[2] = (i+1)*nb_y + j+1;
					v[3] = i*nb_y + j+1;
					q.setNodes(v,4);
					indexCell++;
				}
			}
		}
	};
}

#endif /* CARTESIAN_MESH_2D_GENERATOR_H_ */
