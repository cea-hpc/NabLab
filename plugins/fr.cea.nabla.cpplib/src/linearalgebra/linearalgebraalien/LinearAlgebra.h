#ifndef __LINEARALGEBRAA_H_
#define __LINEARALGEBRAA_H_

#include <alien/hypre/backend.h>

#include <arccore/message_passing_mpi/StandaloneMpiMessagePassingMng.h>
#include <arccore/trace/ITraceMng.h>

#include <alien/distribution/MatrixDistribution.h>
#include <alien/distribution/VectorDistribution.h>
#include <alien/index_manager/IIndexManager.h>
#include <alien/index_manager/IndexManager.h>
#include <alien/index_manager/functional/DefaultAbstractFamily.h>

#include <alien/ref/AlienRefSemantic.h>
#include <alien/hypre/options.h>

#include "Arcane2AlienVector.h"
#include "Matrix.h"

#include <memory>
#include <alien/index_manager/functional/AbstractItemFamily.h>



#include "Distribution.h"
#include <arcane/IParallelMng.h>
#include <alien/index_manager/IndexManager.h>


class LinearAlgebra
{
public:
  LinearAlgebra() : m_linear_algebra(Alien::Hypre::Options().
                                     numIterationsMax(100).
                                     stopCriteriaValue(1e-8).
                                     preconditioner(Alien::Hypre::OptionTypes::NoPC).
                                     solver(Alien::Hypre::OptionTypes::CG)) 
  {}
  ~LinearAlgebra() = default;

  void jsonInit(const char* jsonContent) {}

  /**
   * @brief Solve the linear equation A*x=b
   * 
   * @tparam ItemType 
   * @param A Matrix
   * @param b Vector
   * @param x Vector
   */
  template<typename ItemType>
  void solveLinearSystem(Matrix& A, Arcane2AlienVector<ItemType>& b, Arcane2AlienVector<ItemType>& x)
  {
    m_linear_algebra.solve(A.get(), b.get(), x.get());
    x.updateValue();
  }


private:
  Alien::Hypre::LinearSolver m_linear_algebra;
};

#endif