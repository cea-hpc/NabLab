/*******************************************************************************
 * Copyright (c) 2018 CEA
 * This program and the accompanying materials are made available under the
 * terms of the Eclipse Public License 2.0 which is available at
 * http://www.eclipse.org/legal/epl-2.0.
 *
 * SPDX-License-Identifier: EPL-2.0
 * Contributors: see AUTHORS file
 *******************************************************************************/
#include "types/ArrayOperations.h"

namespace nablalib
{
// INT
Kokkos::View<int*>
ArrayOperations::plus(int a, Kokkos::View<int*> b)
{
	return plus(b, a);
}

Kokkos::View<int*>
ArrayOperations::multiply(int a, Kokkos::View<int*> b)
{
	return multiply(b, a);
}

Kokkos::View<double*>
ArrayOperations::multiply(int a, Kokkos::View<double*> b)
{
	return multiply(b, a);
}

Kokkos::View<double**>
ArrayOperations::multiply(int a, Kokkos::View<double**> b)
{
	return multiply(b, a);
}

// REAL
Kokkos::View<double*>
ArrayOperations::plus(double a, Kokkos::View<double*> b)
{
	return plus(b, a);
}

Kokkos::View<double*>
ArrayOperations::multiply(double a, Kokkos::View<double*> b)
{
	return multiply(b, a);
}

Kokkos::View<double**>
ArrayOperations::multiply(double a, Kokkos::View<double**> b)
{
	return multiply(b, a);
}

// INT ARRAY
Kokkos::View<int*>
ArrayOperations::plus(Kokkos::View<int*> a, int b)
{
	const size_t n0 = a.dimension_0();
	Kokkos::View<int*> result("result", n0);
	for (size_t i=0 ; i<n0 ; ++i)
		result(i) = a(i) + b;
	return result;
}

Kokkos::View<int*>
ArrayOperations::minus(Kokkos::View<int*> a, int b)
{
	const size_t n0 = a.dimension_0();
	Kokkos::View<int*> result("result", n0);
	for (size_t i=0 ; i<n0 ; ++i)
		result(i) = a(i) - b;
	return result;
}

Kokkos::View<int*>
ArrayOperations::multiply(Kokkos::View<int*> a, int b)
{
	const size_t n0 = a.dimension_0();
	Kokkos::View<int*> result("result", n0);
	for (size_t i=0 ; i<n0 ; ++i)
		result(i) = a(i) * b;
	return result;
}

Kokkos::View<int*>
ArrayOperations::divide(Kokkos::View<int*> a, int b)
{
	const size_t n0 = a.dimension_0();
	Kokkos::View<int*> result("result", n0);
	for (size_t i=0 ; i<n0 ; ++i)
		result(i) = a(i) / b;
	return result;
}

Kokkos::View<double*>
ArrayOperations::plus(Kokkos::View<int*> a, double b)
{
	const size_t n0 = a.dimension_0();
	Kokkos::View<double*> result("result", n0);
	for (size_t i=0 ; i<n0 ; ++i)
		result(i) = a(i) + b;
	return result;
}

Kokkos::View<double*>
ArrayOperations::minus(Kokkos::View<int*> a, double b)
{
	const size_t n0 = a.dimension_0();
	Kokkos::View<double*> result("result", n0);
	for (size_t i=0 ; i<n0 ; ++i)
		result(i) = a(i) - b;
	return result;
}

Kokkos::View<double*>
ArrayOperations::multiply(Kokkos::View<int*> a, double b)
{
	const size_t n0 = a.dimension_0();
	Kokkos::View<double*> result("result", n0);
	for (size_t i=0 ; i<n0 ; ++i)
		result(i) = a(i) * b;
	return result;
}

Kokkos::View<double*>
ArrayOperations::divide(Kokkos::View<int*> a, double b)
{
	const size_t n0 = a.dimension_0();
	Kokkos::View<double*> result("result", n0);
	for (size_t i=0 ; i<n0 ; ++i)
		result(i) = a(i) / b;
	return result;
}

Kokkos::View<int*>
ArrayOperations::plus(Kokkos::View<int*> a, Kokkos::View<int*> b)
{
	const size_t n0 = a.dimension_0();
	Kokkos::View<int*> result("result", n0);
	for (size_t i=0 ; i<n0 ; ++i)
		result(i) = a(i) + b(i);
	return result;
}

Kokkos::View<int*>
ArrayOperations::minus(Kokkos::View<int*> a, Kokkos::View<int*> b)
{
	const size_t n0 = a.dimension_0();
	Kokkos::View<int*> result("result", n0);
	for (size_t i=0 ; i<n0 ; ++i)
		result(i) = a(i) - b(i);
	return result;
}

Kokkos::View<int*>
ArrayOperations::multiply(Kokkos::View<int*> a, Kokkos::View<int*> b)
{
	const size_t n0 = a.dimension_0();
	Kokkos::View<int*> result("result", n0);
	for (size_t i=0 ; i<n0 ; ++i)
		result(i) = a(i) * b(i);
	return result;
}

Kokkos::View<int*>
ArrayOperations::divide(Kokkos::View<int*> a, Kokkos::View<int*> b)
{
	const size_t n0 = a.dimension_0();
	Kokkos::View<int*> result("result", n0);
	for (size_t i=0 ; i<n0 ; ++i)
		result(i) = a(i) / b(i);
	return result;
}

// REAL ARRAY
Kokkos::View<double*>
ArrayOperations::plus(Kokkos::View<double*> a, int b)
{
	return plus(a, (double)b);
}

Kokkos::View<double*>
ArrayOperations::minus(Kokkos::View<double*> a, int b)
{
	return minus(a, (double)b);
}

Kokkos::View<double*>
ArrayOperations::multiply(Kokkos::View<double*> a, int b)
{
	return multiply(a, (double)b);
}

Kokkos::View<double*>
ArrayOperations::divide(Kokkos::View<double*> a, int b)
{
	return divide(a, (double)b);
}

Kokkos::View<double*>
ArrayOperations::plus(Kokkos::View<double*> a, double b)
{
	const size_t n0 = a.dimension_0();
	Kokkos::View<double*> result("result", n0);
	for (size_t i=0 ; i<n0 ; ++i)
		result(i) = a(i) + b;
	return result;
}

Kokkos::View<double*>
ArrayOperations::minus(Kokkos::View<double*> a, double b)
{
	const size_t n0 = a.dimension_0();
	Kokkos::View<double*> result("result", n0);
	for (size_t i=0 ; i<n0 ; ++i)
		result(i) = a(i) - b;
	return result;
}

Kokkos::View<double*>
ArrayOperations::multiply(Kokkos::View<double*> a, double b)
{
	const size_t n0 = a.dimension_0();
	Kokkos::View<double*> result("result", n0);
	for (size_t i=0 ; i<n0 ; ++i)
		result(i) = a(i) * b;
	return result;
}

Kokkos::View<double*>
ArrayOperations::divide(Kokkos::View<double*> a, double b)
{
	const size_t n0 = a.dimension_0();
	Kokkos::View<double*> result("result", n0);
	for (size_t i=0 ; i<n0 ; ++i)
		result(i) = a(i) / b;
	return result;
}

Kokkos::View<double*>
ArrayOperations::plus(Kokkos::View<double*> a, Kokkos::View<double*> b)
{
	const size_t n0 = a.dimension_0();
	Kokkos::View<double*> result("result", n0);
	for (size_t i=0 ; i<n0 ; ++i)
		result(i) = a(i) + b(i);
	return result;
}

Kokkos::View<double*>
ArrayOperations::minus(Kokkos::View<double*> a, Kokkos::View<double*> b)
{
	const size_t n0 = a.dimension_0();
	Kokkos::View<double*> result("result", n0);
	for (size_t i=0 ; i<n0 ; ++i)
		result(i) = a(i) - b(i);
	return result;
}

Kokkos::View<double*>
ArrayOperations::multiply(Kokkos::View<double*> a, Kokkos::View<double*> b)
{
	const size_t n0 = a.dimension_0();
	Kokkos::View<double*> result("result", n0);
	for (size_t i=0 ; i<n0 ; ++i)
		result(i) = a(i) * b(i);
	return result;
}

Kokkos::View<double*>
ArrayOperations::divide(Kokkos::View<double*> a, Kokkos::View<double*> b)
{
	const size_t n0 = a.dimension_0();
	Kokkos::View<double*> result("result", n0);
	for (size_t i=0 ; i<n0 ; ++i)
		result(i) = a(i) / b(i);
	return result;
}

// REAL MATRIX
Kokkos::View<double**>
ArrayOperations::multiply(Kokkos::View<double**> a, int b)
{
	return multiply(a, (double)b);
}

Kokkos::View<double**>
ArrayOperations::multiply(Kokkos::View<double**> a, double b)
{
	const size_t n0 = a.dimension_0();
	const size_t n1 = a.dimension_1();
	Kokkos::View<double**> result("result", n0, n1);
	for (size_t i=0 ; i<n0 ; ++i)
		for (size_t j=0 ; j<n1 ; ++j)
			result(i,j) = a(i,j) * b;
	return result;
}

Kokkos::View<double**>
ArrayOperations::multiply(Kokkos::View<double**> a, Kokkos::View<double**> b)
{
	const size_t n0 = a.dimension_0();
	const size_t n1 = a.dimension_1();
	Kokkos::View<double**> result("result", n0, n1);
	for (size_t i=0 ; i<n0 ; ++i)
		for (size_t j=0 ; j<n1 ; ++j)
			result(i,j) = a(i,j) * b(i,j);
	return result;
}

Kokkos::View<double**>
ArrayOperations::divide(Kokkos::View<double**> a, int b)
{
	return divide(a, (double)b);
}

Kokkos::View<double**>
ArrayOperations::divide(Kokkos::View<double**> a, double b)
{
	const size_t n0 = a.dimension_0();
	const size_t n1 = a.dimension_1();
	Kokkos::View<double**> result("result", n0, n1);
	for (size_t i=0 ; i<n0 ; ++i)
		for (size_t j=0 ; j<n1 ; ++j)
			result(i,j) = a(i,j) / b;
	return result;
}

Kokkos::View<double**>
ArrayOperations::plus(Kokkos::View<double**> a, Kokkos::View<double**> b)
{
	const size_t n0 = a.dimension_0();
	const size_t n1 = a.dimension_1();
	Kokkos::View<double**> result("result", n0, n1);
	for (size_t i=0 ; i<n0 ; ++i)
		for (size_t j=0 ; j<n1 ; ++j)
			result(i,j) = a(i,j) + b(i,j);
	return result;
}

Kokkos::View<double**>
ArrayOperations::minus(Kokkos::View<double**> a, Kokkos::View<double**> b)
{
	const size_t n0 = a.dimension_0();
	const size_t n1 = a.dimension_1();
	Kokkos::View<double**> result("result", n0, n1);
	for (size_t i=0 ; i<n0 ; ++i)
		for (size_t j=0 ; j<n1 ; ++j)
			result(i,j) = a(i,j) - b(i,j);
	return result;
}

Kokkos::View<double**>
ArrayOperations::minus(Kokkos::View<double**> a)
{
	const size_t n0 = a.dimension_0();
	const size_t n1 = a.dimension_1();
	Kokkos::View<double**> result("result", n0, n1);
	for (size_t i=0 ; i<n0 ; ++i)
		for (size_t j=0 ; j<n1 ; ++j)
			result(i,j) = -a(i,j);
	return result;
}

}  // namespace nablalib
