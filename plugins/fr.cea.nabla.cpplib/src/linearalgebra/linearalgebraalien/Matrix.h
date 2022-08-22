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


class Matrix
{
public:
  Matrix(const std::string name) : m_name(name), m_size(-1) {}
  ~Matrix() = default;
  
  const Alien::Matrix& get() const { m_builder->finalize(); return m_matrix; }
  Alien::Matrix& get() { if(m_builder) { m_builder->finalize();} return m_matrix; }

  void setAllUIndex(const std::shared_ptr<const Alien::UniqueArray<Alien::Integer>> allUIndex)
	{
    if(m_size == 1)
      throw FatalErrorException(A_FUNCINFO,"Size not set");

		m_allUIndex = allUIndex;
    m_builder = std::make_unique<Alien::DirectMatrixBuilder>(m_matrix, Alien::DirectMatrixOptions::eResetValues);
    m_builder->reserve(m_size);
	  m_builder->allocate();
	}

  const std::string& getName() const { return m_name; }
  void resize(const Alien::Integer size) { m_size = size; }

  void setValue(const Arcane::Int32 i, const Arcane::Int32 j, const double val)
  {
    m_builder->operator()(m_allUIndex->item(i), m_allUIndex->item(j)) = val;
  }

private:
  const std::string m_name;
  Alien::Matrix m_matrix;
  std::shared_ptr<const Alien::UniqueArray<Alien::Integer>> m_allUIndex {};
  std::unique_ptr<Alien::DirectMatrixBuilder> m_builder {};
  Arcane::Integer m_size;
};


#endif
