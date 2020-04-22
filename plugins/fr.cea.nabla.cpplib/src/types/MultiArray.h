/*******************************************************************************
 * Copyright (c) 2020 CEA
 * This program and the accompanying materials are made available under the 
 * terms of the Eclipse Public License 2.0 which is available at
 * http://www.eclipse.org/legal/epl-2.0.
 *
 * SPDX-License-Identifier: EPL-2.0
 * Contributors: see AUTHORS file
 *******************************************************************************/
#ifndef UTILS_MULTIARRAY_H_
#define UTILS_MULTIARRAY_H_

#include <array>
#include <iostream>
#include <type_traits>
#include <algorithm>
#include <functional>

/******************************* MACROs ***************************************/
// Designed to be used with array value type as T1 and scalar operand type as T2
// Meaning that if T2==float and T1==int, return type is T2 else T1
#define RES_TYPE(T1, T2) \
        typename std::conditional_t<std::is_floating_point<T2>::value && std::is_integral<T1>::value, T2, T1>

// Meaning T1 and T2 are arithmetic type (i.e. integral or floating point) and T2 can be converted into T1
#define TYPE_CHECK(T1, T2) \
        typename std::enable_if_t<std::is_arithmetic<T1>::value && std::is_arithmetic<T2>::value && \
                                  std::is_convertible<T1, T2>::value>* = nullptr
                                
// Meaning T1 and T2 are of the same type   is an array of dimension N
#define DIM_CHECK(T1, T2) \
        typename std::enable_if_t<std::is_same<T1, T2>::value>* = nullptr


/******************************************************************************/
// Generic Multi-Dimension template
template <typename T, size_t dim1, size_t... dimN>
struct MultiArray : public std::array<MultiArray<T, dimN...>, dim1>
{
  // Generic method wich recursively calls relevant operation for every dimensions
  // Scalar operations
  template <typename ScalarT, typename BinaryOp>
  MultiArray<RES_TYPE(T, ScalarT), dim1, dimN...> scalarOp(ScalarT x, BinaryOp op) {
    MultiArray<RES_TYPE(T, ScalarT), dim1, dimN...> result;
    std::transform(this->begin(), this->end(), result.begin(), [&](auto i){return i.scalarOp(x, op);});
    return result;
  }
  // Array operations
  template <typename ArrayT, typename BinaryOp>
  MultiArray arrayOp(ArrayT a, BinaryOp op) {
    MultiArray result;
    std::transform(this->begin(), this->end(), a.begin(), result.begin(),
                   [&](auto& i, auto& j){return i.arrayOp(j, op);});
    return result;
  }

  // Binary +
  template <typename ScalarT, TYPE_CHECK(T, ScalarT)>
  MultiArray<RES_TYPE(T, ScalarT), dim1, dimN...> operator+(ScalarT x) {
    return scalarOp(static_cast<RES_TYPE(T, ScalarT)>(x), std::plus<>());
  }
  template <typename ArrayT, typename std::enable_if_t<std::is_same<ArrayT, MultiArray>::value>* = nullptr>
  MultiArray operator+(ArrayT a) {
    return arrayOp(a, std::plus<>());
  }
  
  // Unary -
  MultiArray operator-() {
    return scalarOp(-1.0, std::multiplies<>());
  }
  // Binary -
  template <typename ScalarT, TYPE_CHECK(T, ScalarT)>
  MultiArray<RES_TYPE(T, ScalarT), dim1, dimN...> operator-(ScalarT x) {
    return scalarOp(static_cast<RES_TYPE(T, ScalarT)>(x), std::minus<>());
  }
  template <typename ArrayT, typename std::enable_if_t<std::is_same<ArrayT, MultiArray>::value>* = nullptr>
  MultiArray operator-(ArrayT a) {
    return arrayOp(a, std::minus<>());
  }
  
  // Binary *
  template <typename ScalarT, TYPE_CHECK(T, ScalarT)>
  MultiArray<RES_TYPE(T, ScalarT), dim1, dimN...> operator*(ScalarT x) {
    return scalarOp(static_cast<RES_TYPE(T, ScalarT)>(x), std::multiplies<>());
  }
  template <typename ArrayT, typename std::enable_if_t<std::is_same<ArrayT, MultiArray>::value>* = nullptr>
  MultiArray operator*(ArrayT a) {
    return arrayOp(a, std::multiplies<>());
  }
  
  // Binary /
  template <typename ScalarT, TYPE_CHECK(T, ScalarT)>
  MultiArray<RES_TYPE(T, ScalarT), dim1, dimN...> operator/(ScalarT x) {
    return scalarOp(static_cast<RES_TYPE(T, ScalarT)>(x), std::divides<>());
  }
  template <typename ArrayT, typename std::enable_if_t<std::is_same<ArrayT, MultiArray>::value>* = nullptr>
  MultiArray operator/(ArrayT a) {
    return arrayOp(a, std::divides<>());
  }
  
