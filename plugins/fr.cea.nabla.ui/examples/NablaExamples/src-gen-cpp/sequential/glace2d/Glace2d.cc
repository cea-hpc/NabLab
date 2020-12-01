#include "glace2d/Glace2d.h"
#include <rapidjson/document.h>
#include <rapidjson/istreamwrapper.h>
#include <rapidjson/stringbuffer.h>
#include <rapidjson/writer.h>

using namespace nablalib;

/******************** Free functions definitions ********************/

double det(RealArray2D<2,2> a)
{
	return a[0][0] * a[1][1] - a[0][1] * a[1][0];
}

RealArray1D<2> perp(RealArray1D<2> a)
{
	return {a[1], -a[0]};
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

template<size_t x>
double norm(RealArray1D<x> a)
{
	return std::sqrt(dot(a, a));
}

template<size_t l>
RealArray2D<l,l> tensProduct(RealArray1D<l> a, RealArray1D<l> b)
{
	RealArray2D<l,l> result;
	for (size_t ia=0; ia<l; ia++)
	{
		for (size_t ib=0; ib<l; ib++)
		{
			result[ia][ib] = a[ia] * b[ib];
		}
	}
	return result;
}

template<size_t x, size_t y>
RealArray1D<x> matVectProduct(RealArray2D<x,y> a, RealArray1D<y> b)
{
	RealArray1D<x> result;
	for (size_t ix=0; ix<x; ix++)
	{
		RealArray1D<y> tmp;
		for (size_t iy=0; iy<y; iy++)
		{
			tmp[iy] = a[ix][iy];
		}
		result[ix] = dot(tmp, b);
	}
	return result;
}

template<size_t l>
double trace(RealArray2D<l,l> a)
{
	double result(0.0);
	for (size_t ia=0; ia<l; ia++)
	{
		result = result + a[ia][ia];
	}
	return result;
}

RealArray2D<2,2> inverse(RealArray2D<2,2> a)
{
	const double alpha(1.0 / det(a));
	return {a[1][1] * alpha, -a[0][1] * alpha, -a[1][0] * alpha, a[0][0] * alpha};
}

template<size_t x>
RealArray1D<x> sumR1(RealArray1D<x> a, RealArray1D<x> b)
{
	return a + b;
}

double sumR0(double a, double b)
{
	return a + b;
}

template<size_t x>
RealArray2D<x,x> sumR2(RealArray2D<x,x> a, RealArray2D<x,x> b)
{
	return a + b;
}

double minR0(double a, double b)
{
	return std::min(a, b);
}

/******************** Options definition ********************/

void
Glace2d::Options::jsonInit(const char* jsonContent)
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
	// stopTime
	if (o.HasMember("stopTime"))
	{
		const rapidjson::Value& valueof_stopTime = o["stopTime"];
		assert(valueof_stopTime.IsDouble());
		stopTime = valueof_stopTime.GetDouble();
	}
	else
		stopTime = 0.2;
	// maxIterations
	if (o.HasMember("maxIterations"))
	{
		const rapidjson::Value& valueof_maxIterations = o["maxIterations"];
		assert(valueof_maxIterations.IsInt());
		maxIterations = valueof_maxIterations.GetInt();
	}
	else
		maxIterations = 20000;
	// gamma
	if (o.HasMember("gamma"))
	{
		const rapidjson::Value& valueof_gamma = o["gamma"];
		assert(valueof_gamma.IsDouble());
		gamma = valueof_gamma.GetDouble();
	}
	else
		gamma = 1.4;
	// xInterface
	if (o.HasMember("xInterface"))
	{
		const rapidjson::Value& valueof_xInterface = o["xInterface"];
		assert(valueof_xInterface.IsDouble());
		xInterface = valueof_xInterface.GetDouble();
	}
	else
		xInterface = 0.5;
	// deltatIni
	if (o.HasMember("deltatIni"))
	{
		const rapidjson::Value& valueof_deltatIni = o["deltatIni"];
		assert(valueof_deltatIni.IsDouble());
		deltatIni = valueof_deltatIni.GetDouble();
	}
	else
		deltatIni = 1.0E-5;
	// deltatCfl
	if (o.HasMember("deltatCfl"))
	{
		const rapidjson::Value& valueof_deltatCfl = o["deltatCfl"];
		assert(valueof_deltatCfl.IsDouble());
		deltatCfl = valueof_deltatCfl.GetDouble();
	}
	else
		deltatCfl = 0.4;
	// rhoIniZg
	if (o.HasMember("rhoIniZg"))
	{
		const rapidjson::Value& valueof_rhoIniZg = o["rhoIniZg"];
		assert(valueof_rhoIniZg.IsDouble());
		rhoIniZg = valueof_rhoIniZg.GetDouble();
	}
	else
		rhoIniZg = 1.0;
	// rhoIniZd
	if (o.HasMember("rhoIniZd"))
	{
		const rapidjson::Value& valueof_rhoIniZd = o["rhoIniZd"];
		assert(valueof_rhoIniZd.IsDouble());
		rhoIniZd = valueof_rhoIniZd.GetDouble();
	}
	else
		rhoIniZd = 0.125;
	// pIniZg
	if (o.HasMember("pIniZg"))
	{
		const rapidjson::Value& valueof_pIniZg = o["pIniZg"];
		assert(valueof_pIniZg.IsDouble());
		pIniZg = valueof_pIniZg.GetDouble();
	}
	else
		pIniZg = 1.0;
	// pIniZd
	if (o.HasMember("pIniZd"))
	{
		const rapidjson::Value& valueof_pIniZd = o["pIniZd"];
		assert(valueof_pIniZd.IsDouble());
		pIniZd = valueof_pIniZd.GetDouble();
	}
	else
		pIniZd = 0.1;
}

