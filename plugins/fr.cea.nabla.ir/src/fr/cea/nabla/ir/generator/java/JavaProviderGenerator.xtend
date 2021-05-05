/*******************************************************************************
 * Copyright (c) 2021 CEA
 * This program and the accompanying materials are made available under the 
 * terms of the Eclipse Public License 2.0 which is available at
 * http://www.eclipse.org/legal/epl-2.0.
 *
 * SPDX-License-Identifier: EPL-2.0
 * Contributors: see AUTHORS file
 *******************************************************************************/
package fr.cea.nabla.ir.generator.java

import fr.cea.nabla.ir.IrTypeExtensions
import fr.cea.nabla.ir.generator.GenerationContent
import fr.cea.nabla.ir.generator.ProviderGenerator
import fr.cea.nabla.ir.generator.Utils
import fr.cea.nabla.ir.ir.ExtensionProvider
import java.util.ArrayList

import static extension fr.cea.nabla.ir.ExtensionProviderExtensions.*

class JavaProviderGenerator implements ProviderGenerator
{
	override getName() { 'Java' }

	override getGenerationContents(ExtensionProvider provider)
	{
		val fileContents = new ArrayList<GenerationContent>
		// interface always
		fileContents += new GenerationContent(provider.interfaceName + ".java", getInterfaceFileContent(provider), false)
		// class if they do not exists
		fileContents += new GenerationContent(provider.className + ".java", getClassFileContent(provider), true)
		if (provider.linearAlgebra)
		{
			fileContents += new GenerationContent(IrTypeExtensions.VectorClass + ".java", getVectorClassFileContent(provider), true)
			fileContents += new GenerationContent(IrTypeExtensions.MatrixClass + ".java", getMatrixClassFileContent(provider), true)
		}
		return fileContents
	}

	private def getInterfaceFileContent(ExtensionProvider provider)
	'''
	«Utils::fileHeader»

	package «provider.packageName»;

	public interface «provider.interfaceName»
	{
		public void jsonInit(String jsonContent);
		«FOR f : provider.functions»
		public «FunctionContentProvider.getHeaderContent(f)»;
		«ENDFOR»
	}
	'''

	private def getClassFileContent(ExtensionProvider provider)
	'''
	package «provider.packageName»;

	public class «provider.className» implements «provider.interfaceName»
	{
		@Override
		public void jsonInit(String jsonContent)
		{
			// Your code here
		}
		«FOR f : provider.functions»

		@Override
		public «FunctionContentProvider.getHeaderContent(f)»
		{
			// Your code here
		}
		«ENDFOR»
	}
	'''

	private def getVectorClassFileContent(ExtensionProvider provider)
	'''
	package «provider.packageName»;

	public class «IrTypeExtensions.VectorClass»
	{
		public «IrTypeExtensions.VectorClass»(final String name, final int size)
		{
			// Your code here
		}

		public String getName()
		{
			// Your code here
		}

		public int getSize()
		{
			// Your code here
		}

		public double getValue(int i)
		{
			// Your code here
		}

		public void setValue(int i, double value)
		{
			// Your code here
		}
	}
	'''

	private def getMatrixClassFileContent(ExtensionProvider provider)
	'''
	package «provider.packageName»;

	public class «IrTypeExtensions.MatrixClass»
	{
		public «IrTypeExtensions.MatrixClass»(final String name, final int nbRows, final int nbCols)
		{
			// Your code here
		}

		public String getName()
		{
			// Your code here
		}

		int getNbRows()
		{
			// Your code here
		}

		int getNbCols()
		{
			// Your code here
		}

		public double getValue(int i, int j)
		{
			// Your code here
		}

		public void setValue(int i, int j, double value)
		{
			// Your code here
		}
	}
	'''
}