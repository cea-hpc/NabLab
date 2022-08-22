/* DO NOT EDIT THIS FILE - it is machine generated */

#ifndef __IMPLICITHEATEQUATIONMODULE_H_
#define __IMPLICITHEATEQUATIONMODULE_H_

#include <arcane/utils/NumArray.h>
#include <arcane/datatype/RealArrayVariant.h>
#include <arcane/datatype/RealArray2Variant.h>
#include <arcane/IParallelMng.h>
#include "ImplicitHeatEquation_axl.h"
#include "CartesianMesh2D.h"
#include "LinearAlgebra.h"
#include "Arcane2StlVector.h"

using namespace Arcane;

/*** Free functions **********************************************************/

namespace implicitheatequationfreefuncs
{
	const Real norm(RealArrayVariant a);
	const Real dot(RealArrayVariant a, RealArrayVariant b);
	const Real det(RealArrayVariant a, RealArrayVariant b);
	RealArrayVariant sumR1(RealArrayVariant a, RealArrayVariant b);
	const Real minR0(const Real a, const Real b);
	const Real sumR0(const Real a, const Real b);
	const Real prodR0(const Real a, const Real b);
	RealArrayVariant operatorAdd(RealArrayVariant a, RealArrayVariant b);
	RealArrayVariant operatorMult(const Real a, RealArrayVariant b);
	RealArrayVariant operatorSub(RealArrayVariant a, RealArrayVariant b);
}

/*** Module/Service **********************************************************/

class ImplicitHeatEquationModule
: public ArcaneImplicitHeatEquationObject
{
public:
	ImplicitHeatEquationModule(const ModuleBuildInfo& mbi);
	~ImplicitHeatEquationModule() {}

	// entry points
	virtual void init() override;
	virtual void executeTimeLoopN() override;

	VersionInfo versionInfo() const override { return VersionInfo(1, 0, 0); }

public:
	// jobs
	virtual void computeFaceLength();
	virtual void computeTn();
	virtual void computeV();
	virtual void initD();
	virtual void initTime();
	virtual void initXc();
	virtual void updateU();
	virtual void computeDeltaTn();
	virtual void computeFaceConductivity();
	virtual void initU();
	virtual void setUpTimeLoopN();
	virtual void computeAlphaCoeff();

private:
	// mesh attributes
	CartesianMesh2D* m_mesh;

	// other attributes
	LinearAlgebra m_linear_algebra;
	Int32 m_lastDump;
	Int32 m_n;
	static constexpr Real m_u0 = 1.0;
	static constexpr Real2 m_vectOne = {1.0, 1.0};
	Real m_deltat;
	Real m_t_n;
	Real m_t_nplus1;
	Real m_t_n0;
	Arcane2AlienVector<Cell> m_u_n;
	Arcane2AlienVector<Cell> m_u_nplus1;
	Matrix m_alpha;
};

#endif