/******************** Module definition ********************/

Glace2d::Glace2d(CartesianMesh2D* aMesh, Options& aOptions)
: mesh(aMesh)
, nbNodes(mesh->getNbNodes())
, nbCells(mesh->getNbCells())
, nbInnerNodes(mesh->getNbInnerNodes())
, nbTopNodes(mesh->getNbTopNodes())
, nbBottomNodes(mesh->getNbBottomNodes())
, nbLeftNodes(mesh->getNbLeftNodes())
, nbRightNodes(mesh->getNbRightNodes())
, nbNodesOfCell(CartesianMesh2D::MaxNbNodesOfCell)
, nbCellsOfNode(CartesianMesh2D::MaxNbCellsOfNode)
, options(aOptions)
, writer("Glace2d", options.outputPath)
, lastDump(numeric_limits<int>::min())
, X_n(nbNodes)
, X_nplus1(nbNodes)
, X_n0(nbNodes)
, b(nbNodes)
, bt(nbNodes)
, Ar(nbNodes)
, Mt(nbNodes)
, ur(nbNodes)
, c(nbCells)
, m(nbCells)
, p(nbCells)
, rho(nbCells)
, e(nbCells)
, E_n(nbCells)
, E_nplus1(nbCells)
, V(nbCells)
, deltatj(nbCells)
, uj_n(nbCells)
, uj_nplus1(nbCells)
, l(nbCells, std::vector<double>(nbNodesOfCell))
, Cjr_ic(nbCells, std::vector<RealArray1D<2>>(nbNodesOfCell))
, C(nbCells, std::vector<RealArray1D<2>>(nbNodesOfCell))
, F(nbCells, std::vector<RealArray1D<2>>(nbNodesOfCell))
, Ajr(nbCells, std::vector<RealArray2D<2,2>>(nbNodesOfCell))
{
	// Copy node coordinates
	const auto& gNodes = mesh->getGeometry()->getNodes();
	for (size_t rNodes=0; rNodes<nbNodes; rNodes++)
	{
		X_n0[rNodes][0] = gNodes[rNodes][0];
		X_n0[rNodes][1] = gNodes[rNodes][1];
	}
}

Glace2d::~Glace2d()
{
}

/**
 * Job ComputeCjr called @1.0 in executeTimeLoopN method.
 * In variables: X_n
 * Out variables: C
 */
