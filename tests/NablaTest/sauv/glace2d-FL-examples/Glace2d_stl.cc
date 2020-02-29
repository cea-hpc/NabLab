#include <iostream>
#include <iomanip>
#include <type_traits>
#include <limits>
#include <utility>
#include <cmath>
#include <cfenv>
#pragma STDC FENV_ACCESS ON

// Project headers
#include "mesh/NumericMesh2D.h"
#include "mesh/CartesianMesh2DGenerator.h"
#include "mesh/PvdFileWriter2D.h"
#include "utils/Utils.h"
#include "utils/Timer.h"
#include "utils/Parallel.h"
#include "types/Types.h"
#include "types/MathFunctions.h"
#include "glace2d/Glace2dFunctions.h"

using namespace nablalib;

class Glace2d
{
public:
	struct Options
	{
		// Should be const but usefull to set them from main args
		double X_EDGE_LENGTH = 0.01;
		double Y_EDGE_LENGTH = as_const(X_EDGE_LENGTH);
		int X_EDGE_ELEMS = 100;
		int Y_EDGE_ELEMS = 10;
		int Z_EDGE_ELEMS = 1;
		double option_stoptime = 0.2;
		int option_max_iterations = 20000;
		double gamma = 1.4;
		double option_x_interface = 0.5;
		double option_deltat_ini = 1.0E-5;
		double option_deltat_cfl = 0.4;
		double option_rho_ini_zg = 1.0;
		double option_rho_ini_zd = 0.125;
		double option_p_ini_zg = 1.0;
		double option_p_ini_zd = 0.1;
	};
	Options* options;

private:
	int iteration;
	NumericMesh2D* mesh;
	PvdFileWriter2D writer;
	int nbNodes, nbCells, nbNodesOfCell, nbCellsOfNode, nbInnerNodes, nbOuterFaces, nbNodesOfFace;

	// Global Variables
	double t, deltat, deltat_nplus1, t_nplus1;

	// Connectivity Variables
	std::vector<RealArray1D<2>> X;
	std::vector<RealArray1D<2>> b;
	std::vector<RealArray1D<2>> bt;
	std::vector<RealArray2D<2,2>> Ar;
	std::vector<RealArray2D<2,2>> Mt;
	std::vector<RealArray1D<2>> ur;
	std::vector<double> p_ic;
	std::vector<double> rho_ic;
	std::vector<double> V_ic;
	std::vector<double> c;
	std::vector<double> m;
	std::vector<double> p;
	std::vector<double> rho;
	std::vector<double> e;
	std::vector<double> E;
	std::vector<double> V;
	std::vector<double> deltatj;
	std::vector<RealArray1D<2>> uj;
	std::vector<RealArray1D<2>> center;
	std::vector<std::vector<double>> l;
	std::vector<std::vector<RealArray1D<2>>> C_ic;
	std::vector<std::vector<RealArray1D<2>>> C;
	std::vector<std::vector<RealArray1D<2>>> F;
	std::vector<std::vector<RealArray2D<2,2>>> Ajr;
	std::vector<RealArray1D<2>> X_n0;
	std::vector<RealArray1D<2>> X_nplus1;
	std::vector<RealArray1D<2>> uj_nplus1;
	std::vector<double> E_nplus1;
	
	//const size_t maxHardThread = Kokkos::DefaultExecutionSpace::max_hardware_threads();

