/*******************************************************************************
 * Copyright (c) 2020 CEA
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
#include "types/Types.h"

// Kokkos headers
#include "Kokkos_Core.hpp"

namespace nablalib
{
namespace ArrayOperations
{
	using namespace std;

	// INT
	template<size_t N> IntArray1D<N> plus(int a, IntArray1D<N> b)
	{
		IntArray1D<N> result;
		for (size_t i=0 ; i<N ; ++i)
			result[i] = b[i] + a;
		return result;
	}

	template<size_t N> IntArray1D<N>  multiply(int a, IntArray1D<N> b)
	{
		IntArray1D<N> result;
		for (size_t i=0 ; i<N ; ++i)
			result[i] = b[i] * a;
		return result;
	}

	template<size_t N> RealArray1D<N> multiply(int a, RealArray1D<N> b)
	{
		RealArray1D<N> result;
		for (size_t i=0 ; i<N ; ++i)
			result[i] = b[i] * a;
		return result;
	}

	template<size_t N, size_t M> RealArray2D<N, M> multiply(int a, RealArray2D<N, M> b)
	{
		RealArray2D<N, M> result;
		for (size_t i=0 ; i<N ; ++i)
			for (size_t j=0 ; j<M ; ++j)
				result[i][j] = b[i][j] * a;
		return result;
	}


	// REAL
	template<size_t N> RealArray1D<N> plus(double a, RealArray1D<N> b)
	{
		RealArray1D<N> result;
		for (size_t i=0 ; i<N ; ++i)
			result[i] = b[i] + a;
		return result;
	}

	template<size_t N> RealArray1D<N> multiply(double a, RealArray1D<N> b)
	{
		RealArray1D<N> result;
		for (size_t i=0 ; i<N ; ++i)
			result[i] = b[i] * a;
		return result;
	}

	template<size_t N, size_t M> RealArray2D<N, M> multiply(double a, RealArray2D<N, M> b)
	{
		RealArray2D<N, M> result;
		for (size_t i=0 ; i<N ; ++i)
			for (size_t j=0 ; j<M ; ++j)
				result[i][j] = b[i][j] * a;
		return result;
	}

	// INT ARRAY
	template<size_t N> IntArray1D<N> plus(IntArray1D<N> a, int b)
	{
		IntArray1D<N> result;
		for (size_t i=0 ; i<N ; ++i)
			result[i] = a[i] + b;
		return result;
	}

	template<size_t N> IntArray1D<N> minus(IntArray1D<N> a, int b)
	{
		IntArray1D<N> result;
		for (size_t i=0 ; i<N ; ++i)
			result[i] = a[i] - b;
		return result;
	}

	template<size_t N> IntArray1D<N> multiply(IntArray1D<N> a, int b)
	{
		IntArray1D<N> result;
		for (size_t i=0 ; i<N ; ++i)
			result[i] = a[i] * b;
		return result;
	}

	template<size_t N> IntArray1D<N> divide(IntArray1D<N> a, int b)
	{
		IntArray1D<N> result;
		for (size_t i=0 ; i<N ; ++i)
			result[i] = a[i] / b;
		return result;
	}

	template<size_t N> RealArray1D<N> plus(IntArray1D<N> a, double b)
	{
		RealArray1D<N> result;
		for (size_t i=0 ; i<N ; ++i)
			result[i] = a[i] + b;
		return result;
	}

	template<size_t N> RealArray1D<N> minus(IntArray1D<N> a, double b)
	{
		RealArray1D<N> result;
		for (size_t i=0 ; i<N ; ++i)
			result[i] = a[i] - b;
		return result;
	}

	template<size_t N> RealArray1D<N> multiply(IntArray1D<N> a, double b)
	{
		RealArray1D<N> result;
		for (size_t i=0 ; i<N ; ++i)
			result[i] = a[i] * b;
		return result;
	}

	template<size_t N> RealArray1D<N> divide(IntArray1D<N> a, double b)
	{
		RealArray1D<N> result;
		for (size_t i=0 ; i<N ; ++i)
			result[i] = a[i] / b;
		return result;
	}

	template<size_t N> IntArray1D<N> plus(IntArray1D<N> a, IntArray1D<N> b)
	{
		IntArray1D<N> result;
		for (size_t i=0 ; i<N ; ++i)
			result[i] = a[i] + b[i];
		return result;
	}

	template<size_t N> IntArray1D<N> minus(IntArray1D<N> a, IntArray1D<N> b)
	{
		IntArray1D<N> result;
		for (size_t i=0 ; i<N ; ++i)
			result[i] = a[i] - b[i];
		return result;
	}

	template<size_t N> IntArray1D<N> multiply(IntArray1D<N> a, IntArray1D<N> b)
	{
		IntArray1D<N> result;
		for (size_t i=0 ; i<N ; ++i)
			result[i] = a[i] * b[i];
		return result;
	}

	template<size_t N> IntArray1D<N> divide(IntArray1D<N> a, IntArray1D<N> b)
	{
		IntArray1D<N> result;
		for (size_t i=0 ; i<N ; ++i)
			result[i] = a[i] / b[i];
		return result;
	}

	// REAL ARRAY
	template<size_t N> RealArray1D<N> plus(RealArray1D<N> a, int b)
	{
		RealArray1D<N> result;
		for (size_t i=0 ; i<N ; ++i)
			result[i] = a[i] + b;
		return result;
	}

	template<size_t N> RealArray1D<N> minus(RealArray1D<N> a, int b)
	{
		RealArray1D<N> result;
		for (size_t i=0 ; i<N ; ++i)
			result[i] = a[i] - b;
		return result;
	}

	template<size_t N> RealArray1D<N> multiply(RealArray1D<N> a, int b)
	{
		RealArray1D<N> result;
		for (size_t i=0 ; i<N ; ++i)
			result[i] = a[i] * b;
		return result;
	}

	template<size_t N> RealArray1D<N> divide(RealArray1D<N> a, int b)
	{
		RealArray1D<N> result;
		for (size_t i=0 ; i<N ; ++i)
			result[i] = a[i] / b;
		return result;
	}

	template<size_t N> RealArray1D<N> plus(RealArray1D<N> a, double b)
	{
		RealArray1D<N> result;
		for (size_t i=0 ; i<N ; ++i)
			result[i] = a[i] + b;
		return result;
	}

	template<size_t N> RealArray1D<N> minus(RealArray1D<N> a, double b)
	{
		RealArray1D<N> result;
		for (size_t i=0 ; i<N ; ++i)
			result[i] = a[i] - b;
		return result;
	}

	template<size_t N> RealArray1D<N> multiply(RealArray1D<N> a, double b)
	{
		RealArray1D<N> result;
		for (size_t i=0 ; i<N ; ++i)
			result[i] = a[i] * b;
		return result;
	}

	template<size_t N> RealArray1D<N> divide(RealArray1D<N> a, double b)
	{
		RealArray1D<N> result;
		for (size_t i=0 ; i<N ; ++i)
			result[i] = a[i] / b;
		return result;
	}

	template<size_t N> RealArray1D<N> plus(RealArray1D<N> a, RealArray1D<N> b)
	{
		RealArray1D<N> result;
		for (size_t i=0 ; i<N ; ++i)
			result[i] = a[i] + b[i];
		return result;
	}

	template<size_t N> RealArray1D<N> minus(RealArray1D<N> a, RealArray1D<N> b)
	{
		RealArray1D<N> result;
		for (size_t i=0 ; i<N ; ++i)
			result[i] = a[i] - b[i];
		return result;
	}

	template<size_t N> RealArray1D<N> multiply(RealArray1D<N> a, RealArray1D<N> b)
	{
		RealArray1D<N> result;
		for (size_t i=0 ; i<N ; ++i)
			result[i] = a[i] * b[i];
		return result;
	}

	template<size_t N> RealArray1D<N> divide(RealArray1D<N> a, RealArray1D<N> b)
	{
		RealArray1D<N> result;
		for (size_t i=0 ; i<N ; ++i)
			result[i] = a[i] / b[i];
		return result;
	}

	// REAL MATRIX
	template<size_t N, size_t M> RealArray2D<N, M> multiply(RealArray2D<N, M> a, int b)
	{
		RealArray2D<N, M> result;
		for (size_t i=0 ; i<N ; ++i)
			for (size_t j=0 ; j<M ; ++j)
				result[i][j] = a[i][j] * b;
		return result;
	}

	template<size_t N, size_t M> RealArray2D<N, M> multiply(RealArray2D<N, M> a, double b)
	{
		RealArray2D<N, M> result;
		for (size_t i=0 ; i<N ; ++i)
			for (size_t j=0 ; j<M ; ++j)
				result[i][j] = a[i][j] * b;
		return result;
	}

	template<size_t N, size_t M> RealArray2D<N, M> multiply(RealArray2D<N, M> a, RealArray2D<N, M> b)
	{
		RealArray2D<N, M> result;
		for (size_t i=0 ; i<N ; ++i)
			for (size_t j=0 ; j<M ; ++j)
				result[i][j] = a[i][j] * b[i][j];
		return result;
	}

	template<size_t N, size_t M> RealArray2D<N, M> divide(RealArray2D<N, M> a, int b)
	{
		RealArray2D<N, M> result;
		for (size_t i=0 ; i<N ; ++i)
			for (size_t j=0 ; j<M ; ++j)
				result[i][j] = a[i][j] / b;
		return result;
	}

	template<size_t N, size_t M> RealArray2D<N, M> divide(RealArray2D<N, M> a, double b)
	{
		RealArray2D<N, M> result;
		for (size_t i=0 ; i<N ; ++i)
			for (size_t j=0 ; j<M ; ++j)
				result[i][j] = a[i][j] / b;
		return result;
	}

	template<size_t N, size_t M> RealArray2D<N, M> plus(RealArray2D<N, M> a, RealArray2D<N, M> b)
	{
		RealArray2D<N, M> result;
		for (size_t i=0 ; i<N ; ++i)
			for (size_t j=0 ; j<M ; ++j)
				result[i][j] = a[i][j] + b[i][j];
		return result;
	}

	template<size_t N, size_t M> RealArray2D<N, M> minus(RealArray2D<N, M> a, RealArray2D<N, M> b)
	{
		RealArray2D<N, M> result;
		for (size_t i=0 ; i<N ; ++i)
			for (size_t j=0 ; j<M ; ++j)
				result[i][j] = a[i][j] - b[i][j];
		return result;
	}

	template<size_t N, size_t M> RealArray2D<N, M> minus(RealArray2D<N, M> a)
	{
		RealArray2D<N, M> result;
		for (size_t i=0 ; i<N ; ++i)
			for (size_t j=0 ; j<M ; ++j)
				result[i][j] = -a[i][j];
		return result;
	}
}
}

#endif /* TYPES_ARRAYOPERATIONS_H_ */
