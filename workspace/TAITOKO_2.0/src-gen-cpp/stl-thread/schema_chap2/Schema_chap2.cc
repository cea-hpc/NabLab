#include "schema_chap2/Schema_chap2.h"

using namespace nablalib;

/******************** Free functions definitions ********************/

template<size_t x>
RealArray1D<x> sumR1(RealArray1D<x> a, RealArray1D<x> b)
{
	return a + b;
}


/******************** Options definition ********************/

void
Schema_chap2::Options::jsonInit(const rapidjson::Value::ConstObject& d)
{
	// outputPath
	assert(d.HasMember("outputPath"));
	const rapidjson::Value& valueof_outputPath = d["outputPath"];
	assert(valueof_outputPath.IsString());
	outputPath = valueof_outputPath.GetString();
	// outputPeriod
	assert(d.HasMember("outputPeriod"));
	const rapidjson::Value& valueof_outputPeriod = d["outputPeriod"];
	assert(valueof_outputPeriod.IsInt());
	outputPeriod = valueof_outputPeriod.GetInt();
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
	// X_LENGTH
	assert(d.HasMember("X_LENGTH"));
	const rapidjson::Value& valueof_X_LENGTH = d["X_LENGTH"];
	assert(valueof_X_LENGTH.IsDouble());
	X_LENGTH = valueof_X_LENGTH.GetDouble();
	// Y_LENGTH
	assert(d.HasMember("Y_LENGTH"));
	const rapidjson::Value& valueof_Y_LENGTH = d["Y_LENGTH"];
	assert(valueof_Y_LENGTH.IsDouble());
	Y_LENGTH = valueof_Y_LENGTH.GetDouble();
	// maxIter
	assert(d.HasMember("maxIter"));
	const rapidjson::Value& valueof_maxIter = d["maxIter"];
	assert(valueof_maxIter.IsInt());
	maxIter = valueof_maxIter.GetInt();
	// stopTime
	assert(d.HasMember("stopTime"));
	const rapidjson::Value& valueof_stopTime = d["stopTime"];
	assert(valueof_stopTime.IsDouble());
	stopTime = valueof_stopTime.GetDouble();
}

/******************** Module definition ********************/

Schema_chap2::Schema_chap2(const Options& aOptions, Schema_chap2Functions& aSchema_chap2Functions)
: options(aOptions)
, schema_chap2Functions(aSchema_chap2Functions)
, t_n(0.0)
, t_nplus1(0.0)
, deltax(options.X_EDGE_LENGTH)
, deltay(options.Y_EDGE_LENGTH)
, lastDump(numeric_limits<int>::min())
, mesh(CartesianMesh2DGenerator::generate(options.X_EDGE_ELEMS, options.Y_EDGE_ELEMS, options.X_EDGE_LENGTH, options.Y_EDGE_LENGTH))
, writer("Schema_chap2", options.outputPath)
, nbNodes(mesh->getNbNodes())
, nbFaces(mesh->getNbFaces())
, nbInnerFaces(mesh->getNbInnerFaces())
, nbOuterFaces(mesh->getNbOuterFaces())
, nbInnerVerticalFaces(mesh->getNbInnerVerticalFaces())
, nbInnerHorizontalFaces(mesh->getNbInnerHorizontalFaces())
, nbCompletelyInnerFaces(mesh->getNbCompletelyInnerFaces())
, nbCompletelyInnerVerticalFaces(mesh->getNbCompletelyInnerVerticalFaces())
, nbCompletelyInnerHorizontalFaces(mesh->getNbCompletelyInnerHorizontalFaces())
, nbCells(mesh->getNbCells())
, nbInnerCells(mesh->getNbInnerCells())
, nbOuterCells(mesh->getNbOuterCells())
, nbTopCells(mesh->getNbTopCells())
, nbBottomCells(mesh->getNbBottomCells())
, nbLeftCells(mesh->getNbLeftCells())
, nbRightCells(mesh->getNbRightCells())
, nbNeighbourCells(CartesianMesh2D::MaxNbNeighbourCells)
, nbNodesOfCell(CartesianMesh2D::MaxNbNodesOfCell)
, nbFacesOfCell(CartesianMesh2D::MaxNbFacesOfCell)
, nbNodesOfFace(CartesianMesh2D::MaxNbNodesOfFace)
, nbCellsOfFace(CartesianMesh2D::MaxNbCellsOfFace)
, X(nbNodes)
, Xc(nbCells)
, xc(nbCells)
, yc(nbCells)
, U_n(nbFaces)
, U_nplus1(nbFaces)
, U_n0(nbFaces)
, V_n(nbFaces)
, V_nplus1(nbFaces)
, V_n0(nbFaces)
, H_n(nbCells)
, H_nplus1(nbCells)
, H_n0(nbCells)
, Rij_n(nbCells)
, Rij_nplus1(nbCells)
, Rij_n0(nbCells)
, Fx(nbCells)
, Fy(nbCells)
, Dij(nbCells)
{
	// Copy node coordinates
	const auto& gNodes = mesh->getGeometry()->getNodes();
	for (size_t rNodes=0; rNodes<nbNodes; rNodes++)
	{
		X[rNodes][0] = gNodes[rNodes][0];
		X[rNodes][1] = gNodes[rNodes][1];
	}
}

