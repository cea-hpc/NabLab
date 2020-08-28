package fr.cea.nabla.javalib.mesh;

/* Numbering nodes and cells			Numbering faces
 * 
 *  15---16---17---18---19          |-27-|-28-|-29-|-30-|
 *   | 8  | 9  | 10 | 11 |         19   21   23   25   26
 *  10---11---12---13---14          |-18-|-20-|-22-|-24-|
 *   | 4  | 5  | 6  | 7  |         10   12   14   16   17
 *   5----6----7----8----9          |--9-|-11-|-13-|-15-|
 *   | 0  | 1  | 2  | 3  |          1    3    5    7    8
 *   0----1----2----3----4          |-0--|-2--|-4--|-6--|
 */
public class CartesianMesh2DFactory
{
	private int nbXQuads = -1;
	private int nbYQuads = -1;
	private double xSize = -1;
	private double ySize = -1;

	/** Constructor for Json creation */
	public CartesianMesh2DFactory() {}

	public CartesianMesh2DFactory(int nbXQuads, int nbYQuads, double xSize, double ySize)
	{
		this.nbXQuads = nbXQuads;
		this.nbYQuads = nbYQuads;
		this.xSize = xSize;
		this.ySize = ySize;
	}

	public CartesianMesh2D create()
	{
		if (nbXQuads == -1 || nbYQuads == -1 || xSize == -1 || ySize == -1)
			throw new RuntimeException("MeshFactory attributes uninitialized");

		double[][] nodes = new double[(nbXQuads + 1) * (nbYQuads + 1)][2];
		Quad[] quads = new Quad[nbXQuads * nbYQuads];
		Edge[] edges = new Edge[2 * quads.length + nbXQuads + nbYQuads];

		int[] outerNodesIds = new int[2 * (nbXQuads + nbYQuads)];
		int[] innerNodeIds = new int[nodes.length - outerNodesIds.length];
		int[] topNodeIds = new int[nbXQuads + 1];
		int[] bottomNodeIds = new int[nbXQuads + 1];
		int[] leftNodeIds = new int[nbYQuads + 1];
		int[] rightNodeIds = new int[nbYQuads + 1];

		int[] innerCellIds = new int[(nbXQuads - 2)*(nbYQuads - 2)];
		int[] outerCellIds = new int[2 * nbXQuads + 2 * (nbYQuads - 2)];

		int nodeId = 0;
		int innerNodeId = 0;
		int topNodeId = 0;
		int bottomNodeId = 0;
		int leftNodeId = 0;
		int rightNodeId = 0;

		// node creation
		for (int j = 0; j <=nbYQuads; j++)
			for (int i = 0; i<=nbXQuads; i++)
			{
				nodes[nodeId][0] = xSize * i;
				nodes[nodeId][1] = ySize * j;
				if (i!=0 && j!=0 && i!=nbXQuads && j!=nbYQuads)
					innerNodeIds[innerNodeId++] = nodeId;
				else
				{
					if (j==0) bottomNodeIds[bottomNodeId++] =nodeId;
					if (j==nbYQuads) topNodeIds[topNodeId++] = nodeId;
					if (i==0) leftNodeIds[leftNodeId++] = nodeId;
					if (i==nbXQuads) rightNodeIds[rightNodeId++] = nodeId;
				}
				nodeId++;
		}

		// edge creation
		int nbXNodes = nbXQuads+1;
		int edgeId = 0;
		for (int i = 0; i<nodes.length; i++)
		{
			int rightNodeIndex = i+1;
			if (rightNodeIndex%nbXNodes!=0) edges[edgeId++] = new Edge(i, rightNodeIndex);
			int belowNodeIndex = i + nbXNodes;
			if (belowNodeIndex<nodes.length) edges[edgeId++] = new Edge(i, belowNodeIndex);
		}

		// quad creation
		int quadId = 0;
		int innerCellId = 0;
		int outerCellId = 0;
		for (int j = 0; j < nbYQuads; j++)
			for (int i = 0; i < nbXQuads; i++)
			{
				if( (i != 0) && (i != nbXQuads - 1) && (j != 0) && (j!= nbYQuads - 1) )
					innerCellIds[innerCellId++] = quadId;
				else
					outerCellIds[outerCellId++] = quadId;

				int upperLeftNodeIndex = (j*nbXNodes)+i;
				int lowerLeftNodeIndex = upperLeftNodeIndex + nbXNodes;
				quads[quadId++] = new Quad(upperLeftNodeIndex, upperLeftNodeIndex+1, lowerLeftNodeIndex+1, lowerLeftNodeIndex);
			}

		MeshGeometry meshGeometry = new MeshGeometry(nodes, edges, quads);
		return new CartesianMesh2D(meshGeometry, innerNodeIds, topNodeIds, bottomNodeIds, leftNodeIds, rightNodeIds, innerCellIds, outerCellIds);
	}
}
