#ifndef __EXPLICITHEATEQUATION_H_
#define __EXPLICITHEATEQUATION_H_

#include <arcane/utils/Array.h>
#include "ExplicitHeatEquation_axl.h"

using namespace Arcane;

/******************** Free functions declarations ********************/

namespace explicitheatequationfreefuncs
{
	double norm(ConstArrayView<Real> a);
	double dot(ConstArrayView<Real> a, ConstArrayView<Real> b);
	double det(ConstArrayView<Real> a, ConstArrayView<Real> b);
	UniqueArray<Real> sumR1(ConstArrayView<Real> a, ConstArrayView<Real> b);
	double minR0(double a, double b);
	double sumR0(double a, double b);
	double prodR0(double a, double b);
}

/******************** Module declaration ********************/

class ExplicitHeatEquationModule
: public ArcaneExplicitHeatEquationObject
{
public:
	ExplicitHeatEquationModule(const ModuleBuildInfo& mbi)
	: ArcaneExplicitHeatEquationObject(mbi) {}
	~ExplicitHeatEquationModule() {}

	virtual void init() override;
	virtual void compute() override;

	VersionInfo versionInfo() const override { return VersionInfo(1, 0, 0); }

private:
	void computeFaceLength();
	void computeV();
	void initD();
	void initTime();
	void initXc();
	void updateU();
	void computeDeltaTn();
	void computeFaceConductivity();
	void initU();
	void setUpTimeLoopN();
	void computeAlphaCoeff();
};

#endif
