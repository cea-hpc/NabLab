/* DO NOT EDIT THIS FILE - it is machine generated */

#ifndef __R1SERVICE_H_
#define __R1SERVICE_H_

#include <arcane/utils/Array.h>
#include <arcane/datatype/RealArrayVariant.h>
#include <arcane/datatype/RealArray2Variant.h>
#include <arcane/accelerator/core/IAcceleratorMng.h>
#include <arcane/accelerator/Reduce.h>
#include <arcane/accelerator/Accelerator.h>
#include <arcane/accelerator/RunCommandEnumerate.h>
#include "IRemap.h"
#include "R1_axl.h"
#include "CartesianMesh2D.h"

namespace ax = Arcane::Accelerator;
using namespace Arcane;

/*** Module/Service **********************************************************/

class R1Service
: public ArcaneR1Object
{
public:
	R1Service(const ServiceBuildInfo& mbi);
	~R1Service() {}

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
