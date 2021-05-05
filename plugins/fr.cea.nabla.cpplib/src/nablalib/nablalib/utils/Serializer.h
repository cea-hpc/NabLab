/*******************************************************************************
 * Copyright (c) 2021 CEA
 * This program and the accompanying materials are made available under the
 * terms of the Eclipse Public License 2.0 which is available at
 * http://www.eclipse.org/legal/epl-2.0.
 *
 * SPDX-License-Identifier: EPL-2.0
 * Contributors: see AUTHORS file
 *******************************************************************************/
#ifndef NABLALIB_UTILS_SERIALIZER_H_
#define NABLALIB_UTILS_SERIALIZER_H_

#include <string>
#include <sstream>
#include <iomanip>
#include "nablalib/types/Types.h"

#define DBL_PRECISION 6

namespace nablalib::utils {
  /*
   * Collection of free functions to serialize variables into strings.
   * Values are space separated.
   */
  
  // For integers and floating point numbers.
  template <typename T, typename std::enable_if_t<std::is_arithmetic_v<T>>* = nullptr>
  std::string serialize(const T& v) {
    std::stringstream ss;
    ss << std::setprecision(DBL_PRECISION) << v;
    return std::string(ss.str());
    // Using to_string method instead puts additional useless zeros (fixed full precision)
    // return std::to_string(v);
  }
  
  // For containers which has iterators with operator*(), begin() (and implicitly/hopefully end())
  template <typename T, typename std::enable_if_t<std::is_same_v<typename T::value_type, typename std::decay_t<decltype(*begin(std::declval<T>()))>>>* = nullptr>
  std::string serialize(const T& v) {
    std::string str;
    for (auto i : v)
      str += serialize(i) + " ";
    return str;
  }

}

#endif // NABLALIB_UTILS_SERIALIZER_H_
