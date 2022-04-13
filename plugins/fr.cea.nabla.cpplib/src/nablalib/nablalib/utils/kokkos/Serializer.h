/*******************************************************************************
* Copyright (c) 2022 CEA
>>>>>>> [dev] Store leveldb values as binary
 * This program and the accompanying materials are made available under the
 * terms of the Eclipse Public License 2.0 which is available at
 * http://www.eclipse.org/legal/epl-2.0.
 *
 * SPDX-License-Identifier: EPL-2.0
 * Contributors: see AUTHORS file
 *******************************************************************************/
#ifndef NABLALIB_UTILS_KOKKOS_SERIALIZER_H_
#define NABLALIB_UTILS_KOKKOS_SERIALIZER_H_

#include "Kokkos_Core.hpp"
#include "nablalib/utils/Serializer.h"
/*
 * Collection of free functions to serialize variables build over Kokkos backend into const char*.
 * Values are space separated.
 */
namespace nablalib::utils
{
	template <typename T>
	const char* serialize(const Kokkos::View<T*>& v, int& size, bool& mustDeletePtr)
	{
		std::vector<char> vector;
		for (size_t i(0); i < v.extent(0); i++)
		{
			int innerSize;
			bool innerMustDeletePtr;
			const char* array = serialize(v(i), innerSize, innerMustDeletePtr);
			for (int id = 0; id < innerSize; id++)
				vector.push_back(array[id]);
			if (innerMustDeletePtr)
				delete []array;
		}
		size = vector.size();
		char* array = new char[vector.size()];
		for (size_t i(0) ; i < vector.size() ; i++)
			array[i] = vector[i];
		mustDeletePtr = true;
		return (const char*)array;
	}

	template <typename T>
	const char* serialize(const Kokkos::View<T**>& v, int& size, bool& mustDeletePtr)
	{
		std::vector<char> vector;
		for (size_t i(0); i < v.extent(0); ++i)
		{
			for (size_t j(0); j < v.extent(1); ++j)
			{
				int innerSize;
				bool innerMustDeletePtr;
				const char* array = serialize(v(i, j), innerSize, innerMustDeletePtr);
				for (int id = 0; id < innerSize; id++)
					vector.push_back(array[id]);
				if (innerMustDeletePtr)
					delete []array;
			}
		}
		size = vector.size();
		char* array = new char[vector.size()];
		for (size_t i(0) ; i < vector.size() ; i++)
			array[i] = vector[i];
		mustDeletePtr = true;
		return (const char*)array;
	}

	template <typename T>
	const char* serialize(const Kokkos::View<T***>& v, int& size, bool& mustDeletePtr)
	{
		std::vector<char> vector;
		for (size_t i(0); i < v.extent(0); ++i)
		{
			for (size_t j(0); j < v.extent(1); ++j)
			{
				for (size_t k(0); k < v.extent(2); ++k)
				{
					int innerSize;
					bool innerMustDeletePtr;
					const char* array = serialize(v(i, j, k), innerSize, innerMustDeletePtr);
					for (int id = 0; id < innerSize; id++)
						vector.push_back(array[id]);
					if (innerMustDeletePtr)
						delete []array;
				}
			}
		}
		size = vector.size();
		char* array = new char[vector.size()];
		for (size_t i(0) ; i < vector.size() ; ++i)
			array[i] = vector[i];
		mustDeletePtr = true;
		return (const char*)array;
	}

	// TODO(FL): voir si on peut pas faire qqch de ce style ...
	//template <typename T,  typename std::enable_if_t<std::is_pointer_v<T>>* = nullptr>
	//std::string serialize(const Kokkos::View<T>& v, size_t dim1, size_t... dimN>) {
	//std::stringstream ss;
	//for (size_t i(0); i < v.extent(0); ++i)
	//ss << serialize(v(i)) << " ";
	//return std::string(ss.str());
	//}
}

#endif // NABLALIB_UTILS_KOKKOS_SERIALIZER_H_
