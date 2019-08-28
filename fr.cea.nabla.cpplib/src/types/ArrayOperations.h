/*******************************************************************************
 * Copyright (c) 2018 CEA
 * This program and the accompanying materials are made available under the
 * terms of the Eclipse Public License 2.0 which is available at
 * http://www.eclipse.org/legal/epl-2.0.
 *
 * SPDX-License-Identifier: EPL-2.0
 * Contributors: see AUTHORS file
 *******************************************************************************/
#ifndef TYPES_ARRAYOPERATIONS_H_
#define TYPES_ARRAYOPERATIONS_H_

#include <iostream>

// Kokkos headers
#include "Kokkos_Core.hpp"

namespace nablalib
{
namespace ArrayOperations
{
	// INT
	Kokkos::View<int*> plus(int a, Kokkos::View<int*> b);
	Kokkos::View<int*> multiply(int a, Kokkos::View<int*> b);
	Kokkos::View<double*> multiply(int a, Kokkos::View<double*> b);
	Kokkos::View<double**> multiply(int a, Kokkos::View<double**> b);

	// REAL
	Kokkos::View<double*> plus(double a, Kokkos::View<double*> b);
	Kokkos::View<double*> multiply(double a, Kokkos::View<double*> b);
	Kokkos::View<double**> multiply(double a, Kokkos::View<double**> b);

	// INT ARRAY
	Kokkos::View<int*> plus(Kokkos::View<int*> a, int b);
	Kokkos::View<int*> minus(Kokkos::View<int*> a, int b);
	Kokkos::View<int*> multiply(Kokkos::View<int*> a, int b);
	Kokkos::View<int*> divide(Kokkos::View<int*> a, int b);
	Kokkos::View<double*> plus(Kokkos::View<int*> a, double b);
	Kokkos::View<double*> minus(Kokkos::View<int*> a, double b);
	Kokkos::View<double*> multiply(Kokkos::View<int*> a, double b);
	Kokkos::View<double*> divide(Kokkos::View<int*> a, double b);
	Kokkos::View<int*> plus(Kokkos::View<int*> a, Kokkos::View<int*> b);
	Kokkos::View<int*> minus(Kokkos::View<int*> a, Kokkos::View<int*> b);
	Kokkos::View<int*> multiply(Kokkos::View<int*> a, Kokkos::View<int*> b);
	Kokkos::View<int*> divide(Kokkos::View<int*> a, Kokkos::View<int*> b);

	// REAL ARRAY
	Kokkos::View<double*> plus(Kokkos::View<double*> a, int b);
	Kokkos::View<double*> minus(Kokkos::View<double*> a, int b);
	Kokkos::View<double*> multiply(Kokkos::View<double*> a, int b);
	Kokkos::View<double*> divide(Kokkos::View<double*> a, int b);
	Kokkos::View<double*> plus(Kokkos::View<double*> a, double b);
	Kokkos::View<double*> minus(Kokkos::View<double*> a, double b);
	Kokkos::View<double*> multiply(Kokkos::View<double*> a, double b);
	Kokkos::View<double*> divide(Kokkos::View<double*> a, double b);
	Kokkos::View<double*> plus(Kokkos::View<double*> a, Kokkos::View<double*> b);
	Kokkos::View<double*> minus(Kokkos::View<double*> a, Kokkos::View<double*> b);
	Kokkos::View<double*> multiply(Kokkos::View<double*> a, Kokkos::View<double*> b);
	Kokkos::View<double*> divide(Kokkos::View<double*> a, Kokkos::View<double*> b);

	// REAL MATRIX
	Kokkos::View<double**> multiply(Kokkos::View<double**> a, int b);
	Kokkos::View<double**> multiply(Kokkos::View<double**> a, double b);
	Kokkos::View<double**> multiply(Kokkos::View<double**> a, Kokkos::View<double**> b);
	Kokkos::View<double**> divide(Kokkos::View<double**> a, int b);
	Kokkos::View<double**> divide(Kokkos::View<double**> a, double b);
	Kokkos::View<double**> plus(Kokkos::View<double**> a, Kokkos::View<double**> b);
	Kokkos::View<double**> minus(Kokkos::View<double**> a, Kokkos::View<double**> b);
	Kokkos::View<double**> minus(Kokkos::View<double**> a);
}
}

#endif /* TYPES_ARRAYOPERATIONS_H_ */
