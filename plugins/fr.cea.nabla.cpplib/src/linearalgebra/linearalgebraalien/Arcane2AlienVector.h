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


template<typename ItemType>
class Arcane2AlienVector
{
public:
	Arcane2AlienVector(IModule *m, const std::string &name) 
			: m_arcane_vector(VariableBuildInfo(m, name))
//			,	m_writer(m_vector)
//			, m_reader(m_vector)
	{}

	~Arcane2AlienVector(){};

	/**
	 * @brief Update values arcane variable from alien vector
	 * 
	 * @param allUIndex Array of index to convert index to alien index
	 */
	void updateValue(const UniqueArray<Alien::Integer>& allUIndex)
	{
		ENUMERATE_(ItemType, iter, m_arcane_vector.itemGroup().own())
		{
			const auto index = allUIndex[iter->localId()];
			const double val = getValue(iter, index);
			//Alien::VectorReader reader(m_vector);
			//const double val = reader[index];
			m_arcane_vector[iter] = val;
		}
	}

	/**
	 * @brief Initilise a vector from distrubution
	 * 
	 * @param dist vector distribution
	 */
	void build(const Alien::VectorDistribution& dist)
	{
		m_vector = Alien::Vector(dist);
		//m_writer = Alien::VectorWriter(m_vector);
		//m_reader = Alien::VectorReader(m_vector);
	}

	Alien::Vector& get() { return m_vector; }

	/**
	 * @brief Get the Value object
	 * 
	 * @param i arcane variable index
	 * @param i_alien alien variable index
	 * @return double
	 */
	double getValue(const ItemEnumeratorT<ItemType> i, const Alien::Integer i_alien) const
	{
		Alien::VectorReader reader(m_vector);
		return reader[i_alien];
		//return m_reader[i_alien];
	}

	/**
	 * @brief Set the Value object
	 * 
	 * @param i arcane variable index
	 * @param i_alien alien variable index
	 * @param value value to set
	 */
	void setValue(const ItemEnumeratorT<ItemType> i, const Alien::Integer i_alien, const double value)
	{
		m_arcane_vector[i] = value;
		Alien::VectorWriter writer(m_vector);
		writer[i_alien] = value;
		//m_writer[i_alien] = value;
	}

private:
	MeshVariableScalarRefT<ItemType, Real> m_arcane_vector;
	
	Alien::Vector m_vector;
	//Alien::VectorWriter m_writer;
	//Alien::VectorReader m_reader;
};

#endif