  // ********** Generic method wich calls relevant operation, in-place (input is changed) **********
  // Scalar operations
  template <typename ScalarT, typename BinaryOp>
  MultiArray& scalarOpInPlace(ScalarT x, BinaryOp op) {
    std::transform(this->begin(), this->end(), this->begin(), [&](auto& i){return i.scalarOpInPlace(x, op);});
    return *this;
  }
  // Array operations
  template <typename ArrayT, typename BinaryOp>
  MultiArray& arrayOpInPlace(ArrayT a, BinaryOp op) {
    std::transform(this->begin(), this->end(), a.begin(), this->begin(),
                   [&](auto& i, auto& j){return i.arrayOpInPlace(j, op);});
    return *this;
  }
  
  // +=
  template <typename ScalarT, TYPE_CHECK(T, ScalarT)>
  MultiArray& operator+=(ScalarT x) {
    return scalarOpInPlace(static_cast<T>(x), std::plus<>());
  }
  template <typename ArrayT, typename std::enable_if_t<std::is_same<ArrayT, MultiArray>::value>* = nullptr>
  MultiArray& operator+=(ArrayT a) {
    return arrayOpInPlace(a, std::plus<>());
  }
  
  // -=
  template <typename ScalarT, TYPE_CHECK(T, ScalarT)>
  MultiArray& operator-=(ScalarT x) {
    return scalarOpInPlace(static_cast<T>(x), std::minus<>());
  }
  template <typename ArrayT, typename std::enable_if_t<std::is_same<ArrayT, MultiArray>::value>* = nullptr>
  MultiArray& operator-=(ArrayT a) {
    return arrayOpInPlace(a, std::minus<>());
  }
  
  // *=
  template <typename ScalarT, TYPE_CHECK(T, ScalarT)>
  MultiArray& operator*=(ScalarT x) {
    return scalarOpInPlace(static_cast<T>(x), std::multiplies<>());
  }
  template <typename ArrayT, typename std::enable_if_t<std::is_same<ArrayT, MultiArray>::value>* = nullptr>
  MultiArray& operator*=(ArrayT a) {
    return arrayOpInPlace(a, std::multiplies<>());
  }
  
  // /=
  template <typename ScalarT, TYPE_CHECK(T, ScalarT)>
  MultiArray& operator/=(ScalarT x) {
    return scalarOpInPlace(static_cast<T>(x), std::divides<>());
  }
  template <typename ArrayT, typename std::enable_if_t<std::is_same<ArrayT, MultiArray>::value>* = nullptr>
  MultiArray& operator/=(ArrayT a) {
    return arrayOpInPlace(a, std::divides<>());
  }
};


/******************************************************************************/
// Specialized for 1 dimension to stop recursive calls
template<typename T, size_t dim>
struct MultiArray<T, dim> : public std::array<T, dim>
{
  // ********** Generic method wich calls relevant operation, return by value semantic **********
  // Scalar operations
  template <typename ScalarT, typename BinaryOp>
  MultiArray<RES_TYPE(T, ScalarT), dim> scalarOp(ScalarT x, BinaryOp op) {
    MultiArray<RES_TYPE(T, ScalarT), dim> result;
    std::transform(this->begin(), this->end(), result.begin(),
                   [&](auto& i){return op(static_cast<RES_TYPE(T, ScalarT)>(i), x);});
    return result;
  }
  // Array operations
  template <typename ArrayT, typename BinaryOp>
  MultiArray arrayOp(ArrayT a, BinaryOp op) {
    MultiArray result;
    std::transform(this->begin(), this->end(), a.begin(), result.begin(),
                   [&](auto& i, auto& j){return op(static_cast<T>(i),
                                                   static_cast<T>(j));});
    return result;
  }
  
  // Binary +
  template <typename ScalarT, TYPE_CHECK(T, ScalarT)>
  MultiArray<RES_TYPE(T, ScalarT), dim> operator+(ScalarT x) {
    return scalarOp(static_cast<RES_TYPE(T, ScalarT)>(x), std::plus<>());
  }
  template <typename ArrayT, typename std::enable_if_t<std::is_same<ArrayT, MultiArray>::value>* = nullptr>
  MultiArray operator+(ArrayT a) {
    return arrayOp(a, std::plus<>());
  }
  
  // Unary -
  MultiArray operator-() {
    return scalarOp(-1.0, std::multiplies<>());
  }
  // Binary -
  template <typename ScalarT, TYPE_CHECK(T, ScalarT)>
  MultiArray<RES_TYPE(T, ScalarT), dim> operator-(ScalarT x) {
    return scalarOp(static_cast<RES_TYPE(T, ScalarT)>(x), std::minus<>());
  }
  template <typename ArrayT, typename std::enable_if_t<std::is_same<ArrayT, MultiArray>::value>* = nullptr>
  MultiArray operator-(ArrayT a) {
    return arrayOp(a, std::minus<>());
  }
  
