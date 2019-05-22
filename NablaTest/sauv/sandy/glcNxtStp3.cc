#include "glcNxtStp3.h"

// ********************************************************
// * perp fct
// ********************************************************
static inline Real3 perp(Real3 greek_alpha , Real3 greek_beta ){return Real3(opSub(greek_beta.y,greek_alpha.y),opAdd(-greek_beta.x,greek_alpha.x),0.0);
}

// ********************************************************
// * trace fct
// ********************************************************
static inline Real trace(Real3x3 M ){return opAdd(opAdd(M.x.x,M.y.y),M.z.z);
}