	// Timers
	utils::Timer cpu_timer;
	utils::Timer io_timer;

public:
	Glace2d(Options* aOptions, NumericMesh2D* aNumericMesh2D, string output)
	: options(aOptions)
	, mesh(aNumericMesh2D)
	, writer("Glace2d", output)
	, nbNodes(mesh->getNbNodes())
	, nbCells(mesh->getNbCells())
	, nbNodesOfCell(NumericMesh2D::MaxNbNodesOfCell)
	, nbCellsOfNode(NumericMesh2D::MaxNbCellsOfNode)
	, nbInnerNodes(mesh->getNbInnerNodes())
	, nbOuterFaces(mesh->getNbOuterFaces())
	, nbNodesOfFace(NumericMesh2D::MaxNbNodesOfFace)
	, t(0.0)
	, deltat(as_const(options->option_deltat_ini))
	, deltat_nplus1(as_const(options->option_deltat_ini))
	, t_nplus1(0.0)
	, X(nbNodes)
	, b(nbNodes)
	, bt(nbNodes)
	, Ar(nbNodes)
	, Mt(nbNodes)
	, ur(nbNodes)
	, p_ic(nbCells)
	, rho_ic(nbCells)
	, V_ic(nbCells)
	, c(nbCells)
	, m(nbCells)
	, p(nbCells)
	, rho(nbCells)
	, e(nbCells)
	, E(nbCells)
	, V(nbCells)
	, deltatj(nbCells)
	, uj(nbCells)
	, center(nbCells)
	, l(nbCells, std::vector<double>(nbNodesOfCell))
	, C_ic(nbCells, std::vector<RealArray1D<2>>(nbNodesOfCell))
	, C(nbCells, std::vector<RealArray1D<2>>(nbNodesOfCell))
	, F(nbCells, std::vector<RealArray1D<2>>(nbNodesOfCell))
	, Ajr(nbCells, std::vector<RealArray2D<2,2>>(nbNodesOfCell))
	, X_n0(nbNodes)
	, X_nplus1(nbNodes)
	, uj_nplus1(nbCells)
	, E_nplus1(nbCells)
	{
		// Copy node coordinates
		const auto& gNodes = mesh->getGeometricMesh()->getNodes();
    for (int rNodes(0); rNodes < nbNodes; ++rNodes)
		//Kokkos::parallel_for(nbNodes, KOKKOS_LAMBDA(const int& rNodes)
		{
			X_n0[rNodes] = gNodes[rNodes];
		}//);
	}

private:


  //// Some kind of bad static openMP parallel for
  //void parallel_shit(const int beg, const int end, std::function<void(const int&)> lambda) noexcept
  //{
    //const int chunck_size(std::floor(nbCells / maxHardThread));  // to test shit, could be better
    //const int len(end - beg);
    //// if every chuncks have been computed
    //if (len <= chunck_size) {
      //for (int i(beg); i < end; ++i)
        //lambda(i);
      //return;
    //}

    //std::cout << "BEG = " << beg << ", END = " << end << std::endl;

    //// else spawn a new thread asynchronously
    //const int next(beg + chunck_size < end ? beg + chunck_size : end);
    //auto func = std::bind(&Glace2d::parallel_shit, this, next, end, lambda);
    //auto future = std::async(std::launch::async, func);
    //parallel_shit(beg, next, lambda);
    //return future.get();
  //}



	/**
	 * Job Copy_X_n0_to_X @-3.0
	 * In variables: X_n0
	 * Out variables: X
	 */
	
	void copy_X_n0_to_X() noexcept
	{
    for (size_t i(0); i < X_n0.size(); ++i) {
      X[i][0] = X_n0[i][0];
      X[i][1] = X_n0[i][1];
    }
		//deep_copy(X, X_n0);
	}
	
	/**
	 * Job IniCenter @-3.0
	 * In variables: X_n0
	 * Out variables: center
	 */  
	void iniCenter() noexcept
	{
    parallel::parallel_exec(nbCells, [&](const int& jCells){
      int jId(jCells);
			RealArray1D<2> reduction1270435399 = {0.0, 0.0};
			{
				auto nodesOfCellJ(mesh->getNodesOfCell(jId));
				for (int rNodesOfCellJ=0; rNodesOfCellJ<nodesOfCellJ.size(); rNodesOfCellJ++)
				{
					int rId(nodesOfCellJ[rNodesOfCellJ]);
					int rNodes(rId);
					reduction1270435399 += (X_n0[rNodes]);
				}
			}
			center[jCells] = 0.25 * reduction1270435399;
    });
	}
	
	/**
	 * Job ComputeCjrIc @-3.0
	 * In variables: X_n0
	 * Out variables: C_ic
	 */
	
	void computeCjrIc() noexcept
	{
		parallel::parallel_exec(nbCells, [&](const int& jCells)
		{
			int jId(jCells);
			{
				auto nodesOfCellJ(mesh->getNodesOfCell(jId));
				for (int rNodesOfCellJ=0; rNodesOfCellJ<nodesOfCellJ.size(); rNodesOfCellJ++)
				{
					int rMinus1Id(nodesOfCellJ[(rNodesOfCellJ-1+nbNodesOfCell)%nbNodesOfCell]);
					int rPlus1Id(nodesOfCellJ[(rNodesOfCellJ+1+nbNodesOfCell)%nbNodesOfCell]);
					int rMinus1Nodes(rMinus1Id);
					int rPlus1Nodes(rPlus1Id);
					C_ic[jCells][rNodesOfCellJ] = 0.5 * Glace2dFunctions::perp(X_n0[rPlus1Nodes] - X_n0[rMinus1Nodes]);
				}
			}
		});
	}
	
	/**
	 * Job IniUn @-3.0
	 * In variables: 
	 * Out variables: uj
	 */
	
