#include "Distribution.h"

const void Distribution::prepare(Alien::IMessagePassingMng *parallelMng,
                                 const Alien::UniqueArray<Arccore::Int64> uniqueId,
                                 const Alien::UniqueArray<Arccore::Integer> owners)
{
  Alien::AbstractItemFamily family(uniqueId, owners, parallelMng);
  m_index_mng = std::make_unique<Alien::IndexManager>(parallelMng);

  auto indexSetU = m_index_mng->buildScalarIndexSet("U", family, 0);
  m_index_mng->prepare();

  m_allUIndex = std::make_unique<const Alien::UniqueArray<Alien::Integer>>(m_index_mng->getIndexes(indexSetU));
}

Alien::VectorDistribution Distribution::getVectorDistribution(Alien::IMessagePassingMng *parallelMng)
{
  if (m_index_mng == nullptr || m_allUIndex == nullptr)
    throw FatalErrorException(A_FUNCINFO, "Distribution not prepared");

  auto global_size = m_index_mng->globalSize();
  auto local_size = m_index_mng->localSize();
  return Alien::VectorDistribution(global_size, local_size, parallelMng);
}

Alien::MatrixDistribution Distribution::getMatrixDistribution(Alien::IMessagePassingMng *parallelMng)
{
  if (m_index_mng == nullptr || m_allUIndex == nullptr)
    throw FatalErrorException(A_FUNCINFO, "Distribution not prepared");

  auto global_size = m_index_mng->globalSize();
  auto local_size = m_index_mng->localSize();
  return Alien::MatrixDistribution(global_size, global_size, local_size, parallelMng);
}

void Distribution::create(Matrix &matrix, Alien::IMessagePassingMng *parallelMng)
{
  if (m_index_mng == nullptr || m_allUIndex == nullptr)
    throw FatalErrorException(A_FUNCINFO, "Distribution not prepared");

  matrix.get() = Alien::Matrix(getMatrixDistribution(parallelMng));
  matrix.setAllUIndex(m_allUIndex);
}
