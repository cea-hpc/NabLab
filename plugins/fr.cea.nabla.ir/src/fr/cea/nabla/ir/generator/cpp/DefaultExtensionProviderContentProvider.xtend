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
import fr.cea.nabla.ir.generator.CppGeneratorUtils
import fr.cea.nabla.ir.generator.Utils
import fr.cea.nabla.ir.ir.DefaultExtensionProvider
import fr.cea.nabla.ir.ir.Function
import org.eclipse.xtend.lib.annotations.Data

import static extension fr.cea.nabla.ir.ExtensionProviderExtensions.*

@Data
class DefaultExtensionProviderContentProvider
{
	val IncludesContentProvider includesContentProvider
	val FunctionContentProvider functionContentProvider

	def getInterfaceHeaderFileContent(DefaultExtensionProvider provider)
	'''
		/* «Utils::doNotEditWarning» */

		#ifndef «CppGeneratorUtils.getHDefineName(provider.interfaceName)»
		#define «CppGeneratorUtils.getHDefineName(provider.interfaceName)»

		«includesContentProvider.getIncludes(false, false)»

		«includesContentProvider.getUsings(false)»

		class «provider.interfaceName»
		{
		public:
			virtual ~«provider.interfaceName»() {};
			virtual void jsonInit(const char* jsonContent) = 0;

			«FOR f : provider.functions»
				«IF f.template»
				/* Template method can not be virtual. Must be directly defined in implementation class.
				«functionContentProvider.getDeclarationContent(f)»;
				*/
				«ELSE»
				virtual «functionContentProvider.getDeclarationContent(f)» = 0;
				«ENDIF»
			«ENDFOR»
		};

		#endif
	'''

	def getHeaderFileContent(DefaultExtensionProvider provider)
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
			«functionContentProvider.getDeclarationContent(f)»
			{
				// Your code here
			}
			«ELSE»
			«functionContentProvider.getDeclarationContent(f)» override;
			«ENDIF»
			«ENDFOR»
		};

		#endif
	'''

	def getSourceFileContent(DefaultExtensionProvider provider)
	'''
		#include "«provider.className».h"
		#include <string>

		void «provider.className»::jsonInit(const char* jsonContent)
		{
			// Your code here
		}
		«FOR f : provider.functions.filter[!template]»

		«functionContentProvider.getDefinitionContent(provider.className, f)»
		«ENDFOR»
	'''

	def getVectorHeaderFileContent(DefaultExtensionProvider provider)
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

	def getVectorSourceFileContent(DefaultExtensionProvider provider)
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

	def getMatrixHeaderFileContent(DefaultExtensionProvider provider)
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

	def getMatrixSourceFileContent(DefaultExtensionProvider provider)
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