	void iniUn() noexcept
	{
		parallel::parallel_exec(nbCells, [&](const int& jCells)
		{
			uj[jCells][0] = 0.0;
			uj[jCells][1] = 0.0;
		});
	}
	
	/**
	 * Job IniIc @-2.0
	 * In variables: center, option_x_interface, option_rho_ini_zg, option_p_ini_zg, option_rho_ini_zd, option_p_ini_zd
	 * Out variables: rho_ic, p_ic
	 */
	
	void iniIc() noexcept
	{
		parallel::parallel_exec(nbCells, [&](const int& jCells)
		{
			if (center[jCells][0] < as_const(options->option_x_interface)) 
			{
				rho_ic[jCells] = as_const(options->option_rho_ini_zg);
				p_ic[jCells] = as_const(options->option_p_ini_zg);
			}
			else 
			{
				rho_ic[jCells] = as_const(options->option_rho_ini_zd);
				p_ic[jCells] = as_const(options->option_p_ini_zd);
			}
		});
	}
	
	/**
	 * Job IniVIc @-2.0
	 * In variables: C_ic, X_n0
	 * Out variables: V_ic
	 */
	
	void iniVIc() noexcept
	{
		parallel::parallel_exec(nbCells, [&](const int& jCells)
		{
			int jId(jCells);
			double reduction_985651369 = 0.0;
			{
				auto nodesOfCellJ(mesh->getNodesOfCell(jId));
				for (int rNodesOfCellJ=0; rNodesOfCellJ<nodesOfCellJ.size(); rNodesOfCellJ++)
				{
					int rId(nodesOfCellJ[rNodesOfCellJ]);
					int rNodes(rId);
					reduction_985651369 += (MathFunctions::dot(C_ic[jCells][rNodesOfCellJ], X_n0[rNodes]));
				}
			}
			V_ic[jCells] = 0.5 * reduction_985651369;
		});
	}
	
	/**
	 * Job IniM @-1.0
	 * In variables: rho_ic, V_ic
	 * Out variables: m
	 */
	
	void iniM() noexcept
	{
		parallel::parallel_exec(nbCells, [&](const int& jCells)
		{
			m[jCells] = rho_ic[jCells] * V_ic[jCells];
		});
	}
	
	/**
	 * Job IniEn @-1.0
	 * In variables: p_ic, gamma, rho_ic
	 * Out variables: E
	 */
	
	void iniEn() noexcept
	{
		parallel::parallel_exec(nbCells, [&](const int& jCells)
		{
			E[jCells] = p_ic[jCells] / ((as_const(options->gamma) - 1.0) * rho_ic[jCells]);
		});
	}
	
	/**
	 * Job ComputeCjr @1.0
	 * In variables: X
	 * Out variables: C
	 */
	
	void computeCjr() noexcept
	{
		parallel::parallel_exec(nbCells, [&](const int& jCells)
		{
			int jId(jCells);
			{
				auto nodesOfCellJ(mesh->getNodesOfCell(jId));
				for (int rNodesOfCellJ=0; rNodesOfCellJ<nodesOfCellJ.size(); rNodesOfCellJ++)
				{
					int rMinus1Id(nodesOfCellJ[(rNodesOfCellJ-1+nbNodesOfCell)%nbNodesOfCell]);
					int rPlus1Id(nodesOfCellJ[(rNodesOfCellJ+1+nbNodesOfCell)%nbNodesOfCell]);
					int rMinus1Nodes(rMinus1Id);
					int rPlus1Nodes(rPlus1Id);
					C[jCells][rNodesOfCellJ] = 0.5 * Glace2dFunctions::perp(X[rPlus1Nodes] - X[rMinus1Nodes]);
				}
			}
		});
	}
	
	/**
	 * Job ComputeInternalEnergy @1.0
	 * In variables: E, uj
	 * Out variables: e
	 */
	
	void computeInternalEnergy() noexcept
	{
		parallel::parallel_exec(nbCells, [&](const int& jCells)
		{
			e[jCells] = E[jCells] - 0.5 * MathFunctions::dot(uj[jCells], uj[jCells]);
		});
	}
	
	/**
	 * Job ComputeLjr @2.0
	 * In variables: C
	 * Out variables: l
	 */
	
	void computeLjr() noexcept
	{
		parallel::parallel_exec(nbCells, [&](const int& jCells)
		{
			int jId(jCells);
			{
				auto nodesOfCellJ(mesh->getNodesOfCell(jId));
				for (int rNodesOfCellJ=0; rNodesOfCellJ<nodesOfCellJ.size(); rNodesOfCellJ++)
				{
					l[jCells][rNodesOfCellJ] = MathFunctions::norm(C[jCells][rNodesOfCellJ]);
				}
			}
		});
	}
	
