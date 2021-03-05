/*** GENERATED FILE - DO NOT OVERWRITE ***/

#include "ExplicitHeatEquation.h"
#include <rapidjson/document.h>
#include <rapidjson/istreamwrapper.h>
#include <rapidjson/stringbuffer.h>
#include <rapidjson/writer.h>


/******************** Free functions definitions ********************/

namespace explicitheatequationfreefuncs
{
template<size_t x>
double norm(RealArray1D<x> a)
{
	return std::sqrt(explicitheatequationfreefuncs::dot(a, a));
}

template<size_t x>
double dot(RealArray1D<x> a, RealArray1D<x> b)
{
	double result(0.0);
	for (size_t i=0; i<x; i++)
	{
		result = result + a[i] * b[i];
	}
	return result;
}

double det(RealArray1D<2> a, RealArray1D<2> b)
{
	return (a[0] * b[1] - a[1] * b[0]);
}

template<size_t x>
RealArray1D<x> sumR1(RealArray1D<x> a, RealArray1D<x> b)
{
	return a + b;
}

double minR0(double a, double b)
{
	return std::min(a, b);
}

double sumR0(double a, double b)
{
	return a + b;
}

double prodR0(double a, double b)
{
	return a * b;
}
}

/******************** Options definition ********************/

void
ExplicitHeatEquation::Options::jsonInit(const char* jsonContent)
{
	rapidjson::Document document;
	assert(!document.Parse(jsonContent).HasParseError());
	assert(document.IsObject());
	const rapidjson::Value::Object& o = document.GetObject();

	// outputPath
	assert(o.HasMember("outputPath"));
	const rapidjson::Value& valueof_outputPath = o["outputPath"];
	assert(valueof_outputPath.IsString());
	outputPath = valueof_outputPath.GetString();
	// outputPeriod
	assert(o.HasMember("outputPeriod"));
	const rapidjson::Value& valueof_outputPeriod = o["outputPeriod"];
	assert(valueof_outputPeriod.IsInt());
	outputPeriod = valueof_outputPeriod.GetInt();
	// u0
	if (o.HasMember("u0"))
	{
		const rapidjson::Value& valueof_u0 = o["u0"];
		assert(valueof_u0.IsDouble());
		u0 = valueof_u0.GetDouble();
	}
	else
		u0 = 1.0;
	// stopTime
	if (o.HasMember("stopTime"))
	{
		const rapidjson::Value& valueof_stopTime = o["stopTime"];
		assert(valueof_stopTime.IsDouble());
		stopTime = valueof_stopTime.GetDouble();
	}
	else
		stopTime = 1.0;
	// maxIterations
	if (o.HasMember("maxIterations"))
	{
		const rapidjson::Value& valueof_maxIterations = o["maxIterations"];
		assert(valueof_maxIterations.IsInt());
		maxIterations = valueof_maxIterations.GetInt();
	}
	else
		maxIterations = 500000000;
}

/******************** Module definition ********************/

ExplicitHeatEquation::ExplicitHeatEquation(CartesianMesh2D* aMesh, Options& aOptions)
: mesh(aMesh)
, nbNodes(mesh->getNbNodes())
, nbCells(mesh->getNbCells())
, nbFaces(mesh->getNbFaces())
, nbNeighbourCells(CartesianMesh2D::MaxNbNeighbourCells)
, nbNodesOfFace(CartesianMesh2D::MaxNbNodesOfFace)
, nbCellsOfFace(CartesianMesh2D::MaxNbCellsOfFace)
, nbNodesOfCell(CartesianMesh2D::MaxNbNodesOfCell)
, options(aOptions)
, writer("ExplicitHeatEquation", options.outputPath)
, lastDump(numeric_limits<int>::min())
, deltat(0.001)
, X(nbNodes)
, Xc(nbCells)
, u_n(nbCells)
, u_nplus1(nbCells)
, V(nbCells)
, D(nbCells)
, faceLength(nbFaces)
, faceConductivity(nbFaces)
, alpha(nbCells, std::vector<double>(nbCells))
{
	// Copy node coordinates
	const auto& gNodes = mesh->getGeometry()->getNodes();
	for (size_t rNodes=0; rNodes<nbNodes; rNodes++)
	{
		X[rNodes][0] = gNodes[rNodes][0];
		X[rNodes][1] = gNodes[rNodes][1];
	}
}

ExplicitHeatEquation::~ExplicitHeatEquation()
{
}

/**
 * Job computeFaceLength called @1.0 in simulate method.
 * In variables: X
 * Out variables: faceLength
 */