Schema_chap2::~Schema_chap2()
{
	delete mesh;
}

/**
 * Job ComputeTn called @1.0 in executeTimeLoopN method.
 * In variables: deltat, t_n
 * Out variables: t_nplus1
 */
void Schema_chap2::computeTn() noexcept
{
	t_nplus1 = t_n + deltat;
}

/**
 * Job InitDij called @1.0 in simulate method.
 * In variables: 
 * Out variables: Dij
 */
void Schema_chap2::initDij() noexcept
{
	for (size_t cCells=0; cCells<nbCells; cCells++)
	{
		Dij[cCells] = -4000.0;
	}
}

/**
 * Job InitFxy called @1.0 in simulate method.
 * In variables: 
 * Out variables: Fx, Fy
 */
void Schema_chap2::initFxy() noexcept
{
	for (size_t cCells=0; cCells<nbCells; cCells++)
	{
		Fx[cCells] = 0.0;
		Fy[cCells] = 0.0;
	}
}

/**
 * Job InitH1 called @1.0 in simulate method.
 * In variables: 
 * Out variables: H_n0
 */
void Schema_chap2::initH1() noexcept
{
	{
		const auto innerCells(mesh->getInnerCells());
		const size_t nbInnerCells(innerCells.size());
		for (size_t cInnerCells=0; cInnerCells<nbInnerCells; cInnerCells++)
		{
			const Id cId(innerCells[cInnerCells]);
			const size_t cCells(cId);
			H_n0[cCells] = schema_chap2Functions.nextWaveHeight();
		}
	}
}

/**
 * Job InitRij called @1.0 in simulate method.
 * In variables: 
 * Out variables: Rij_n0
 */
void Schema_chap2::initRij() noexcept
{
	for (size_t cCells=0; cCells<nbCells; cCells++)
	{
		Rij_n0[cCells] = 0.0;
	}
}

/**
 * Job InitU called @1.0 in simulate method.
 * In variables: 
 * Out variables: U_n0
 */
void Schema_chap2::initU() noexcept
{
	{
		const auto innerFaces(mesh->getInnerFaces());
		const size_t nbInnerFaces(innerFaces.size());
		for (size_t fInnerFaces=0; fInnerFaces<nbInnerFaces; fInnerFaces++)
		{
			const Id fId(innerFaces[fInnerFaces]);
			const size_t fFaces(fId);
			U_n0[fFaces] = 0.0;
		}
	}
}

/**
 * Job InitV called @1.0 in simulate method.
 * In variables: 
 * Out variables: V_n0
 */
void Schema_chap2::initV() noexcept
{
	{
		const auto innerFaces(mesh->getInnerFaces());
		const size_t nbInnerFaces(innerFaces.size());
		for (size_t fInnerFaces=0; fInnerFaces<nbInnerFaces; fInnerFaces++)
		{
			const Id fId(innerFaces[fInnerFaces]);
			const size_t fFaces(fId);
			V_n0[fFaces] = 0.0;
		}
	}
}

/**
 * Job InitXc called @1.0 in simulate method.
 * In variables: X
 * Out variables: Xc
 */
void Schema_chap2::initXc() noexcept
{
	for (size_t cCells=0; cCells<nbCells; cCells++)
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
				reduction0 = sumR1(reduction0, X[pNodes]);
			}
		}
		Xc[cCells] = 0.25 * reduction0;
	}
}

/**
 * Job UpdateHouter called @1.0 in executeTimeLoopN method.
 * In variables: H_n
 * Out variables: H_nplus1
 */
