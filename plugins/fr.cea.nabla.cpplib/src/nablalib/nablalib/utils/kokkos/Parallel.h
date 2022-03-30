/*******************************************************************************
 * Copyright (c) 2022 CEA
 * This program and the accompanying materials are made available under the
 * terms of the Eclipse Public License 2.0 which is available at
 * http://www.eclipse.org/legal/epl-2.0.
 *
 * SPDX-License-Identifier: EPL-2.0
 * Contributors: see AUTHORS file
 *******************************************************************************/
#ifndef NABLALIB_UTILS_KOKKOS_PARALLEL_H_
#define NABLALIB_UTILS_KOKKOS_PARALLEL_H_

#include <functional>
// Kokkos headers
#include "Kokkos_Core.hpp"

namespace nablalib::utils::kokkos {

template<class T>
struct KokkosJoiner {
public:
  //Required
  typedef KokkosJoiner reducer;
  typedef T value_type;
  typedef Kokkos::View<value_type> result_view_type;

private:
  value_type & value;
  value_type init_value;
  std::function<value_type(value_type,value_type)> user_join;

public:

  KOKKOS_INLINE_FUNCTION
  KokkosJoiner(value_type& value_, const value_type init_value_, std::function<value_type(value_type,value_type)>&& user_join_)
  : value(value_)
  , init_value(init_value_)
  , user_join(user_join_)
  {}

  //Required
  KOKKOS_INLINE_FUNCTION
  void join(value_type& dest, const value_type& src)  const {
    dest = user_join(dest, src);
  }

  KOKKOS_INLINE_FUNCTION
  void join(volatile value_type& dest, const volatile value_type& src) const {
	  const_cast<value_type&>(dest) = user_join(const_cast<value_type&>(dest), const_cast<value_type&>(src));
  }

  KOKKOS_INLINE_FUNCTION
  void init( value_type& val)  const {
    val = init_value;
  }

  KOKKOS_INLINE_FUNCTION
  value_type& reference() const {
    return value;
  }

  KOKKOS_INLINE_FUNCTION
  result_view_type view() const {
    return result_view_type(&value);
  }

  KOKKOS_INLINE_FUNCTION
  bool references_scalar() const {
    return true;
  }
};

}

#endif  // NABLALIB_UTILS_KOKKOS_PARALLEL_H_
