/*******************************************************************************
 * Copyright (c) 2020 CEA
 * This program and the accompanying materials are made available under the 
 * terms of the Eclipse Public License 2.0 which is available at
 * http://www.eclipse.org/legal/epl-2.0.
 *
 * SPDX-License-Identifier: EPL-2.0
 * Contributors: see AUTHORS file
 *******************************************************************************/
#ifndef NABLALIB_TYPES_MULTIARRAY_H_
#define NABLALIB_TYPES_MULTIARRAY_H_

#include <iostream>
#include <type_traits>
#include <algorithm>
#include <memory>
#include <exception>
#include <array>
#include <numeric>

/**
 * TODO:
 * - Add allocator support as another template argument
 * - Add alignment support
 * - Replace most exceptions with assert to be able to desactive them and be more GPU compliant
 * - Split class into more files
 * - Replace pointer with smart pointer
 * - Maybe split static and dynamic size code
 */

namespace nablalib::types
{
// ******************************* MACROs **************************************
/**
 * Designed to be used as an implicit floating point type conversion
 * for operation between an array of type T1 and a scalar of type T2
 * E.g. if T2==float and T1==int, return type is T2 else T1
 */
#define RES_TYPE(T1, T2) \
        typename std::conditional_t<std::is_floating_point_v<T2> && std::is_integral_v<T1>, T2, T1>

/// Meaning T1 and T2 are arithmetic type (i.e. integral or floating point) and T2 can be converted into T1
#define TYPE_CHECK(T1, T2) \
        typename std::enable_if_t<std::is_arithmetic_v<T1> && std::is_arithmetic_v<T2> && \
                                  std::is_convertible_v<T1, T2>>* = nullptr
                                
/// Meaning T1 and T2 are of the same type   is an array of dimension N
#define DIM_CHECK(T1, T2) \
        typename std::enable_if_t<std::is_same_v<T1, T2>>* = nullptr


// *****************************************************************************


/**
 * @class MultiArray
 * @brief Generic Multi-Dimension template
 * Classical contiguous space allocation, raw major ordering (suject to change)
 *
 * @note Offset goes like this: ID_N + (ID_N-1 x DIM_N) + ... + (ID_1 x DIM_2 x ... x DIM_N)
 *
 * @tparam T Data type
 * @tparam DIM_1 Desired size for 1st dimension
 * @tparam DIM_N Desired sizes for all other dimensions
 */
template <typename T, size_t DIM_1, size_t... DIM_N>
class MultiArray
{
 public:
  /// Alias for data type
  using value_type = T;
  /// Alias for underlying size type
  using size_type = size_t;

  /**
   * @brief Default Ctor
   * Default constructor, allocate memory contiguously (memory size = DIM_1 x ... x DIM_N)
   * When giving dimension a 0 value (e.g. MultiArray<double, 4, 0>) initial memory allocation is
   * 1 element of given type (e.g. (4 * 1)*sizeof(double)). Then, dynamic resizing will be required by
   * calling initSize(...) method.
   */
  MultiArray()
    : m_size{(DIM_1?DIM_1:1), (DIM_N?DIM_N:1)...},
      m_nb_elmt(std::accumulate(m_size.begin(), m_size.end(), 1, std::multiplies<size_type>())),
      m_self_destruct(true), m_ptr(new T[m_nb_elmt]) {}

  /**
   * @brief Initializer list constructor
   * Constructs a new MultiArray object with given values.
   * Memory is allocated (product of template parameters' value).
   * Dynamic resizing is not supported with initial values contructor
   * (hence a 0 value template parameter is forbidden).
   *
   * @param init Brace-enclosed-list value. Must be as large as product of every template parameters
   */
  MultiArray(std::initializer_list<T> init)
    : m_size{DIM_1,DIM_N...},
      m_nb_elmt(std::accumulate(m_size.begin(), m_size.end(), 1, std::multiplies<size_type>())),
      m_self_destruct(true), m_ptr(nullptr) {
    static_assert(DIM_1 && (DIM_N && ...), "Can't contruct a dynamic size MultiArray with initial values");
    if (m_nb_elmt != init.size())
      throw std::logic_error(
        "MultiArray ctor initializer list must have as much elements as indicated in class template parameters");
    m_ptr = new T[m_nb_elmt];
    std::uninitialized_copy(init.begin(), init.end(), m_ptr);
  }

