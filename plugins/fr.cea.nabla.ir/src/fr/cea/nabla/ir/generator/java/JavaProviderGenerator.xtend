package fr.cea.nabla.ir.generator.java

import fr.cea.nabla.ir.generator.GenerationContent
import fr.cea.nabla.ir.generator.ProviderGenerator
import fr.cea.nabla.ir.generator.Utils
import fr.cea.nabla.ir.ir.ExtensionProvider
import fr.cea.nabla.ir.ir.Function
import java.util.ArrayList

import static extension fr.cea.nabla.ir.generator.ExtensionProviderExtensions.*

class JavaProviderGenerator implements ProviderGenerator
{
	override getName() { 'Java' }

	override getGenerationContents(ExtensionProvider provider, Iterable<Function> functions)
	{
		val fileContents = new ArrayList<GenerationContent>

		// interface
		val interfaceFileName = getNsPrefix(provider, '.', '/') + provider.interfaceName + ".java"
		fileContents += new GenerationContent(interfaceFileName, getInterfaceFileContent(provider, functions), false)

		// Generates class if it does not exists
		val classFileName = getNsPrefix(provider, '.', '/') + provider.facadeClass + ".java"
		fileContents += new GenerationContent(classFileName, getClassFileContent(provider, functions), true)

		return fileContents
	}

	private def getInterfaceFileContent(ExtensionProvider provider, Iterable<Function> irFunctions)
	'''
	«Utils::fileHeader»

	«IF !provider.facadeNamespace.nullOrEmpty»
	package «provider.facadeNamespace»;

	«ENDIF»
	public interface «provider.interfaceName»
	{
		public void jsonInit(String jsonContent);
		«FOR f : irFunctions»
		public «FunctionContentProvider.getHeaderContent(f)»;
		«ENDFOR»
	}
	'''

	private def getClassFileContent(ExtensionProvider provider, Iterable<Function> irFunctions)
	'''
	«IF !provider.facadeNamespace.nullOrEmpty»
	package «provider.facadeNamespace»;

	«ENDIF»
	public class «provider.facadeClass» implements «provider.interfaceName»
	{
		@Override
		public void jsonInit(String jsonContent)
		{
			// Your code here
		}
		«FOR f : irFunctions»

		@Override
		public «FunctionContentProvider.getHeaderContent(f)»
		{
			// Your code here
		}
		«ENDFOR»
	}
	'''
}