/* DO NOT EDIT THIS FILE - it is machine generated */

#ifndef __ITERATIVEHEATEQUATIONMODULE_H_
#define __ITERATIVEHEATEQUATIONMODULE_H_

#include <arcane/utils/Array.h>
#include <arcane/datatype/RealArrayVariant.h>
#include <arcane/datatype/RealArray2Variant.h>
#include "IterativeHeatEquation_axl.h"
#include "CartesianMesh2D.h"

using namespace Arcane;

/*** Free functions **********************************************************/

namespace iterativeheatequationfreefuncs
{
	const bool check(const bool a);
	const Real norm(RealArrayVariant a);
	const Real dot(RealArrayVariant a, RealArrayVariant b);
	const Real det(RealArrayVariant a, RealArrayVariant b);
	RealArrayVariant sumR1(RealArrayVariant a, RealArrayVariant b);
	const Real minR0(const Real a, const Real b);
	const Real sumR0(const Real a, const Real b);
	const Real prodR0(const Real a, const Real b);
	const Real maxR0(const Real a, const Real b);
	RealArrayVariant operatorAdd(RealArrayVariant a, RealArrayVariant b);
	RealArrayVariant operatorMult(const Real a, RealArrayVariant b);
	RealArrayVariant operatorSub(RealArrayVariant a, RealArrayVariant b);
}

/*** Module ******************************************************************/

class IterativeHeatEquationModule
: public ArcaneIterativeHeatEquationObject
{
public:
	IterativeHeatEquationModule(const ModuleBuildInfo& mbi);
	~IterativeHeatEquationModule() {}

	virtual void init() override;
	virtual void executeTimeLoopN() override;

	VersionInfo versionInfo() const override { return VersionInfo(1, 0, 0); }

private:
	void computeFaceLength();
	void computeTn();
	void computeV();
	void initD();
	void initTime();
	void initXc();
	void setUpTimeLoopK();
	void updateU();
	void computeDeltaTn();
	void computeFaceConductivity();
	void computeResidual();
	void executeTimeLoopK();
	void initU();
	void setUpTimeLoopN();
	void computeAlphaCoeff();
	void tearDownTimeLoopK();

private:
	// mesh attributes
	CartesianMesh2D* m_mesh;

	// other attributes
	Int32 m_lastDump;
	Int32 m_n;
	Int32 m_k;
	static constexpr Real m_u0 = 1.0;
	static constexpr Real2 m_vectOne = {1.0, 1.0};
	static constexpr Int32 m_maxIterationsK = 1000;
	static constexpr Real m_epsilon = 1.0E-8;
	Real m_deltat;
	Real m_t_n;
	Real m_t_nplus1;
	Real m_t_n0;
	Real m_residual;
};

#endif