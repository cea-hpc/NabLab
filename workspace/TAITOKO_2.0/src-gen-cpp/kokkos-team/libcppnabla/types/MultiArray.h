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
#include <utility>


/******************************* MACROs ***************************************/
// Designed to be used with array value type as T1 and scalar operand type as T2
// Meaning that if T2==float and T1==int, return type is T2 else T1
#define RES_TYPE(T1, T2) \
        typename std::conditional_t<std::is_floating_point_v<T2> && std::is_integral_v<T1>, T2, T1>

// Meaning T1 and T2 are arithmetic type (i.e. integral or floating point) and T2 can be converted into T1
#define TYPE_CHECK(T1, T2) \
        typename std::enable_if_t<std::is_arithmetic_v<T1> && std::is_arithmetic_v<T2> && \
                                  std::is_convertible_v<T1, T2>>* = nullptr
                                
// Meaning T1 and T2 are of the same type   is an array of dimension N
#define DIM_CHECK(T1, T2) \
        typename std::enable_if_t<std::is_same_v<T1, T2>>* = nullptr


/******************************************************************************/
// Generic Multi-Dimension template
// When specifying a 0 dimension MultiArray, it becomes dynamic, using std::vector inheritance instead of std::array
template <typename T, size_t DIM_1, size_t... DIM_N>
struct MultiArray : public std::conditional_t<DIM_1, std::array<MultiArray<T, DIM_N...>, DIM_1>, std::vector<MultiArray<T, DIM_N...>>>
{
  // Template dimensions backup
  static constexpr std::array<size_t, 1 + sizeof...(DIM_N)> dimensions = {DIM_1, DIM_N...};
  
  // Helper for wrapping dynamic memory allocation when MultiArray inherite from vector
  template<typename SIZE_1, typename... SIZE_N>
  typename std::enable_if_t<std::is_integral_v<std::decay_t<SIZE_1>> && (std::is_integral_v<std::decay_t<SIZE_N>> && ...), void> initSize(SIZE_1 size_1, SIZE_N... size_n) {
    static_assert(1 + sizeof...(size_n) == dimensions.size());
    if (!dimensions.front())
      reinterpret_cast<std::vector<MultiArray<T, DIM_N...>>*>(this)->resize(size_1);
    for (size_t i(0); i < this->size(); ++i)
      this->operator[](i).initSize(size_n...);
  }

  // Generic method wich recursively calls relevant operation for every dimensions
  // Scalar operations
  template <typename ScalarT, typename BinaryOp>
  MultiArray<RES_TYPE(T, ScalarT), DIM_1, DIM_N...> scalarOp(ScalarT x, BinaryOp op) const {
    MultiArray<RES_TYPE(T, ScalarT), DIM_1, DIM_N...> result;
    std::transform(this->begin(), this->end(), result.begin(), [&](auto i){return i.scalarOp(x, op);});
    return result;
  }
  // Array operations
  template <typename ArrayT, typename BinaryOp>
  MultiArray arrayOp(ArrayT a, BinaryOp op) const {
    MultiArray result;
    std::transform(this->begin(), this->end(), a.begin(), result.begin(),
                   [&](auto& i, auto& j){return i.arrayOp(j, op);});
    return result;
  }

  // Binary +
  template <typename ScalarT, TYPE_CHECK(T, ScalarT)>
  MultiArray<RES_TYPE(T, ScalarT), DIM_1, DIM_N...> operator+(ScalarT x) const {
    return scalarOp(static_cast<RES_TYPE(T, ScalarT)>(x), std::plus<>());
  }
  template <typename ArrayT, typename std::enable_if_t<std::is_same_v<ArrayT, MultiArray>>* = nullptr>
  MultiArray operator+(ArrayT a) const {
    return arrayOp(a, std::plus<>());
  }
  
  // Unary -
  MultiArray operator-() const {
    return scalarOp(-1.0, std::multiplies<>());
  }
  // Binary -
  template <typename ScalarT, TYPE_CHECK(T, ScalarT)>
  MultiArray<RES_TYPE(T, ScalarT), DIM_1, DIM_N...> operator-(ScalarT x) const {
    return scalarOp(static_cast<RES_TYPE(T, ScalarT)>(x), std::minus<>());
  }
  template <typename ArrayT, typename std::enable_if_t<std::is_same_v<ArrayT, MultiArray>>* = nullptr>
  MultiArray operator-(ArrayT a) const {
    return arrayOp(a, std::minus<>());
  }
  
  // Binary *
  template <typename ScalarT, TYPE_CHECK(T, ScalarT)>
  MultiArray<RES_TYPE(T, ScalarT), DIM_1, DIM_N...> operator*(ScalarT x) const {
    return scalarOp(static_cast<RES_TYPE(T, ScalarT)>(x), std::multiplies<>());
  }
  template <typename ArrayT, typename std::enable_if_t<std::is_same_v<ArrayT, MultiArray>>* = nullptr>
  MultiArray operator*(ArrayT a) const {
    return arrayOp(a, std::multiplies<>());
  }
  