void ExplicitHeatEquation::computeFaceLength() noexcept
{
	parallel_exec(nbFaces, [&](const size_t& fFaces)
	{
		const Id fId(fFaces);
		double reduction0(0.0);
		{
			const auto nodesOfFaceF(mesh->getNodesOfFace(fId));
			const size_t nbNodesOfFaceF(nodesOfFaceF.size());
			for (size_t pNodesOfFaceF=0; pNodesOfFaceF<nbNodesOfFaceF; pNodesOfFaceF++)
			{
				const Id pId(nodesOfFaceF[pNodesOfFaceF]);
				const Id pPlus1Id(nodesOfFaceF[(pNodesOfFaceF+1+nbNodesOfFace)%nbNodesOfFace]);
				const size_t pNodes(pId);
				const size_t pPlus1Nodes(pPlus1Id);
				reduction0 = explicitheatequationfreefuncs::sumR0(reduction0, explicitheatequationfreefuncs::norm(X[pNodes] - X[pPlus1Nodes]));
			}
		}
		faceLength[fFaces] = 0.5 * reduction0;
	});
}

/**
 * Job computeTn called @1.0 in executeTimeLoopN method.
 * In variables: deltat, t_n
 * Out variables: t_nplus1
 */
void ExplicitHeatEquation::computeTn() noexcept
{
	t_nplus1 = t_n + deltat;
}

/**
 * Job computeV called @1.0 in simulate method.
 * In variables: X
 * Out variables: V
 */
void ExplicitHeatEquation::computeV() noexcept
{
	parallel_exec(nbCells, [&](const size_t& jCells)
	{
		const Id jId(jCells);
		double reduction0(0.0);
		{
			const auto nodesOfCellJ(mesh->getNodesOfCell(jId));
			const size_t nbNodesOfCellJ(nodesOfCellJ.size());
			for (size_t pNodesOfCellJ=0; pNodesOfCellJ<nbNodesOfCellJ; pNodesOfCellJ++)
			{
				const Id pId(nodesOfCellJ[pNodesOfCellJ]);
				const Id pPlus1Id(nodesOfCellJ[(pNodesOfCellJ+1+nbNodesOfCell)%nbNodesOfCell]);
				const size_t pNodes(pId);
				const size_t pPlus1Nodes(pPlus1Id);
				reduction0 = explicitheatequationfreefuncs::sumR0(reduction0, explicitheatequationfreefuncs::det(X[pNodes], X[pPlus1Nodes]));
			}
		}
		V[jCells] = 0.5 * reduction0;
	});
}

/**
 * Job initD called @1.0 in simulate method.
 * In variables: 
 * Out variables: D
 */
void ExplicitHeatEquation::initD() noexcept
{
	parallel_exec(nbCells, [&](const size_t& cCells)
	{
		D[cCells] = 1.0;
	});
}

/**
 * Job initTime called @1.0 in simulate method.
 * In variables: 
 * Out variables: t_n0
 */
void ExplicitHeatEquation::initTime() noexcept
{
	t_n0 = 0.0;
}

/**
 * Job initXc called @1.0 in simulate method.
 * In variables: X
 * Out variables: Xc
 */
void ExplicitHeatEquation::initXc() noexcept
{
	parallel_exec(nbCells, [&](const size_t& cCells)
	{
		const Id cId(cCells);
		RealArray1D<2> reduction0({0.0, 0.0});
		{
			const auto nodesOfCellC(mesh->getNodesOfCell(cId));
			const size_t nbNodesOfCellC(nodesOfCellC.size());
			for (size_t pNodesOfCellC=0; pNodesOfCellC<nbNodesOfCellC; pNodesOfCellC++)
			{
				const Id pId(nodesOfCellC[pNodesOfCellC]);
				const size_t pNodes(pId);
				reduction0 = explicitheatequationfreefuncs::sumR1(reduction0, X[pNodes]);
			}
		}
		Xc[cCells] = 0.25 * reduction0;
	});
}

/**
 * Job updateU called @1.0 in executeTimeLoopN method.
 * In variables: alpha, u_n
 * Out variables: u_nplus1
 */
void ExplicitHeatEquation::updateU() noexcept
{
	parallel_exec(nbCells, [&](const size_t& cCells)
	{
		const Id cId(cCells);
		double reduction0(0.0);
		{
			const auto neighbourCellsC(mesh->getNeighbourCells(cId));
			const size_t nbNeighbourCellsC(neighbourCellsC.size());
			for (size_t dNeighbourCellsC=0; dNeighbourCellsC<nbNeighbourCellsC; dNeighbourCellsC++)
			{
				const Id dId(neighbourCellsC[dNeighbourCellsC]);
				const size_t dCells(dId);
				reduction0 = explicitheatequationfreefuncs::sumR0(reduction0, alpha[cCells][dCells] * u_n[dCells]);
			}
		}
		u_nplus1[cCells] = alpha[cCells][cCells] * u_n[cCells] + reduction0;
	});
}