void Glace2d::computeCjr() noexcept
{
	for (size_t jCells=0; jCells<nbCells; jCells++)
	{
		const Id jId(jCells);
		{
			const auto nodesOfCellJ(mesh->getNodesOfCell(jId));
			const size_t nbNodesOfCellJ(nodesOfCellJ.size());
			for (size_t rNodesOfCellJ=0; rNodesOfCellJ<nbNodesOfCellJ; rNodesOfCellJ++)
			{
				const Id rPlus1Id(nodesOfCellJ[(rNodesOfCellJ+1+nbNodesOfCell)%nbNodesOfCell]);
				const Id rMinus1Id(nodesOfCellJ[(rNodesOfCellJ-1+nbNodesOfCell)%nbNodesOfCell]);
				const size_t rPlus1Nodes(rPlus1Id);
				const size_t rMinus1Nodes(rMinus1Id);
				C[jCells][rNodesOfCellJ] = 0.5 * perp(X_n[rPlus1Nodes] - X_n[rMinus1Nodes]);
			}
		}
	}
}

/**
 * Job ComputeInternalEnergy called @1.0 in executeTimeLoopN method.
 * In variables: E_n, uj_n
 * Out variables: e
 */
void Glace2d::computeInternalEnergy() noexcept
{
	for (size_t jCells=0; jCells<nbCells; jCells++)
	{
		e[jCells] = E_n[jCells] - 0.5 * dot(uj_n[jCells], uj_n[jCells]);
	}
}

/**
 * Job IniCjrIc called @1.0 in simulate method.
 * In variables: X_n0
 * Out variables: Cjr_ic
 */
void Glace2d::iniCjrIc() noexcept
{
	for (size_t jCells=0; jCells<nbCells; jCells++)
	{
		const Id jId(jCells);
		{
			const auto nodesOfCellJ(mesh->getNodesOfCell(jId));
			const size_t nbNodesOfCellJ(nodesOfCellJ.size());
			for (size_t rNodesOfCellJ=0; rNodesOfCellJ<nbNodesOfCellJ; rNodesOfCellJ++)
			{
				const Id rPlus1Id(nodesOfCellJ[(rNodesOfCellJ+1+nbNodesOfCell)%nbNodesOfCell]);
				const Id rMinus1Id(nodesOfCellJ[(rNodesOfCellJ-1+nbNodesOfCell)%nbNodesOfCell]);
				const size_t rPlus1Nodes(rPlus1Id);
				const size_t rMinus1Nodes(rMinus1Id);
				Cjr_ic[jCells][rNodesOfCellJ] = 0.5 * perp(X_n0[rPlus1Nodes] - X_n0[rMinus1Nodes]);
			}
		}
	}
}

/**
 * Job IniTime called @1.0 in simulate method.
 * In variables: 
 * Out variables: t_n0
 */
void Glace2d::iniTime() noexcept
{
	t_n0 = 0.0;
}

/**
 * Job IniTimeStep called @1.0 in simulate method.
 * In variables: deltatIni
 * Out variables: deltat_n0
 */
void Glace2d::iniTimeStep() noexcept
{
	deltat_n0 = options.deltatIni;
}

/**
 * Job ComputeLjr called @2.0 in executeTimeLoopN method.
 * In variables: C
 * Out variables: l
 */
void Glace2d::computeLjr() noexcept
{
	for (size_t jCells=0; jCells<nbCells; jCells++)
	{
		const Id jId(jCells);
		{
			const auto nodesOfCellJ(mesh->getNodesOfCell(jId));
			const size_t nbNodesOfCellJ(nodesOfCellJ.size());
			for (size_t rNodesOfCellJ=0; rNodesOfCellJ<nbNodesOfCellJ; rNodesOfCellJ++)
			{
				l[jCells][rNodesOfCellJ] = norm(C[jCells][rNodesOfCellJ]);
			}
		}
	}
}

/**
 * Job ComputeV called @2.0 in executeTimeLoopN method.
 * In variables: C, X_n
 * Out variables: V
 */
void Glace2d::computeV() noexcept
{
	for (size_t jCells=0; jCells<nbCells; jCells++)
	{
		const Id jId(jCells);
		double reduction0(0.0);
		{
			const auto nodesOfCellJ(mesh->getNodesOfCell(jId));
			const size_t nbNodesOfCellJ(nodesOfCellJ.size());
			for (size_t rNodesOfCellJ=0; rNodesOfCellJ<nbNodesOfCellJ; rNodesOfCellJ++)
			{
				const Id rId(nodesOfCellJ[rNodesOfCellJ]);
				const size_t rNodes(rId);
				reduction0 = sumR0(reduction0, dot(C[jCells][rNodesOfCellJ], X_n[rNodes]));
			}
		}
		V[jCells] = 0.5 * reduction0;
	}
}

