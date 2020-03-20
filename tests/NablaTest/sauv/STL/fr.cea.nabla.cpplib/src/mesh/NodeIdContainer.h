/*******************************************************************************
 * Copyright (c) 2018 CEA
 * This program and the accompanying materials are made available under the
 * terms of the Eclipse Public License 2.0 which is available at
 * http://www.eclipse.org/legal/epl-2.0.
 *
 * SPDX-License-Identifier: EPL-2.0
 * Contributors: see AUTHORS file
 *******************************************************************************/
#ifndef MESH_NODEIDCONTAINER_H_
#define MESH_NODEIDCONTAINER_H_

#include <iostream>
#include <array>
#include <type_traits>
#include <utility>

using namespace std;

namespace nablalib
{

// Template class for node IDs collection. Restricted usage of integral types.
template <typename T, size_t N, typename enable_if<is_integral<T>::value>::type* = nullptr>
class NodeIdContainer
{
 public:
  template <typename... Args, typename enable_if<(is_integral<Args>::value && ...)>::type* = nullptr>
  explicit NodeIdContainer(Args... args) : m_nodeIds{args...} {}

  explicit NodeIdContainer(const NodeIdContainer<T, N>& nc) : m_nodeIds(nc.m_nodeIds) {}

  ~NodeIdContainer() = default;

  const array<T, N>& getNodeIds() const noexcept { return m_nodeIds; }

  ostream& operator<<(ostream& s)
  {
    if (m_nodeIds.size() > 0) {
      s << "[" << m_nodeIds[0];
      for (size_t i(1); i < m_nodeIds.size(); ++i)
        s << ", " << m_nodeIds[i];
      s << "]";
    }
    return s;
  }

 private:
  array<T, N> m_nodeIds;
};

// Type alias
using Edge = NodeIdContainer<int, 2>;
using Quad = NodeIdContainer<int, 4>;

}
#endif /* MESH_NODEIDCONTAINER_H_ */
