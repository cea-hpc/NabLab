#include <arcane/launcher/ArcaneLauncher.h>

#include <cassert>
#include <iostream>
#include <arcane/utils/ITraceMng.h>
#include <arcane/IMesh.h>
#include <arcane/ISubDomain.h>
#include <arcane/VariableTypes.h>
#include "CartesianMesh2D.h"

using namespace Arcane;

/* Numbering nodes and cells			Numbering faces
 *
 *  15---16---17---18---19          |-27-|-28-|-29-|-30-|
 *   | 8  | 9  | 10 | 11 |         10   11   12   13   14
 *  10---11---12---13---14          |-23-|-24-|-25-|-26-|
 *   | 4  | 5  | 6  | 7  |         5     6    7    8    9
 *   5----6----7----8----9          |-19-|-20-|-21-|-22-|
 *   | 0  | 1  | 2  | 3  |          0    1    2    3    4
 *   0----1----2----3----4          |-15-|-16-|-17-|-18-|
 *
 * 	Si on a positionné l'option de construction des faces suivante dans le jeu de données
 * 	<face-numbering-version>4</face-numbering-version>
 */


void
assertSame(ItemGroup a, vector<int> b)
{
	assert(a.size() == b.size());
	ENUMERATE_ITEM(i, a)
		assert(i.localId() == b[i.index()]);
}

void
printItemGroup(ItemGroup g)
{
	std::cout << "Item group " << g.name() << " (" << g.size() << "): [ ";
	ENUMERATE_ITEM(i, g)
		std::cout << i.localId() << " ";
	std::cout << "]" << std::endl;
}

void
executeCode(ISubDomain* sd)
{
	// Récupère le maillage initial
	IMesh* arcane_mesh = sd->defaultMesh();
	// Récupère le gestionnaire de traces pour les affichages
	ITraceMng* tr = arcane_mesh->traceMng();
	// Affiche le nombre de mailles
	tr->info() << "NB_CELL=" << arcane_mesh->nbCell();

	CartesianMesh2D* mesh = CartesianMesh2D::createInstance(arcane_mesh);

	vector<int> expected_inner_nodes{6, 7, 8, 11, 12, 13};
	vector<int> expected_outer_nodes{0, 1, 2, 3, 4, 5, 9, 10, 14, 15, 16, 17, 18, 19};
	vector<int> expected_top_nodes{15, 16, 17, 18, 19};
	vector<int> expected_bottom_nodes{0, 1, 2, 3, 4};
	vector<int> expected_left_nodes{0, 5, 10, 15};
	vector<int> expected_right_nodes{4, 9, 14, 19};

	assertSame(mesh->getGroup(CartesianMesh2D::InnerNodes), expected_inner_nodes);
//	assertSame(mesh->getGroup(CartesianMesh2D::OuterNodes), expected_outer_nodes);
	assertSame(mesh->getGroup(CartesianMesh2D::TopNodes), expected_top_nodes);
	assertSame(mesh->getGroup(CartesianMesh2D::BottomNodes), expected_bottom_nodes);
	assertSame(mesh->getGroup(CartesianMesh2D::LeftNodes), expected_left_nodes);
	assertSame(mesh->getGroup(CartesianMesh2D::RightNodes), expected_right_nodes);

	vector<int> expected_inner_cells{5, 6};
//	vector<int> expected_outer_cells{0, 1, 2, 3, 4, 7, 8, 9, 10, 11};
	vector<int> expected_top_cells{8, 9, 10, 11};
	vector<int> expected_bottom_cells{0, 1, 2, 3};
	vector<int> expected_left_cells{0, 4, 8};
	vector<int> expected_right_cells{3, 7, 11};

	assertSame(mesh->getGroup(CartesianMesh2D::InnerCells), expected_inner_cells);
//	assertSame(mesh->getGroup(CartesianMesh2D::OuterCells), expected_outer_cells);
	assertSame(mesh->getGroup(CartesianMesh2D::TopCells), expected_top_cells);
	assertSame(mesh->getGroup(CartesianMesh2D::BottomCells), expected_bottom_cells);
	assertSame(mesh->getGroup(CartesianMesh2D::LeftCells), expected_left_cells);
	assertSame(mesh->getGroup(CartesianMesh2D::RightCells), expected_right_cells);

	// Arcane mesh does not have the same face numerotation than STL mesh
	vector<int> expected_inner_faces{1, 2, 3, 6, 7, 8, 11, 12, 13, 19, 20, 21, 22, 23, 24, 25, 26};
	vector<int> expected_bottom_faces{15, 16, 17, 18};
	vector<int> expected_top_faces{27, 28, 29, 30};
	vector<int> expected_left_faces{0, 5, 10};
	vector<int> expected_right_faces{4, 9, 14};
	vector<int> expected_bottom_left_node{0};
	vector<int> expected_bottom_right_node{4};
	vector<int> expected_top_left_node{15};
	vector<int> expected_top_right_node{19};

	assertSame(mesh->getGroup(CartesianMesh2D::InnerFaces), expected_inner_faces);
	assertSame(mesh->getGroup(CartesianMesh2D::BottomFaces), expected_bottom_faces);
	assertSame(mesh->getGroup(CartesianMesh2D::TopFaces), expected_top_faces);
	assertSame(mesh->getGroup(CartesianMesh2D::LeftFaces), expected_left_faces);
	assertSame(mesh->getGroup(CartesianMesh2D::RightFaces), expected_right_faces);

	assertSame(mesh->getGroup(CartesianMesh2D::BottomLeftNode), expected_bottom_left_node);
	assertSame(mesh->getGroup(CartesianMesh2D::BottomRightNode), expected_bottom_right_node);
	assertSame(mesh->getGroup(CartesianMesh2D::TopLeftNode), expected_top_left_node);
	assertSame(mesh->getGroup(CartesianMesh2D::TopRightNode), expected_top_right_node);

	tr->info() << "End of executeCode";
}

int
main(int argc,char* argv[])
{
  // Le nom du fichier du jeu de données est le dernier argument de la ligne de commande.
  if (argc<2){
    std::cout << "Usage: DirectCartesian casefile.arc\n";
    return 1;
  }
  ArcaneLauncher::init(CommandLineArguments(&argc,&argv));
  String case_file_name = argv[argc-1];
  // Déclare la fonction qui sera exécutée par l'appel à run()
  auto f = [=](DirectSubDomainExecutionContext& ctx) -> int
  {
    executeCode(ctx.subDomain());
    return 0;
  };
  // Exécute le fonctor 'f'.
  return ArcaneLauncher::run(f);
}
