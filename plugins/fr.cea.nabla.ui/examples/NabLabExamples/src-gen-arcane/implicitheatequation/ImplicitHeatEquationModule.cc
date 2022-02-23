/* DO NOT EDIT THIS FILE - it is machine generated */

#include "ImplicitHeatEquationModule.h"
#include <arcane/Concurrency.h>
#include <arcane/ITimeLoopMng.h>

using namespace Arcane;

/*** Free functions **********************************************************/

namespace implicitheatequationfreefuncs
{
	const Real norm(RealArrayVariant a)
	{
		return std::sqrt(implicitheatequationfreefuncs::dot(a, a));
	}
	
	const Real dot(RealArrayVariant a, RealArrayVariant b)
	{
		Real result(0.0);
		for (Int32 i=0; i<a.size(); i++)
		{
			result = result + a[i] * b[i];
		}
		return result;
	}
	
	const Real det(RealArrayVariant a, RealArrayVariant b)
	{
		return (a[0] * b[1] - a[1] * b[0]);
	}
	
	RealArrayVariant sumR1(RealArrayVariant a, RealArrayVariant b)
	{
		return implicitheatequationfreefuncs::operatorAdd(a, b);
	}
	
	const Real minR0(const Real a, const Real b)
	{
		return std::min(a, b);
	}
	
	const Real sumR0(const Real a, const Real b)
	{
		return a + b;
	}
	
	const Real prodR0(const Real a, const Real b)
	{
		return a * b;
	}
	
	RealArrayVariant operatorAdd(RealArrayVariant a, RealArrayVariant b)
	{
		UniqueArray<Real> result(a.size());
		for (Int32 ix0=0; ix0<a.size(); ix0++)
		{
			result[ix0] = a[ix0] + b[ix0];
		}
		return result;
	}
	
	RealArrayVariant operatorMult(const Real a, RealArrayVariant b)
	{
		UniqueArray<Real> result(b.size());
		for (Int32 ix0=0; ix0<b.size(); ix0++)
		{
			result[ix0] = a * b[ix0];
		}
		return result;
	}
	
	RealArrayVariant operatorSub(RealArrayVariant a, RealArrayVariant b)
	{
		UniqueArray<Real> result(a.size());
		for (Int32 ix0=0; ix0<a.size(); ix0++)
		{
			result[ix0] = a[ix0] - b[ix0];
		}
		return result;
	}
}

/*** Module/Service **********************************************************/

ImplicitHeatEquationModule::ImplicitHeatEquationModule(const ModuleBuildInfo& bi)
: ArcaneImplicitHeatEquationObject(bi)
, m_u_n(this, "u_n")
, m_u_nplus1(this, "u_nplus1")
, m_alpha("alpha")
{}

void ImplicitHeatEquationModule::init()
{
	// initialization of mesh attributes
	m_mesh = CartesianMesh2D::createInstance(mesh());

	// initialization of other attributes
	m_lastDump = numeric_limits<int>::min();
	m_n = 0;
	m_deltat = 0.001;
	m_u_n.resize(nbCell());
	m_u_nplus1.resize(nbCell());
	m_alpha.resize(nbCell(), nbCell());

	// calling jobs
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
}

/**
 * Job computeFaceLength called @1.0 in simulate method.
 * In variables: X
 * Out variables: faceLength
 */
void ImplicitHeatEquationModule::computeFaceLength()
{
	arcaneParallelForeach(allFaces(), [&](FaceVectorView view)
	{
		ENUMERATE_FACE(fFaces, view)
		{
			const auto fId(fFaces.asItemLocalId());
			Real reduction0(0.0);
			{
				const auto nodesOfFaceF(m_mesh->getNodesOfFace(fId));
				const Int32 nbNodesOfFaceF(nodesOfFaceF.size());
				for (Int32 pNodesOfFaceF=0; pNodesOfFaceF<nbNodesOfFaceF; pNodesOfFaceF++)
				{
					const auto pId(nodesOfFaceF[pNodesOfFaceF]);
					const auto pPlus1Id(nodesOfFaceF[(pNodesOfFaceF+1+nbNodesOfFaceF)%nbNodesOfFaceF]);
					const auto pNodes(pId);
					const auto pPlus1Nodes(pPlus1Id);
					reduction0 = implicitheatequationfreefuncs::sumR0(reduction0, implicitheatequationfreefuncs::norm(Real2(implicitheatequationfreefuncs::operatorSub(m_X[pNodes], m_X[pPlus1Nodes]))));
				}
			}
			m_faceLength[fFaces] = 0.5 * reduction0;
		}
	});
}

