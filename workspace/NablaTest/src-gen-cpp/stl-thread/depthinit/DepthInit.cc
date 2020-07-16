#include "depthinit/DepthInit.h"

using namespace nablalib;

/******************** Free functions definitions ********************/


/******************** Options definition ********************/

void
DepthInit::Options::jsonInit(const rapidjson::Value::ConstObject& d)
{
	// X_EDGE_LENGTH
	assert(d.HasMember("X_EDGE_LENGTH"));
	const rapidjson::Value& valueof_X_EDGE_LENGTH = d["X_EDGE_LENGTH"];
	assert(valueof_X_EDGE_LENGTH.IsDouble());
	X_EDGE_LENGTH = valueof_X_EDGE_LENGTH.GetDouble();
	// Y_EDGE_LENGTH
	assert(d.HasMember("Y_EDGE_LENGTH"));
	const rapidjson::Value& valueof_Y_EDGE_LENGTH = d["Y_EDGE_LENGTH"];
	assert(valueof_Y_EDGE_LENGTH.IsDouble());
	Y_EDGE_LENGTH = valueof_Y_EDGE_LENGTH.GetDouble();
	// X_EDGE_ELEMS
	assert(d.HasMember("X_EDGE_ELEMS"));
	const rapidjson::Value& valueof_X_EDGE_ELEMS = d["X_EDGE_ELEMS"];
	assert(valueof_X_EDGE_ELEMS.IsInt());
	X_EDGE_ELEMS = valueof_X_EDGE_ELEMS.GetInt();
	// Y_EDGE_ELEMS
	assert(d.HasMember("Y_EDGE_ELEMS"));
	const rapidjson::Value& valueof_Y_EDGE_ELEMS = d["Y_EDGE_ELEMS"];
	assert(valueof_Y_EDGE_ELEMS.IsInt());
	Y_EDGE_ELEMS = valueof_Y_EDGE_ELEMS.GetInt();
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

DepthInit::DepthInit(const Options& aOptions, DepthInitFunctions& aDepthInitFunctions)
: options(aOptions)
, depthInitFunctions(aDepthInitFunctions)
, mesh(CartesianMesh2DGenerator::generate(options.X_EDGE_ELEMS, options.Y_EDGE_ELEMS, options.X_EDGE_LENGTH, options.Y_EDGE_LENGTH))
, nbCells(mesh->getNbCells())
, nbNodes(mesh->getNbNodes())
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
	delete mesh;
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
	
	std::cout << "[" << __GREEN__ << "MESH" << __RESET__ << "]      X=" << __BOLD__ << options.X_EDGE_ELEMS << __RESET__ << ", Y=" << __BOLD__ << options.Y_EDGE_ELEMS
		<< __RESET__ << ", X length=" << __BOLD__ << options.X_EDGE_LENGTH << __RESET__ << ", Y length=" << __BOLD__ << options.Y_EDGE_LENGTH << __RESET__ << std::endl;
	
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
	
	// options
	DepthInit::Options options;
	if (d.HasMember("options"))
	{
		const rapidjson::Value& valueof_options = d["options"];
		assert(valueof_options.IsObject());
		options.jsonInit(valueof_options.GetObject());
	}
	
	// depthInitFunctions
	DepthInitFunctions depthInitFunctions;
	if (d.HasMember("depthInitFunctions"))
	{
		const rapidjson::Value& valueof_depthInitFunctions = d["depthInitFunctions"];
		assert(valueof_depthInitFunctions.IsObject());
		depthInitFunctions.jsonInit(valueof_depthInitFunctions.GetObject());
	}
	
	// simulator must be a pointer if there is a finalize at the end (Kokkos, omp...)
	auto simulator = new DepthInit(options, depthInitFunctions);
	simulator->simulate();
	
	// simulator must be deleted before calling finalize
	delete simulator;
	return 0;
}
