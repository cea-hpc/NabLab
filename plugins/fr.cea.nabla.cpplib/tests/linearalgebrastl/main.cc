/*******************************************************************************
 * Copyright (c) 2022 CEA
 * This program and the accompanying materials are made available under the
 * terms of the Eclipse Public License 2.0 which is available at
 * http://www.eclipse.org/legal/epl-2.0.
 *
 * SPDX-License-Identifier: EPL-2.0
 * Contributors: see AUTHORS file
 *******************************************************************************/

#include <cassert>
#include "LinearAlgebra.h"

int main()
{
	int m_size = 4;
	int n_size = 6;
	Matrix alpha("alpha", m_size, n_size);
	alpha.setValue(0, 0, 10);
	alpha.setValue(0, 1, 20);
	alpha.setValue(1, 1, 30);
	alpha.setValue(1, 3, 40);
	alpha.setValue(2, 2, 50);
	alpha.setValue(2, 3, 60);
	alpha.setValue(2, 4, 70);
	alpha.setValue(3, 5, 80);
	std::cout << alpha.print() << std::endl;

	SparseMatrixType sparseAlpha = alpha.crsMatrix();
	std::cout << alpha.print() << std::endl;

	int size;
	bool mustDeletePtr;
	serialize(alpha, size, mustDeletePtr);
	assert(size == 192); // 4 * 6 * 8
	return 0;
}
