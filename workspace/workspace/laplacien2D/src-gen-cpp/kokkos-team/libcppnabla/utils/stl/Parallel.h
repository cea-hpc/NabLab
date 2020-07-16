/*******************************************************************************
 * Copyright (c) 2020 CEA
 * This program and the accompanying materials are made available under the
 * terms of the Eclipse Public License 2.0 which is available at
 * http://www.eclipse.org/legal/epl-2.0.
 *
 * SPDX-License-Identifier: EPL-2.0
 * Contributors: see AUTHORS file
 *******************************************************************************/
#ifndef UTILS_STL_PARALLEL_H_
#define UTILS_STL_PARALLEL_H_

#include <functional>
#include <thread>
#include <future>
#include <algorithm>
#include <numeric>

namespace nablalib
{
  
namespace parallel
{
  
// ------------------------------ Would love to be private  ------------------------------ 
namespace internal
{
// Internal call for parallel process, not meant to be use outside the parallel_exec
template <typename F>
void parallel_exec_internal(const size_t nb_thread, const size_t nb_elmt,
                            const size_t begin, const size_t end, F lambda) noexcept
{
  const size_t chunck_size(std::floor(nb_elmt / nb_thread));  // chuncks are simples, we should do better...
  const size_t len(end - begin);
  // if every chuncks have been computed
  if (len <= chunck_size || chunck_size == 0) {  // 0 size chunck may happen with 1 elmt
    for (size_t i(begin); i < end; ++i)
      lambda(i);
    return;
  }

  // std::cout << "BEG = " << begin << ", END = " << end << std::endl;

  // else spawn a new thread asynchronously
  const size_t next(begin + chunck_size < end ? begin + chunck_size : end);
  auto future = std::async(std::launch::async, parallel_exec_internal<F>, nb_thread, nb_elmt, next, end, lambda);
  parallel_exec_internal(nb_thread, nb_elmt, begin, next, lambda);
  future.get();
  return;
}

// Internal call for parallel reduce, not meant to be use outside the parallel_reduce
template <typename T, typename BinOp, typename JoinOp>
T parallel_reduce_internal(const size_t nb_thread, const size_t nb_elmt,
                           std::vector<size_t>::iterator begin, std::vector<size_t>::iterator end,
                           const T init_val, BinOp bin_op, JoinOp join_op) noexcept
{
  const size_t chunck_size(std::floor(nb_elmt / nb_thread));  // chuncks are simples, we should do better...
  const size_t len(std::distance(begin, end));
  // if every chuncks have been computed
  if (len <= chunck_size)
    return std::accumulate(begin, end, init_val, bin_op);

  // std::cout << "BEG = " << begin << ", END = " << end << std::endl;

  // else spawn a new thread asynchronously
  auto next(begin + chunck_size < end ? begin + chunck_size : end);
  auto future = std::async(std::launch::async, parallel_reduce_internal<T, BinOp, JoinOp>,
                           nb_thread, nb_elmt, next, end, init_val, bin_op, join_op);
  auto result = parallel_reduce_internal(nb_thread, nb_elmt, begin, next, init_val, bin_op, join_op);
  return join_op(result, future.get());
}
}  // ------------------------------ end of namespace internal  ------------------------------ 

// Some kind of bad static openMP parallel for
// Given a range number of elements, the lambda function parameter is called upon each element.
// Data is processed by chuncks and each chunck has is own dedicated thread.
template <typename F>
void parallel_exec(const size_t nb_elmt, F&& lambda) noexcept
{
  // Getting number of concurrent threads supported.
  size_t nb_thread(2);  // Hyper thread support by default
  if (std::thread::hardware_concurrency() > 0)
    nb_thread = std::thread::hardware_concurrency();
  else
    std::cerr << "WARNING: can't figure out optimal threads number, using 2 by default." << std::endl;
    
  // Actually calling multithreaded lambda function over nb_elmt
  internal::parallel_exec_internal(nb_thread, nb_elmt, 0, nb_elmt, lambda);
}

// Some kind of bad static openMP parallel reduce
// Given a number of elements, binary operation is called upon each couple of elements of variable V.
// Data is processed by chuncks and each chunck has is own dedicated thread.
template <typename T, typename BinOp, typename JoinOp>
T parallel_reduce(const size_t nb_elmt, const T init_val, BinOp&& bin_op, JoinOp&& join_op) noexcept
{
  // Getting number of concurrent threads supported.
  size_t nb_thread(2);  // Hyper thread support by default
  if (std::thread::hardware_concurrency() > 0)
    nb_thread = std::thread::hardware_concurrency();
  else
    std::cerr << "WARNING: can't figure out optimal threads number, using 2 by default." << std::endl;
    
  // Actually calling multithreaded lambda function over nb_elmt
  // We need an indexes vector to handle dereference operator in bin_op for accumulate call
  std::vector<size_t> indexes(nb_elmt);
  std::iota(indexes.begin(), indexes.end(), 0);
  return internal::parallel_reduce_internal(nb_thread, nb_elmt, indexes.begin(), indexes.end(),
                                            init_val, bin_op, join_op);
}

}  // end of namespace parallel

}  // end of namespace nablalib

#endif  // UTILS_STL_PARALLEL_H_
