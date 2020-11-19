#include "hydroremap/R2.h"

using namespace nablalib;

/******************** Options definition ********************/

void
R2::Options::jsonInit(const rapidjson::Value& json)
{
	assert(json.IsObject());
	const rapidjson::Value::ConstObject& o = json.GetObject();
}

/******************** Module definition ********************/

R2::R2(CartesianMesh2D* aMesh, Options& aOptions)
: mesh(aMesh)
, nbNodes(mesh->getNbNodes())
, nbCells(mesh->getNbCells())
, options(aOptions)
, rv2(nbCells)
{
}

R2::~R2()
{
}

/**
 * Job rj1 called @2.0 in simulate method.
 * In variables: hv3
 * Out variables: rv2
 */
void R2::rj1() noexcept
{
	parallel::parallel_exec(nbCells, [&](const size_t& cCells)
	{
		rv2[cCells] = mainModule->hv3[cCells];
	});
}

/**
 * Job rj2 called @3.0 in simulate method.
 * In variables: rv2
 * Out variables: hv6
 */
void R2::rj2() noexcept
{
	parallel::parallel_exec(nbCells, [&](const size_t& cCells)
	{
		mainModule->hv6[cCells] = rv2[cCells];
	});
}
