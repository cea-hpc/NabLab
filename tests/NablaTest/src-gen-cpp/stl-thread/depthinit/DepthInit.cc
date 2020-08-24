#include "depthinit/DepthInit.h"

using namespace nablalib;

/******************** Free functions definitions ********************/


/******************** Options definition ********************/

void
DepthInit::Options::jsonInit(const rapidjson::Value::ConstObject& d)
{
	// maxTime
	assert(d.HasMember("maxTime"));
	const rapidjson::Value& valueof_maxTime = d["maxTime"];
	assert(valueof_maxTime.IsDouble());
	maxTime = valueof_maxTime.GetDouble();
	// maxIter
	assert(d.HasMember("maxIter"));
	const rapidjson::Value& valueof_maxIter = d["maxIter"];
	assert(valueof_maxIter.IsInt());
	maxIter = valueof_maxIter.GetInt();
	// deltat
	assert(d.HasMember("deltat"));
	const rapidjson::Value& valueof_deltat = d["deltat"];
	assert(valueof_deltat.IsDouble());
	deltat = valueof_deltat.GetDouble();
}

/******************** Module definition ********************/

DepthInit::DepthInit(CartesianMesh2D* aMesh, const Options& aOptions, DepthInitFunctions& aDepthInitFunctions)
: mesh(aMesh)
, nbCells(mesh->getNbCells())
, nbNodes(mesh->getNbNodes())
, options(aOptions)
, depthInitFunctions(aDepthInitFunctions)
, X(nbNodes)
, eta(nbCells)
{
	// Copy node coordinates
	const auto& gNodes = mesh->getGeometry()->getNodes();
	for (size_t rNodes=0; rNodes<nbNodes; rNodes++)
	{
		X[rNodes][0] = gNodes[rNodes][0];
		X[rNodes][1] = gNodes[rNodes][1];
	}
}

DepthInit::~DepthInit()
{
}

/**
 * Job initFromFile called @1.0 in simulate method.
 * In variables: 
 * Out variables: eta
 */
void DepthInit::initFromFile() noexcept
{
	for (size_t jCells=0; jCells<nbCells; jCells++)
	{
		eta[jCells] = depthInitFunctions.nextWaveHeight();
	}
}

void DepthInit::simulate()
{
	std::cout << "\n" << __BLUE_BKG__ << __YELLOW__ << __BOLD__ <<"\tStarting DepthInit ..." << __RESET__ << "\n\n";
	
	std::cout << "[" << __GREEN__ << "TOPOLOGY" << __RESET__ << "]  HWLOC unavailable cannot get topological informations" << std::endl;
	
	std::cout << "[" << __GREEN__ << "OUTPUT" << __RESET__ << "]    " << __BOLD__ << "Disabled" << __RESET__ << std::endl;

	initFromFile(); // @1.0
	
	std::cout << __YELLOW__ << "\n\tDone ! Took " << __MAGENTA__ << __BOLD__ << globalTimer.print() << __RESET__ << std::endl;
}

/******************** Module definition ********************/

int main(int argc, char* argv[]) 
{
	string dataFile;
	
	if (argc == 2)
	{
		dataFile = argv[1];
	}
	else
	{
		std::cerr << "[ERROR] Wrong number of arguments. Expecting 1 arg: dataFile." << std::endl;
		std::cerr << "(DepthInitDefaultOptions.json)" << std::endl;
		return -1;
	}
	
	// read json dataFile
	ifstream ifs(dataFile);
	rapidjson::IStreamWrapper isw(ifs);
	rapidjson::Document d;
	d.ParseStream(isw);
	assert(d.IsObject());
	
	// mesh
	assert(d.HasMember("mesh"));
	const rapidjson::Value& valueof_mesh = d["mesh"];
	assert(valueof_mesh.IsObject());
	CartesianMesh2DFactory meshFactory;
	meshFactory.jsonInit(valueof_mesh.GetObject());
	CartesianMesh2D* mesh = meshFactory.create();
	
	// options
	DepthInit::Options options;
	assert(d.HasMember("options"));
	const rapidjson::Value& valueof_options = d["options"];
	assert(valueof_options.IsObject());
	options.jsonInit(valueof_options.GetObject());
	
	// depthInitFunctions
	DepthInitFunctions depthInitFunctions;
	if (d.HasMember("depthInitFunctions"))
	{
		const rapidjson::Value& valueof_depthInitFunctions = d["depthInitFunctions"];
		assert(valueof_depthInitFunctions.IsObject());
		depthInitFunctions.jsonInit(valueof_depthInitFunctions.GetObject());
	}
	
	// simulator must be a pointer if there is a finalize at the end (Kokkos, omp...)
	auto simulator = new DepthInit(mesh, options, depthInitFunctions);
	simulator->simulate();
	
	// simulator must be deleted before calling finalize
	delete simulator;
	delete mesh;
	return 0;
}