	/**
	 * Job ComputeV @2.0
	 * In variables: C, X
	 * Out variables: V
	 */
	
	void computeV() noexcept
	{
		parallel::parallel_exec(nbCells, [&](const int& jCells)
		{
			int jId(jCells);
			double reduction_1003648137 = 0.0;
			{
				auto nodesOfCellJ(mesh->getNodesOfCell(jId));
				for (int rNodesOfCellJ=0; rNodesOfCellJ<nodesOfCellJ.size(); rNodesOfCellJ++)
				{
					int rId(nodesOfCellJ[rNodesOfCellJ]);
					int rNodes(rId);
					reduction_1003648137 += (MathFunctions::dot(C[jCells][rNodesOfCellJ], X[rNodes]));
				}
			}
			V[jCells] = 0.5 * reduction_1003648137;
		});
	}
	
	/**
	 * Job ComputeDensity @3.0
	 * In variables: m, V
	 * Out variables: rho
	 */
	
	void computeDensity() noexcept
	{
		parallel::parallel_exec(nbCells, [&](const int& jCells)
		{
			rho[jCells] = m[jCells] / V[jCells];
		});
	}
	
	/**
	 * Job ComputeEOSp @4.0
	 * In variables: gamma, rho, e
	 * Out variables: p
	 */
	
	void computeEOSp() noexcept
	{
		parallel::parallel_exec(nbCells, [&](const int& jCells)
		{
			p[jCells] = (as_const(options->gamma) - 1.0) * rho[jCells] * e[jCells];
		});
	}
	
	/**
	 * Job dumpVariables @4.0
	 * In variables: rho
	 * Out variables: 
	 */
	
	void dumpVariables() noexcept
	{
		if (!writer.isDisabled() && (iteration % 1 == 0)) 
		{
			cpu_timer.stop();
			io_timer.start();
			std::map<string, double*> cellVariables;
			std::map<string, double*> nodeVariables;
			cellVariables.insert(pair<string,double*>("Density", rho.data()));
			auto quads = mesh->getGeometricMesh()->getQuads();
			writer.writeFile(iteration, t, nbNodes, X.data(), nbCells, quads.data(), cellVariables, nodeVariables);
			io_timer.stop();
			cpu_timer.start();
		}
	}
	
	/**
	 * Job ComputeEOSc @5.0
	 * In variables: gamma, p, rho
	 * Out variables: c
	 */
	
	void computeEOSc() noexcept
	{
		parallel::parallel_exec(nbCells, [&](const int& jCells)
		{
			c[jCells] = MathFunctions::sqrt(as_const(options->gamma) * p[jCells] / rho[jCells]);
		});
	}
	
	/**
	 * Job Computedeltatj @6.0
	 * In variables: l, V, c
	 * Out variables: deltatj
	 */
	
	void computedeltatj() noexcept
	{
		parallel::parallel_exec(nbCells, [&](const int& jCells)
		{
			int jId(jCells);
			double reduction_1877857069 = 0.0;
			{
				auto nodesOfCellJ(mesh->getNodesOfCell(jId));
				for (int rNodesOfCellJ=0; rNodesOfCellJ<nodesOfCellJ.size(); rNodesOfCellJ++)
				{
					reduction_1877857069 += (l[jCells][rNodesOfCellJ]);
				}
			}
			deltatj[jCells] = 2.0 * V[jCells] / (c[jCells] * reduction_1877857069);
		});
	}
	
	/**
	 * Job ComputeAjr @6.0
	 * In variables: rho, c, l, C
	 * Out variables: Ajr
	 */
	
	void computeAjr() noexcept
	{
		parallel::parallel_exec(nbCells, [&](const int& jCells)
		{
			int jId(jCells);
			{
				auto nodesOfCellJ(mesh->getNodesOfCell(jId));
				for (int rNodesOfCellJ=0; rNodesOfCellJ<nodesOfCellJ.size(); rNodesOfCellJ++)
				{
					Ajr[jCells][rNodesOfCellJ] = ((rho[jCells] * c[jCells]) / l[jCells][rNodesOfCellJ]) * Glace2dFunctions::tensProduct(C[jCells][rNodesOfCellJ], C[jCells][rNodesOfCellJ]);
				}
			}
		});
	}
	
	/**
	 * Job ComputeAr @7.0
	 * In variables: Ajr
	 * Out variables: Ar
	 */
	