  // Binary /
  template <typename ScalarT, TYPE_CHECK(T, ScalarT)>
  MultiArray<RES_TYPE(T, ScalarT), DIM_1, DIM_N...> operator/(ScalarT x) const {
    return scalarOp(static_cast<RES_TYPE(T, ScalarT)>(x), std::divides<>());
  }
  template <typename ArrayT, typename std::enable_if_t<std::is_same_v<ArrayT, MultiArray>>* = nullptr>
  MultiArray operator/(ArrayT a) const {
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
  template <typename ArrayT, typename std::enable_if_t<std::is_same_v<ArrayT, MultiArray>>* = nullptr>
  MultiArray& operator+=(ArrayT a) {
    return arrayOpInPlace(a, std::plus<>());
  }
  
  // -=
  template <typename ScalarT, TYPE_CHECK(T, ScalarT)>
  MultiArray& operator-=(ScalarT x) {
    return scalarOpInPlace(static_cast<T>(x), std::minus<>());
  }
  template <typename ArrayT, typename std::enable_if_t<std::is_same_v<ArrayT, MultiArray>>* = nullptr>
  MultiArray& operator-=(ArrayT a) {
    return arrayOpInPlace(a, std::minus<>());
  }
  
  // *=
  template <typename ScalarT, TYPE_CHECK(T, ScalarT)>
  MultiArray& operator*=(ScalarT x) {
    return scalarOpInPlace(static_cast<T>(x), std::multiplies<>());
  }
  template <typename ArrayT, typename std::enable_if_t<std::is_same_v<ArrayT, MultiArray>>* = nullptr>
  MultiArray& operator*=(ArrayT a) {
    return arrayOpInPlace(a, std::multiplies<>());
  }
  
  // /=
  template <typename ScalarT, TYPE_CHECK(T, ScalarT)>
  MultiArray& operator/=(ScalarT x) {
    return scalarOpInPlace(static_cast<T>(x), std::divides<>());
  }
  template <typename ArrayT, typename std::enable_if_t<std::is_same_v<ArrayT, MultiArray>>* = nullptr>
  MultiArray& operator/=(ArrayT a) {
    return arrayOpInPlace(a, std::divides<>());
  }
};


/******************************************************************************/
// Specialized for 1 dimension to stop recursive calls
template<typename T, size_t DIM>
struct MultiArray<T, DIM> : public std::conditional_t<DIM, std::array<T, DIM>, std::vector<T>>
{
  // Template dimensions backup
  static constexpr std::array<size_t, 1> dimensions = {DIM};
  
  template<typename SIZE>
  typename std::enable_if_t<std::is_integral_v<std::decay_t<SIZE>>, void> initSize(SIZE size) {
    if (!dimensions.front())
      reinterpret_cast<std::vector<T>*>(this)->resize(size);
  }
  
  // ********** Generic method wich calls relevant operation, return by value semantic **********
  // Scalar operations
  template <typename ScalarT, typename BinaryOp>
  MultiArray<RES_TYPE(T, ScalarT), DIM> scalarOp(ScalarT x, BinaryOp op) const {
    MultiArray<RES_TYPE(T, ScalarT), DIM> result;
    std::transform(this->begin(), this->end(), result.begin(),
                   [&](auto& i){return op(static_cast<RES_TYPE(T, ScalarT)>(i), x);});
    return result;
  }
  // Array operations
  template <typename ArrayT, typename BinaryOp>
  MultiArray arrayOp(ArrayT a, BinaryOp op) const {
    MultiArray result;
    std::transform(this->begin(), this->end(), a.begin(), result.begin(),
                   [&](auto& i, auto& j){return op(static_cast<T>(i),
                                                   static_cast<T>(j));});
    return result;
  }
  
  // Binary +
  template <typename ScalarT, TYPE_CHECK(T, ScalarT)>
  MultiArray<RES_TYPE(T, ScalarT), DIM> operator+(ScalarT x) const {
    return scalarOp(static_cast<RES_TYPE(T, ScalarT)>(x), std::plus<>());
  }
  template <typename ArrayT, typename std::enable_if_t<std::is_same_v<ArrayT, MultiArray>>* = nullptr>
  MultiArray operator+(ArrayT a) const {
    return arrayOp(a, std::plus<>());
  }
  
  // Unary -
  MultiArray operator-() const {
    return scalarOp(-1.0, std::multiplies<>());
  }
  // Binary -
  template <typename ScalarT, TYPE_CHECK(T, ScalarT)>
  MultiArray<RES_TYPE(T, ScalarT), DIM> operator-(ScalarT x) const {
    return scalarOp(static_cast<RES_TYPE(T, ScalarT)>(x), std::minus<>());
  }
  template <typename ArrayT, typename std::enable_if_t<std::is_same_v<ArrayT, MultiArray>>* = nullptr>
  MultiArray operator-(ArrayT a) const {
    return arrayOp(a, std::minus<>());
  }
  