  /**
   * @brief (Deep) Copy contructor
   * (copy every value os a into already allocated memory of this)
   *
   * @param a MultiArray to copy
   */
  MultiArray(const MultiArray& a)
    : m_size(a.m_size), m_nb_elmt(a.m_nb_elmt), m_self_destruct(true), m_ptr(new T[m_nb_elmt]) {
    if ((m_size.size() != a.m_size.size()) || (m_size != a.m_size))
      throw std::logic_error("Can't construct MultiArray from another MultiArray with different dimensions");
    std::uninitialized_copy(a.begin(), a.end(), m_ptr);
  }

/**
   * @brief Constructor for dynamic allocation,
   * which is indicated by a 0 value template parameter.
   *
   * @note Can only be called from outermost MultiArray
   *
   * @remark Method parameters must match class template parameters.
   * Obviously, parameters matching non zero value template parameters are meaningless and unused.
   * They are kept to get a clear overview of size for each dimension.
   *
   * @example size_t nb_elmt(foo.get());
   * @example MultiArray<int, 0, 3> array(nb_elmt, 3);
   *
   * @param[in] size_1 Desired size for the 1st dimension. Must reflect template parameter for non dynamic size
   * @param[in] size_n... Desired size for all other dimensions. Must reflect template parameters for non dynamic size
   */
  template<typename SIZE_1, typename... SIZE_N,
    typename std::enable_if_t<
      std::is_integral_v<std::decay_t<SIZE_1>> && (std::is_integral_v<std::decay_t<SIZE_N>> && ...), void>* = nullptr>
  MultiArray(SIZE_1 size_1, SIZE_N... size_n)
    : m_size{}, m_nb_elmt(0), m_self_destruct(true), m_ptr(nullptr) {
    static_assert(sizeof...(size_n) == sizeof...(DIM_N),
                  "Constructor must have as much parameters as MultiArray template parameters");
    if ((DIM_1?DIM_1!=size_1:0) || ((DIM_N?DIM_N!=size_n:0) || ...))
      throw std::logic_error(
        std::string("Constructor for dynamic size must be called with template parameters values of static sizes")
         + std::string(". Did you mean \"MultiArray(")
         + std::string((std::to_string(DIM_1?DIM_1:size_1) + ... + std::string(", " + std::to_string(DIM_N?DIM_N:size_n))))
         + std::string(")\" ?"));
    if (!(size_1 && (size_n && ...)))
      throw std::logic_error("Don't pass 0 as dynamic size constructor parameter");
    m_nb_elmt = (size_1 * ... * size_n);
    m_ptr = new T[m_nb_elmt];
    m_size = {static_cast<size_type>(size_1), static_cast<size_type>(size_n)...};
  }

  /**
   * @brief Dtor
   * Destructor. Free memory only if boolean attribute m_self_destruct is true.
   */
  ~MultiArray() {if (m_self_destruct) delete[] m_ptr;}

  /**
   * @brief Deep copy operator (copy every value os a into already allocated memory of this)
   *
   * @param a MultiArray to copy
   * @return MultiArray& modified object
   */
  MultiArray& operator=(MultiArray a) {
    if ((m_size.size() != a.m_size.size()) || (m_size != a.m_size))
      throw std::logic_error("Can't copy MultiArray with different dimensions (i.e. template parameters)");
    m_size = a.m_size;
    m_nb_elmt = a.m_nb_elmt;
    std::uninitialized_copy(a.begin(), a.end(), m_ptr);
    return *this;
  }