void Schema_chap2::updateHouter() noexcept
{
	{
		const auto topCells(mesh->getTopCells());
		const size_t nbTopCells(topCells.size());
		for (size_t tcTopCells=0; tcTopCells<nbTopCells; tcTopCells++)
		{
			const Id tcId(topCells[tcTopCells]);
			const size_t tcCells(tcId);
			const Id bcId(mesh->getBottomCell(tcId));
			const size_t bcCells(bcId);
			H_nplus1[tcCells] = H_n[bcCells];
		}
	}
	{
		const auto bottomCells(mesh->getBottomCells());
		const size_t nbBottomCells(bottomCells.size());
		for (size_t bcBottomCells=0; bcBottomCells<nbBottomCells; bcBottomCells++)
		{
			const Id bcId(bottomCells[bcBottomCells]);
			const size_t bcCells(bcId);
			const Id tcId(mesh->getTopCell(bcId));
			const size_t tcCells(tcId);
			H_nplus1[bcCells] = H_n[tcCells];
		}
	}
	{
		const auto leftCells(mesh->getLeftCells());
		const size_t nbLeftCells(leftCells.size());
		for (size_t lcLeftCells=0; lcLeftCells<nbLeftCells; lcLeftCells++)
		{
			const Id lcId(leftCells[lcLeftCells]);
			const size_t lcCells(lcId);
			const Id rcId(mesh->getRightCell(lcId));
			const size_t rcCells(rcId);
			H_nplus1[lcCells] = H_n[rcCells];
		}
	}
	{
		const auto rightCells(mesh->getRightCells());
		const size_t nbRightCells(rightCells.size());
		for (size_t rcRightCells=0; rcRightCells<nbRightCells; rcRightCells++)
		{
			const Id rcId(rightCells[rcRightCells]);
			const size_t rcCells(rcId);
			const Id lcId(mesh->getLeftCell(rcId));
			const size_t lcCells(lcId);
			H_nplus1[rcCells] = H_n[lcCells];
		}
	}
}

/**
 * Job UpdateRij called @1.0 in executeTimeLoopN method.
 * In variables: Rij_n, t_n, xc
 * Out variables: Rij_nplus1
 */
void Schema_chap2::updateRij() noexcept
{
	for (size_t cCells=0; cCells<nbCells; cCells++)
	{
		if (t_n < 1 && xc[cCells] < 5000) 
			Rij_nplus1[cCells] = Rij_n[cCells] - 0.1;
		else
			Rij_nplus1[cCells] = Rij_n[cCells] + 0.0;
	}
}

/**
 * Job UpdateUinner called @1.0 in executeTimeLoopN method.
 * In variables: C, Dij, F, Fx, H_n, U_n, V_n, deltat, deltax, deltay, g
 * Out variables: U_nplus1
 */
