/*******************************************************************************
 * Copyright (c) 2022 CEA
 * This program and the accompanying materials are made available under the
 * terms of the Eclipse Public License 2.0 which is available at
 * http://www.eclipse.org/legal/epl-2.0.
 *
 * SPDX-License-Identifier: EPL-2.0
 * Contributors: see AUTHORS file
 *******************************************************************************/
#ifndef __ARCANE2STLVECTOR_H_
#define __ARCANE2STLVECTOR_H_

#include <arcane/IModule.h>
#include <arcane/MeshVariableScalarRef.h>
#include "Vector.h"

using namespace Arcane;

/**
 * This class allows to keep the Arcane variable type closed to
 * the Vector type. The Vector type is used to call the solver.
 * The Arcane type is used to keep Arcane services like VTK output.
 */
template<typename ItemType>
class Arcane2StlVector
{
 public:
  Arcane2StlVector(IModule *m, const string &name)
  : m_arcane_vector(Arcane::VariableBuildInfo(m, name))
  , m_stl_vector(name)
  {}
  ~Arcane2StlVector() {};

  Arcane2StlVector& operator=(const Arcane2StlVector& val)
  {
	  m_arcane_vector.copy(val.m_arcane_vector);
	  m_stl_vector = val.m_stl_vector;
	  return *this;
  }

  Arcane2StlVector& operator=(const Vector& val)
  {
	  ENUMERATE_(ItemType, iter, m_arcane_vector.itemGroup())
		m_arcane_vector[iter] = val.getValue(iter.index());
	  m_stl_vector = val;
	  return *this;
  }

  operator Vector&() { return m_stl_vector; }
  operator const Vector&() const { return m_stl_vector; }
  const void resize(const size_t size) { m_stl_vector.resize(size); }
  const size_t getSize() const { return m_stl_vector.getSize(); }

  double getValue(const ItemEnumeratorT<ItemType> i) const { return m_arcane_vector[i]; }
  void setValue(const ItemEnumeratorT<ItemType> i, double value)
  {
	  m_arcane_vector[i] = value;
	  m_stl_vector.setValue(i.index(), value);
  }

  double getValue(const ItemLocalIdT<ItemType> i) const { return m_arcane_vector[i]; }
  void setValue(const ItemLocalIdT<ItemType> i, double value)
  {
	  m_arcane_vector[i] = value;
	  m_stl_vector.setValue(i.localId(), value);
  }

//  double getValue(const size_t i) const { return m_stl_vector.getValue(i); }
//  void setValue(const size_t i, double value) { m_stl_vector.setValue(i, value); }

 private:
  MeshVariableScalarRefT< ItemType, Real > m_arcane_vector;
  Vector m_stl_vector;
};

#endif
