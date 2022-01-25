/*******************************************************************************
 * Copyright (c) 2022 CEA
 * This program and the accompanying materials are made available under the
 * terms of the Eclipse Public License 2.0 which is available at
 * http://www.eclipse.org/legal/epl-2.0.
 *
 * SPDX-License-Identifier: EPL-2.0
 * Contributors: see AUTHORS file
 *******************************************************************************/
#ifndef NABLALIB_UTILS_KOKKOS_SERIALIZER_H_
#define NABLALIB_UTILS_KOKKOS_SERIALIZER_H_

#include "nablalib/utils/Serializer.h"

/*
 * Collection of free functions to serialize variables build over Kokkos backend into strings.
 * Values are space separated.
 */
namespace nablalib::utils::kokkos {

//std::string serialize(const VectorType& v) {
  //std::stringstream ss;
  //for (size_t i(0); i < v.extent(0); ++i)
    //ss << std::setprecision(DBL_PRECISION) << v(i) << " ";
  //return std::string(ss.str());
//}

template <typename T>
std::string serialize(const Kokkos::View<T*>& v) {
  std::stringstream ss;
  for (size_t i(0); i < v.extent(0); ++i)
    ss << nablalib::utils::serialize(v(i)) << " ";
  return std::string(ss.str());
}

template <typename T>
std::string serialize(const Kokkos::View<T**>& v) {
  std::stringstream ss;
  for (size_t i(0); i < v.extent(0); ++i) {
    for (size_t j(0); j < v.extent(1); ++j) {
      ss << nablalib::utils::serialize(v(i, j)) << " ";
    }
  }
  return std::string(ss.str());
}

template <typename T>
std::string serialize(const Kokkos::View<T***>& v) {
  std::stringstream ss;
  for (size_t i(0); i < v.extent(0); ++i) {
    for (size_t j(0); j < v.extent(1); ++j) {
      for (size_t k(0); k < v.extent(2); ++k) {
        ss << serialize(v(i, j, k)) << " ";
      }
    }
  }
  return std::string(ss.str());
}

// TODO(FL): voir si on peut pas faire qqch de ce style ...
//template <typename T,  typename std::enable_if_t<std::is_pointer_v<T>>* = nullptr>
//std::string serialize(const Kokkos::View<T>& v, size_t dim1, size_t... dimN>) {
  //std::stringstream ss;
  //for (size_t i(0); i < v.extent(0); ++i)
    //ss << serialize(v(i)) << " ";
  //return std::string(ss.str());
//}

}

#endif // NABLALIB_UTILS_KOKKOS_SERIALIZER_H_