void Schema_chap2::updateUinner() noexcept
{
	{
		const auto completelyInnerVerticalFaces(mesh->getCompletelyInnerVerticalFaces());
		const size_t nbCompletelyInnerVerticalFaces(completelyInnerVerticalFaces.size());
		for (size_t civfCompletelyInnerVerticalFaces=0; civfCompletelyInnerVerticalFaces<nbCompletelyInnerVerticalFaces; civfCompletelyInnerVerticalFaces++)
		{
			const Id civfId(completelyInnerVerticalFaces[civfCompletelyInnerVerticalFaces]);
			const size_t civfFaces(civfId);
			double TV(0.0);
			double TU1(0.0);
			double TU2(0.0);
			double THU(0.0);
			double SB(0.0);
			{
				const Id fijId(mesh->getBottomRightFaceNeighbour(civfId));
				const size_t fijFaces(fijId);
				const Id fijplus1Id(mesh->getTopRightFaceNeighbour(civfId));
				const size_t fijplus1Faces(fijplus1Id);
				const Id fimoins1jplus1Id(mesh->getTopLeftFaceNeighbour(civfId));
				const size_t fimoins1jplus1Faces(fimoins1jplus1Id);
				const Id fimoins1jId(mesh->getBottomLeftFaceNeighbour(civfId));
				const size_t fimoins1jFaces(fimoins1jId);
				TV = 0.25 * (V_n[fijFaces] + V_n[fijplus1Faces] + V_n[fimoins1jplus1Faces] + V_n[fimoins1jFaces]);
			}
			if (U_n[civfFaces] < 0) 
			{
				{
					const Id fiplus1jId(mesh->getRightFaceNeighbour(civfId));
					const size_t fiplus1jFaces(fiplus1jId);
					TU1 = U_n[fiplus1jFaces] - U_n[civfFaces];
				}
			}
			else
			{
				{
					const Id fimoins1jId(mesh->getLeftFaceNeighbour(civfId));
					const size_t fimoins1jFaces(fimoins1jId);
					TU1 = U_n[civfFaces] - U_n[fimoins1jFaces];
				}
			}
			if (TV < 0) 
			{
				{
					const Id fijplus1Id(mesh->getTopFaceNeighbour(civfId));
					const size_t fijplus1Faces(fijplus1Id);
					TU2 = U_n[fijplus1Faces] - U_n[civfFaces];
				}
			}
			else
			{
				{
					const Id fijmoins1Id(mesh->getBottomFaceNeighbour(civfId));
					const size_t fijmoins1Faces(fijmoins1Id);
					TU2 = U_n[civfFaces] - U_n[fijmoins1Faces];
				}
			}
			{
				const Id cijId(mesh->getFrontCell(civfId));
				const size_t cijCells(cijId);
				const Id cimoins1jId(mesh->getLeftCell(cijId));
				const size_t cimoins1jCells(cimoins1jId);
				THU = H_n[cijCells] - H_n[cimoins1jCells];
			}
			{
				const Id cijId(mesh->getFrontCell(civfId));
				const size_t cijCells(cijId);
				const Id fijvId(mesh->getBottomRightFaceNeighbour(civfId));
				const size_t fijvFaces(fijvId);
				SB = g * U_n[civfFaces] * (std::sqrt(U_n[civfFaces] * U_n[civfFaces] + V_n[fijvFaces] * V_n[fijvFaces])) / (C * C * (Dij[cijCells] + H_n[cijCells]));
			}
			{
				const Id fijvId(mesh->getBottomRightFaceNeighbour(civfId));
				const size_t fijvFaces(fijvId);
				const Id cijId(mesh->getFrontCell(civfId));
				const size_t cijCells(cijId);
				U_nplus1[civfFaces] = U_n[civfFaces] - deltat * (U_n[civfFaces] * TU1 / deltax + TV * TU2 / deltay) - g * deltat / deltax * THU + deltat * (-F * V_n[fijvFaces] - Fx[cijCells] + SB);
			}
		}
	}
}

/**
 * Job UpdateUouter called @1.0 in executeTimeLoopN method.
 * In variables: U_n
 * Out variables: U_nplus1
 */
void Schema_chap2::updateUouter() noexcept
{
	{
		const auto topCells(mesh->getTopCells());
		const size_t nbTopCells(topCells.size());
		for (size_t tcTopCells=0; tcTopCells<nbTopCells; tcTopCells++)
		{
			const Id tcId(topCells[tcTopCells]);
			const Id rfId(mesh->getRightFaceOfCell(tcId));
			const size_t rfFaces(rfId);
			const Id bfId(mesh->getBottomFaceOfCell(tcId));
			const Id bcId(mesh->getFrontCell(bfId));
			const Id brfId(mesh->getRightFaceOfCell(bcId));
			const size_t brfFaces(brfId);
			U_nplus1[rfFaces] = U_n[brfFaces];
		}
	}
	{
		const auto bottomCells(mesh->getBottomCells());
		const size_t nbBottomCells(bottomCells.size());
		for (size_t bcBottomCells=0; bcBottomCells<nbBottomCells; bcBottomCells++)
		{
			const Id bcId(bottomCells[bcBottomCells]);
			const Id rfId(mesh->getRightFaceOfCell(bcId));
			const size_t rfFaces(rfId);
			const Id tfId(mesh->getTopFaceOfCell(bcId));
			const Id bcfId(mesh->getBackCell(tfId));
			const Id trfId(mesh->getRightFaceOfCell(bcfId));
			const size_t trfFaces(trfId);
			U_nplus1[rfFaces] = U_n[trfFaces];
		}
	}
	{
		const auto leftCells(mesh->getLeftCells());
		const size_t nbLeftCells(leftCells.size());
		for (size_t lcLeftCells=0; lcLeftCells<nbLeftCells; lcLeftCells++)
		{
			const Id lcId(leftCells[lcLeftCells]);
			const Id lfId(mesh->getLeftFaceOfCell(lcId));
			const size_t lfFaces(lfId);
			const Id rfId(mesh->getRightFaceOfCell(lcId));
			const size_t rfFaces(rfId);
			U_nplus1[lfFaces] = U_n[rfFaces];
		}
	}
	{
		const auto rightCells(mesh->getRightCells());
		const size_t nbRightCells(rightCells.size());
		for (size_t rcRightCells=0; rcRightCells<nbRightCells; rcRightCells++)
		{
			const Id rcId(rightCells[rcRightCells]);
			const Id rfId(mesh->getRightFaceOfCell(rcId));
			const size_t rfFaces(rfId);
			const Id lfId(mesh->getLeftFaceOfCell(rcId));
			const size_t lfFaces(lfId);
			U_nplus1[rfFaces] = U_n[lfFaces];
		}
	}
}

