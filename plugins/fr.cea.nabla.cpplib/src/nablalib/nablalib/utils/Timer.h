/*******************************************************************************
 * Copyright (c) 2022 CEA
 * This program and the accompanying materials are made available under the
 * terms of the Eclipse Public License 2.0 which is available at
 * http://www.eclipse.org/legal/epl-2.0.
 *
 * SPDX-License-Identifier: EPL-2.0
 * Contributors: see AUTHORS file
 *******************************************************************************/
#ifndef NABLALIB_UTILS_TIMER_H_
#define NABLALIB_UTILS_TIMER_H_

#include <chrono>
#include <string>

namespace nablalib::utils
{
	/*---------------------------------------------------------------------------*/
	/*!
	 * \brief
	 * Timer class:
	 * Stores a time value (in milliseconds).
	 * This value is recorded from start operation to stop operation.
	 * You can start and stop multiple times the timer to increase its time value.
	 * Reset operation is used to put back time value to 0.
	 * Print operation is a pretty print feature to make value humanly readable.
	 */
	/*---------------------------------------------------------------------------*/
	class Timer
	{
	 private:
	  // Simple enum to store timer state
	  enum eTimerState {
	    kSTOPPED,
	    kSTARTED
	  };

	 public:
	  // Alias on clock type
	  /*
	   * On cherche à avoir une horloge monotonique de maximum précision.
	   * Idéalement c'est que doit fournir le système via la high_resolution_clock.
	   * Si la high_resolution_clock n'est pas monotonique, on choisit la steady_clock.
	   * Et si le système ne fournit aucune horloge monotonique, alors on prend
	   * celle avec la meilleure précision
	   */
	  typedef std::conditional<std::chrono::high_resolution_clock::is_steady, std::chrono::high_resolution_clock,
	                           std::conditional<std::chrono::steady_clock::is_steady, std::chrono::steady_clock,
	                                            std::chrono::high_resolution_clock>::type>::type clock_type;

	  // Alias on duration unit
	  typedef std::chrono::nanoseconds duration_type;

	  Timer(bool start_on_create = false);       // ctor
	  Timer(const Timer &) = delete;             // no copy ctor
	  Timer& operator=(const Timer &) = delete;  // no copy operator
	  ~Timer() = default;                        // default dtor

	  // Accessor
	  const duration_type& time() const;
	  const duration_type& meanTime() const;
	  const duration_type& minTime() const;
	  const duration_type& maxTime() const;

	  // Timer operations, explicitly named
	  void start();                              // starts timer from this call
	  void stop();                               // stops timer from this call
	  void reset();                              // reset internal value to 0

	  // Pretty printers
	  // prints time value (humanly readable) in a string, if short_version = true, display only ms count
	  static const std::string print(const duration_type& time, const bool short_version = false);

	  const std::string print(const bool short_version = false); // prints time value (humanly readable) in a string
	                                                             // if short_version = true, display only ms count
	  const std::string summary();               // prints all different time values stored and computed in a string

	 private:
	  // Inner private members
	  eTimerState            m_state;            // timer state (timer is running or not)
	  clock_type::time_point m_start_time;       // starting time relative to start operation
	  duration_type          m_time;             // current time
	  duration_type          m_mean_time;        // current time
	  duration_type          m_min_time;         // current time
	  duration_type          m_max_time;         // current time
	};  // class Timer

}
#endif /* NABLALIB_UTILS_TIMER_H_ */
