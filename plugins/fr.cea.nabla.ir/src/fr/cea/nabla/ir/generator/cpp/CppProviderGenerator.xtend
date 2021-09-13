/*******************************************************************************
 * Copyright (c) 2021 CEA
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
import fr.cea.nabla.ir.generator.CppGeneratorUtils
import fr.cea.nabla.ir.ir.DefaultExtensionProvider
import fr.cea.nabla.ir.ir.Function
import java.util.ArrayList

import static extension fr.cea.nabla.ir.ExtensionProviderExtensions.*

class CppProviderGenerator extends CppGenerator implements ProviderGenerator
{
	new(Backend backend)
	{
		super(backend)
	}

	override getGenerationContents(DefaultExtensionProvider provider)
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

	private def getInterfaceHeaderFileContent(DefaultExtensionProvider provider)
	'''
		/* «Utils::doNotEditWarning» */

		#ifndef «CppGeneratorUtils.getHDefineName(provider.interfaceName)»
		#define «CppGeneratorUtils.getHDefineName(provider.interfaceName)»

		«backend.includesContentProvider.getIncludes(false, false)»

		«backend.includesContentProvider.getUsings(false)»

		class «provider.interfaceName»
		{
		public:
			virtual ~«provider.interfaceName»() {};
			virtual void jsonInit(const char* jsonContent) = 0;

			«FOR f : provider.functions»
				«IF f.template»
				/* Template method can not be virtual. Must be directly defined in implementation class.
				«backend.functionContentProvider.getDeclarationContent(f)»;
				*/
				«ELSE»
				virtual «backend.functionContentProvider.getDeclarationContent(f)» = 0;
				«ENDIF»
			«ENDFOR»
		};

		#endif
	'''

	private def getHeaderFileContent(DefaultExtensionProvider provider)
	'''
		#ifndef «CppGeneratorUtils.getHDefineName(provider.className)»
		#define «CppGeneratorUtils.getHDefineName(provider.className)»

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

			«IF f.template»
			«backend.functionContentProvider.getDeclarationContent(f)»
			{
				// Your code here
			}
			«ELSE»
			«backend.functionContentProvider.getDeclarationContent(f)» override;
			«ENDIF»
			«ENDFOR»
		};

		#endif
	'''

	private def getSourceFileContent(DefaultExtensionProvider provider)
	'''
		#include "«provider.className».h"
		#include <string>

		void «provider.className»::jsonInit(const char* jsonContent)
		{
			// Your code here
		}
		«FOR f : provider.functions.filter[!template]»

		«backend.functionContentProvider.getDefinitionContent(provider.className, f)»
		«ENDFOR»
	'''

	private def getVectorHeaderFileContent(DefaultExtensionProvider provider)
	'''
		#ifndef «CppGeneratorUtils.getHDefineName(IrTypeExtensions.VectorClass)»
		#define «CppGeneratorUtils.getHDefineName(IrTypeExtensions.VectorClass)»

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

	private def getVectorSourceFileContent(DefaultExtensionProvider provider)
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

	private def getMatrixHeaderFileContent(DefaultExtensionProvider provider)
	'''
		#ifndef «CppGeneratorUtils.getHDefineName(IrTypeExtensions.MatrixClass)»
		#define «CppGeneratorUtils.getHDefineName(IrTypeExtensions.MatrixClass)»

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

	private def getMatrixSourceFileContent(DefaultExtensionProvider provider)
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

	private def boolean isTemplate(Function it)
	{
		!variables.empty
	}
}