/**
 * Job UpdateVinner called @1.0 in executeTimeLoopN method.
 * In variables: C, Dij, F, Fx, H_n, U_n, V_n, deltat, deltax, deltay, g
 * Out variables: V_nplus1
 */
void Schema_chap2::updateVinner() noexcept
{
	{
		const auto completelyInnerHorizontalFaces(mesh->getCompletelyInnerHorizontalFaces());
		const size_t nbCompletelyInnerHorizontalFaces(completelyInnerHorizontalFaces.size());
		for (size_t cihfCompletelyInnerHorizontalFaces=0; cihfCompletelyInnerHorizontalFaces<nbCompletelyInnerHorizontalFaces; cihfCompletelyInnerHorizontalFaces++)
		{
			const Id cihfId(completelyInnerHorizontalFaces[cihfCompletelyInnerHorizontalFaces]);
			const size_t cihfFaces(cihfId);
			double TU(0.0);
			double TV1(0.0);
			double TV2(0.0);
			double THV(0.0);
			double SB(0.0);
			{
				const Id fijId(mesh->getTopLeftFaceNeighbour(cihfId));
				const size_t fijFaces(fijId);
				const Id fiplus1jId(mesh->getTopRightFaceNeighbour(cihfId));
				const size_t fiplus1jFaces(fiplus1jId);
				const Id fijmoins1Id(mesh->getBottomLeftFaceNeighbour(cihfId));
				const size_t fijmoins1Faces(fijmoins1Id);
				const Id fiplus1jmoins1Id(mesh->getBottomRightFaceNeighbour(cihfId));
				const size_t fiplus1jmoins1Faces(fiplus1jmoins1Id);
				TU = 0.25 * (U_n[fijFaces] + U_n[fiplus1jFaces] + U_n[fijmoins1Faces] + U_n[fiplus1jmoins1Faces]);
			}
			if (TU < 0) 
			{
				{
					const Id fiplus1jId(mesh->getRightFaceNeighbour(cihfId));
					const size_t fiplus1jFaces(fiplus1jId);
					TV1 = V_n[fiplus1jFaces] - V_n[cihfFaces];
				}
			}
			else
			{
				{
					const Id fimoins1jId(mesh->getLeftFaceNeighbour(cihfId));
					const size_t fimoins1jFaces(fimoins1jId);
					TV1 = V_n[cihfFaces] - V_n[fimoins1jFaces];
				}
			}
			if (V_n[cihfFaces] < 0) 
			{
				{
					const Id fijplus1Id(mesh->getTopFaceNeighbour(cihfId));
					const size_t fijplus1Faces(fijplus1Id);
					TV2 = V_n[fijplus1Faces] - V_n[cihfFaces];
				}
			}
			else
			{
				{
					const Id fijmoins1Id(mesh->getBottomFaceNeighbour(cihfId));
					const size_t fijmoins1Faces(fijmoins1Id);
					TV2 = V_n[cihfFaces] - V_n[fijmoins1Faces];
				}
			}
			{
				const Id cijId(mesh->getBackCell(cihfId));
				const size_t cijCells(cijId);
				const Id cijmoins1Id(mesh->getFrontCell(cihfId));
				const size_t cijmoins1Cells(cijmoins1Id);
				THV = H_n[cijCells] - H_n[cijmoins1Cells];
			}
			{
				const Id cijId(mesh->getBackCell(cihfId));
				const size_t cijCells(cijId);
				const Id fijvId(mesh->getTopLeftFaceNeighbour(cihfId));
				const size_t fijvFaces(fijvId);
				SB = g * U_n[fijvFaces] * (std::sqrt(U_n[fijvFaces] * U_n[fijvFaces] + V_n[cihfFaces] * V_n[cihfFaces])) / (C * C * (Dij[cijCells] + H_n[cijCells]));
			}
			{
				const Id fijvId(mesh->getTopLeftFaceNeighbour(cihfId));
				const size_t fijvFaces(fijvId);
				const Id cijId(mesh->getBackCell(cihfId));
				const size_t cijCells(cijId);
				V_nplus1[cihfFaces] = V_n[cihfFaces] - deltat * (V_n[cihfFaces] * TV1 / deltax + TU * TV2 / deltay) - g * deltat / deltax * THV + deltat * (-F * U_n[fijvFaces] - Fx[cijCells] + SB);
			}
		}
	}
}

