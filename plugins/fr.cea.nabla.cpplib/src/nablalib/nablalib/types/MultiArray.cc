/*******************************************************************************
 * Copyright (c) 2020 CEA
 * This program and the accompanying materials are made available under the 
 * terms of the Eclipse Public License 2.0 which is available at
 * http://www.eclipse.org/legal/epl-2.0.
 *
 * SPDX-License-Identifier: EPL-2.0
 * Contributors: see AUTHORS file
 *******************************************************************************/

#include "nablalib/types/MultiArray.h"

namespace nablalib::types
{
// ****************************************************************************
void dummy() {
  MultiArray<double, 2, 3> a{0, 1, 3,
                             4, 5, 6};

  std::cout << "MultiArray test :" << std::endl;
  std::cout << "a : rank = " << a.dimension() << ", extent = " << a.size() << std::endl;
  std::cout << "a[0] : rank = " << a[0].dimension() << ", extent = " << a[0].size() << std::endl;
  std::cout << a << std::endl;

  size_t nbCells(3);
  size_t nbNodesOfCell(4);
  size_t five(5);
  
  MultiArray<int, 0> b(five);
  std::cout << "b : rank = " << b.dimension() << ", extent = " << b.size() << std::endl;
  std::cout << b << std::endl << std::endl;

  MultiArray<float, 0, 0, 2, 2> Ajr(nbCells, five, 2, 2);
  Ajr.initSize(nbCells, nbNodesOfCell, 2, 2);
  std::cout << "Ajr : rank = " << Ajr.dimension() << ", extent = " << Ajr.size() << std::endl;
  std::cout << Ajr << std::endl;

  MultiArray<int, 0, 1, 1> fail(five, 2, 2);
}
// *****************************************************************************
#ifdef TEST

int main() {
  dummy();
}

#endif

}
