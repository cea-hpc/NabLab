/*******************************************************************************
 * Copyright (c) 2018 CEA
 * This program and the accompanying materials are made available under the 
 * terms of the Eclipse Public License 2.0 which is available at
 * http://www.eclipse.org/legal/epl-2.0.
 *
 * SPDX-License-Identifier: EPL-2.0
 *
 * Contributors:
 * 	Benoit Lelandais - initial implementation
 * 	Marie-Pierre Oudot - initial implementation
 * 	Jean-Sylvain Camier - Nabla generation support
 *******************************************************************************/
#ifndef UTILS_H_
#define UTILS_H_

#include <vector>
#include <exception>

using namespace std;

namespace nablalib
{

class Utils
{
 public:
	static const int indexOf(const vector<int>& array, const int value)
	{
		for (int i=0 ; i<array.size() ; ++i)
			if (array[i] == value)
				return i;
		throw out_of_range("Value not in array");
	}
};

}
#endif /* UTILS_H_ */