/**
 * Job UpdateVouter called @1.0 in executeTimeLoopN method.
 * In variables: V_n
 * Out variables: V_nplus1
 */
void Schema_chap2::updateVouter() noexcept
{
	{
		const auto topCells(mesh->getTopCells());
		const size_t nbTopCells(topCells.size());
		for (size_t tcTopCells=0; tcTopCells<nbTopCells; tcTopCells++)
		{
			const Id tcId(topCells[tcTopCells]);
			const Id bfId(mesh->getBottomFaceOfCell(tcId));
			const size_t bfFaces(bfId);
			const Id tfId(mesh->getTopFaceOfCell(tcId));
			const size_t tfFaces(tfId);
			V_nplus1[tfFaces] = V_n[bfFaces];
		}
	}
	{
		const auto bottomCells(mesh->getBottomCells());
		const size_t nbBottomCells(bottomCells.size());
		for (size_t bcBottomCells=0; bcBottomCells<nbBottomCells; bcBottomCells++)
		{
			const Id bcId(bottomCells[bcBottomCells]);
			const Id bfId(mesh->getBottomFaceOfCell(bcId));
			const size_t bfFaces(bfId);
			const Id tfId(mesh->getTopFaceOfCell(bcId));
			const size_t tfFaces(tfId);
			V_nplus1[bfFaces] = V_n[tfFaces];
		}
	}
	{
		const auto leftCells(mesh->getLeftCells());
		const size_t nbLeftCells(leftCells.size());
		for (size_t lcLeftCells=0; lcLeftCells<nbLeftCells; lcLeftCells++)
		{
			const Id lcId(leftCells[lcLeftCells]);
			const Id bfId(mesh->getBottomFaceOfCell(lcId));
			const size_t bfFaces(bfId);
			const Id rfId(mesh->getRightFaceOfCell(lcId));
			const Id rcId(mesh->getFrontCell(rfId));
			const Id bfrcId(mesh->getBottomFaceOfCell(rcId));
			const size_t bfrcFaces(bfrcId);
			V_nplus1[bfFaces] = V_n[bfrcFaces];
		}
	}
	{
		const auto rightCells(mesh->getRightCells());
		const size_t nbRightCells(rightCells.size());
		for (size_t rcRightCells=0; rcRightCells<nbRightCells; rcRightCells++)
		{
			const Id rcId(rightCells[rcRightCells]);
			const Id bfId(mesh->getBottomFaceOfCell(rcId));
			const size_t bfFaces(bfId);
			const Id lfId(mesh->getLeftFaceOfCell(rcId));
			const Id lcId(mesh->getBackCell(lfId));
			const Id bflcId(mesh->getBottomFaceOfCell(lcId));
			const size_t bflcFaces(bflcId);
			V_nplus1[bfFaces] = V_n[bflcFaces];
		}
	}
}

/**
 * Job InitXcAndYc called @2.0 in simulate method.
 * In variables: Xc
 * Out variables: xc, yc
 */
void Schema_chap2::initXcAndYc() noexcept
{
	for (size_t cCells=0; cCells<nbCells; cCells++)
	{
		xc[cCells] = Xc[cCells][0];
		yc[cCells] = Xc[cCells][1];
	}
}

/**
 * Job SetUpTimeLoopN called @2.0 in simulate method.
 * In variables: H_n0, Rij_n0, U_n0, V_n0
 * Out variables: H_n, Rij_n, U_n, V_n
 */
void Schema_chap2::setUpTimeLoopN() noexcept
{
	for (size_t i1(0) ; i1<U_n.size() ; i1++)
		U_n[i1] = U_n0[i1];
	for (size_t i1(0) ; i1<V_n.size() ; i1++)
		V_n[i1] = V_n0[i1];
	for (size_t i1(0) ; i1<H_n.size() ; i1++)
		H_n[i1] = H_n0[i1];
	for (size_t i1(0) ; i1<Rij_n.size() ; i1++)
		Rij_n[i1] = Rij_n0[i1];
}

