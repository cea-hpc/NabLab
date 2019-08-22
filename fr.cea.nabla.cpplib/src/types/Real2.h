/*******************************************************************************
 * Copyright (c) 2018 CEA
 * This program and the accompanying materials are made available under the
 * terms of the Eclipse Public License 2.0 which is available at
 * http://www.eclipse.org/legal/epl-2.0.
 *
 * SPDX-License-Identifier: EPL-2.0
 * Contributors: see AUTHORS file
 *******************************************************************************/
#ifndef TYPES_REAL2_H_
#define TYPES_REAL2_H_

#include <iostream>
#include <type_traits>

namespace nablalib
{

struct Real2
{
  // Public attributes
	double x;
	double y;

	// Default ctor
	Real2() : x(0.0), y(0.0) {}
	// Dtor
	~Real2() {}
	// Ctor from a single float value
	template <typename T,
	          typename std::enable_if<std::is_floating_point<typename std::decay<T>::type>::value>::type* = nullptr>
	explicit Real2(T v) : x(v), y(v) {}
  // Ctor from 2 different float values
  template <typename T, typename U,
            typename std::enable_if<std::is_floating_point<typename std::decay<T>::type>::value &&
                                    std::is_floating_point<typename std::decay<U>::type>::value>::type* = nullptr>
  explicit Real2(T&& a, U&& b) : x(std::forward<T>(a)), y(std::forward<U>(b)) {}
  // Copy ctor
  explicit Real2(const Real2& v) : x(v.x), y(v.y) {}
	// Move ctor
  explicit Real2(Real2&& v) : x(std::move(v.x)), y(std::move(v.y)) {}

	// Assignment operator
	Real2& operator=(const double v) noexcept { x = v; y = v; return *this; }
	Real2& operator=(const Real2& v) noexcept { x = v.x; y = v.y; return *this; }
	Real2& operator=(Real2&& v) noexcept { x = std::move(v.x); y = std::move(v.y); return *this; }

	// Sum
	Real2& operator+=(const double v) noexcept { x += v; y += v; return *this; }
	Real2& operator+=(const Real2& v) noexcept { x += v.x; y += v.y; return *this; }

	// Add
	template <typename T, typename std::enable_if<std::is_arithmetic<T>::value>::type* = nullptr>
	Real2 operator+(T v) const noexcept
	{
	  return Real2(x + v, y + v);
	}
	Real2 operator+(const Real2& v) const noexcept { return Real2(x + v.x, y + v.y); }

	// Minus
  template <typename T, typename std::enable_if<std::is_arithmetic<T>::value>::type* = nullptr>
  Real2 operator-(T v) const noexcept
  {
    return Real2(x - v, y - v);
  }
  Real2 operator-(const Real2& v) const noexcept { return Real2(x - v.x, y - v.y); }

  // Mult
	template <typename T, typename std::enable_if<std::is_arithmetic<T>::value>::type* = nullptr>
	Real2 operator*(T v) const noexcept
	{
	  return Real2(x * v, y * v);
	}
	Real2 operator*(const Real2& v) const noexcept { return Real2(x * v.x, y * v.y); }

	// Div
	template <typename T, typename std::enable_if<std::is_arithmetic<T>::value>::type* = nullptr>
  Real2 operator/(T v) const
  {
    return Real2(x / v, y / v);
  }
  Real2 operator/(const Real2& v) const { return Real2(x / v.x, y / v.y); }

	// I/O
	friend std::ostream& operator <<(std::ostream& s, const Real2& a)
	{
		s << "[" << a.x << "," << a.y << "]";
		return s;
	}
};

// Helpers for commutativity  // Needed ?
template <typename T, typename std::enable_if<std::is_arithmetic<T>::value>::type* = nullptr>
Real2 operator+(T a, const Real2& b) noexcept
{
  return b.operator+(a);
}
template <typename T, typename std::enable_if<std::is_arithmetic<T>::value>::type* = nullptr>
Real2 operator*(T a, const Real2& b) noexcept
{
  return b.operator*(a);
}

}
#endif /* TYPES_REAL2_H_ */