	void computeAr() noexcept
	{
		parallel::parallel_exec(nbNodes, [&](const int& rNodes)
		{
			int rId(rNodes);
			RealArray2D<2,2> reduction833380395 = {0.0, 0.0, 0.0, 0.0};
			{
				auto cellsOfNodeR(mesh->getCellsOfNode(rId));
				for (int jCellsOfNodeR=0; jCellsOfNodeR<cellsOfNodeR.size(); jCellsOfNodeR++)
				{
					int jId(cellsOfNodeR[jCellsOfNodeR]);
					int jCells(jId);
					int rNodesOfCellJ(utils::indexOf(mesh->getNodesOfCell(jId),rId));
					reduction833380395 += (Ajr[jCells][rNodesOfCellJ]);
				}
			}
			Ar[rNodes] = reduction833380395;
		});
	}
	
	/**
	 * Job ComputeBr @7.0
	 * In variables: p, C, Ajr, uj
	 * Out variables: b
	 */
	
	void computeBr() noexcept
	{
		parallel::parallel_exec(nbNodes, [&](const int& rNodes)
		{
			int rId(rNodes);
			RealArray1D<2> reduction84436631 = {0.0, 0.0};
			{
				auto cellsOfNodeR(mesh->getCellsOfNode(rId));
				for (int jCellsOfNodeR=0; jCellsOfNodeR<cellsOfNodeR.size(); jCellsOfNodeR++)
				{
					int jId(cellsOfNodeR[jCellsOfNodeR]);
					int jCells(jId);
					int rNodesOfCellJ(utils::indexOf(mesh->getNodesOfCell(jId),rId));
					reduction84436631 += (p[jCells] * C[jCells][rNodesOfCellJ] + Glace2dFunctions::matVectProduct(Ajr[jCells][rNodesOfCellJ], uj[jCells]));
				}
			}
			b[rNodes] = reduction84436631;
		});
	}
	
	/**
	 * Job ComputeDt @7.0
	 * In variables: deltatj, option_deltat_cfl
	 * Out variables: deltat_nplus1
	 */
	
	void computeDt() noexcept
	{
		//double reduction1979477213(numeric_limits<double>::max());
		//{
			//Kokkos::Min<double> reducer(reduction1979477213);
			//Kokkos::parallel_reduce("Reductionreduction1979477213", nbCells, [&](const int& jCells, double& x)
			//{
				//reducer.join(x, deltatj(jCells));
			//}, reducer);
		//}
		//deltat_nplus1 = as_const(options->option_deltat_cfl) * reduction1979477213;
    
    deltat_nplus1 = as_const(options->option_deltat_cfl) *
                        parallel::parallel_reduce(nbCells, deltatj, numeric_limits<double>::max(),
                                                  [&](const double& a, const double& b){return std::min(a, b);});
	}
	
	/**
	 * Job Copy_deltat_nplus1_to_deltat @8.0
	 * In variables: deltat_nplus1
	 * Out variables: deltat
	 */
	
	void copy_deltat_nplus1_to_deltat() noexcept
	{
		std::swap(deltat_nplus1, deltat);
	}
	
	/**
	 * Job ComputeMt @8.0
	 * In variables: Ar
	 * Out variables: Mt
	 */
	
	void computeMt() noexcept
	{
		auto innerNodes(mesh->getInnerNodes());
		parallel::parallel_exec(nbInnerNodes, [&](const int& rInnerNodes)
		{
			int rId(innerNodes[rInnerNodes]);
			int rNodes(rId);
			Mt[rNodes] = Ar[rNodes];
		});
	}
	
	/**
	 * Job ComputeBt @8.0
	 * In variables: b
	 * Out variables: bt
	 */
	
	void computeBt() noexcept
	{
		auto innerNodes(mesh->getInnerNodes());
		parallel::parallel_exec(nbInnerNodes, [&](const int& rInnerNodes)
		{
			int rId(innerNodes[rInnerNodes]);
			int rNodes(rId);
			bt[rNodes] = b[rNodes];
		});
	}
	
	/**
	 * Job OuterFacesComputations @8.0
	 * In variables: X_EDGE_ELEMS, X_EDGE_LENGTH, Y_EDGE_ELEMS, Y_EDGE_LENGTH, X, b, Ar
	 * Out variables: bt, Mt
	 */
	
