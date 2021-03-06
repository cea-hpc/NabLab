/*******************************************************************************
 * Copyright (c) 2020 CEA
 * This program and the accompanying materials are made available under the
 * terms of the Eclipse Public License 2.0 which is available at
 * http://www.eclipse.org/legal/epl-2.0.
 *
 * SPDX-License-Identifier: EPL-2.0
 * Contributors: see AUTHORS file
 *******************************************************************************/
#ifndef NABLALIB_LINEARALGEBRA_KOKKOS_VECTOR_H_
#define NABLALIB_LINEARALGEBRA_KOKKOS_VECTOR_H_

#include <string>
#include "Kokkos_Core.hpp"

namespace nablalib::linearalgebra::kokkos
{
typedef Kokkos::View<double*> VectorType;

class Vector
{
 friend class LinearAlgebra;

 public:
  Vector(const std::string& name, const int size);
  Vector(VectorType& v);
  ~Vector();

  Vector& operator=(const Vector& v);

  const int getSize() const;
  // getter
  double getValue(const int i) const;
  // setter
  void setValue(const int i, double value);

// private:
  VectorType m_data;
};

}

#endif /* NABLALIB_LINEARALGEBRA_KOKKOS_VECTOR_H_ */