  /**
   * @brief copy operator from list of values
   *
   * @param list list of values
   * @return MultiArray& modified object
   */
  MultiArray& operator=(std::initializer_list<T> list) {
    if (m_nb_elmt != list.size()) {
      throw std::logic_error(
        "Initializer list in MultiArray copy operator has " + std::to_string(list.size()) +
        " elements but should have " + std::to_string(m_nb_elmt));
    }
    std::uninitialized_copy(list.begin(), list.end(), m_ptr);
    return *this;
  }

  /**
   * @brief Memory buffer accessor
   * Gives raw pointer access to linear buffer data
   *
   * @return address of 1st element of data buffer
   */
  T* data() {return m_ptr;}

  /**
   * @brief Returns an iterator to the beginning
   *
   * @return address of 1st element of data buffer
   */
  T* begin() const {return &(m_ptr[0]);}

  /**
   * @brief Returns an iterator to the end
   *
   * @return past the last element of data buffer
   */
  T* end() const {return &(m_ptr[m_nb_elmt]);}

  /**
   * @brief Dimension getter
   * Returns current dimension (aka. rank) of MultiArray

   * @example MultiArray<float, 5, 3> array;
   * @example std::cout << array.dimension();  // prints 2
   * @example std::cout << array[0].dimension();  // prints 1

   * @return current dimension (aka. rank)
   */
  size_type dimension() const {return m_size.size();}

  /**
   * @brief Size getter
   * Returns number of elements (aka. extent) of current dimension of MultiArray

   * @example MultiArray<float, 2, 3> array;
   * @example std::cout << array.size();  // prints 2
   * @example std::cout << array[0].size();  // prints 3

   * @return number of elements (aka. extent)
   */
  size_type size() const {return m_size[0];}

  /**
   * @brief initSize method. Meant to be called only for dynamic allocation,
   * which is indicated by a 0 value template parameter.
   *
   * @note Can only be called from outermost MultiArray
   *
   * @remark Method parameters must match class template parameters.
   * Obviously, parameters matching non zero value template parameters are meaningless and unused.
   * They are kept to get a clear overview of size for each dimension.
   *
   * @example MultiArray<int, 2, 0> array;
   * @example size_t nb_elmt(foo.get());
   * @example std::cout << array.initSize(2, nb_elmt);  // OK
   * @example std::cout << array[0].initSize(nb_elmt);  // NOT OK !!!
   *
   * @param[in] size_1 Desired size for the 1st dimension. Must reflect template parameter for non dynamic size
   * @param[in] size_n... Desired size for all other dimensions. Must reflect template parameters for non dynamic size
   */
  template<typename SIZE_1, typename... SIZE_N>
  typename std::enable_if_t<
      std::is_integral_v<std::decay_t<SIZE_1>> && (std::is_integral_v<std::decay_t<SIZE_N>> && ...),
      void> initSize(SIZE_1 size_1, SIZE_N... size_n) {
    if (!m_self_destruct)
      throw std::logic_error("initSize cannot be called from \"inner\" dimensions");
    static_assert(sizeof...(size_n) == sizeof...(DIM_N),
                  "initSize must have as much parameters as MultiArray template parameters");
    if ((DIM_1?DIM_1!=size_1:0) || ((DIM_N?DIM_N!=size_n:0) || ...))
      throw std::logic_error("initSize must be called with template parameters values for static size");
    if (!(size_1 && (size_n && ...)))
      throw std::logic_error("Don't pass 0 as initSize parameter");
    delete[] m_ptr;
    m_nb_elmt = (size_1 * ... * size_n);
    m_ptr = new T[m_nb_elmt];
    m_size = {static_cast<size_type>(size_1), static_cast<size_type>(size_n)...};
  }