	void outerFacesComputations() noexcept
	{
		auto outerFaces(mesh->getOuterFaces());
		parallel::parallel_exec(nbOuterFaces, [&](const int& kOuterFaces)
		{
			int kId(outerFaces[kOuterFaces]);
			const double epsilon = 1.0E-10;
			RealArray2D<2,2> I = {1.0, 0.0, 0.0, 1.0};
			double X_MIN = 0.0;
			double X_MAX = as_const(options->X_EDGE_ELEMS) * as_const(options->X_EDGE_LENGTH);
			double Y_MIN = 0.0;
			double Y_MAX = as_const(options->Y_EDGE_ELEMS) * as_const(options->Y_EDGE_LENGTH);
			RealArray1D<2> nY = {0.0, 1.0};
			{
				auto nodesOfFaceK(mesh->getNodesOfFace(kId));
				for (int rNodesOfFaceK=0; rNodesOfFaceK<nodesOfFaceK.size(); rNodesOfFaceK++)
				{
					int rId(nodesOfFaceK[rNodesOfFaceK]);
					int rNodes(rId);
					if ((X[rNodes][1] - Y_MIN < epsilon) || (X[rNodes][1] - Y_MAX < epsilon)) 
					{
						double sign = 0.0;
						if (X[rNodes][1] - Y_MIN < epsilon) 
							sign = -1.0;
						else 
							sign = 1.0;
						RealArray1D<2> n = sign * nY;
						RealArray2D<2,2> nxn = Glace2dFunctions::tensProduct(n, n);
						RealArray2D<2,2> IcP = I - nxn;
						bt[rNodes] = Glace2dFunctions::matVectProduct(IcP, b[rNodes]);
						Mt[rNodes] = IcP * (Ar[rNodes] * IcP) + nxn * Glace2dFunctions::trace(Ar[rNodes]);
					}
					if ((MathFunctions::fabs(X[rNodes][0] - X_MIN) < epsilon) || ((MathFunctions::fabs(X[rNodes][0] - X_MAX) < epsilon))) 
					{
						Mt[rNodes] = I;
						bt[rNodes][0] = 0.0;
						bt[rNodes][1] = 0.0;
					}
				}
			}
		});
	}
	
	/**
	 * Job ComputeTn @8.0
	 * In variables: t, deltat_nplus1
	 * Out variables: t_nplus1
	 */
	
	void computeTn() noexcept
	{
		t_nplus1 = as_const(t) + as_const(deltat_nplus1);
	}
	
	/**
	 * Job Copy_t_nplus1_to_t @9.0
	 * In variables: t_nplus1
	 * Out variables: t
	 */
	
	void copy_t_nplus1_to_t() noexcept
	{
		std::swap(t_nplus1, t);
	}
	
	/**
	 * Job ComputeU @9.0
	 * In variables: Mt, bt
	 * Out variables: ur
	 */
	
	void computeU() noexcept
	{
		parallel::parallel_exec(nbNodes, [&](const int& rNodes)
		{
			ur[rNodes] = Glace2dFunctions::matVectProduct(Glace2dFunctions::inverse(Mt[rNodes]), bt[rNodes]);
		});
	}
	
	/**
	 * Job ComputeFjr @10.0
	 * In variables: p, C, Ajr, uj, ur
	 * Out variables: F
	 */
	
	void computeFjr() noexcept
	{
		parallel::parallel_exec(nbCells, [&](const int& jCells)
		{
			int jId(jCells);
			{
				auto nodesOfCellJ(mesh->getNodesOfCell(jId));
				for (int rNodesOfCellJ=0; rNodesOfCellJ<nodesOfCellJ.size(); rNodesOfCellJ++)
				{
					int rId(nodesOfCellJ[rNodesOfCellJ]);
					int rNodes(rId);
					F[jCells][rNodesOfCellJ] = p[jCells] * C[jCells][rNodesOfCellJ] + Glace2dFunctions::matVectProduct(Ajr[jCells][rNodesOfCellJ], (uj[jCells] - ur[rNodes]));
				}
			}
		});
	}
	
	/**
	 * Job ComputeXn @10.0
	 * In variables: X, deltat, ur
	 * Out variables: X_nplus1
	 */
	
	void computeXn() noexcept
	{
		parallel::parallel_exec(nbNodes, [&](const int& rNodes)
		{
			X_nplus1[rNodes] = X[rNodes] + as_const(deltat) * ur[rNodes];
		});
	}
	
	/**
	 * Job Copy_X_nplus1_to_X @11.0
	 * In variables: X_nplus1
	 * Out variables: X
	 */
	
	void copy_X_nplus1_to_X() noexcept
	{
		std::swap(X_nplus1, X);
	}
	
