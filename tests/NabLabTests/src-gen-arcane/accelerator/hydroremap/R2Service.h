/* DO NOT EDIT THIS FILE - it is machine generated */

#ifndef __R2SERVICE_H_
#define __R2SERVICE_H_

#include <arcane/utils/NumArray.h>
#include <arcane/datatype/RealArrayVariant.h>
#include <arcane/datatype/RealArray2Variant.h>
#include <arcane/accelerator/core/IAcceleratorMng.h>
#include <arcane/accelerator/Reduce.h>
#include <arcane/accelerator/Accelerator.h>
#include <arcane/accelerator/RunCommandEnumerate.h>
#include "IRemap.h"
#include "R2_axl.h"
#include "CartesianMesh2D.h"

namespace ax = Arcane::Accelerator;
using namespace Arcane;

/*** Module/Service **********************************************************/

class R2Service
: public ArcaneR2Object
{
public:
	R2Service(const ServiceBuildInfo& mbi);
	~R2Service() {}

public:
	// jobs
	virtual void rj1() override;
	virtual void rj2() override;

private:
	// mesh attributes
	CartesianMesh2D* m_mesh;

	// other attributes

	// accelerator queue
	ax::RunQueue* m_default_queue = nullptr;
};

#endif