  /**
   * @brief Element accessor method.
   * Gives access to the ith element of the container
   *
   * @note Access pattern is: ID_N + (ID_N-1 x DIM_N) + ... + (ID_1 x DIM_2 x ... x DIM_N)
   *
   * @param i Index of element of this dimension
   * @return MultiArray<T, DIM_N...> Irrelevant, used for variadic recursive private ctor calls
   */
  MultiArray<T, DIM_N...> operator[](const size_type i) const {
    std::array<size_type, sizeof...(DIM_N)> dimensions;
    std::copy(m_size.begin() + 1, m_size.end(), dimensions.begin());
    size_type nb_elmt(std::accumulate(dimensions.begin(), dimensions.end(), 1, std::multiplies<size_type>()));
    return MultiArray<T, DIM_N...>(m_ptr + (i * nb_elmt), dimensions);
  }

  // *****************************************************************************
  // FIXME: pb with DIM_X == 0, TODO: replace DIM by m_size
  // Generic method wich recursively calls relevant operation for every dimensions
  // Scalar operations
  template <typename ScalarT, typename BinaryOp>
  MultiArray<RES_TYPE(T, ScalarT), DIM_1, DIM_N...> scalarOp(ScalarT x, BinaryOp op) const {
    MultiArray<RES_TYPE(T, ScalarT), DIM_1, DIM_N...> result;
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
  // *****************************************************************************

 // private:  // FIXME: I really want to make it private, but can't manage to do so...
  /**
   * @brief Construct a new Nablab Array object without memory allocation by passing raw data memory pointer.
   *
   * @note This ctor is not meant to be used directly, it's used internally by operator[]
   *
   * @param ptr data pointer to be used (instead of allocating memory like other ctor do)
   * @param dimensions array indicating number of elements for each dimension
   */
  MultiArray(T* ptr, std::array<size_type, 1 + sizeof...(DIM_N)> dimensions)
    : m_size(dimensions), m_nb_elmt(std::accumulate(m_size.begin(), m_size.end(), 1, std::multiplies<size_type>())),
      m_self_destruct(false), m_ptr(ptr) {}

 private:
  std::array<size_type, 1 + sizeof...(DIM_N)> m_size;
  size_type m_nb_elmt;
  bool m_self_destruct;
  T* m_ptr;
};


// *****************************************************************************
// *****************************************************************************


/**
 * @class MultiArray
 * @brief Specialized template for 1 dimension (to stop recursive variadic template calls)
 *
 * @tparam T Data type
 * @tparam DIM Number of elements
 */
template<typename T, size_t DIM>
class MultiArray<T, DIM>
{
  // friend variadic template class to solve private ctor problem
  // TODO: find why it's not enough ?!
  // template<typename U, size_t DIM_1, size_t... DIM_N>
  // friend class MultiArray;

 public:
  /// Alias for data type
  using value_type = T;
  /// Alias for underlying size type
  using size_type = size_t;

  /**
   * @brief Default Ctor
   * Default constructor, allocate memory contiguously for DIM elements of T type
   * When giving dimension a 0 value, initial memory allocation is only 1 element.
   * Dynamic resizing will be required by calling initSize(...) method.
   */
  MultiArray() : m_size(DIM?DIM:1), m_self_destruct(true), m_ptr(nullptr) {
    m_ptr = new T[m_size];
  }

  /**
   * @brief Construct a new Nablab Array object from a given initializer list
   *
   * @note May throw if initializer list size if not equal to dimension class template parameter
   *
   * @param init List of initial values to be copied in allocated memory
   */
  MultiArray(std::initializer_list<T> init)
    : m_size(init.size()), m_self_destruct(true), m_ptr(nullptr) {
      if (DIM != init.size())
        throw std::logic_error(
          "MultiArray ctor initializer list must have as much elements as indicated in class template parameter");
      m_ptr = new T[m_size];
      std::uninitialized_copy(init.begin(), init.end(), m_ptr);
  }