/**
 * Job computeDeltaTn called @2.0 in simulate method.
 * In variables: D, V
 * Out variables: deltat
 */
void ExplicitHeatEquation::computeDeltaTn() noexcept
{
	double reduction0;
	reduction0 = parallel_reduce(nbCells, numeric_limits<double>::max(), [&](double& accu, const size_t& cCells)
		{
			return (accu = explicitheatequationfreefuncs::minR0(accu, V[cCells] / D[cCells]));
		},
		&explicitheatequationfreefuncs::minR0);
	deltat = reduction0 * 0.24;
}

/**
 * Job computeFaceConductivity called @2.0 in simulate method.
 * In variables: D
 * Out variables: faceConductivity
 */
void ExplicitHeatEquation::computeFaceConductivity() noexcept
{
	parallel_exec(nbFaces, [&](const size_t& fFaces)
	{
		const Id fId(fFaces);
		double reduction0(1.0);
		{
			const auto cellsOfFaceF(mesh->getCellsOfFace(fId));
			const size_t nbCellsOfFaceF(cellsOfFaceF.size());
			for (size_t c1CellsOfFaceF=0; c1CellsOfFaceF<nbCellsOfFaceF; c1CellsOfFaceF++)
			{
				const Id c1Id(cellsOfFaceF[c1CellsOfFaceF]);
				const size_t c1Cells(c1Id);
				reduction0 = explicitheatequationfreefuncs::prodR0(reduction0, D[c1Cells]);
			}
		}
		double reduction1(0.0);
		{
			const auto cellsOfFaceF(mesh->getCellsOfFace(fId));
			const size_t nbCellsOfFaceF(cellsOfFaceF.size());
			for (size_t c2CellsOfFaceF=0; c2CellsOfFaceF<nbCellsOfFaceF; c2CellsOfFaceF++)
			{
				const Id c2Id(cellsOfFaceF[c2CellsOfFaceF]);
				const size_t c2Cells(c2Id);
				reduction1 = explicitheatequationfreefuncs::sumR0(reduction1, D[c2Cells]);
			}
		}
		faceConductivity[fFaces] = 2.0 * reduction0 / reduction1;
	});
}

/**
 * Job initU called @2.0 in simulate method.
 * In variables: Xc, u0, vectOne
 * Out variables: u_n
 */
void ExplicitHeatEquation::initU() noexcept
{
	parallel_exec(nbCells, [&](const size_t& cCells)
	{
		if (explicitheatequationfreefuncs::norm(Xc[cCells] - vectOne) < 0.5) 
			u_n[cCells] = options.u0;
		else
			u_n[cCells] = 0.0;
	});
}

/**
 * Job setUpTimeLoopN called @2.0 in simulate method.
 * In variables: t_n0
 * Out variables: t_n
 */
void ExplicitHeatEquation::setUpTimeLoopN() noexcept
{
	t_n = t_n0;
}

/**
 * Job computeAlphaCoeff called @3.0 in simulate method.
 * In variables: V, Xc, deltat, faceConductivity, faceLength
 * Out variables: alpha
 */
void ExplicitHeatEquation::computeAlphaCoeff() noexcept
{
	parallel_exec(nbCells, [&](const size_t& cCells)
	{
		const Id cId(cCells);
		double alphaDiag(0.0);
		{
			const auto neighbourCellsC(mesh->getNeighbourCells(cId));
			const size_t nbNeighbourCellsC(neighbourCellsC.size());
			for (size_t dNeighbourCellsC=0; dNeighbourCellsC<nbNeighbourCellsC; dNeighbourCellsC++)
			{
				const Id dId(neighbourCellsC[dNeighbourCellsC]);
				const size_t dCells(dId);
				const Id fId(mesh->getCommonFace(cId, dId));
				const size_t fFaces(fId);
				const double alphaExtraDiag(deltat / V[cCells] * (faceLength[fFaces] * faceConductivity[fFaces]) / explicitheatequationfreefuncs::norm(Xc[cCells] - Xc[dCells]));
				alpha[cCells][dCells] = alphaExtraDiag;
				alphaDiag = alphaDiag + alphaExtraDiag;
			}
		}
		alpha[cCells][cCells] = 1 - alphaDiag;
	});
}

/**
 * Job executeTimeLoopN called @4.0 in simulate method.
 * In variables: alpha, deltat, t_n, u_n
 * Out variables: t_nplus1, u_nplus1
 */
