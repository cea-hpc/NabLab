#include "../utils/Timer.h"

#include <iostream>
#include <iomanip>
#include <sstream>
#include <cmath>

/*---------------------------------------------------------------------------*/
/*---------------------------------------------------------------------------*/

namespace nablalib
{

namespace utils
{
/*---------------------------------------------------------------------------*/
/*!
 * \brief
 * Ctor.
 * Every inner members are default constructed.
 * Timer is stopped at its creation.
 */
/*---------------------------------------------------------------------------*/
Timer::
Timer(bool start_on_create)
    : m_state(eTimerState::kSTOPPED), m_start_time(clock_type::time_point()),
      m_time(duration_type::zero()), m_mean_time(duration_type::zero()),
      m_min_time(duration_type::zero()), m_max_time(duration_type::zero())
{
  if (start_on_create)
    this->start();
}

/*---------------------------------------------------------------------------*/
/*!
 * \brief
 * Accessor of time value.
 *
 * @return : time between timer start/stop operations.
 */
/*---------------------------------------------------------------------------*/
const Timer::duration_type& Timer::
time() const
{
  return m_time;
}

/*---------------------------------------------------------------------------*/
/*!
 * \brief
 * Accessor of mean time value.
 *
 * @return : mean time between all start/stop operations.
 */
/*---------------------------------------------------------------------------*/
const Timer::duration_type& Timer::
meanTime() const {
  return m_mean_time;
}

/*---------------------------------------------------------------------------*/
/*!
 * \brief
 * Accessor of minimum time value.
 *
 * @return : minimum time recorded between start/stop operations.
 */
/*---------------------------------------------------------------------------*/
const Timer::duration_type& Timer::
minTime() const {
  return m_min_time;
}

/*---------------------------------------------------------------------------*/
/*!
 * \brief
 * Accessor of maximum time value.
 *
 * @return : maximum time recorded between start/stop operations.
 */
/*---------------------------------------------------------------------------*/
const Timer::duration_type& Timer::
maxTime() const {
  return m_max_time;
}

/*---------------------------------------------------------------------------*/
/*!
 * \brief
 * Starts timer, recording time point and updating internal clock state.
 */
/*---------------------------------------------------------------------------*/
void Timer::
start()
{
  if (m_state == eTimerState::kSTOPPED) {
    // Recording starting time
    m_start_time = clock_type::now();
    // Updating state
    m_state = eTimerState::kSTARTED;
  } else {
    // If a timer is already running, we ignore the new start command and print a warning
    std::cerr << "### WARNING: trying to start an already started timer, ignoring timer.start()..." << std::endl;
  }
}

/*---------------------------------------------------------------------------*/
/*!
 * \brief
 * Stops timer, computing duration between start and stop commands, mean,
 * min, max time values and updating internal clock state.
 */
/*---------------------------------------------------------------------------*/
void Timer::
stop()
{
  if (m_state == eTimerState::kSTARTED) {
    // Current time value time between the last start and this stop
    duration_type current_time(std::chrono::duration_cast<duration_type>(clock_type::now() - m_start_time));
    // Global time
    m_time += current_time;
    // Mean
    m_mean_time = std::chrono::duration_cast<duration_type>((m_mean_time + current_time) * 0.5);
    // Min
    if (m_min_time == duration_type::zero() || current_time < m_min_time)
      m_min_time = current_time;
    // Max
    if (m_max_time == duration_type::zero() || current_time > m_max_time)
      m_max_time = current_time;
    // Updating state
    m_state = eTimerState::kSTOPPED;
  } else {
    // If a timer is already stopped, we ignore the new stop command and print a warning
    std::cerr << "### WARNING: trying to stop an already stopped timer, ignoring timer.stop()..." << std::endl;
  }
}

/*---------------------------------------------------------------------------*/
/*!
 * \brief
 * Reseting starting time point and time value (without updating timer state).
 */
/*---------------------------------------------------------------------------*/
void Timer::
reset()
{
  m_start_time = clock_type::time_point();
  m_time = duration_type::zero();
  m_mean_time = duration_type::zero();
  m_min_time = duration_type::zero();
  m_max_time = duration_type::zero();
}

/*---------------------------------------------------------------------------*/
/*!
 * \brief
 * Pretty printer for human.
 * @param time : time to print
 * @param short_version : flag for detailled information
 * @return : string filled with time information
 */
/*---------------------------------------------------------------------------*/
const std::string Timer::
print(const duration_type& time, const bool short_version) {
  // A floating point milliseconds type
  using FpMilliseconds = std::chrono::duration<float, std::chrono::milliseconds::period>;

  std::chrono::hours   h(0);
  std::chrono::minutes m(0);
  std::chrono::seconds s(0);
  FpMilliseconds       ms(0.0);
  std::stringstream    output;

  if (!short_version) {
    // Compute hours
    h = std::chrono::duration_cast<std::chrono::hours>(time);

    // Display hours and compute minutes
    if (h > std::chrono::hours::zero()) {
      output << std::setw(2) << std::to_string(h.count()) << "h";
      m = std::chrono::duration_cast<std::chrono::minutes>(time % h);
    } else {
      output << std::setw(3) << "   ";
      m = std::chrono::duration_cast<std::chrono::minutes>(time);
    }
    m += h;

    // Display minutes and compute seconds
    if (m > std::chrono::minutes::zero()) {
      output << std::setw(2) << std::to_string((m - h).count()) << "m";
      s = std::chrono::duration_cast<std::chrono::seconds>(time % m);
    } else {
      output << std::setw(3) << "   ";
      s = std::chrono::duration_cast<std::chrono::seconds>(time);
    }
    s += m;
  } else {
    // Compute seconds
    s = std::chrono::duration_cast<std::chrono::seconds>(time);
  }

  // Display seconds and compute milliseconds
  if (s > std::chrono::seconds::zero()) {
    output << (short_version?std::setw(5):std::setw(2)) << std::to_string((s - m).count()) << "s";
    ms = std::chrono::duration_cast<FpMilliseconds>(time % s);
  } else {
    output << (short_version?std::setw(6):std::setw(3)) << "   ";
    ms = std::chrono::duration_cast<FpMilliseconds>(time);
  }
  ms += s;

  // Display milliseconds
  if (ms > std::chrono::milliseconds::zero())
    output << std::setw(3) << std::to_string(static_cast<int>(std::ceil((ms - s).count()))) << "ms";

  return output.str();
}

/*---------------------------------------------------------------------------*/
/*!
 * \brief
 * Pretty printer for human.
 * @return : string filled with time information
 */
/*---------------------------------------------------------------------------*/
const std::string Timer::
print(const bool short_version) {
  return print(m_time, short_version);
}

/*---------------------------------------------------------------------------*/
/*!
 * \brief
 * Pretty printer for human.
 * @return : string filled with all timers information
 */
/*---------------------------------------------------------------------------*/
const std::string Timer::
summary() {
  std::stringstream output;

  output << std::setw(18) << print() << " ~ "
         << std::setw(18) << print(m_mean_time, true) << " ["
         << std::setw(18) << print(m_min_time, true)  << ", "
         << std::setw(18) << print(m_max_time, true)  << "]";

  return output.str();
}

/*---------------------------------------------------------------------------*/
/*---------------------------------------------------------------------------*/

}  // namespace utils

}  // namespace nablalib
