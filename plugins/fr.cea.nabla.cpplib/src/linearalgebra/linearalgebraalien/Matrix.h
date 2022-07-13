#ifndef __MATRIX_HA_
#define __MATRIX_HA_

#include <string>

#include <alien/hypre/backend.h>

#include <arccore/message_passing_mpi/StandaloneMpiMessagePassingMng.h>
#include <arccore/trace/ITraceMng.h>

#include <alien/distribution/MatrixDistribution.h>
#include <alien/distribution/VectorDistribution.h>
#include <alien/index_manager/IIndexManager.h>
#include <alien/index_manager/IndexManager.h>
#include <alien/index_manager/functional/DefaultAbstractFamily.h>

#include <alien/ref/AlienRefSemantic.h>


#define DBL_PRECISION 6

class Matrix
{
public:
  Matrix(const std::string name) : m_name(name) {}
  ~Matrix() = default;
  
  const Alien::Matrix& get() const { return m_matrix; }
  Alien::Matrix& get() { return m_matrix; }

  const std::string& getName() const { return m_name; }

private:
  const std::string m_name;
  Alien::Matrix m_matrix;
};


#endif