void ExplicitHeatEquation::executeTimeLoopN() noexcept
{
	n = 0;
	bool continueLoop = true;
	do
	{
		globalTimer.start();
		cpuTimer.start();
		n++;
		if (!writer.isDisabled() && n >= lastDump + options.outputPeriod)
			dumpVariables(n);
		if (n!=1)
			std::cout << "[" << __CYAN__ << __BOLD__ << setw(3) << n << __RESET__ "] t = " << __BOLD__
				<< setiosflags(std::ios::scientific) << setprecision(8) << setw(16) << t_n << __RESET__;
	
		computeTn(); // @1.0
		updateU(); // @1.0
		
	
		// Evaluate loop condition with variables at time n
		continueLoop = (t_nplus1 < options.stopTime && n + 1 < options.maxIterations);
	
		if (continueLoop)
		{
			// Switch variables to prepare next iteration
			std::swap(t_nplus1, t_n);
			std::swap(u_nplus1, u_n);
		}
	
		cpuTimer.stop();
		globalTimer.stop();
	
		// Timers display
		if (!writer.isDisabled())
			std::cout << " {CPU: " << __BLUE__ << cpuTimer.print(true) << __RESET__ ", IO: " << __BLUE__ << ioTimer.print(true) << __RESET__ "} ";
		else
			std::cout << " {CPU: " << __BLUE__ << cpuTimer.print(true) << __RESET__ ", IO: " << __RED__ << "none" << __RESET__ << "} ";
		
		// Progress
		std::cout << progress_bar(n, options.maxIterations, t_n, options.stopTime, 25);
		std::cout << __BOLD__ << __CYAN__ << Timer::print(
			eta(n, options.maxIterations, t_n, options.stopTime, deltat, globalTimer), true)
			<< __RESET__ << "\r";
		std::cout.flush();
	
		cpuTimer.reset();
		ioTimer.reset();
	} while (continueLoop);
	// force a last output at the end
	dumpVariables(n, false);
}

void ExplicitHeatEquation::dumpVariables(int iteration, bool useTimer)
{
	if (!writer.isDisabled())
	{
		if (useTimer)
		{
			cpuTimer.stop();
			ioTimer.start();
		}
		auto quads = mesh->getGeometry()->getQuads();
		writer.startVtpFile(iteration, t_n, nbNodes, X.data(), nbCells, quads.data());
		writer.openNodeData();
		writer.closeNodeData();
		writer.openCellData();
		writer.openCellArray("Temperature", 0);
		for (size_t i=0 ; i<nbCells ; ++i)
			writer.write(u_n[i]);
		writer.closeCellArray();
		writer.closeCellData();
		writer.closeVtpFile();
		lastDump = n;
		if (useTimer)
		{
			ioTimer.stop();
			cpuTimer.start();
		}
	}
}

void ExplicitHeatEquation::simulate()
{
	std::cout << "\n" << __BLUE_BKG__ << __YELLOW__ << __BOLD__ <<"\tStarting ExplicitHeatEquation ..." << __RESET__ << "\n\n";
	
	std::cout << "[" << __GREEN__ << "TOPOLOGY" << __RESET__ << "]  HWLOC unavailable cannot get topological informations" << std::endl;
	
	if (!writer.isDisabled())
		std::cout << "[" << __GREEN__ << "OUTPUT" << __RESET__ << "]    VTK files stored in " << __BOLD__ << writer.outputDirectory() << __RESET__ << " directory" << std::endl;
	else
		std::cout << "[" << __GREEN__ << "OUTPUT" << __RESET__ << "]    " << __BOLD__ << "Disabled" << __RESET__ << std::endl;

	computeFaceLength(); // @1.0
	computeV(); // @1.0
	initD(); // @1.0
	initTime(); // @1.0
	initXc(); // @1.0
	computeDeltaTn(); // @2.0
	computeFaceConductivity(); // @2.0
	initU(); // @2.0
	setUpTimeLoopN(); // @2.0
	computeAlphaCoeff(); // @3.0
	executeTimeLoopN(); // @4.0
	
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
		std::cerr << "(ExplicitHeatEquation.json)" << std::endl;
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
	ExplicitHeatEquation::Options explicitHeatEquationOptions;
	if (d.HasMember("explicitHeatEquation"))
	{
		rapidjson::StringBuffer strbuf;
		rapidjson::Writer<rapidjson::StringBuffer> writer(strbuf);
		d["explicitHeatEquation"].Accept(writer);
		explicitHeatEquationOptions.jsonInit(strbuf.GetString());
	}
	ExplicitHeatEquation* explicitHeatEquation = new ExplicitHeatEquation(mesh, explicitHeatEquationOptions);
	
	// Start simulation
	// Simulator must be a pointer when a finalize is needed at the end (Kokkos, omp...)
	explicitHeatEquation->simulate();
	
	delete explicitHeatEquation;
	delete mesh;
	return ret;
}
