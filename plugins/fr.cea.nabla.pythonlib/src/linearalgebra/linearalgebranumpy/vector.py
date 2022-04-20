"""
 *******************************************************************************/
 * Copyright (c) 2022 CEA
 * This program and the accompanying materials are made available under the 
 * terms of the Eclipse Public License 2.0 which is available at
 * http://www.eclipse.org/legal/epl-2.0.
 *
 * SPDX-License-Identifier: EPL-2.0
 * Contributors: see AUTHORS file
 *******************************************************************************/
"""
import numpy as np

class Vector:
	def __init__(self, name, data):
		self.__name = name
		self.__data = data

	@classmethod
	def zeros(cls, name, size):
		return cls(name, np.zeros(size, dtype=np.double))

	def getName(self):
		return self.__name

	def getSize(self):
		return len(self.__data)

	def getValue(self, i):
		return self.__data[i]

	def setValue(self, i, value):
		self.__data[i] = value

	def getData(self):
		return self.__data
