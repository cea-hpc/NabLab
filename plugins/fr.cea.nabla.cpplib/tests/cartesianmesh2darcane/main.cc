#include <arcane/launcher/ArcaneLauncher.h>

#include <cassert>
#include <iostream>
#include <arcane/utils/ITraceMng.h>
#include <arcane/IMesh.h>
#include <arcane/ISubDomain.h>
#include <arcane/VariableTypes.h>
#include "CartesianMesh2D.h"

using namespace Arcane;

void
assertSame(ItemGroup a, vector<int> b)
{
	assert(a.size() == b.size());
	ENUMERATE_ITEM(i, a)
		assert(i.localId() == b[i.index()]);
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

//	vector<int> expected_inner_cells{5, 6};
//	vector<int> expected_outer_cells{0, 1, 2, 3, 4, 7, 8, 9, 10, 11};
//	vector<int> expected_top_cells{8, 9, 10, 11};
//	vector<int> expected_bottom_cells{0, 1, 2, 3};
//	vector<int> expected_left_cells{0, 4, 8};
//	vector<int> expected_right_cells{3, 7, 11};
//
//	assertSame(mesh->getGroup(CartesianMesh2D::InnerCells), expected_inner_cells);
//	assertSame(mesh->getGroup(CartesianMesh2D::OuterCells), expected_outer_cells);
//	assertSame(mesh->getGroup(CartesianMesh2D::TopCells), expected_top_cells);
//	assertSame(mesh->getGroup(CartesianMesh2D::BottomCells), expected_bottom_cells);
//	assertSame(mesh->getGroup(CartesianMesh2D::LeftCells), expected_left_cells);
//	assertSame(mesh->getGroup(CartesianMesh2D::RightCells), expected_right_cells);
//
//	vector<int> expected_inner_faces{3, 5, 7, 9, 11, 12, 13, 14, 15, 16, 18, 20, 21, 22, 23, 24, 25};
//	vector<int> expected_outer_faces{0, 1, 2, 4, 6, 8, 10, 17, 19, 26, 27, 28, 29, 30};
//	vector<int> expected_inner_horizontal_faces{9, 11, 13, 15, 18, 20, 22, 24};
//	vector<int> expected_inner_vertical_faces{3, 5, 7, 12, 14, 16, 21, 23, 25};
//	vector<int> expected_top_faces{27, 28, 29, 30};
//	vector<int> expected_bottom_faces{0, 2, 4, 6};
//	vector<int> expected_left_faces{1, 10, 19};
//	vector<int> expected_right_faces{8, 17, 26};
//
//	assertSame(mesh->getGroup(CartesianMesh2D::InnerFaces), expected_inner_faces);
//	assertSame(mesh->getGroup(CartesianMesh2D::OuterFaces), expected_outer_faces);
//	assertSame(mesh->getGroup(CartesianMesh2D::InnerHorizontalFaces), expected_inner_horizontal_faces);
//	assertSame(mesh->getGroup(CartesianMesh2D::InnerVerticalFaces), expected_inner_vertical_faces);
//	assertSame(mesh->getGroup(CartesianMesh2D::TopFaces), expected_top_faces);
//	assertSame(mesh->getGroup(CartesianMesh2D::BottomFaces), expected_bottom_faces);
//	assertSame(mesh->getGroup(CartesianMesh2D::LeftFaces), expected_left_faces);
//	assertSame(mesh->getGroup(CartesianMesh2D::RightFaces), expected_right_faces);
//
//	assertSame(mesh->getGroup(CartesianMesh2D::BottomLeftNode)[0], 0);
//	assertSame(mesh->getGroup(CartesianMesh2D::BottomRightNode)[0], 4);
//	assertSame(mesh->getGroup(CartesianMesh2D::TopLeftNode)[0], 15);
//	assertSame(mesh->getGroup(CartesianMesh2D::TopRightNode)[0], 19);

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