  /**
   * @brief (Deep) Copy contructor
   * (copy every value os a into already allocated memory of this)
   *
   * @param a MultiArray to copy
   */
  MultiArray(const MultiArray& a)
    : m_size(a.m_size), m_self_destruct(true), m_ptr(new T[m_size]) {
    if (m_size != a.m_size)
      throw std::logic_error("Can't construct MultiArray from another MultiArray with different dimensions");
    std::uninitialized_copy(a.begin(), a.end(), m_ptr);
  }

  /**
   * @brief Constructor for dynamic dimension, which is indicated by a 0 value template parameter.
   *
   * @remark Method parameter must match class template parameter.
   * Obviously, parameter matching non zero value template parameter are meaningless and unused.
   * They are kept to get a clear overview of size for each dimension.
   *
   * @example size_t nb_elmt(foo.get());
   * @example MultiArray<int, 0> array(nb_elmt);  // OK
   *
   * @param[in] size_1 Desired size for the 1st dimension. Must reflect template parameter for non dynamic size
   * @param[in] size_n... Desired size for all other dimensions. Must reflect template parameters for non dynamic size
   */
  template<typename SIZE, typename std::enable_if_t<std::is_integral_v<std::decay_t<SIZE>>, void>* = nullptr>
  MultiArray(SIZE size) : m_size(0), m_self_destruct(true), m_ptr(nullptr) {
    if (DIM && (DIM!=size))
      throw std::logic_error(
        std::string("Constructor for dynamic size must be called with template parameter value for static size")
        + std::string(".\nDid you mean \"MultiArray(") + std::to_string(DIM) + std::string(")\" ?"));
    if (!size)
      throw std::logic_error("Don't pass 0 for dynamic size constructor");
    if constexpr(DIM) {
      return;
    } else {
      m_ptr = new T[size];
      // TODO: change to shared_ptr in the future, m_ptr = std::make_shared<T>(size);
      m_size = size;
    }
  }

  /**
   * @brief Dtor
   * Destructor. Free memory only if boolean attribute m_self_destruct is true.
   */
  ~MultiArray() {if (m_self_destruct) delete[] m_ptr;}

  /**
   * @brief Deep copy operator (copy every value os a into already allocated memory of this)
   *
   * @param a MultiArray to copy
   * @return MultiArray& modified object
   */
  MultiArray& operator=(MultiArray a) {
    if (m_size != a.m_size)
      throw std::logic_error("Can't copy MultiArray with different dimensions (i.e. template parameters)");
    std::uninitialized_copy(a.begin(), a.end(), m_ptr);
    return *this;
  }

  /**
   * @brief copy operator from list of values
   *
   * @param list list of values
   * @return MultiArray& modified object
   */
  MultiArray& operator=(std::initializer_list<T> list) {
    if (m_size != list.size()) {
      throw std::logic_error(
        "Initializer list in MultiArray copy operator has " + std::to_string(list.size()) +
        " elements but should have " + std::to_string(m_size));
    }
    std::uninitialized_copy(list.begin(), list.end(), m_ptr);
    return *this;
  }

  /**
   * @brief Memory buffer accessor
   * Gives raw pointer access to linear buffer data
   *
   * @return address of 1st element of data buffer
   */
  T* data() {return m_ptr;}

  /**
   * @brief Returns an iterator to the beginning
   *
   * @return address of 1st element of data buffer
   */
  T* begin() const {return &(m_ptr[0]);}

  /**
   * @brief Returns an iterator to the end
   *
   * @return past the last element of data buffer
   */
  T* end() const {return &(m_ptr[m_size]);}

  /**
   * @brief Dimension getter

   * @return 1
   */
  size_type dimension() const {return 1;}

  /**
   * @brief Size getter

   * @return number of elements (aka. extent)
   */
  size_type size() const {return m_size;}

