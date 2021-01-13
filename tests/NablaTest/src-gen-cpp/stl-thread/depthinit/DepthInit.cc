#include "depthinit/DepthInit.h"
#include <rapidjson/document.h>
#include <rapidjson/istreamwrapper.h>
#include <rapidjson/stringbuffer.h>
#include <rapidjson/writer.h>

using namespace nablalib;

/******************** Options definition ********************/

void
DepthInit::Options::jsonInit(const char* jsonContent)
{
	rapidjson::Document document;
	assert(!document.Parse(jsonContent).HasParseError());
	assert(document.IsObject());
	const rapidjson::Value::Object& o = document.GetObject();

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
	// depthInitFunctions
	if (o.HasMember("depthInitFunctions"))
	{
		rapidjson::StringBuffer strbuf;
		rapidjson::Writer<rapidjson::StringBuffer> writer(strbuf);
		o["depthInitFunctions"].Accept(writer);
		depthInitFunctions.jsonInit(strbuf.GetString());
	}
}

/******************** Module definition ********************/

DepthInit::DepthInit(CartesianMesh2D* aMesh, Options& aOptions)
: mesh(aMesh)
, nbCells(mesh->getNbCells())
, nbNodes(mesh->getNbNodes())
, options(aOptions)
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
		eta[jCells] = options.depthInitFunctions.nextWaveHeight();
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
		std::cerr << "(DepthInit.json)" << std::endl;
		return -1;
	}
	
	// read json dataFile
	ifstream ifs(dataFile);
	rapidjson::IStreamWrapper isw(ifs);
	rapidjson::Document d;
	d.ParseStream(isw);
	assert(d.IsObject());
	
	// Mesh instanciation
	CartesianMesh2DFactory meshFactory;
	if (d.HasMember("mesh"))
	{
		rapidjson::StringBuffer strbuf;
		rapidjson::Writer<rapidjson::StringBuffer> writer(strbuf);
		d["mesh"].Accept(writer);
		meshFactory.jsonInit(strbuf.GetString());
	}
	CartesianMesh2D* mesh = meshFactory.create();
	
	// Module instanciation(s)
	DepthInit::Options depthInitOptions;
	if (d.HasMember("depthInit"))
	{
		rapidjson::StringBuffer strbuf;
		rapidjson::Writer<rapidjson::StringBuffer> writer(strbuf);
		d["depthInit"].Accept(writer);
		depthInitOptions.jsonInit(strbuf.GetString());
	}
	DepthInit* depthInit = new DepthInit(mesh, depthInitOptions);
	
	// Start simulation
	// Simulator must be a pointer when a finalize is needed at the end (Kokkos, omp...)
	depthInit->simulate();
	
	delete depthInit;
	delete mesh;
	return ret;
}
