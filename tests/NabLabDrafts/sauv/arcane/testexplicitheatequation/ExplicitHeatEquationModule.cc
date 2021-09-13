#include "ExplicitHeatEquationModule.h"
#include <arcane/Concurrency.h>

using namespace Arcane;

/******************** Free functions definitions ********************/

namespace explicitheatequationfreefuncs
{
	double norm(ConstArrayView<Real> a)
	{
		return std::sqrt(explicitheatequationfreefuncs::dot(a, a));
	}

	double dot(ConstArrayView<Real> a, ConstArrayView<Real> b)
	{
		double result(0.0);
		for (Integer i=0; i<a.size(); i++)
		{
			result = result + a[i] * b[i];
		}
		return result;
	}

	double det(ConstArrayView<Real> a, ConstArrayView<Real> b)
	{
		return (a[0] * b[1] - a[1] * b[0]);
	}

	UniqueArray<Real> sumR1(ConstArrayView<Real> a, ConstArrayView<Real> b)
	{
		UniqueArray<Real> result(a.size());
		for (Integer i=0; i<a.size(); i++)
		{
			result[i] = a[i] + b[i];
		}
		return result;
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

/**
 * Job computeFaceLength called @1.0 in simulate method.
 * In variables: X
 * Out variables: faceLength
 */
void ExplicitHeatEquationModule::computeFaceLength()
{
	Parallel::Foreach(allFaces(), [&](FaceVectorView view)
	{
		ENUMERATE_FACE(f, view)
		{
			double reduction0(0.0);
			ENUMERATE_NODE(p, f.nodes())
			{
				reduction0 = explicitheatequationfreefuncs::sumR0(reduction0, explicitheatequationfreefuncs::norm(X[p] - X[p+1]));
			}
			faceLength[f] = 0.5 * reduction0;
		}
	});
}

/**
 * Job computeV called @1.0 in simulate method.
 * In variables: X
 * Out variables: V
 */
void ExplicitHeatEquationModule::computeV()
{
	Parallel::Foreach(allCells(), [&](CellVectorView view)
	{
		ENUMERATE_CELL(c, view)
		{
			double reduction0(0.0);
			ENUMERATE_NODE(p, c.nodes())
			{
				reduction0 = explicitheatequationfreefuncs::sumR0(reduction0, explicitheatequationfreefuncs::det(X[p], X[p+1]));
			}
			V[c] = 0.5 * reduction0;
		}
	});
}

/**
 * Job initD called @1.0 in simulate method.
 * In variables: 
 * Out variables: D
 */
void ExplicitHeatEquationModule::initD()
{
	Parallel::Foreach(allCells(), [&](CellVectorView view)
	{
		ENUMERATE_CELL(c, view)
		{
			D[c] = 1.0;
		}
	});
}

/**
 * Job initTime called @1.0 in simulate method.
 * In variables:
 * Out variables: t_n0
 */
void ExplicitHeatEquationModule::initTime()
{
	t_n0 = 0.0;
}

/**
 * Job initXc called @1.0 in simulate method.
 * In variables: X
 * Out variables: Xc
 */
void ExplicitHeatEquationModule::initXc()
{
	Parallel::Foreach(allCells(), [&](CellVectorView view)
	{
		ENUMERATE_CELL(c, view)
		{
			RealArray1D<2> reduction0({0.0, 0.0});
			ENUMERATE_NODE(p, c.nodes())
			{
				reduction0 = explicitheatequationfreefuncs::sumR1(reduction0, X[p]);
			}
			Xc[c] = 0.25 * reduction0;
		}
	});
}

/**
 * Job updateU called @1.0 in executeTimeLoopN method.
 * In variables: alpha, u_n
 * Out variables: u_nplus1
 */
void ExplicitHeatEquationModule::updateU()
{
	Parallel::Foreach(allCells(), [&](CellVectorView view)
	{
		ENUMERATE_CELL(c, view)
		{
			double reduction0(0.0);
			ENUMERATE
				for (size_t dNeighbourCellsC=0; dNeighbourCellsC<nbNeighbourCellsC; dNeighbourCellsC++)
				{
					const Id dId(neighbourCellsC[dNeighbourCellsC]);
					const size_t dCells(dId);
					reduction0 = explicitheatequationfreefuncs::sumR0(reduction0, alpha[cCells][dCells] * u_n[dCells]);
				}
			}
			u_nplus1[cCells] = alpha[cCells][cCells] * u_n[cCells] + reduction0;
		}
	});
}

/**
 * Job computeDeltaTn called @2.0 in simulate method.
 * In variables: D, V
 * Out variables: deltat
 */
void ExplicitHeatEquationModule::computeDeltaTn()
{
	double reduction0;
	reduction0 = parallel_reduce(nbCells, double(numeric_limits<double>::max()), [&](double& accu, const size_t& cCells)
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
void ExplicitHeatEquationModule::computeFaceConductivity()
{
	Parallel::Foreach(allFaces(), [&](FaceVectorView view)
	{
		ENUMERATE_FACE(f, view)
		{
			double reduction0(1.0);
			ENUMERATE_CELL(c, f.cells())
			{
				reduction0 = explicitheatequationfreefuncs::prodR0(reduction0, D[c]);
			}
			double reduction1(0.0);
			ENUMERATE_CELL(c, f.cells())
			{}
				reduction1 = explicitheatequationfreefuncs::sumR0(reduction1, D[c]);
			}
			faceConductivity[f] = 2.0 * reduction0 / reduction1;
		}
	});
}

/**
 * Job initU called @2.0 in simulate method.
 * In variables: Xc, u0, vectOne
 * Out variables: u_n
 */
void ExplicitHeatEquationModule::initU()
{
	Parallel::Foreach(allCells(), [&](CellVectorView view)
	{
		ENUMERATE_CELL(c, view)
		{
			if (explicitheatequationfreefuncs::norm(Xc[c] - vectOne) < 0.5)
				u_n[c] = options.u0;
			else
				u_n[c] = 0.0;
		}
	});
}

/**
 * Job setUpTimeLoopN called @2.0 in simulate method.
 * In variables: t_n0
 * Out variables: t_n
 */
void ExplicitHeatEquationModule::setUpTimeLoopN()
{
	m_global_time = t_n0;
}

/**
 * Job computeAlphaCoeff called @3.0 in simulate method.
 * In variables: V, Xc, deltat, faceConductivity, faceLength
 * Out variables: alpha
 */
void ExplicitHeatEquationModule::computeAlphaCoeff()
{
	Parallel::Foreach(allCells(), [&](CellVectorView view)
	{
		ENUMERATE_CELL(c, view)
		{
			double alphaDiag(0.0);
			{
				ENUMERATE_CELL(d, c.?)
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
		}
	});
}

/**
 * Job executeTimeLoopN called @4.0 in simulate method.
 * In variables: t_n, u_n
 * Out variables: t_nplus1, u_nplus1
 */
void ExplicitHeatEquationModule::compute()
{
	computeTn(); // @1.0
	updateU(); // @1.0

	// Evaluate loop condition with variables at time n
	continueLoop = (t_nplus1 < options.stopTime && n + 1 < options.maxIterations);

	if (continueLoop)
	{
		Parallel::Foreach(allCells(), [&](CellVectorView view)
		{
			ENUMERATE_CELL(c, view)
			{
				u_n[c] = u_nplus1[c];
			}
		});
	}
	else

}

void ExplicitHeatEquationModule::init()
{
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
}


ARCANE_REGISTER_MODULE_EXPLICITHEATEQUATION(ExplicitHeatEquationModule);

