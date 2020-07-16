/*******************************************************************************
 * Copyright (c) 2020 CEA
 * This program and the accompanying materials are made available under the 
 * terms of the Eclipse Public License 2.0 which is available at
 * http://www.eclipse.org/legal/epl-2.0.
 *
 * SPDX-License-Identifier: EPL-2.0
 * Contributors: see AUTHORS file
 *******************************************************************************/

#include "MultiArray.h"
#include <iostream>
#include <typeinfo>

// Type alias
using Id = size_t;

template<size_t N>
using IntArray1D = MultiArray<int, N>;

template<size_t M, size_t N>
using IntArray2D = MultiArray<int, M, N>;

template<size_t N>
using  RealArray1D = MultiArray<double, N>;

template<size_t M, size_t N>
using RealArray2D = MultiArray<double, M, N>;

/******************************************************************************/
void dummy() {
  
  RealArray<7> v{0., 1., 2., 3., 4., 5., 6.};
   
  std::cout << "RealArray<7> v test value:\t" << v << std::endl;
  std::cout << "v dimension is: " << v.dimensions << std::endl;
   
  std::cout << "Adding 10 to every values of v, 'on the fly':\t" << v + 10 << std::endl << std::endl;
   
  std::cout << "Same operation but in place (by modifying v itself):\n";
  v += 10;
  std::cout << v << std::endl << std::endl;
   
  std::cout << "Adding 10 again, then dividing by 2 every values 'on the fly':\n\t" << (v + 10) / 2 << std::endl << std::endl;
   
  std::cout << "Testing array operation, (v + v) == (v * 2) : "
            << std::boolalpha << (v + v == v * 2) << std::endl << std::endl;
  
  std::cout << "4 dimensions test:\n\t";
  RealArray<3, 4, 5, 6> u;
  u[0][0][0][0] = 666.;
  std::cout << "u[0][0][0][0] = " << u[0][0][0][0] << std::endl << "u dimensions are: " << u.dimensions << std::endl;

  std::cout << "5x5 matrix w:\n";
  constexpr size_t DIM1=5;
  constexpr size_t DIM2=2;
  constexpr size_t DIM3=3;
  IntArray<DIM1, DIM2 + DIM3> w{ 2, -1,  0,  0,  0,
                                -1,  2, -1,  0,  0,
                                 0, -1,  2, -1,  0,
                                 0,  0, -1,  2, -1,
                                 0,  0,  0, -1,  2};

  std::cout << w << std::endl;
   
  std::cout << "Testing array operation, (w + w) == (w * 2) : "
            << std::boolalpha << (w + w == w * 2) << std::endl << std::endl;
   
  std::cout << "Multiplying by 2.66 every values of w (rouding to integer):\n";
  RealArray<5, 5> tmp(w * 2.66);
  w *= 2.66;
  std::cout << w << std::endl;
   
  std::cout << "While values should be (if not rounded):\n";
  std::cout << tmp <<  std::endl;

  
  // mix
  std::cout << "--- Testing mix array with static and dynamic dimensions: ---" << std::endl;
  const size_t nb_elmt(3);
  
  MultiArray<int, 5, 0> mix_array;
  mix_array.initSize(5, nb_elmt);
  std::cout << mix_array.dimensions << " matrix mix_array, dynamic dimension will be 3:\n";

  int k(0);
  for (size_t i(0); i < mix_array.size(); ++i) {
    for (size_t j(0); j < mix_array[i].size(); ++j) {
      mix_array[i][j] = k++;
    }
  }
  std::cout << mix_array << std::endl;
  
  MultiArray<double, 0, 6> mix_array2;
  mix_array2.initSize(nb_elmt, 6);
  std::cout << mix_array2.dimensions << " matrix mix_array2, dynamic dimension will be 3:\n";

  for (size_t i(0); i < mix_array2.size(); ++i) {
    for (size_t j(0); j < mix_array2[i].size(); ++j) {
      mix_array2[i][j] = static_cast<double>(k) + (k / 10.0);
      ++k;
    }
  }
  std::cout << mix_array2 << std::endl << std::endl;
  
  std::cout << "3 dimensions mix test matrix [nb_cells][2][nb_nodes], with nb_cells=3 and nb_nodes=4 => 24 elmnts:" << std::endl;
  const size_t nb_cells(3);
  const size_t nb_nodes(4);
  MultiArray<double, 0, 2, 0> mix_array3;
  mix_array3.initSize(nb_cells, 2, nb_nodes);
  for (size_t i(0); i < mix_array3.size(); ++i) {
    for (size_t j(0); j < mix_array3[i].size(); ++j) {
      for (size_t z(0); z < mix_array3[i][j].size(); ++z) {
        mix_array3[i][j][z] = k++;
      }
    }
  }      
  std::cout << mix_array3 << std::endl;
}

/******************************************************************************/
#ifdef TEST

int main() {
  dummy();
}

#endif