/**
 * Job Initialize called @2.0 in simulate method.
 * In variables: Cjr_ic, X_n0, gamma, pIniZd, pIniZg, rhoIniZd, rhoIniZg, xInterface
 * Out variables: E_n, m, p, rho, uj_n
 */
void Glace2d::initialize() noexcept
{
	for (size_t jCells=0; jCells<nbCells; jCells++)
	{
		const Id jId(jCells);
		double rho_ic;
		double p_ic;
		RealArray1D<2> reduction0({0.0, 0.0});
		{
			const auto nodesOfCellJ(mesh->getNodesOfCell(jId));
			const size_t nbNodesOfCellJ(nodesOfCellJ.size());
			for (size_t rNodesOfCellJ=0; rNodesOfCellJ<nbNodesOfCellJ; rNodesOfCellJ++)
			{
				const Id rId(nodesOfCellJ[rNodesOfCellJ]);
				const size_t rNodes(rId);
				reduction0 = sumR1(reduction0, X_n0[rNodes]);
			}
		}
		const RealArray1D<2> center(0.25 * reduction0);
		if (center[0] < options.xInterface) 
		{
			rho_ic = options.rhoIniZg;
			p_ic = options.pIniZg;
		}
		else
		{
			rho_ic = options.rhoIniZd;
			p_ic = options.pIniZd;
		}
		double reduction1(0.0);
		{
			const auto nodesOfCellJ(mesh->getNodesOfCell(jId));
			const size_t nbNodesOfCellJ(nodesOfCellJ.size());
			for (size_t rNodesOfCellJ=0; rNodesOfCellJ<nbNodesOfCellJ; rNodesOfCellJ++)
			{
				const Id rId(nodesOfCellJ[rNodesOfCellJ]);
				const size_t rNodes(rId);
				reduction1 = sumR0(reduction1, dot(Cjr_ic[jCells][rNodesOfCellJ], X_n0[rNodes]));
			}
		}
		const double V_ic(0.5 * reduction1);
		m[jCells] = rho_ic * V_ic;
		p[jCells] = p_ic;
		rho[jCells] = rho_ic;
		E_n[jCells] = p_ic / ((options.gamma - 1.0) * rho_ic);
		uj_n[jCells] = {0.0, 0.0};
	}
}

/**
 * Job SetUpTimeLoopN called @2.0 in simulate method.
 * In variables: X_n0, deltat_n0, t_n0
 * Out variables: X_n, deltat_n, t_n
 */
void Glace2d::setUpTimeLoopN() noexcept
{
	t_n = t_n0;
	deltat_n = deltat_n0;
	for (size_t i2(0) ; i2<X_n.size() ; i2++)
		for (size_t i1(0) ; i1<X_n[i2].size() ; i1++)
			X_n[i2][i1] = X_n0[i2][i1];
}

/**
 * Job ComputeDensity called @3.0 in executeTimeLoopN method.
 * In variables: V, m
 * Out variables: rho
 */
void Glace2d::computeDensity() noexcept
{
	for (size_t jCells=0; jCells<nbCells; jCells++)
	{
		rho[jCells] = m[jCells] / V[jCells];
	}
}

/**
 * Job ExecuteTimeLoopN called @3.0 in simulate method.
 * In variables: Ajr, Ar, C, E_n, F, Mt, V, X_n, b, bt, c, deltatCfl, deltat_n, deltat_nplus1, deltatj, e, gamma, l, m, p, rho, t_n, uj_n, ur
 * Out variables: Ajr, Ar, C, E_nplus1, F, Mt, V, X_nplus1, b, bt, c, deltat_nplus1, deltatj, e, l, p, rho, t_nplus1, uj_nplus1, ur
 */
