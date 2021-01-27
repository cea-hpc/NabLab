/*** GENERATED FILE - DO NOT OVERWRITE ***/

#include "hydroremap/R1.h"
#include <rapidjson/document.h>
#include <rapidjson/istreamwrapper.h>
#include <rapidjson/stringbuffer.h>
#include <rapidjson/writer.h>


/******************** Options definition ********************/

void
R1::Options::jsonInit(const char* jsonContent)
{
	rapidjson::Document document;
	assert(!document.Parse(jsonContent).HasParseError());
	assert(document.IsObject());
	const rapidjson::Value::Object& o = document.GetObject();

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
	parallel_exec(nbCells, [&](const size_t& cCells)
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
	parallel_exec(nbCells, [&](const size_t& cCells)
	{
		rv3[cCells] = mainModule->hv4[cCells];
	});
}