  // Binary *
  template <typename ScalarT, TYPE_CHECK(T, ScalarT)>
  MultiArray<RES_TYPE(T, ScalarT), DIM> operator*(ScalarT x) const {
    return scalarOp(static_cast<RES_TYPE(T, ScalarT)>(x), std::multiplies<>());
  }
  template <typename ArrayT, typename std::enable_if_t<std::is_same_v<ArrayT, MultiArray>>* = nullptr>
  MultiArray operator*(ArrayT a) const {
    return arrayOp(a, std::multiplies<>());
  }
  
  // Binary /
  template <typename ScalarT, TYPE_CHECK(T, ScalarT)>
  MultiArray<RES_TYPE(T, ScalarT), DIM> operator/(ScalarT x) const {
    return scalarOp(static_cast<RES_TYPE(T, ScalarT)>(x), std::divides<>());
  }
  template <typename ArrayT, typename std::enable_if_t<std::is_same_v<ArrayT, MultiArray>>* = nullptr>
  MultiArray operator/(ArrayT a) const {
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
  template <typename ArrayT, typename std::enable_if_t<std::is_same_v<ArrayT, MultiArray>>* = nullptr>
  MultiArray& operator+=(ArrayT a) {
    return arrayOpInPlace(a, std::plus<>());
  }
  
  // -=
  template <typename ScalarT, TYPE_CHECK(T, ScalarT)>
  MultiArray& operator-=(ScalarT x) {
    return scalarOpInPlace(static_cast<T>(x), std::minus<>());
  }
  template <typename ArrayT, typename std::enable_if_t<std::is_same_v<ArrayT, MultiArray>>* = nullptr>
  MultiArray& operator-=(ArrayT a) {
    return arrayOpInPlace(a, std::minus<>());
  }
  
  // *=
  template <typename ScalarT, TYPE_CHECK(T, ScalarT)>
  MultiArray& operator*=(ScalarT x) {
    return scalarOpInPlace(static_cast<T>(x), std::multiplies<>());
  }
  template <typename ArrayT, typename std::enable_if_t<std::is_same_v<ArrayT, MultiArray>>* = nullptr>
  MultiArray& operator*=(ArrayT a) {
    return arrayOpInPlace(a, std::multiplies<>());
  }
  
  // /=
  template <typename ScalarT, TYPE_CHECK(T, ScalarT)>
  MultiArray& operator/=(ScalarT x) {
    return scalarOpInPlace(static_cast<T>(x), std::divides<>());
  }
  template <typename ArrayT, typename std::enable_if_t<std::is_same_v<ArrayT, MultiArray>>* = nullptr>
  MultiArray& operator/=(ArrayT a) {
    return arrayOpInPlace(a, std::divides<>());
  }
};


/******************************************************************************/
// Alias for double array of N dimensions
template <size_t DIM_1, size_t... DIM_N>
using RealArray = MultiArray<double, DIM_1, DIM_N...>;

// Alias for int array of N dimensions
template <size_t DIM_1, size_t... DIM_N>
using IntArray = MultiArray<int, DIM_1, DIM_N...>;


/******************************************************************************/
// Pretty printer helper function for std::array array
template<typename T, size_t N>
std::ostream& operator<<(std::ostream& os, const std::array<T, N>& array) {
  os << "[";
  for (typename std::array<T, N>::size_type i(0); i < N; ++i)
    os << array[i] << (i!=N-1?", ":"]\n");
  return os;
}

// Pretty printer helper function for 1 dimension MultiArray
template<typename T, size_t DIM>
std::ostream& operator<<(std::ostream& os, const MultiArray<T, DIM>& array) {
  for (typename MultiArray<T, DIM>::size_type i(0); i < array.size(); ++i)
    std::cout << (i==0?"| ":"") << array[i] << (i==array.size()-1?" |":" ");
  return os;
}

// Pretty printer helper function for N dimension MultiArray
template <typename T, size_t DIM_1, size_t... DIM_N>
std::ostream& operator<<(std::ostream& os, const MultiArray<T, DIM_1, DIM_N...>& array) {
  for (auto i : array)
    os << i << std::endl;
  return os;
}


/******************************************************************************/
// Commutative helpers
template <typename T, size_t DIM_1, size_t... DIM_N, typename std::enable_if_t<std::is_arithmetic_v<T>>* = nullptr>
auto operator+(T lhs, MultiArray<T, DIM_1, DIM_N...> rhs) {
  return rhs.operator+(lhs);
}

template <typename T, size_t DIM_1, size_t... DIM_N, typename std::enable_if_t<std::is_arithmetic_v<T>>* = nullptr>
auto operator*(T lhs, MultiArray<T, DIM_1, DIM_N...> rhs) {
  return rhs.operator*(lhs);
}


#endif
