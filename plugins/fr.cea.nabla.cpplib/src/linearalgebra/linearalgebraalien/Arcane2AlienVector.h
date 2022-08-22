#ifndef __ARCANE2ALIENVECTOR_H_
#define __ARCANE2ALIENVECTOR_H_

#include <arcane/IModule.h>
#include <arcane/MeshVariableScalarRef.h>

#include <alien/hypre/backend.h>

#include <arccore/message_passing_mpi/StandaloneMpiMessagePassingMng.h>
#include <arccore/trace/ITraceMng.h>

#include <alien/distribution/MatrixDistribution.h>
#include <alien/distribution/VectorDistribution.h>
#include <alien/index_manager/IIndexManager.h>
#include <alien/index_manager/IndexManager.h>
#include <alien/index_manager/functional/DefaultAbstractFamily.h>

#include <alien/ref/AlienRefSemantic.h>

using namespace Arcane;

template <typename ItemType>
class Arcane2AlienVector
{
public:
	Arcane2AlienVector(IModule *m, const std::string &name)
			: m_arcane_vector(VariableBuildInfo(m, name)), m_allUIndex(nullptr) {}

	~Arcane2AlienVector() = default;

	/**
	 * @brief Update values arcane variable from alien vector
	 * 
	 */
	void updateValue()
	{
		ENUMERATE_(ItemType, iter, m_arcane_vector.itemGroup().own())
		{
			const double val = getValue(iter);
			m_arcane_vector[iter] = val;
		}
	}

	/**
	 * @brief Initilise a vector from distrubution
	 *
	 * @param dist vector distribution
	 */
	void build(const Alien::VectorDistribution &dist)
	{
		m_vector = Alien::Vector(dist);
	}

	Alien::Vector &get() { return m_vector; }

	void setAllUIndex(const std::shared_ptr<const Alien::UniqueArray<Alien::Integer>>& allUIndex)
	{
		m_allUIndex = allUIndex;
	}

	/**
	 * @brief Get the Value object
	 *
	 * @param i arcane variable index
	 * @return double
	 */
	double getValue(const ItemEnumeratorT<ItemType> i) const
	{
		Alien::VectorReader reader(m_vector);
		return reader[m_allUIndex->operator[](i->localId())];
	}

	/**
	 * @brief Set the Value object
	 *
	 * @param i arcane variable index
	 * @param value value to set
	 */
	void setValue(const ItemEnumeratorT<ItemType> i, const double value)
	{
		m_arcane_vector[i] = value;
		Alien::VectorWriter writer(m_vector);
		writer[m_allUIndex->operator[](i->localId())] = value;
	}

	Arcane2AlienVector& operator=(const Arcane2AlienVector& vec)
	{
		ENUMERATE_(ItemType, iter, m_arcane_vector.itemGroup().own())
		{
			const double val = vec.getValue(iter);
			setValue(iter, val);
		}
		return *this;
	}
	

private:
	MeshVariableScalarRefT<ItemType, Real> m_arcane_vector;

	Alien::Vector m_vector;
	std::shared_ptr<const Alien::UniqueArray<Alien::Integer>> m_allUIndex;
};

#endif