/**
 * Job UpdateHinner called @2.0 in executeTimeLoopN method.
 * In variables: Dij, H_n, Rij_n, Rij_nplus1, U_n, V_n, deltat, deltax, deltay
 * Out variables: H_nplus1
 */
void Schema_chap2::updateHinner() noexcept
{
	{
		const auto innerCells(mesh->getInnerCells());
		const size_t nbInnerCells(innerCells.size());
		for (size_t cInnerCells=0; cInnerCells<nbInnerCells; cInnerCells++)
		{
			const Id cId(innerCells[cInnerCells]);
			const size_t cCells(cId);
			double TD1(0.0);
			double TD2(0.0);
			double TV1(0.0);
			double TV2(0.0);
			{
				const Id rfId(mesh->getRightFaceOfCell(cId));
				const size_t rfFaces(rfId);
				if (U_n[rfFaces] < 0) 
				{
					{
						const Id rcId(mesh->getRightCell(cId));
						const size_t rcCells(rcId);
						TD1 = Dij[rcCells] + H_n[rcCells] - Rij_n[rcCells];
					}
				}
				else
					TD1 = Dij[cCells] + H_n[cCells] - Rij_n[cCells];
			}
			{
				const Id lfId(mesh->getLeftFaceOfCell(cId));
				const size_t lfFaces(lfId);
				if (U_n[lfFaces] < 0) 
					TD2 = Dij[cCells] + H_n[cCells] - Rij_n[cCells];
				else
				{
					{
						const Id lcId(mesh->getLeftCell(cId));
						const size_t lcCells(lcId);
						TD2 = Dij[lcCells] + H_n[lcCells] - Rij_n[lcCells];
					}
				}
			}
			{
				const Id tfId(mesh->getTopFaceOfCell(cId));
				const size_t tfFaces(tfId);
				if (V_n[tfFaces] < 0) 
				{
					{
						const Id tcId(mesh->getTopCell(cId));
						const size_t tcCells(tcId);
						TV1 = Dij[tcCells] + H_n[tcCells] - Rij_n[tcCells];
					}
				}
				else
					TV1 = Dij[cCells] + H_n[cCells] - Rij_n[cCells];
			}
			{
				const Id bfId(mesh->getBottomFaceOfCell(cId));
				const size_t bfFaces(bfId);
				if (V_n[bfFaces] < 0) 
					TV2 = Dij[cCells] + H_n[cCells] - Rij_n[cCells];
				else
				{
					{
						const Id bcId(mesh->getBottomCell(cId));
						const size_t bcCells(bcId);
						TV2 = Dij[bcCells] + H_n[bcCells] - Rij_n[bcCells];
					}
				}
			}
			{
				const Id rfId(mesh->getRightFaceOfCell(cId));
				const size_t rfFaces(rfId);
				const Id lfId(mesh->getLeftFaceOfCell(cId));
				const size_t lfFaces(lfId);
				const Id tfId(mesh->getTopFaceOfCell(cId));
				const size_t tfFaces(tfId);
				const Id bfId(mesh->getBottomFaceOfCell(cId));
				const size_t bfFaces(bfId);
				H_nplus1[cCells] = H_n[cCells] - deltat * (U_n[rfFaces] * TD1 / deltax - U_n[lfFaces] * TD2 / deltax + V_n[tfFaces] * TV1 / deltay - V_n[bfFaces] * TV2 / deltay) + Rij_nplus1[cCells] - Rij_n[cCells];
			}
		}
	}
}

/**
 * Job ExecuteTimeLoopN called @3.0 in simulate method.
 * In variables: C, Dij, F, Fx, H_n, Rij_n, Rij_nplus1, U_n, V_n, deltat, deltax, deltay, g, t_n, xc
 * Out variables: H_nplus1, Rij_nplus1, U_nplus1, V_nplus1, t_nplus1
 */