  /**
   * @brief initSize method. Meant to be called only for dynamic allocation,
   * which is indicated by a 0 value template parameter.
   *
   * @remark Method parameters must match class template parameters.
   * Obviously, parameters matching non zero value template parameters are meaningless and unused.
   * They are kept to get a clear overview of size for each dimension.
   *
   * @example MultiArray<int, 2, 0> array;
   * @example size_t nb_elmt(foo.get());
   * @example std::cout << array.initSize(2, nb_elmt);  // OK
   * @example std::cout << array[0].initSize(nb_elmt);  // NOT OK !!!
   *
   * @param[in] size_1 Desired size for the 1st dimension. Must reflect template parameter for non dynamic size
   * @param[in] size_n... Desired size for all other dimensions. Must reflect template parameters for non dynamic size
   */
  template<typename SIZE>
  typename std::enable_if_t<std::is_integral_v<std::decay_t<SIZE>>, void> initSize(SIZE size) {
    if (!m_self_destruct)
      throw std::logic_error("initSize cannot be called from \"inner\" dimensions");
    if (DIM && (DIM!=size))
      throw std::logic_error("initSize must be called with template parameters values for static size");
    if (!size)
      throw std::logic_error("Don't pass 0 as initSize parameter");
    if constexpr(DIM) {
      return;
    } else {
      delete[] m_ptr;
      m_ptr = new T[size];
      // TODO: change shared_ptr inthe future, m_ptr = std::make_shared<T>(size);
      m_size = size;
    }
  }

  /**
   * @brief Element accessor method.
   * Gives access to the ith element of the container
   *
   * @param i Index of element to access
   * @return ith element
   */
  T& operator[](const size_type i) const {return m_ptr[i];}

// *****************************************************************************
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
// *****************************************************************************

 // private:  // FIXME: I really want to make it private, but can't manage to do so...
  /**
   * @brief Construct a new Nablab Array object without memory allocation by passing raw data memory pointer.
   *
   * @note This ctor is not meant to be used directly, it's used internally by operator[]
   *
   * @param ptr data pointer to be used (instead of allocating memory like other ctor do)
   * @param dimension array of only 1 element indicating number of elements for this dimension
   */
  MultiArray(T* ptr, std::array<size_type, 1> dimensions)
    : m_size(std::accumulate(dimensions.begin(), dimensions.end(), 1, std::multiplies<size_type>())),
      m_self_destruct(false), m_ptr(ptr) {}

 private:
  size_type m_size;
  bool m_self_destruct;
  T* m_ptr;
};


// *****************************************************************************
// *****************************************************************************

/// Pretty printer helper function for 1 dimension MultiArray
template<typename T, size_t DIM>
std::ostream& operator<<(std::ostream& os, const MultiArray<T, DIM>& array) {
  for (typename MultiArray<T, DIM>::size_type i(0); i < array.size(); ++i)
    std::cout << (i==0?"| ":"") << array[i] << (i==array.size()-1?" |":" ");
  return os;
}

/// Pretty printer helper function for N dimension MultiArray
 template <typename T, size_t DIM_1, size_t... DIM_N, typename std::enable_if_t<(sizeof...(DIM_N)>0)>* = nullptr>
std::ostream& operator<<(std::ostream& os, const MultiArray<T, DIM_1, DIM_N...>& array) {
  for (typename MultiArray<T, DIM_1>::size_type i(0); i < array.size(); ++i)
    std::cout << array[i] << std::endl;
  return os;
}


// *****************************************************************************
// *****************************************************************************

/// Commutative operator+ helper
template <typename T, size_t DIM_1, size_t... DIM_N, typename std::enable_if_t<std::is_arithmetic_v<T>>* = nullptr>
auto operator+(T lhs, MultiArray<T, DIM_1, DIM_N...> rhs) {
  return rhs.operator+(lhs);
}

/// Commutative operator* helper
template <typename T, size_t DIM_1, size_t... DIM_N, typename std::enable_if_t<std::is_arithmetic_v<T>>* = nullptr>
auto operator*(T lhs, MultiArray<T, DIM_1, DIM_N...> rhs) {
  return rhs.operator*(lhs);
}

}

#endif  // NABLALIB_TYPES_MULTIARRAY_H_