/**
 * Job computeTn called @1.0 in executeTimeLoopN method.
 * In variables: deltat, t_n
 * Out variables: t_nplus1
 */
void ImplicitHeatEquationModule::computeTn()
{
	m_t_nplus1 = m_t_n + m_deltat;
}

/**
 * Job computeV called @1.0 in simulate method.
 * In variables: X
 * Out variables: V
 */
void ImplicitHeatEquationModule::computeV()
{
	arcaneParallelForeach(allCells(), [&](CellVectorView view)
	{
		ENUMERATE_CELL(jCells, view)
		{
			const auto jId(jCells.asItemLocalId());
			Real reduction0(0.0);
			{
				const auto nodesOfCellJ(m_mesh->getNodesOfCell(jId));
				const Int32 nbNodesOfCellJ(nodesOfCellJ.size());
				for (Int32 pNodesOfCellJ=0; pNodesOfCellJ<nbNodesOfCellJ; pNodesOfCellJ++)
				{
					const auto pId(nodesOfCellJ[pNodesOfCellJ]);
					const auto pPlus1Id(nodesOfCellJ[(pNodesOfCellJ+1+nbNodesOfCellJ)%nbNodesOfCellJ]);
					const auto pNodes(pId);
					const auto pPlus1Nodes(pPlus1Id);
					reduction0 = implicitheatequationfreefuncs::sumR0(reduction0, implicitheatequationfreefuncs::det(m_X[pNodes], m_X[pPlus1Nodes]));
				}
			}
			m_V[jCells] = 0.5 * reduction0;
		}
	});
}

/**
 * Job initD called @1.0 in simulate method.
 * In variables: 
 * Out variables: D
 */
void ImplicitHeatEquationModule::initD()
{
	arcaneParallelForeach(allCells(), [&](CellVectorView view)
	{
		ENUMERATE_CELL(cCells, view)
		{
			m_D[cCells] = 1.0;
		}
	});
}

/**
 * Job initTime called @1.0 in simulate method.
 * In variables: 
 * Out variables: t_n0
 */
void ImplicitHeatEquationModule::initTime()
{
	m_t_n0 = 0.0;
}

/**
 * Job initXc called @1.0 in simulate method.
 * In variables: X
 * Out variables: Xc
 */
void ImplicitHeatEquationModule::initXc()
{
	arcaneParallelForeach(allCells(), [&](CellVectorView view)
	{
		ENUMERATE_CELL(cCells, view)
		{
			const auto cId(cCells.asItemLocalId());
			Real2 reduction0{0.0, 0.0};
			{
				const auto nodesOfCellC(m_mesh->getNodesOfCell(cId));
				const Int32 nbNodesOfCellC(nodesOfCellC.size());
				for (Int32 pNodesOfCellC=0; pNodesOfCellC<nbNodesOfCellC; pNodesOfCellC++)
				{
					const auto pId(nodesOfCellC[pNodesOfCellC]);
					const auto pNodes(pId);
					reduction0 = Real2(implicitheatequationfreefuncs::sumR1(reduction0, m_X[pNodes]));
				}
			}
			m_Xc[cCells] = Real2(implicitheatequationfreefuncs::operatorMult(0.25, reduction0));
		}
	});
}

/**
 * Job updateU called @1.0 in executeTimeLoopN method.
 * In variables: alpha, u_n
 * Out variables: u_nplus1
 */
void ImplicitHeatEquationModule::updateU()
{
	m_u_nplus1 = m_linear_algebra.solveLinearSystem(m_alpha, m_u_n);
}

/**
 * Job computeDeltaTn called @2.0 in simulate method.
 * In variables: D, V
 * Out variables: deltat
 */
void ImplicitHeatEquationModule::computeDeltaTn()
{
	Real reduction0(numeric_limits<double>::max());
	ENUMERATE_CELL(cCells, allCells())
	{
		reduction0 = implicitheatequationfreefuncs::minR0(reduction0, m_V[cCells] / m_D[cCells]);
	}
	m_deltat = reduction0 * 0.24;
	m_global_deltat = m_deltat;
}

/**
 * Job computeFaceConductivity called @2.0 in simulate method.
 * In variables: D
 * Out variables: faceConductivity
 */