	/**
	 * Job ComputeUn @11.0
	 * In variables: F, uj, deltat, m
	 * Out variables: uj_nplus1
	 */
	
	void computeUn() noexcept
	{
		parallel::parallel_exec(nbCells, [&](const int& jCells)
		{
			int jId(jCells);
			RealArray1D<2> reduction_1886203389 = {0.0, 0.0};
			{
				auto nodesOfCellJ(mesh->getNodesOfCell(jId));
				for (int rNodesOfCellJ=0; rNodesOfCellJ<nodesOfCellJ.size(); rNodesOfCellJ++)
				{
					reduction_1886203389 += (F[jCells][rNodesOfCellJ]);
				}
			}
			uj_nplus1[jCells] = uj[jCells] - (as_const(deltat) / m[jCells]) * reduction_1886203389;
		});
	}
	
	/**
	 * Job ComputeEn @11.0
	 * In variables: F, ur, E, deltat, m
	 * Out variables: E_nplus1
	 */
	
	void computeEn() noexcept
	{
		parallel::parallel_exec(nbCells, [&](const int& jCells)
		{
			int jId(jCells);
			double reduction241165959 = 0.0;
			{
				auto nodesOfCellJ(mesh->getNodesOfCell(jId));
				for (int rNodesOfCellJ=0; rNodesOfCellJ<nodesOfCellJ.size(); rNodesOfCellJ++)
				{
					int rId(nodesOfCellJ[rNodesOfCellJ]);
					int rNodes(rId);
					reduction241165959 += (MathFunctions::dot(F[jCells][rNodesOfCellJ], ur[rNodes]));
				}
			}
			E_nplus1[jCells] = E[jCells] - (as_const(deltat) / m[jCells]) * reduction241165959;
		});
	}
	
	/**
	 * Job Copy_uj_nplus1_to_uj @12.0
	 * In variables: uj_nplus1
	 * Out variables: uj
	 */
	
	void copy_uj_nplus1_to_uj() noexcept
	{
		std::swap(uj_nplus1, uj);
	}
	
	/**
	 * Job Copy_E_nplus1_to_E @12.0
	 * In variables: E_nplus1
	 * Out variables: E
	 */
	