void Glace2d::executeTimeLoopN() noexcept
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
	
		computeCjr(); // @1.0
		computeInternalEnergy(); // @1.0
		computeLjr(); // @2.0
		computeV(); // @2.0
		computeDensity(); // @3.0
		computeEOSp(); // @4.0
		computeEOSc(); // @5.0
		computeAjr(); // @6.0
		computedeltatj(); // @6.0
		computeAr(); // @7.0
		computeBr(); // @7.0
		computeDt(); // @7.0
		computeBoundaryConditions(); // @8.0
		computeBt(); // @8.0
		computeMt(); // @8.0
		computeTn(); // @8.0
		computeU(); // @9.0
		computeFjr(); // @10.0
		computeXn(); // @10.0
		computeEn(); // @11.0
		computeUn(); // @11.0
		
	
		// Evaluate loop condition with variables at time n
		continueLoop = (t_nplus1 < options.stopTime && n + 1 < options.maxIterations);
	
		if (continueLoop)
		{
			// Switch variables to prepare next iteration
			std::swap(t_nplus1, t_n);
			std::swap(deltat_nplus1, deltat_n);
			std::swap(X_nplus1, X_n);
			std::swap(E_nplus1, E_n);
			std::swap(uj_nplus1, uj_n);
		}
	
		cpuTimer.stop();
		globalTimer.stop();
	
		// Timers display
		if (!writer.isDisabled())
			std::cout << " {CPU: " << __BLUE__ << cpuTimer.print(true) << __RESET__ ", IO: " << __BLUE__ << ioTimer.print(true) << __RESET__ "} ";
		else
			std::cout << " {CPU: " << __BLUE__ << cpuTimer.print(true) << __RESET__ ", IO: " << __RED__ << "none" << __RESET__ << "} ";
		
		// Progress
		std::cout << utils::progress_bar(n, options.maxIterations, t_n, options.stopTime, 25);
		std::cout << __BOLD__ << __CYAN__ << utils::Timer::print(
			utils::eta(n, options.maxIterations, t_n, options.stopTime, deltat_n, globalTimer), true)
			<< __RESET__ << "\r";
		std::cout.flush();
	
		cpuTimer.reset();
		ioTimer.reset();
	} while (continueLoop);
	// force a last output at the end
	dumpVariables(n, false);
}

/**
 * Job ComputeEOSp called @4.0 in executeTimeLoopN method.
 * In variables: e, gamma, rho
 * Out variables: p
 */
void Glace2d::computeEOSp() noexcept
{
	for (size_t jCells=0; jCells<nbCells; jCells++)
	{
		p[jCells] = (options.gamma - 1.0) * rho[jCells] * e[jCells];
	}
}

/**
 * Job ComputeEOSc called @5.0 in executeTimeLoopN method.
 * In variables: gamma, p, rho
 * Out variables: c
 */
void Glace2d::computeEOSc() noexcept
{
	for (size_t jCells=0; jCells<nbCells; jCells++)
	{
		c[jCells] = std::sqrt(options.gamma * p[jCells] / rho[jCells]);
	}
}

/**
 * Job ComputeAjr called @6.0 in executeTimeLoopN method.
 * In variables: C, c, l, rho
 * Out variables: Ajr
 */
void Glace2d::computeAjr() noexcept
{
	for (size_t jCells=0; jCells<nbCells; jCells++)
	{
		const Id jId(jCells);
		{
			const auto nodesOfCellJ(mesh->getNodesOfCell(jId));
			const size_t nbNodesOfCellJ(nodesOfCellJ.size());
			for (size_t rNodesOfCellJ=0; rNodesOfCellJ<nbNodesOfCellJ; rNodesOfCellJ++)
			{
				Ajr[jCells][rNodesOfCellJ] = ((rho[jCells] * c[jCells]) / l[jCells][rNodesOfCellJ]) * tensProduct(C[jCells][rNodesOfCellJ], C[jCells][rNodesOfCellJ]);
			}
		}
	}
}

/**
 * Job Computedeltatj called @6.0 in executeTimeLoopN method.
 * In variables: V, c, l
 * Out variables: deltatj
 */
void Glace2d::computedeltatj() noexcept
{
	for (size_t jCells=0; jCells<nbCells; jCells++)
	{
		const Id jId(jCells);
		double reduction0(0.0);
		{
			const auto nodesOfCellJ(mesh->getNodesOfCell(jId));
			const size_t nbNodesOfCellJ(nodesOfCellJ.size());
			for (size_t rNodesOfCellJ=0; rNodesOfCellJ<nbNodesOfCellJ; rNodesOfCellJ++)
			{
				reduction0 = sumR0(reduction0, l[jCells][rNodesOfCellJ]);
			}
		}
		deltatj[jCells] = 2.0 * V[jCells] / (c[jCells] * reduction0);
	}
}

