/*******************************************************************************
 * Copyright (c) 2022 CEA
 * This program and the accompanying materials are made available under the
 * terms of the Eclipse Public License 2.0 which is available at
 * http://www.eclipse.org/legal/epl-2.0.
 *
 * SPDX-License-Identifier: EPL-2.0
 * Contributors: see AUTHORS file
 *******************************************************************************/
package fr.cea.nabla.ir.generator.python

import fr.cea.nabla.ir.IrTypeExtensions
import fr.cea.nabla.ir.ir.DefaultExtensionProvider

import static extension fr.cea.nabla.ir.ExtensionProviderExtensions.*

class DefaultExtensionProviderContentProvider
{
	static def getClassFileContent(DefaultExtensionProvider provider)
	'''
	class «provider.className»:
		def jsonInit(self, jsonContent):
			# Your code here
			raise Exception("Not yet implemented")
		«FOR f : provider.functions»

		def «FunctionContentProvider.getHeaderContent(f)»:
			# Your code here
			raise Exception("Not yet implemented")
		«ENDFOR»
	'''

	static def getVectorClassFileContent(DefaultExtensionProvider provider)
	'''
	class «IrTypeExtensions.VectorClass»:
		def __init__(self, name, size):
			# Your code here
			raise Exception("Not yet implemented")

		def getName(self):
			# Your code here
			raise Exception("Not yet implemented")

		def getSize(self):
			# Your code here
			raise Exception("Not yet implemented")

		def getValue(self, i):
			# Your code here
			raise Exception("Not yet implemented")

		def setValue(self, i, value):
			# Your code here
			raise Exception("Not yet implemented")
	'''

	static def getMatrixClassFileContent(DefaultExtensionProvider provider)
	'''
	class «IrTypeExtensions.MatrixClass»:
		def __init__(self, name, nbRows, nbCols):
			# Your code here
			raise Exception("Not yet implemented")

		def getName(self):
			# Your code here
			raise Exception("Not yet implemented")

		def getNbRows(self):
			# Your code here
			raise Exception("Not yet implemented")

		def getNbCols(self):
			# Your code here
			raise Exception("Not yet implemented")

		def getValue(self, i, j):
			# Your code here
			raise Exception("Not yet implemented")

		def setValue(self, i, j, value):
			# Your code here
			raise Exception("Not yet implemented")
	'''
}