#ifndef CARTESIAN_MESH_2D_GENERATOR_H_
#define CARTESIAN_MESH_2D_GENERATOR_H_

#include "mesh/Mesh.h"
#include "types/Real2.h"

namespace nablalib
{

class CartesianMesh2DGenerator
{
public:
	static Mesh<Real2>* generate(int nbXQuads, int nbYQuads, double xSize, double ySize);
};

}
#endif /* CARTESIAN_MESH_2D_GENERATOR_H_ */