void Schema_chap2::executeTimeLoopN() noexcept
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
		updateHouter(); // @1.0
		updateRij(); // @1.0
		updateUinner(); // @1.0
		updateUouter(); // @1.0
		updateVinner(); // @1.0
		updateVouter(); // @1.0
		updateHinner(); // @2.0
		
	
		// Evaluate loop condition with variables at time n
		continueLoop = (t_nplus1 < options.stopTime && n < options.maxIter);
	
		if (continueLoop)
		{
			// Switch variables to prepare next iteration
			std::swap(t_nplus1, t_n);
			std::swap(U_nplus1, U_n);
			std::swap(V_nplus1, V_n);
			std::swap(H_nplus1, H_n);
			std::swap(Rij_nplus1, Rij_n);
		}
	
		cpuTimer.stop();
		globalTimer.stop();
	
		// Timers display
		if (!writer.isDisabled())
			std::cout << " {CPU: " << __BLUE__ << cpuTimer.print(true) << __RESET__ ", IO: " << __BLUE__ << ioTimer.print(true) << __RESET__ "} ";
		else
			std::cout << " {CPU: " << __BLUE__ << cpuTimer.print(true) << __RESET__ ", IO: " << __RED__ << "none" << __RESET__ << "} ";
		
		// Progress
		std::cout << utils::progress_bar(n, options.maxIter, t_n, options.stopTime, 25);
		std::cout << __BOLD__ << __CYAN__ << utils::Timer::print(
			utils::eta(n, options.maxIter, t_n, options.stopTime, deltat, globalTimer), true)
			<< __RESET__ << "\r";
		std::cout.flush();
	
		cpuTimer.reset();
		ioTimer.reset();
	} while (continueLoop);
	// force a last output at the end
	dumpVariables(n, false);
}

void Schema_chap2::dumpVariables(int iteration, bool useTimer)
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
		writer.write("hauteur", H_n);
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

void Schema_chap2::simulate()
{
	std::cout << "\n" << __BLUE_BKG__ << __YELLOW__ << __BOLD__ <<"\tStarting Schema_chap2 ..." << __RESET__ << "\n\n";
	
	std::cout << "[" << __GREEN__ << "MESH" << __RESET__ << "]      X=" << __BOLD__ << options.X_EDGE_ELEMS << __RESET__ << ", Y=" << __BOLD__ << options.Y_EDGE_ELEMS
		<< __RESET__ << ", X length=" << __BOLD__ << options.X_EDGE_LENGTH << __RESET__ << ", Y length=" << __BOLD__ << options.Y_EDGE_LENGTH << __RESET__ << std::endl;
	
	std::cout << "[" << __GREEN__ << "TOPOLOGY" << __RESET__ << "]  HWLOC unavailable cannot get topological informations" << std::endl;
	
	if (!writer.isDisabled())
		std::cout << "[" << __GREEN__ << "OUTPUT" << __RESET__ << "]    VTK files stored in " << __BOLD__ << writer.outputDirectory() << __RESET__ << " directory" << std::endl;
	else
		std::cout << "[" << __GREEN__ << "OUTPUT" << __RESET__ << "]    " << __BOLD__ << "Disabled" << __RESET__ << std::endl;

	initDij(); // @1.0
	initFxy(); // @1.0
	initH1(); // @1.0
	initRij(); // @1.0
	initU(); // @1.0
	initV(); // @1.0
	initXc(); // @1.0
	initXcAndYc(); // @2.0
	setUpTimeLoopN(); // @2.0
	executeTimeLoopN(); // @3.0
	
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
		std::cerr << "(Schema_chap2DefaultOptions.json)" << std::endl;
		return -1;
	}
	
	// read json dataFile
	ifstream ifs(dataFile);
	rapidjson::IStreamWrapper isw(ifs);
	rapidjson::Document d;
	d.ParseStream(isw);
	assert(d.IsObject());
	
	// options
	Schema_chap2::Options options;
	if (d.HasMember("options"))
	{
		const rapidjson::Value& valueof_options = d["options"];
		assert(valueof_options.IsObject());
		options.jsonInit(valueof_options.GetObject());
	}
	
	// schema_chap2Functions
	Schema_chap2Functions schema_chap2Functions;
	if (d.HasMember("schema_chap2Functions"))
	{
		const rapidjson::Value& valueof_schema_chap2Functions = d["schema_chap2Functions"];
		assert(valueof_schema_chap2Functions.IsObject());
		schema_chap2Functions.jsonInit(valueof_schema_chap2Functions.GetObject());
	}
	
	// simulator must be a pointer if there is a finalize at the end (Kokkos, omp...)
	auto simulator = new Schema_chap2(options, schema_chap2Functions);
	simulator->simulate();
	
	// simulator must be deleted before calling finalize
	delete simulator;
	return 0;
}
