/*******************************************************************************
 * Copyright (c) 2020 CEA
 * This program and the accompanying materials are made available under the
 * terms of the Eclipse Public License 2.0 which is available at
 * http://www.eclipse.org/legal/epl-2.0.
 *
 * SPDX-License-Identifier: EPL-2.0
 * Contributors: see AUTHORS file
 *******************************************************************************/
#ifndef NABLALIB_UTILS_UTILS_H_
#define NABLALIB_UTILS_UTILS_H_

#include <array>
#include <vector>
#include <exception>
#include <string>
#include "nablalib/utils/Timer.h"

#ifndef WIN32
/* colors */
#define __BLACK__         "\033[30m"
#define __RED__           "\033[31m"
#define __GREEN__         "\033[32m"
#define __YELLOW__        "\033[33m"
#define __BLUE__          "\033[34m"
#define __MAGENTA__       "\033[35m"
#define __CYAN__          "\033[36m"
#define __WHITE__         "\033[37m"
// BacKGround colors
#define __BLACK_BKG__     "\033[40m"
#define __RED_BKG__       "\033[41m"
#define __GREEN_BKG__     "\033[42m"
#define __YELLOW_BKG__    "\033[43m"
#define __BLUE_BKG__      "\033[44m"
#define __MAGENTA_BKG__   "\033[45m"
#define __CYAN_BKG__      "\033[46m"
#define __WHITE_BKG__     "\033[47m"
// Styles
#define __RESET__         "\033[0m"
#define __BOLD__          "\033[1m"
#define __UNDERLINE__     "\033[4m"
#define __INVERSE__       "\033[7m"
#define __BOLD_OFF__      "\033[21m"
#define __UNDERLINE_OFF__ "\033[24m"
#define __INVERSE_OFF__   "\033[27m"
#endif

namespace nablalib::utils
{
	// Array version
	template <typename T, size_t N>
	size_t indexOf(const std::array<T, N>& array, const T& value)
	{
	  for (size_t i(0) ; i < array.size(); ++i)
	    if (array[i] == value)
	      return i;
	  throw std::out_of_range("Value not in array");
	}
	
	// Vector overload
	// TODO: can do better with a container type trait like with operator[] and size method
	template <typename T>
	size_t indexOf(const std::vector<T>& vector, const T& value)
	{
	  for (size_t i(0) ; i < vector.size(); ++i)
	    if (vector[i] == value)
	      return i;
	  throw std::out_of_range("Value not in vector");
	}
	

  // Estimated simulation time
  const utils::Timer::duration_type eta(const int& it, const int& max_it, const double& t, const double& max_t,
                                        const double& delta_t, const utils::Timer& timer) noexcept;
  // Simulation progress
  const std::string progress_bar(const int& it, const int& max_it, const double& t, const double& max_t,
                                 const size_t& width = 25) noexcept;
}
#endif /* NABLALIB_UTILS_UTILS_H_ */
