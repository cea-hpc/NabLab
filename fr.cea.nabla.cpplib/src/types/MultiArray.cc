/*******************************************************************************
 * Copyright (c) 2018 CEA
 * This program and the accompanying materials are made available under the 
 * terms of the Eclipse Public License 2.0 which is available at
 * http://www.eclipse.org/legal/epl-2.0.
 *
 * SPDX-License-Identifier: EPL-2.0
 * Contributors: see AUTHORS file
 *******************************************************************************/
#ifdef UNIT_TEST 


#include "MultiArray.h"
#include <iostream>
#include <cassert>


int main()
{
   RealArray<7> v{0., 1., 2., 3., 4., 5., 6.};
   
   std::cout << "RealArray<7> v test value:\n\t" << v << std::endl;
   
   std::cout << "Adding 10 to every values of v:\n\t" << v + 10 << std::endl;
   
   std::cout << "Same operation but modifying v according to these values:\n\t";
   v += 10;
   std::cout << v << std::endl;
   
   std::cout << "Adding 10 again, then dividing by 2 every values 'on the fly':\n\t" << (v + 10) / 2 << std::endl;
   
   std::cout << "Testing array operation, (v + v) == (v * 2) : "
             << std::boolalpha << (v + v == v * 2) << std::endl << std::endl;
   
   std::cout << "4 dimensions test:\n\t";
   RealArray<3, 4, 5, 6> u;
   u[0][0][0][0] = 666.;
   std::cout << "u[0][0][0][0] = " << u[0][0][0][0] << std::endl << std::endl;

   std::cout << "5x5 matrix w:\n";
   IntArray<5, 5> w{ 2, -1,  0,  0,  0,
                    -1,  2, -1,  0,  0,
                     0, -1,  2, -1,  0,
                     0,  0, -1,  2, -1,
                     0,  0,  0, -1,  2};
   for (IntArray<5, 5>::size_type i(0); i < 5; ++i)
     std::cout << w[i];
   std::cout << std::endl;
   
   std::cout << "Testing array operation, (w + w) == (w * 2) : "
             << std::boolalpha << (w + w == w * 2) << std::endl << std::endl;
   
   std::cout << "Multiplying by 2.66 every values of w (rouding to integer):\n";
   RealArray<5, 5> tmp(w * 2.66);
   w *= 2.66;
   for (RealArray<5, 5>::size_type i(0); i < 5; ++i)
     std::cout << w[i];
   std::cout << std::endl;
   
   std::cout << "While values should be (if not rounded):\n";
   for (RealArray<5, 5>::size_type i(0); i < 5; ++i)
     std::cout << tmp[i];
   std::cout << std::endl;
}

#endif
