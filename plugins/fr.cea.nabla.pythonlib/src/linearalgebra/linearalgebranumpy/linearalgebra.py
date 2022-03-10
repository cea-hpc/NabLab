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
from vector import Vector

class LinearAlgebra:
	def jsonInit(self, jsonContent):
		# no json init file
		pass

	def solveLinearSystem(self, a, b):
		x = np.linalg.solve(a.getData(), b.getData())
		return Vector(b.getName() + "_plus1", x)

	def solveLinearSystem1(self, x0, x1, x2):
		# Your code here
		raise Exception("Not yet implemented")

	def solveLinearSystem2(self, x0, x1, x2):
		# Your code here
		raise Exception("Not yet implemented")

	def solveLinearSystem3(self, x0, x1, x2, x3):
		# Your code here
		raise Exception("Not yet implemented")

	def solveLinearSystem4(self, x0, x1, x2, x3):
		# Your code here
		raise Exception("Not yet implemented")

	def solveLinearSystem5(self, x0, x1, x2, x3, x4):
		# Your code here
		raise Exception("Not yet implemented")

	def solveLinearSystem6(self, x0, x1, x2, x3, x4):
		# Your code here
		raise Exception("Not yet implemented")

	def solveLinearSystem7(self, x0, x1, x2, x3, x4, x5):
		# Your code here
		raise Exception("Not yet implemented")
