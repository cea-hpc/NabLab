/*******************************************************************************
 * Copyright (c) 2020 CEA
 * This program and the accompanying materials are made available under the
 * terms of the Eclipse Public License 2.0 which is available at
 * http://www.eclipse.org/legal/epl-2.0.
 *
 * SPDX-License-Identifier: EPL-2.0
 * Contributors: see AUTHORS file
 *******************************************************************************/
#include "nablalib/linearalgebra/stl/Vector.h"

namespace nablalib::linearalgebra::stl
{

Vector::
Vector(const std::string& name, const int size)
: m_data(size) {}


Vector::
Vector(VectorType& v)
: m_data(v) {}


Vector::
~Vector() {}


Vector& Vector::
operator=(const Vector& val)
{
	m_data = val.m_data;
	return *this;
}


const int Vector::
getSize() const
{
  return m_data.size();
}


double Vector::
getValue(const int i) const
{
  return m_data[i];
}


void Vector::
setValue(const int i, double value)
{
	m_data[i] = value;
}

}