/**
 * Job ComputeAr called @7.0 in executeTimeLoopN method.
 * In variables: Ajr
 * Out variables: Ar
 */
void Glace2d::computeAr() noexcept
{
	for (size_t rNodes=0; rNodes<nbNodes; rNodes++)
	{
		const Id rId(rNodes);
		RealArray2D<2,2> reduction0({0.0, 0.0,  0.0, 0.0});
		{
			const auto cellsOfNodeR(mesh->getCellsOfNode(rId));
			const size_t nbCellsOfNodeR(cellsOfNodeR.size());
			for (size_t jCellsOfNodeR=0; jCellsOfNodeR<nbCellsOfNodeR; jCellsOfNodeR++)
			{
				const Id jId(cellsOfNodeR[jCellsOfNodeR]);
				const size_t jCells(jId);
				const size_t rNodesOfCellJ(utils::indexOf(mesh->getNodesOfCell(jId), rId));
				reduction0 = sumR2(reduction0, Ajr[jCells][rNodesOfCellJ]);
			}
		}
		Ar[rNodes] = reduction0;
	}
}

/**
 * Job ComputeBr called @7.0 in executeTimeLoopN method.
 * In variables: Ajr, C, p, uj_n
 * Out variables: b
 */
void Glace2d::computeBr() noexcept
{
	for (size_t rNodes=0; rNodes<nbNodes; rNodes++)
	{
		const Id rId(rNodes);
		RealArray1D<2> reduction0({0.0, 0.0});
		{
			const auto cellsOfNodeR(mesh->getCellsOfNode(rId));
			const size_t nbCellsOfNodeR(cellsOfNodeR.size());
			for (size_t jCellsOfNodeR=0; jCellsOfNodeR<nbCellsOfNodeR; jCellsOfNodeR++)
			{
				const Id jId(cellsOfNodeR[jCellsOfNodeR]);
				const size_t jCells(jId);
				const size_t rNodesOfCellJ(utils::indexOf(mesh->getNodesOfCell(jId), rId));
				reduction0 = sumR1(reduction0, p[jCells] * C[jCells][rNodesOfCellJ] + matVectProduct(Ajr[jCells][rNodesOfCellJ], uj_n[jCells]));
			}
		}
		b[rNodes] = reduction0;
	}
}

/**
 * Job ComputeDt called @7.0 in executeTimeLoopN method.
 * In variables: deltatCfl, deltatj
 * Out variables: deltat_nplus1
 */
void Glace2d::computeDt() noexcept
{
	double reduction0(numeric_limits<double>::max());
	for (size_t jCells=0; jCells<nbCells; jCells++)
	{
		reduction0 = minR0(reduction0, deltatj[jCells]);
	}
	deltat_nplus1 = options.deltatCfl * reduction0;
}

/**
 * Job ComputeBoundaryConditions called @8.0 in executeTimeLoopN method.
 * In variables: Ar, b
 * Out variables: Mt, bt
 */
void Glace2d::computeBoundaryConditions() noexcept
{
	const RealArray2D<2,2> I({1.0, 0.0, 0.0, 1.0});
	{
		const auto topNodes(mesh->getTopNodes());
		const size_t nbTopNodes(topNodes.size());
		for (size_t rTopNodes=0; rTopNodes<nbTopNodes; rTopNodes++)
		{
			const Id rId(topNodes[rTopNodes]);
			const size_t rNodes(rId);
			const RealArray1D<2> N({0.0, 1.0});
			const RealArray2D<2,2> NxN(tensProduct(N, N));
			const RealArray2D<2,2> IcP(I - NxN);
			bt[rNodes] = matVectProduct(IcP, b[rNodes]);
			Mt[rNodes] = IcP * (Ar[rNodes] * IcP) + NxN * trace(Ar[rNodes]);
		}
	}
	{
		const auto bottomNodes(mesh->getBottomNodes());
		const size_t nbBottomNodes(bottomNodes.size());
		for (size_t rBottomNodes=0; rBottomNodes<nbBottomNodes; rBottomNodes++)
		{
			const Id rId(bottomNodes[rBottomNodes]);
			const size_t rNodes(rId);
			const RealArray1D<2> N({0.0, -1.0});
			const RealArray2D<2,2> NxN(tensProduct(N, N));
			const RealArray2D<2,2> IcP(I - NxN);
			bt[rNodes] = matVectProduct(IcP, b[rNodes]);
			Mt[rNodes] = IcP * (Ar[rNodes] * IcP) + NxN * trace(Ar[rNodes]);
		}
	}
	{
		const auto leftNodes(mesh->getLeftNodes());
		const size_t nbLeftNodes(leftNodes.size());
		for (size_t rLeftNodes=0; rLeftNodes<nbLeftNodes; rLeftNodes++)
		{
			const Id rId(leftNodes[rLeftNodes]);
			const size_t rNodes(rId);
			Mt[rNodes] = I;
			bt[rNodes] = {0.0, 0.0};
		}
	}
	{
		const auto rightNodes(mesh->getRightNodes());
		const size_t nbRightNodes(rightNodes.size());
		for (size_t rRightNodes=0; rRightNodes<nbRightNodes; rRightNodes++)
		{
			const Id rId(rightNodes[rRightNodes]);
			const size_t rNodes(rId);
			Mt[rNodes] = I;
			bt[rNodes] = {0.0, 0.0};
		}
	}
}