	void copy_E_nplus1_to_E() noexcept
	{
		std::swap(E_nplus1, E);
	}

public:
	void simulate()
	{
		std::cout << "\n" << __BLUE_BKG__ << __YELLOW__ << __BOLD__ <<"\tStarting Glace2d ..." << __RESET__ << "\n\n";

		std::cout << "[" << __GREEN__ << "MESH" << __RESET__ << "]      X=" << __BOLD__ << options->X_EDGE_ELEMS << __RESET__ << ", Y=" << __BOLD__ << options->Y_EDGE_ELEMS
			<< __RESET__ << ", X length=" << __BOLD__ << options->X_EDGE_LENGTH << __RESET__ << ", Y length=" << __BOLD__ << options->Y_EDGE_LENGTH << __RESET__ << std::endl;


		//if (Kokkos::hwloc::available()) {
			//std::cout << "[" << __GREEN__ << "TOPOLOGY" << __RESET__ << "]  NUMA=" << __BOLD__ << Kokkos::hwloc::get_available_numa_count()
				//<< __RESET__ << ", Cores/NUMA=" << __BOLD__ << Kokkos::hwloc::get_available_cores_per_numa()
				//<< __RESET__ << ", Threads/Core=" << __BOLD__ << Kokkos::hwloc::get_available_threads_per_core() << __RESET__ << std::endl;
		//} else {
			//std::cout << "[" << __GREEN__ << "TOPOLOGY" << __RESET__ << "]  HWLOC unavailable cannot get topological informations" << std::endl;
		//}
    std::cout << "[" << __GREEN__ << "TOPOLOGY" << __RESET__ << "]  Running "
              << (std::thread::hardware_concurrency()>2?std::thread::hardware_concurrency():2) << " threads" << std::endl;

		// std::cout << "[" << __GREEN__ << "KOKKOS" << __RESET__ << "]    " << __BOLD__ << (is_same<MyLayout,Kokkos::LayoutLeft>::value?"Left":"Right")" << __RESET__ << " layout" << std::endl;

		if (!writer.isDisabled())
			std::cout << "[" << __GREEN__ << "OUTPUT" << __RESET__ << "]    VTK files stored in " << __BOLD__ << writer.outputDirectory() << __RESET__ << " directory" << std::endl;
		else
			std::cout << "[" << __GREEN__ << "OUTPUT" << __RESET__ << "]    " << __BOLD__ << "Disabled" << __RESET__ << std::endl;

		utils::Timer timer(true);

		copy_X_n0_to_X(); // @-3.0
		iniCenter(); // @-3.0
		computeCjrIc(); // @-3.0
		iniUn(); // @-3.0
		iniIc(); // @-2.0
		iniVIc(); // @-2.0
		iniM(); // @-1.0
		iniEn(); // @-1.0
		timer.stop();

		iteration = 0;
		while (t < options->option_stoptime && iteration < options->option_max_iterations)
		{
			timer.start();
			cpu_timer.start();
			iteration++;
			if (iteration!=1)
				std::cout << "[" << __CYAN__ << __BOLD__ << setw(3) << iteration << __RESET__ "] t = " << __BOLD__
					<< setiosflags(std::ios::scientific) << setprecision(8) << setw(16) << t << __RESET__;

			computeCjr(); // @1.0
			computeInternalEnergy(); // @1.0
			computeLjr(); // @2.0
			computeV(); // @2.0
			computeDensity(); // @3.0
			computeEOSp(); // @4.0
			dumpVariables(); // @4.0
			computeEOSc(); // @5.0
			computedeltatj(); // @6.0
			computeAjr(); // @6.0
			computeAr(); // @7.0
			computeBr(); // @7.0
			computeDt(); // @7.0
			copy_deltat_nplus1_to_deltat(); // @8.0
			computeMt(); // @8.0
			computeBt(); // @8.0
			outerFacesComputations(); // @8.0
			computeTn(); // @8.0
			copy_t_nplus1_to_t(); // @9.0
			computeU(); // @9.0
			computeFjr(); // @10.0
			computeXn(); // @10.0
			copy_X_nplus1_to_X(); // @11.0
			computeUn(); // @11.0
			computeEn(); // @11.0
			copy_uj_nplus1_to_uj(); // @12.0
			copy_E_nplus1_to_E(); // @12.0
			cpu_timer.stop();

			// Timers display
			if (!writer.isDisabled()) {
				std::cout << " {CPU: " << __BLUE__ << cpu_timer.print(true) << __RESET__ ", IO: " << __BLUE__ << io_timer.print(true) << __RESET__ "} ";
			} else {
				std::cout << " {CPU: " << __BLUE__ << cpu_timer.print(true) << __RESET__ ", IO: " << __RED__ << "none" << __RESET__ << "} ";
			}

			// Progress
			std::cout << utils::progress_bar(iteration, options->option_max_iterations, t, options->option_stoptime, 30);
			timer.stop();
			std::cout << __BOLD__ << __CYAN__ << utils::Timer::print(
				utils::eta(iteration, options->option_max_iterations, t, options->option_stoptime, deltat, timer), true)
				<< __RESET__ << "\r";
			std::cout.flush();
			cpu_timer.reset();
			io_timer.reset();
		}
		std::cout << __YELLOW__ << "\n\tDone ! Took " << __MAGENTA__ << __BOLD__ << timer.print() << __RESET__ << std::endl;
	}
};	

int main(int argc, char* argv[]) 
{
	//Kokkos::initialize(argc, argv);
	auto o = new Glace2d::Options();
	string output;
	if (argc == 5) {
		o->X_EDGE_ELEMS = std::atoi(argv[1]);
		o->Y_EDGE_ELEMS = std::atoi(argv[2]);
		o->X_EDGE_LENGTH = std::atof(argv[3]);
		o->Y_EDGE_LENGTH = std::atof(argv[4]);
	} else if (argc == 6) {
		o->X_EDGE_ELEMS = std::atoi(argv[1]);
		o->Y_EDGE_ELEMS = std::atoi(argv[2]);
		o->X_EDGE_LENGTH = std::atof(argv[3]);
		o->Y_EDGE_LENGTH = std::atof(argv[4]);
		output = argv[5];
	} else if (argc != 1) {
		std::cerr << "[ERROR] Wrong number of arguments. Expecting 4 or 5 args: X Y Xlength Ylength (output)." << std::endl;
		std::cerr << "(X=100, Y=10, Xlength=0.01, Ylength=0.01 output=current directory with no args)" << std::endl;
	}
	auto gm = CartesianMesh2DGenerator::generate(o->X_EDGE_ELEMS, o->Y_EDGE_ELEMS, o->X_EDGE_LENGTH, o->Y_EDGE_LENGTH);
	auto nm = new NumericMesh2D(gm);
	auto c = new Glace2d(o, nm, output);
	c->simulate();
	delete c;
	delete nm;
	delete gm;
	delete o;
	//Kokkos::finalize();
	return 0;
}