  // Binary *
  template <typename ScalarT, TYPE_CHECK(T, ScalarT)>
  MultiArray<RES_TYPE(T, ScalarT), dim> operator*(ScalarT x) {
    return scalarOp(static_cast<RES_TYPE(T, ScalarT)>(x), std::multiplies<>());
  }
  template <typename ArrayT, typename std::enable_if_t<std::is_same<ArrayT, MultiArray>::value>* = nullptr>
  MultiArray operator*(ArrayT a) {
    return arrayOp(a, std::multiplies<>());
  }
  
  // Binary /
  template <typename ScalarT, TYPE_CHECK(T, ScalarT)>
  MultiArray<RES_TYPE(T, ScalarT), dim> operator/(ScalarT x) {
    return scalarOp(static_cast<RES_TYPE(T, ScalarT)>(x), std::divides<>());
  }
  template <typename ArrayT, typename std::enable_if_t<std::is_same<ArrayT, MultiArray>::value>* = nullptr>
  MultiArray operator/(ArrayT a) {
    return arrayOp(a, std::divides<>());
  }
  
  // ********** Generic method wich calls relevant operation, in-place (input is changed) **********
  // Scalar operations
  template <typename ScalarT, typename BinaryOp>
  MultiArray& scalarOpInPlace(ScalarT x, BinaryOp op) {
    std::transform(this->begin(), this->end(), this->begin(), [&](auto& i){return op(i, x);});
    return *this;
  }
  // Array operations
  template <typename ArrayT, typename BinaryOp>
  MultiArray& arrayOpInPlace(ArrayT a, BinaryOp op) {
    std::transform(this->begin(), this->end(), a.begin(), this->begin(),
                   [&](auto& i, auto& j){return op(static_cast<T>(i),
                                                   static_cast<T>(j));});
    return *this;
  }
  
  // +=
  template <typename ScalarT, TYPE_CHECK(T, ScalarT)>
  MultiArray& operator+=(ScalarT x) {
    return scalarOpInPlace(static_cast<T>(x), std::plus<>());
  }
  template <typename ArrayT, typename std::enable_if_t<std::is_same<ArrayT, MultiArray>::value>* = nullptr>
  MultiArray& operator+=(ArrayT a) {
    return arrayOpInPlace(a, std::plus<>());
  }
  
  // -=
  template <typename ScalarT, TYPE_CHECK(T, ScalarT)>
  MultiArray& operator-=(ScalarT x) {
    return scalarOpInPlace(static_cast<T>(x), std::minus<>());
  }
  template <typename ArrayT, typename std::enable_if_t<std::is_same<ArrayT, MultiArray>::value>* = nullptr>
  MultiArray& operator-=(ArrayT a) {
    return arrayOpInPlace(a, std::minus<>());
  }
  
  // *=
  template <typename ScalarT, TYPE_CHECK(T, ScalarT)>
  MultiArray& operator*=(ScalarT x) {
    return scalarOpInPlace(static_cast<T>(x), std::multiplies<>());
  }
  template <typename ArrayT, typename std::enable_if_t<std::is_same<ArrayT, MultiArray>::value>* = nullptr>
  MultiArray& operator*=(ArrayT a) {
    return arrayOpInPlace(a, std::multiplies<>());
  }
  
  // /=
  template <typename ScalarT, TYPE_CHECK(T, ScalarT)>
  MultiArray& operator/=(ScalarT x) {
    return scalarOpInPlace(static_cast<T>(x), std::divides<>());
  }
  template <typename ArrayT, typename std::enable_if_t<std::is_same<ArrayT, MultiArray>::value>* = nullptr>
  MultiArray& operator/=(ArrayT a) {
    return arrayOpInPlace(a, std::divides<>());
  }
};


/******************************************************************************/
// Alias for double array of N dimensions
template <size_t dim1, size_t... dimN>
using RealArray = MultiArray<double, dim1, dimN...>;

// Alias for int array of N dimensions
template <size_t dim1, size_t... dimN>
using IntArray = MultiArray<int, dim1, dimN...>;


/******************************************************************************/
// Pretty printer helper function for 1 dimension array
template<typename T, size_t N>
std::ostream& operator<<(std::ostream& os, const std::array<T, N>& array) {
  os << "[";
  for (typename std::array<T, N>::size_type i(0); i < N; ++i)
    os << array[i] << (i!=N-1?", ":"]\n");
  return os;
}


/******************************************************************************/
// Commutative helpers
template <typename T, size_t dim1, size_t... dimN, typename std::enable_if_t<std::is_arithmetic<T>::value>* = nullptr>
auto operator+(T lhs, MultiArray<T, dim1, dimN...> rhs) {
  return rhs.operator+(lhs);
}

template <typename T, size_t dim1, size_t... dimN, typename std::enable_if_t<std::is_arithmetic<T>::value>* = nullptr>
auto operator*(T lhs, MultiArray<T, dim1, dimN...> rhs) {
  return rhs.operator*(lhs);
}


#endif