/**
 * Job ComputeBt called @8.0 in executeTimeLoopN method.
 * In variables: b
 * Out variables: bt
 */
void Glace2d::computeBt() noexcept
{
	{
		const auto innerNodes(mesh->getInnerNodes());
		const size_t nbInnerNodes(innerNodes.size());
		for (size_t rInnerNodes=0; rInnerNodes<nbInnerNodes; rInnerNodes++)
		{
			const Id rId(innerNodes[rInnerNodes]);
			const size_t rNodes(rId);
			bt[rNodes] = b[rNodes];
		}
	}
}

/**
 * Job ComputeMt called @8.0 in executeTimeLoopN method.
 * In variables: Ar
 * Out variables: Mt
 */
void Glace2d::computeMt() noexcept
{
	{
		const auto innerNodes(mesh->getInnerNodes());
		const size_t nbInnerNodes(innerNodes.size());
		for (size_t rInnerNodes=0; rInnerNodes<nbInnerNodes; rInnerNodes++)
		{
			const Id rId(innerNodes[rInnerNodes]);
			const size_t rNodes(rId);
			Mt[rNodes] = Ar[rNodes];
		}
	}
}

/**
 * Job ComputeTn called @8.0 in executeTimeLoopN method.
 * In variables: deltat_nplus1, t_n
 * Out variables: t_nplus1
 */
void Glace2d::computeTn() noexcept
{
	t_nplus1 = t_n + deltat_nplus1;
}

/**
 * Job ComputeU called @9.0 in executeTimeLoopN method.
 * In variables: Mt, bt
 * Out variables: ur
 */
void Glace2d::computeU() noexcept
{
	for (size_t rNodes=0; rNodes<nbNodes; rNodes++)
	{
		ur[rNodes] = matVectProduct(inverse(Mt[rNodes]), bt[rNodes]);
	}
}

/**
 * Job ComputeFjr called @10.0 in executeTimeLoopN method.
 * In variables: Ajr, C, p, uj_n, ur
 * Out variables: F
 */
void Glace2d::computeFjr() noexcept
{
	for (size_t jCells=0; jCells<nbCells; jCells++)
	{
		const Id jId(jCells);
		{
			const auto nodesOfCellJ(mesh->getNodesOfCell(jId));
			const size_t nbNodesOfCellJ(nodesOfCellJ.size());
			for (size_t rNodesOfCellJ=0; rNodesOfCellJ<nbNodesOfCellJ; rNodesOfCellJ++)
			{
				const Id rId(nodesOfCellJ[rNodesOfCellJ]);
				const size_t rNodes(rId);
				F[jCells][rNodesOfCellJ] = p[jCells] * C[jCells][rNodesOfCellJ] + matVectProduct(Ajr[jCells][rNodesOfCellJ], (uj_n[jCells] - ur[rNodes]));
			}
		}
	}
}

/**
 * Job ComputeXn called @10.0 in executeTimeLoopN method.
 * In variables: X_n, deltat_n, ur
 * Out variables: X_nplus1
 */
void Glace2d::computeXn() noexcept
{
	for (size_t rNodes=0; rNodes<nbNodes; rNodes++)
	{
		X_nplus1[rNodes] = X_n[rNodes] + deltat_n * ur[rNodes];
	}
}

