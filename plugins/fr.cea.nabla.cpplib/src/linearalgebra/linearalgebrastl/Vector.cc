/*******************************************************************************
 * Copyright (c) 2022 CEA
 * This program and the accompanying materials are made available under the
 * terms of the Eclipse Public License 2.0 which is available at
 * http://www.eclipse.org/legal/epl-2.0.
 *
 * SPDX-License-Identifier: EPL-2.0
 * Contributors: see AUTHORS file
 *******************************************************************************/
#include "Vector.h"
#include "nablalib/utils/Serializer.h"

using namespace nablalib::utils;

Vector::
Vector(const std::string& name, const size_t size)
: m_data(size) {}


Vector::
Vector(const std::string& name)
: m_data(0) {}


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


const void Vector::
resize(const size_t size)
{
	m_data.resize(size);
}

const size_t Vector::
getSize() const
{
  return m_data.size();
}


double Vector::
getValue(const size_t i) const
{
  return m_data[i];
}


void Vector::
setValue(const size_t i, double value)
{
	m_data[i] = value;
}

std::string serialize(const Vector& v)
{
	return serialize(v.m_data);
}
