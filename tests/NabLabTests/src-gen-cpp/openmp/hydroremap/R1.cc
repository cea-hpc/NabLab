/* DO NOT EDIT THIS FILE - it is machine generated */

#include "R1.h"
#include <rapidjson/document.h>
#include <rapidjson/istreamwrapper.h>
#include <rapidjson/stringbuffer.h>
#include <rapidjson/writer.h>


/******************** Module definition ********************/

R1::R1(CartesianMesh2D& aMesh)
: mesh(aMesh)
, nbNodes(mesh.getNbNodes())
, nbCells(mesh.getNbCells())
, rv3(nbCells)
{
}

R1::~R1()
{
}

void
R1::jsonInit(const char* jsonContent)
{
	assert(!jsonDocument.Parse(jsonContent).HasParseError());
	assert(jsonDocument.IsObject());
	rapidjson::Value::Object options = jsonDocument.GetObject();
}


/**
 * Job rj1 called @1.0 in simulate method.
 * In variables: hv1
 * Out variables: hv4
 */
void R1::rj1() noexcept
{
	#pragma omp parallel for shared(hv4)
	for (size_t cCells=0; cCells<nbCells; cCells++)
	{
		mainModule->hv4[cCells] = mainModule->hv1[cCells];
	}
}

/**
 * Job rj2 called @2.0 in simulate method.
 * In variables: hv4
 * Out variables: rv3
 */
void R1::rj2() noexcept
{
	#pragma omp parallel for shared(rv3)
	for (size_t cCells=0; cCells<nbCells; cCells++)
	{
		rv3[cCells] = mainModule->hv4[cCells];
	}
}