void ImplicitHeatEquationModule::computeFaceConductivity()
{
	arcaneParallelForeach(allFaces(), [&](FaceVectorView view)
	{
		ENUMERATE_FACE(fFaces, view)
		{
			const auto fId(fFaces.asItemLocalId());
			Real reduction0(1.0);
			{
				const auto cellsOfFaceF(m_mesh->getCellsOfFace(fId));
				const Int32 nbCellsOfFaceF(cellsOfFaceF.size());
				for (Int32 c1CellsOfFaceF=0; c1CellsOfFaceF<nbCellsOfFaceF; c1CellsOfFaceF++)
				{
					const auto c1Id(cellsOfFaceF[c1CellsOfFaceF]);
					const auto c1Cells(c1Id);
					reduction0 = implicitheatequationfreefuncs::prodR0(reduction0, m_D[c1Cells]);
				}
			}
			Real reduction1(0.0);
			{
				const auto cellsOfFaceF(m_mesh->getCellsOfFace(fId));
				const Int32 nbCellsOfFaceF(cellsOfFaceF.size());
				for (Int32 c2CellsOfFaceF=0; c2CellsOfFaceF<nbCellsOfFaceF; c2CellsOfFaceF++)
				{
					const auto c2Id(cellsOfFaceF[c2CellsOfFaceF]);
					const auto c2Cells(c2Id);
					reduction1 = implicitheatequationfreefuncs::sumR0(reduction1, m_D[c2Cells]);
				}
			}
			m_faceConductivity[fFaces] = 2.0 * reduction0 / reduction1;
		}
	});
}

/**
 * Job initU called @2.0 in simulate method.
 * In variables: Xc, u0, vectOne
 * Out variables: u_n
 */
void ImplicitHeatEquationModule::initU()
{
	arcaneParallelForeach(allCells(), [&](CellVectorView view)
	{
		ENUMERATE_CELL(cCells, view)
		{
			if (implicitheatequationfreefuncs::norm(Real2(implicitheatequationfreefuncs::operatorSub(m_Xc[cCells], m_vectOne))) < 0.5) 
				m_u_n.setValue(cCells, m_u0);
			else
				m_u_n.setValue(cCells, 0.0);
		}
	});
}

/**
 * Job setUpTimeLoopN called @2.0 in simulate method.
 * In variables: t_n0
 * Out variables: t_n
 */
void ImplicitHeatEquationModule::setUpTimeLoopN()
{
	m_t_n = m_t_n0;
}

/**
 * Job computeAlphaCoeff called @3.0 in simulate method.
 * In variables: V, Xc, deltat, faceConductivity, faceLength
 * Out variables: alpha
 */
void ImplicitHeatEquationModule::computeAlphaCoeff()
{
	arcaneParallelForeach(allCells(), [&](CellVectorView view)
	{
		ENUMERATE_CELL(cCells, view)
		{
			const auto cId(cCells.asItemLocalId());
			Real alphaDiag(0.0);
			{
				const auto neighbourCellsC(m_mesh->getNeighbourCells(cId));
				const Int32 nbNeighbourCellsC(neighbourCellsC.size());
				for (Int32 dNeighbourCellsC=0; dNeighbourCellsC<nbNeighbourCellsC; dNeighbourCellsC++)
				{
					const auto dId(neighbourCellsC[dNeighbourCellsC]);
					const auto dCells(dId);
					const auto fId(m_mesh->getCommonFace(cId, dId));
					const auto fFaces(fId);
					const Real alphaExtraDiag(-m_deltat / m_V[cCells] * (m_faceLength[fFaces] * m_faceConductivity[fFaces]) / implicitheatequationfreefuncs::norm(Real2(implicitheatequationfreefuncs::operatorSub(m_Xc[cCells], m_Xc[dCells]))));
					m_alpha.setValue(cCells.index(), dCells, alphaExtraDiag);
					alphaDiag = alphaDiag + alphaExtraDiag;
				}
			}
			m_alpha.setValue(cCells.index(), cCells.index(), 1 - alphaDiag);
		}
	});
}

/**
 * Job executeTimeLoopN called @4.0 in simulate method.
 * In variables: lastDump, maxIterations, n, outputPeriod, stopTime, t_n, t_nplus1, u_n
 * Out variables: t_nplus1, u_nplus1
 */
void ImplicitHeatEquationModule::executeTimeLoopN()
{
	m_n++;
	computeTn(); // @1.0
	updateU(); // @1.0
	
	// Evaluate loop condition with variables at time n
	bool continueLoop = (m_t_nplus1 < options()->stopTime() && m_n + 1 < options()->maxIterations());
	
	m_t_n = m_t_nplus1;
	m_u_n = m_u_nplus1;
	
	if (!continueLoop)
		subDomain()->timeLoopMng()->stopComputeLoop(true);
}

ARCANE_REGISTER_MODULE_IMPLICITHEATEQUATION(ImplicitHeatEquationModule);
