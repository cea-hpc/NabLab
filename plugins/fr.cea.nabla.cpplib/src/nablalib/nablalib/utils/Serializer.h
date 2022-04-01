/*******************************************************************************
 * Copyright (c) 2022 CEA
 * This program and the accompanying materials are made available under the
 * terms of the Eclipse Public License 2.0 which is available at
 * http://www.eclipse.org/legal/epl-2.0.
 *
 * SPDX-License-Identifier: EPL-2.0
 * Contributors: see AUTHORS file
 *******************************************************************************/
#ifndef NABLALIB_UTILS_SERIALIZER_H_
#define NABLALIB_UTILS_SERIALIZER_H_

#include <string>
#include <sstream>
#include <iomanip>
#include "nablalib/types/Types.h"

#define DBL_PRECISION 6

using namespace nablalib::types;

namespace nablalib::utils
{
	//deals with bool, int & double
	template <typename T, typename = std::enable_if_t<std::is_same_v<T, int> ||  std::is_same_v<T,double> ||  std::is_same_v<T,bool>>>
	const char* serialize(const T& dataValue, int& size, bool& mustDeletePtr)
	{
		size = sizeof(dataValue);
		mustDeletePtr = false;
		return (const char*)&dataValue;
	}

	//deals with BoolArray1D, IntArray1D, RealArray1D
	template <typename T, size_t N>
	const char* serialize(const MultiArray<T, N>& dataValue, int& size, bool& mustDeletePtr)
	{
		// We can't use N because dynamic MultiArrays are MultiArray<0>
		size = dataValue.size() * sizeof(T);
		mustDeletePtr = false;
		return (const char*)dataValue.data();
	}

	//deals with BoolArray2D, IntArray2D & RealArray2D
	template <typename T, size_t N, size_t M>
	const char* serialize(const MultiArray<T, N, M>& dataValue, int& size, bool& mustDeletePtr)
	{
		// We can't use N &M because dynamic MultiArrays are MultiArray<0,0>
		size = dataValue.size() * dataValue[0].size() * sizeof(T);
		mustDeletePtr = false;
		return (const char*)dataValue.data();
	}

	template <typename T, typename = std::enable_if_t<std::is_same_v<T, int> ||  std::is_same_v<T,double> ||  std::is_same_v<T,bool>>>
	inline const char* serialize(const std::vector<T>& v, int& size, bool& mustDeletePtr)
	{
		size = v.size() * sizeof(T);
		mustDeletePtr = false;
		return (const char*)v.data();
	}

	template<typename T, size_t N>
	const char* serialize(const std::vector<MultiArray<T, N>>& v, int& size, bool& mustDeletePtr)
	{
		size_t n = v.size();
		size = n * N * sizeof(T);
		T* array = new T[n * N];
		for (size_t i = 0; i < n; i++)
			for (size_t j = 0 ; j < N; j++)
				array[i * N + j] = v[i][j];
		mustDeletePtr = true;
		return (const char*)array;
	}

	template<typename T, size_t N, size_t M>
	const char* serialize(const std::vector<MultiArray<T, N, M>>& v, int& size, bool& mustDeletePtr)
	{
		size_t n = v.size();
		size = n * N * M * sizeof(T);
		T* array = new T[n * N * M];
		for (size_t i = 0; i < n; i++)
			for (size_t j = 0 ; j < N; j++)
				for (size_t k = 0 ; k < M; k++)
					array[i * N * M + j * M + k] = v[i][j][k];
		mustDeletePtr = true;
		return (const char*)array;
	}

	inline const char* serialize(const std::vector<std::vector<double>>& v, int& size, bool& mustDeletePtr)
	{
		size_t n = v.size();
		size_t m = v[0].size();
		size = n * m * sizeof(double);
		double* array = new double[n * m];
		for (size_t i = 0; i < n; i++)
			for (size_t j = 0 ; j < m; j++)
				array[i * m + j] = v[i][j];
		mustDeletePtr = true;
		return (const char*)array;
	}

	template<size_t N>
	const char* serialize(const std::vector<std::vector<RealArray1D<N>>>& v, int& size, bool& mustDeletePtr)
	{
		size_t n = v.size();
		size_t m = v[0].size();
		size = n * m * N * sizeof(double);
		double* array = new double[n * m * N];
		for (size_t i = 0; i < n; i++)
			for (size_t j = 0 ; j < m; j++)
				for (size_t k = 0; k < N; k++)
					array[i * m * N + j * N + k] = v[i][j][k];
		mustDeletePtr = true;
		return (const char*)array;
	}

	template<size_t N, size_t M>
	const char* serialize(const std::vector<std::vector<RealArray2D<N,M>>>& v, int& size, bool& mustDeletePtr)
	{
		size_t n = v.size();
		size_t m = v[0].size();
		size = n * m * N * M * sizeof(double);
		double* array = new double[n * m * N * M];
		for (size_t i = 0; i < n; i++)
			for (size_t j = 0; j < m; j++)
				for (size_t k = 0 ; k < N; k++)
					for (size_t l = 0 ; l < M; l++)
						array[i * m * N * M + j * N * M + k * M + l] = v[i][j][k][l];
		mustDeletePtr = true;
		return (const char*)array;
	}
}
#endif // NABLALIB_UTILS_SERIALIZER_H_
