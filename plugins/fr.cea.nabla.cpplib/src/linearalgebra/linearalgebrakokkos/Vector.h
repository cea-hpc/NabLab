/*******************************************************************************
 * Copyright (c) 2022 CEA
 * This program and the accompanying materials are made available under the
 * terms of the Eclipse Public License 2.0 which is available at
 * http://www.eclipse.org/legal/epl-2.0.
 *
 * SPDX-License-Identifier: EPL-2.0
 * Contributors: see AUTHORS file
 *******************************************************************************/
#ifndef __VECTOR_H_
#define __VECTOR_H_

#include <string>
#include "Kokkos_Core.hpp"

typedef Kokkos::View<double*> VectorType;

class Vector
{
 friend class LinearAlgebra;

 public:
  Vector(const std::string& name, const size_t size);
  Vector(VectorType& v);
  ~Vector();

  Vector& operator=(const Vector& v);

  const size_t getSize() const;
  // getter
  double getValue(const size_t i) const;
  // setter
  void setValue(const size_t i, double value);

// private:
  VectorType m_data;
};

const char* serialize(const Vector& v, int& size, bool& mustDeletePtr);

#endif
