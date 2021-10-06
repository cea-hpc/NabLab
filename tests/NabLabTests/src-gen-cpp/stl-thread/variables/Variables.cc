/* DO NOT EDIT THIS FILE - it is machine generated */

#include "Variables.h"
#include <rapidjson/document.h>
#include <rapidjson/istreamwrapper.h>
#include <rapidjson/stringbuffer.h>
#include <rapidjson/writer.h>


/******************** Module definition ********************/

Variables::Variables(CartesianMesh2D& aMesh)
: mesh(aMesh)
, nbNodes(mesh.getNbNodes())
, maxCellsOfNode(CartesianMesh2D::MaxNbCellsOfNode)
, X(nbNodes)
{
	// Copy node coordinates
	const auto& gNodes = mesh.getGeometry()->getNodes();
	for (size_t rNodes=0; rNodes<nbNodes; rNodes++)
	{
		X[rNodes][0] = gNodes[rNodes][0];
		X[rNodes][1] = gNodes[rNodes][1];
	}
}

Variables::~Variables()
{
}

void
Variables::jsonInit(const char* jsonContent)
{
	assert(!jsonDocument.Parse(jsonContent).HasParseError());
	assert(jsonDocument.IsObject());
	rapidjson::Value::Object options = jsonDocument.GetObject();
}


/**
 * Job init_arrayOption called @1.0 in simulate method.
 * In variables: 
 * Out variables: arrayOption
 */
void Variables::init_arrayOption() noexcept
{
	// arrayOption
	rapidjson::Value::Object options = jsonDocument.GetObject();
	assert(options.HasMember("arrayOption"));
	const rapidjson::Value& valueof_arrayOption = options["arrayOption"];
	assert(valueof_arrayOption.IsArray());
	assert(valueof_arrayOption.Size() == 2);
	for (size_t i1=0 ; i1<2 ; i1++)
	{
		assert(valueof_arrayOption[i1].IsDouble());
		arrayOption[i1] = valueof_arrayOption[i1].GetDouble();
	}
}

/**
 * Job init_optionDim called @1.0 in simulate method.
 * In variables: 
 * Out variables: optionDim
 */
void Variables::init_optionDim() noexcept
{
	// optionDim
	rapidjson::Value::Object options = jsonDocument.GetObject();
	assert(options.HasMember("optionDim"));
	const rapidjson::Value& valueof_optionDim = options["optionDim"];
	assert(valueof_optionDim.IsInt());
	optionDim = valueof_optionDim.GetInt();
}

/**
 * Job newVar called @1.0 in simulate method.
 * In variables: 
 * Out variables: 
 */
void Variables::newVar() noexcept
{
	parallel_exec(nbNodes, [&](const size_t& rNodes)
	{
		const Id rId(rNodes);
		const int localNbCells(mesh.getCellsOfNode(rId).size());
		RealArray1D<0> tmp;
		tmp.initSize(localNbCells);
	});
}

/**
 * Job setUnknownDim called @1.0 in simulate method.
 * In variables: 
 * Out variables: unknownDim
 */
void Variables::setUnknownDim() noexcept
{
	unknownDim = 4;
}

/**
 * Job init_dynamicArray called @2.0 in simulate method.
 * In variables: unknownDim
 * Out variables: dynamicArray
 */
void Variables::init_dynamicArray() noexcept
{
	dynamicArray.initSize(unknownDim);
}

/**
 * Job init_dynamicOptArray called @2.0 in simulate method.
 * In variables: optionDim
 * Out variables: dynamicOptArray
 */
void Variables::init_dynamicOptArray() noexcept
{
	dynamicOptArray.initSize(optionDim);
}

/**
 * Job init_optionArray called @2.0 in simulate method.
 * In variables: optionDim
 * Out variables: optionArray
 */
void Variables::init_optionArray() noexcept
{
	optionArray.initSize(optionDim);
	// optionArray
	rapidjson::Value::Object options = jsonDocument.GetObject();
	assert(options.HasMember("optionArray"));
	const rapidjson::Value& valueof_optionArray = options["optionArray"];
	assert(valueof_optionArray.IsArray());
	assert(valueof_optionArray.Size() == optionDim);
	for (size_t i1=0 ; i1<optionDim ; i1++)
	{
		assert(valueof_optionArray[i1].IsDouble());
		optionArray[i1] = valueof_optionArray[i1].GetDouble();
	}
}

void Variables::simulate()
{
	std::cout << "\n" << __BLUE_BKG__ << __YELLOW__ << __BOLD__ <<"\tStarting Variables ..." << __RESET__ << "\n\n";
	
	std::cout << "[" << __GREEN__ << "TOPOLOGY" << __RESET__ << "]  HWLOC unavailable cannot get topological informations" << std::endl;
	
	std::cout << "[" << __GREEN__ << "OUTPUT" << __RESET__ << "]    " << __BOLD__ << "Disabled" << __RESET__ << std::endl;

	init_arrayOption(); // @1.0
	init_optionDim(); // @1.0
	newVar(); // @1.0
	setUnknownDim(); // @1.0
	init_dynamicArray(); // @2.0
	init_dynamicOptArray(); // @2.0
	init_optionArray(); // @2.0
	
	std::cout << "\nFinal time = " << t << endl;
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
		std::cerr << "(Variables.json)" << std::endl;
		return -1;
	}
	
	// read json dataFile
	ifstream ifs(dataFile);
	rapidjson::IStreamWrapper isw(ifs);
	rapidjson::Document d;
	d.ParseStream(isw);
	assert(d.IsObject());
	
	// Mesh instanciation
	CartesianMesh2D mesh;
	assert(d.HasMember("mesh"));
	rapidjson::StringBuffer strbuf;
	rapidjson::Writer<rapidjson::StringBuffer> writer(strbuf);
	d["mesh"].Accept(writer);
	mesh.jsonInit(strbuf.GetString());
	
	// Module instanciation(s)
	Variables* variables = new Variables(mesh);
	if (d.HasMember("variables"))
	{
		rapidjson::StringBuffer strbuf;
		rapidjson::Writer<rapidjson::StringBuffer> writer(strbuf);
		d["variables"].Accept(writer);
		variables->jsonInit(strbuf.GetString());
	}
	
	// Start simulation
	// Simulator must be a pointer when a finalize is needed at the end (Kokkos, omp...)
	variables->simulate();
	
	delete variables;
	return ret;
}
