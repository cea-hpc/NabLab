#include "hydroremap/H.h"
#include "hydroremap/R1.h"
#include "hydroremap/R2.h"

using namespace nablalib;

/******************** Options definition ********************/

void
H::Options::jsonInit(const rapidjson::Value& json)
{
	assert(json.IsObject());
	const rapidjson::Value::ConstObject& o = json.GetObject();
	// maxTime
	if (o.HasMember("maxTime"))
	{
		const rapidjson::Value& valueof_maxTime = o["maxTime"];
		assert(valueof_maxTime.IsDouble());
		maxTime = valueof_maxTime.GetDouble();
	}
	else
		maxTime = 0.1;
	// maxIter
	if (o.HasMember("maxIter"))
	{
		const rapidjson::Value& valueof_maxIter = o["maxIter"];
		assert(valueof_maxIter.IsInt());
		maxIter = valueof_maxIter.GetInt();
	}
	else
		maxIter = 500;
	// deltat
	if (o.HasMember("deltat"))
	{
		const rapidjson::Value& valueof_deltat = o["deltat"];
		assert(valueof_deltat.IsDouble());
		deltat = valueof_deltat.GetDouble();
	}
	else
		deltat = 1.0;
}

/******************** Module definition ********************/

H::H(CartesianMesh2D* aMesh, Options& aOptions)
: mesh(aMesh)
, nbNodes(mesh->getNbNodes())
, nbCells(mesh->getNbCells())
, options(aOptions)
, X(nbNodes)
, hv1(nbCells)
, hv2(nbCells)
, hv3(nbCells)
, hv4(nbCells)
, hv5(nbCells)
, hv6(nbCells)
, hv7(nbCells)
{
	// Copy node coordinates
	const auto& gNodes = mesh->getGeometry()->getNodes();
	for (size_t rNodes=0; rNodes<nbNodes; rNodes++)
	{
		X[rNodes][0] = gNodes[rNodes][0];
		X[rNodes][1] = gNodes[rNodes][1];
	}
}

H::~H()
{
}

/**
 * Job hj1 called @1.0 in simulate method.
 * In variables: hv2
 * Out variables: hv3
 */
void H::hj1() noexcept
{
	parallel::parallel_exec(nbCells, [&](const size_t& cCells)
	{
		hv3[cCells] = hv2[cCells];
	});
}

/**
 * Job hj2 called @2.0 in simulate method.
 * In variables: hv3
 * Out variables: hv5
 */
void H::hj2() noexcept
{
	parallel::parallel_exec(nbCells, [&](const size_t& cCells)
	{
		hv5[cCells] = hv3[cCells];
	});
}

/**
 * Job hj3 called @4.0 in simulate method.
 * In variables: hv4, hv5, hv6
 * Out variables: hv7
 */
void H::hj3() noexcept
{
	parallel::parallel_exec(nbCells, [&](const size_t& cCells)
	{
		hv7[cCells] = hv4[cCells] + hv5[cCells] + hv6[cCells];
	});
}

void H::simulate()
{
	std::cout << "\n" << __BLUE_BKG__ << __YELLOW__ << __BOLD__ <<"\tStarting HydroRemap ..." << __RESET__ << "\n\n";
	
	std::cout << "[" << __GREEN__ << "TOPOLOGY" << __RESET__ << "]  HWLOC unavailable cannot get topological informations" << std::endl;
	
	std::cout << "[" << __GREEN__ << "OUTPUT" << __RESET__ << "]    " << __BOLD__ << "Disabled" << __RESET__ << std::endl;

	hj1(); // @1.0
	r1->rj1(); // @1.0
	hj2(); // @2.0
	r2->rj1(); // @2.0
	r1->rj2(); // @2.0
	r2->rj2(); // @3.0
	hj3(); // @4.0
	
	std::cout << __YELLOW__ << "\n\tDone ! Took " << __MAGENTA__ << __BOLD__ << globalTimer.print() << __RESET__ << std::endl;
}

int main(int argc, char* argv[]) 
{
	string dataFile;
	int ret = 0;
	
	if (argc == 2)
	{
		dataFile = argv[1];
	}
	else
	{
		std::cerr << "[ERROR] Wrong number of arguments. Expecting 1 arg: dataFile." << std::endl;
		std::cerr << "(HydroRemap.json)" << std::endl;
		return -1;
	}
	
	// read json dataFile
	ifstream ifs(dataFile);
	rapidjson::IStreamWrapper isw(ifs);
	rapidjson::Document d;
	d.ParseStream(isw);
	assert(d.IsObject());
	
	// Mesh instanciation
	assert(d.HasMember("mesh"));
	CartesianMesh2DFactory meshFactory;
	meshFactory.jsonInit(d["mesh"]);
	CartesianMesh2D* mesh = meshFactory.create();
	
	// Module instanciation(s)
	H::Options hOptions;
	if (d.HasMember("h")) hOptions.jsonInit(d["h"]);
	H* h = new H(mesh, hOptions);
	R1::Options r1Options;
	if (d.HasMember("r1")) r1Options.jsonInit(d["r1"]);
	R1* r1 = new R1(mesh, r1Options);
	r1->setMainModule(h);
	R2::Options r2Options;
	if (d.HasMember("r2")) r2Options.jsonInit(d["r2"]);
	R2* r2 = new R2(mesh, r2Options);
	r2->setMainModule(h);
	
	// Start simulation
	// Simulator must be a pointer when a finalize is needed at the end (Kokkos, omp...)
	h->simulate();
	
	delete r2;
	delete r1;
	delete h;
	delete mesh;
	return ret;
}
