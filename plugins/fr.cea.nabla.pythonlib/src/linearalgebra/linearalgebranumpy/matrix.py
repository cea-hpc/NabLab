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

class Matrix:
	def __init__(self, name, data):
		self.__name = name
		self.__data = data

	@classmethod
	def zeros(cls, name, nbRows, nbCols):
		return cls(name, np.zeros((nbRows, nbCols), dtype=np.double))

	def getName(self):
		return self.__name

	def getNbRows(self):
		return self.__data.shape[0]

	def getNbCols(self):
		return self.__data.shape[1]

	def getValue(self, i, j):
		return self.__data[i, j]

	def setValue(self, i, j, value):
		self.__data[i, j] = value

	def getData(self):
		return self.__data
