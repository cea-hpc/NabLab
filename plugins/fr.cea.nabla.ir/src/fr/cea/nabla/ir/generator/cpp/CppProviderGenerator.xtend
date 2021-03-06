/*******************************************************************************
 * Copyright (c) 2020 CEA
 * This program and the accompanying materials are made available under the
 * terms of the Eclipse Public License 2.0 which is available at
 * http://www.eclipse.org/legal/epl-2.0.
 *
 * SPDX-License-Identifier: EPL-2.0
 * Contributors: see AUTHORS file
 *******************************************************************************/
package fr.cea.nabla.ir.generator.cpp

import fr.cea.nabla.ir.IrTypeExtensions
import fr.cea.nabla.ir.generator.GenerationContent
import fr.cea.nabla.ir.generator.ProviderGenerator
import fr.cea.nabla.ir.generator.Utils
import fr.cea.nabla.ir.ir.ExtensionProvider
import java.util.ArrayList

import static extension fr.cea.nabla.ir.ExtensionProviderExtensions.*
import static extension fr.cea.nabla.ir.generator.cpp.CppGeneratorUtils.*

class CppProviderGenerator extends CppGenerator implements ProviderGenerator
{
	new(Backend backend)
	{
		super(backend)
	}

	override getGenerationContents(ExtensionProvider provider)
	{
		val fileContents = new ArrayList<GenerationContent>
		fileContents += new GenerationContent(provider.interfaceName + ".h", getInterfaceHeaderFileContent(provider), false)
		fileContents += new GenerationContent("CMakeLists.txt", backend.cmakeContentProvider.getCMakeFileContent(provider), false)
		// Generates .h and .cc if they does not exists
		fileContents += new GenerationContent(provider.className + ".h", getHeaderFileContent(provider), true)
		fileContents += new GenerationContent(provider.className + ".cc", getSourceFileContent(provider), true)
		if (provider.linearAlgebra)
		{
			fileContents += new GenerationContent(IrTypeExtensions.VectorClass + ".h", getVectorHeaderFileContent(provider), true)
			fileContents += new GenerationContent(IrTypeExtensions.VectorClass + ".cc", getVectorSourceFileContent(provider), true)
			fileContents += new GenerationContent(IrTypeExtensions.MatrixClass + ".h", getMatrixHeaderFileContent(provider), true)
			fileContents += new GenerationContent(IrTypeExtensions.MatrixClass + ".cc", getMatrixSourceFileContent(provider), true)
		}
		return fileContents
	}

	private def getInterfaceHeaderFileContent(ExtensionProvider provider)
	'''
		«Utils::fileHeader»

		#ifndef «provider.interfaceName.HDefineName»
		#define «provider.interfaceName.HDefineName»

		«backend.includesContentProvider.getIncludes(false, false)»

		«backend.includesContentProvider.getUsings(false)»

		class «provider.interfaceName»
		{
		public:
			virtual void jsonInit(const char* jsonContent) = 0;

			/* 
			 * Here are the other methods to implement in «name» class.
			 * Some of them can be templates. Therefore they can not be virtual.
			 *
			«FOR f : provider.functions»

				«backend.functionContentProvider.getDeclarationContent(f)»;
			«ENDFOR»
			*/
		};

		#endif
	'''

	private def getHeaderFileContent(ExtensionProvider provider)
	'''
		#ifndef «provider.className.HDefineName»
		#define «provider.className.HDefineName»

		#include "«provider.interfaceName».h"
		«IF provider.linearAlgebra»
		#include "«IrTypeExtensions.VectorClass».h"
		#include "«IrTypeExtensions.MatrixClass».h"
		«ENDIF»

		class «provider.className» : public «provider.interfaceName»
		{
		public:
			void jsonInit(const char* jsonContent) override;
			«FOR f : provider.functions»

			«backend.functionContentProvider.getDeclarationContent(f)»
			{
				// Your code here
			}
			«ENDFOR»
		};

		#endif
	'''

