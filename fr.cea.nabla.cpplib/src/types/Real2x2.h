/*******************************************************************************
 * Copyright (c) 2018 CEA
 * This program and the accompanying materials are made available under the
 * terms of the Eclipse Public License 2.0 which is available at
 * http://www.eclipse.org/legal/epl-2.0.
 *
 * SPDX-License-Identifier: EPL-2.0
 *
 * Contributors:
 * 	Benoit Lelandais - initial implementation
 * 	Marie-Pierre Oudot - initial implementation
 * 	Jean-Sylvain Camier - Nabla generation support
 *******************************************************************************/
#ifndef TYPES_REAL2X2_H_
#define TYPES_REAL2X2_H_

#include <iostream>
#include "types/Real2.h"

namespace nablalib
{
struct Real2x2
{
  // Pulic attributes
	Real2 x;
	Real2 y;

	// Default ctor
	Real2x2() : x(), y() { }
	// Dtor
	~Real2x2() {}
	// Ctor from single float value
	Real2x2(double v) : x(v), y(v) { }
	// Ctor from 2 different Real2 values
	Real2x2(const Real2& a, const Real2& b) : x(a), y(b) { }
	Real2x2(Real2&& a, Real2&& b) : x(std::move(a)), y(std::move(b)) { }
	// Copy ctor
	Real2x2(const Real2x2& v) : x(v.x), y(v.y) { }
	// Move ctor
	Real2x2(Real2x2&& v) : x(std::move(v.x)), y(std::move(v.y)) { }

	// Assignment operator
	Real2x2& operator=(const Real2x2& v) noexcept { x = v.x; y = v.y; return *this; }
	// Move operator
	Real2x2& operator=(Real2x2&& v) noexcept { x = std::move(v.x); y = std::move(v.y); return *this; }

	// Sum
	Real2x2& operator+=(const Real2x2& v) noexcept { x += v.x; y += v.y; return *this; }

	// Add
  Real2x2 operator+(const Real2x2& v) const noexcept { return Real2x2(x + v.x, y + v.y); }

  // Minus
  Real2x2 operator-(const Real2x2& v) const noexcept { return Real2x2(x - v.x, y - v.y); }

  // Mult
  template <typename T, typename std::enable_if<std::is_arithmetic<T>::value>::type* = nullptr>
  Real2x2 operator*(T v) const noexcept
  {
    return Real2x2(x * v, y * v);
  }
  Real2x2 operator*(const Real2x2& v) const noexcept { return Real2x2(x * v.x, y * v.y); }

  // Div
  template <typename T, typename std::enable_if<std::is_arithmetic<T>::value>::type* = nullptr>
  Real2x2 operator/(T v) const
  {
    return Real2x2(x / v, y / v);
  }

	// I/O
	friend std::ostream& operator <<(std::ostream& s, const Real2x2& a)
	{
		s << "[" << a.x << "," << a.y << "]";
		return s;
	}
};

// Helpers for associativity  // Needed ?
template <typename T, typename std::enable_if<std::is_arithmetic<T>::value>::type* = nullptr>
Real2x2 operator*(T a, const Real2x2& b) noexcept
{
  return b.operator*(a);
}

}
#endif /* TYPES_REAL2X2_H_ */
