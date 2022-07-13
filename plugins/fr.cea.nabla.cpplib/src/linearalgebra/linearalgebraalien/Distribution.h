#ifndef __DISTRIBUTION_H_
#define __DISTRIBUTION_H_

#include <memory>
#include <arccore/message_passing_mpi/StandaloneMpiMessagePassingMng.h>
#include <alien/index_manager/functional/AbstractItemFamily.h>
#include <alien/distribution/MatrixDistribution.h>
#include <alien/distribution/VectorDistribution.h>
#include <alien/index_manager/IIndexManager.h>
#include <alien/index_manager/IndexManager.h>
#include <alien/index_manager/functional/DefaultAbstractFamily.h>

#include "Arcane2AlienVector.h"
#include "Matrix.h"

class Distribution
{
public:
  Distribution() = default;
  ~Distribution() = default;

  /**
   * @brief Prepare distribution with mesh information
   * 
   * @param parallelMng Message passing manager
   * @param uniqueId Array of unique id
   * @param owners Array of owner subdomain
   * @return const Alien::UniqueArray<Alien::Integer> 
   */
  const Alien::UniqueArray<Alien::Integer> prepare(Alien::IMessagePassingMng *parallelMng,
                                                   const Alien::UniqueArray<Arccore::Int64> uniqueId,
                                                   const Alien::UniqueArray<Arccore::Integer> owners);

  /**
   * @brief Create a Matrix object
   * 
   * @param matrix Matrix to create
   * @param parallelMng Message passing manager
   */
  void create(Matrix& matrix, Alien::IMessagePassingMng *parallelMng);

  /**
   * @brief Create a Vector object
   * 
   * @tparam ItemType 
   * @param vector Vector to create
   * @param parallelMng Message passing manager
   */
  template<typename ItemType>
  void create(Arcane2AlienVector<ItemType>& vector, Alien::IMessagePassingMng *parallelMng)
  {
    if(m_index_mng == nullptr)
      throw FatalErrorException(A_FUNCINFO,"Distribution not prepared");

    vector.build(getVectorDistribution(parallelMng));
  }

private:
  /**
   * @brief Get the Vector Distribution object
   * 
   * @param parallelMng Message passing manager
   * @return Alien::VectorDistribution 
   */
  Alien::VectorDistribution getVectorDistribution(Alien::IMessagePassingMng *parallelMng);

  /**
   * @brief Get the Matrix Distribution object
   * 
   * @param parallelMng Message passing manager
   * @return Alien::MatrixDistribution 
   */
  Alien::MatrixDistribution getMatrixDistribution(Alien::IMessagePassingMng *parallelMng);

private:
  std::unique_ptr<Alien::IndexManager> m_index_mng;
};

#endif