	private def getSourceFileContent(ExtensionProvider provider)
	'''
		#include "«provider.className».h"
		#include <string>

		void «provider.className»::jsonInit(const char* jsonContent)
		{
			// Your code here
		}
	'''

	private def getVectorHeaderFileContent(ExtensionProvider provider)
	'''
		#ifndef «IrTypeExtensions.VectorClass.HDefineName»
		#define «IrTypeExtensions.VectorClass.HDefineName»

		#include <cstddef>
		#include <string>

		class «IrTypeExtensions.VectorClass»
		{
		public:
			«IrTypeExtensions.VectorClass»(const std::string& name, const std::size_t size);
			~«IrTypeExtensions.VectorClass»();

			«IrTypeExtensions.VectorClass»& operator=(const «IrTypeExtensions.VectorClass»& val);

			const std::size_t getSize() const;
			double getValue(const std::size_t i) const;
			void setValue(const std::size_t i, double value);
		};

		#endif
	'''

	private def getVectorSourceFileContent(ExtensionProvider provider)
	'''
		#include "«IrTypeExtensions.VectorClass».h"

		«IrTypeExtensions.VectorClass»::
		«IrTypeExtensions.VectorClass»(const std::string& name, const std::size_t size)
		{
			// Your code here
		}

		«IrTypeExtensions.VectorClass»::
		~«IrTypeExtensions.VectorClass»()
		{
			// Your code here
		}

		«IrTypeExtensions.VectorClass»& «IrTypeExtensions.VectorClass»::
		operator=(const «IrTypeExtensions.VectorClass»& val)
		{
			// Your code here
			return *this;
		}

		const std::size_t «IrTypeExtensions.VectorClass»::
		getSize() const
		{
			// Your code here
		}

		double «IrTypeExtensions.VectorClass»::
		getValue(const std::size_t i) const
		{
			// Your code here
		}

		void «IrTypeExtensions.VectorClass»::
		setValue(const std::size_t i, double value)
		{
			// Your code here
		}
	'''

	private def getMatrixHeaderFileContent(ExtensionProvider provider)
	'''
		#ifndef «IrTypeExtensions.MatrixClass.HDefineName»
		#define «IrTypeExtensions.MatrixClass.HDefineName»

		#include <cstddef>
		#include <string>

		class «IrTypeExtensions.MatrixClass»
		{
		public:
			«IrTypeExtensions.MatrixClass»(const std::string name, const std::size_t rows, const std::size_t cols);
			~«IrTypeExtensions.MatrixClass»();

			const std::size_t getNbRows() const;
			const std::size_t getNbCols() const;
			double getValue(const std::size_t row, const std::size_t col) const;
			void setValue(const std::size_t row, const std::size_t col, double value);
		};

		#endif
	'''

	private def getMatrixSourceFileContent(ExtensionProvider provider)
	'''
		#include "«IrTypeExtensions.MatrixClass».h"

		«IrTypeExtensions.MatrixClass»::
		«IrTypeExtensions.MatrixClass»(const std::string name, const std::size_t rows, const std::size_t cols)
		{
			// Your code here
		}

		«IrTypeExtensions.MatrixClass»::
		~«IrTypeExtensions.MatrixClass»()
		{
			// Your code here
		}

		const std::size_t «IrTypeExtensions.MatrixClass»::
		getNbRows() const
		{
			// Your code here
		}

		const std::size_t «IrTypeExtensions.MatrixClass»::
		getNbCols() const
		{
			// Your code here
		}

		double «IrTypeExtensions.MatrixClass»::
		getValue(const std::size_t _row, const std::size_t _col) const
		{
			// Your code here
		}

		void «IrTypeExtensions.MatrixClass»::
		setValue(const std::size_t _row, const std::size_t _col, double value)
		{
			// Your code here
		}
	'''
}