/**
 * Job ComputeEn called @11.0 in executeTimeLoopN method.
 * In variables: E_n, F, deltat_n, m, ur
 * Out variables: E_nplus1
 */
void Glace2d::computeEn() noexcept
{
	for (size_t jCells=0; jCells<nbCells; jCells++)
	{
		const Id jId(jCells);
		double reduction0(0.0);
		{
			const auto nodesOfCellJ(mesh->getNodesOfCell(jId));
			const size_t nbNodesOfCellJ(nodesOfCellJ.size());
			for (size_t rNodesOfCellJ=0; rNodesOfCellJ<nbNodesOfCellJ; rNodesOfCellJ++)
			{
				const Id rId(nodesOfCellJ[rNodesOfCellJ]);
				const size_t rNodes(rId);
				reduction0 = sumR0(reduction0, dot(F[jCells][rNodesOfCellJ], ur[rNodes]));
			}
		}
		E_nplus1[jCells] = E_n[jCells] - (deltat_n / m[jCells]) * reduction0;
	}
}

/**
 * Job ComputeUn called @11.0 in executeTimeLoopN method.
 * In variables: F, deltat_n, m, uj_n
 * Out variables: uj_nplus1
 */
void Glace2d::computeUn() noexcept
{
	for (size_t jCells=0; jCells<nbCells; jCells++)
	{
		const Id jId(jCells);
		RealArray1D<2> reduction0({0.0, 0.0});
		{
			const auto nodesOfCellJ(mesh->getNodesOfCell(jId));
			const size_t nbNodesOfCellJ(nodesOfCellJ.size());
			for (size_t rNodesOfCellJ=0; rNodesOfCellJ<nbNodesOfCellJ; rNodesOfCellJ++)
			{
				reduction0 = sumR1(reduction0, F[jCells][rNodesOfCellJ]);
			}
		}
		uj_nplus1[jCells] = uj_n[jCells] - (deltat_n / m[jCells]) * reduction0;
	}
}

void Glace2d::dumpVariables(int iteration, bool useTimer)
{
	if (!writer.isDisabled())
	{
		if (useTimer)
		{
			cpuTimer.stop();
			ioTimer.start();
		}
		auto quads = mesh->getGeometry()->getQuads();
		writer.startVtpFile(iteration, t_n, nbNodes, X_n.data(), nbCells, quads.data());
		writer.openNodeData();
		writer.closeNodeData();
		writer.openCellData();
		writer.write("Density", rho);
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

void Glace2d::simulate()
{
	std::cout << "\n" << __BLUE_BKG__ << __YELLOW__ << __BOLD__ <<"\tStarting Glace2d ..." << __RESET__ << "\n\n";
	
	std::cout << "[" << __GREEN__ << "TOPOLOGY" << __RESET__ << "]  HWLOC unavailable cannot get topological informations" << std::endl;
	
	if (!writer.isDisabled())
		std::cout << "[" << __GREEN__ << "OUTPUT" << __RESET__ << "]    VTK files stored in " << __BOLD__ << writer.outputDirectory() << __RESET__ << " directory" << std::endl;
	else
		std::cout << "[" << __GREEN__ << "OUTPUT" << __RESET__ << "]    " << __BOLD__ << "Disabled" << __RESET__ << std::endl;

	iniCjrIc(); // @1.0
	iniTime(); // @1.0
	iniTimeStep(); // @1.0
	initialize(); // @2.0
	setUpTimeLoopN(); // @2.0
	executeTimeLoopN(); // @3.0
	
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
		std::cerr << "(Glace2d.json)" << std::endl;
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
	Glace2d::Options glace2dOptions;
	if (d.HasMember("glace2d"))
	{
		rapidjson::StringBuffer strbuf;
		rapidjson::Writer<rapidjson::StringBuffer> writer(strbuf);
		d["glace2d"].Accept(writer);
		glace2dOptions.jsonInit(strbuf.GetString());
	}
	Glace2d* glace2d = new Glace2d(mesh, glace2dOptions);
	
	// Start simulation
	// Simulator must be a pointer when a finalize is needed at the end (Kokkos, omp...)
	glace2d->simulate();
	
	delete glace2d;
	delete mesh;
	return ret;
}
