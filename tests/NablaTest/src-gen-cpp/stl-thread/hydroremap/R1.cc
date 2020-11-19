#include "hydroremap/R1.h"

using namespace nablalib;

/******************** Options definition ********************/

void
R1::Options::jsonInit(const rapidjson::Value& json)
{
	assert(json.IsObject());
	const rapidjson::Value::ConstObject& o = json.GetObject();
}

/******************** Module definition ********************/

R1::R1(CartesianMesh2D* aMesh, Options& aOptions)
: mesh(aMesh)
, nbNodes(mesh->getNbNodes())
, nbCells(mesh->getNbCells())
, options(aOptions)
, rv3(nbCells)
{
}

R1::~R1()
{
}

/**
 * Job rj1 called @1.0 in simulate method.
 * In variables: hv1
 * Out variables: hv4
 */
void R1::rj1() noexcept
{
	parallel::parallel_exec(nbCells, [&](const size_t& cCells)
	{
		mainModule->hv4[cCells] = mainModule->hv1[cCells];
	});
}

/**
 * Job rj2 called @2.0 in simulate method.
 * In variables: hv4
 * Out variables: rv3
 */
void R1::rj2() noexcept
{
	parallel::parallel_exec(nbCells, [&](const size_t& cCells)
	{
		rv3[cCells] = mainModule->hv4[cCells];
	});
}
