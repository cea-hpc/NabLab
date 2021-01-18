package fr.cea.nabla.ir.generator

import fr.cea.nabla.ir.ir.ExtensionProvider

class ExtensionProviderExtensions
{
	static def getNamespaceName(ExtensionProvider it) { extensionName.toLowerCase }
	static def getClassName(ExtensionProvider it) { providerName }
	static def getInterfaceName(ExtensionProvider it) { 'I' + providerName }
	static def getProjectName(ExtensionProvider it) { providerName }
	static def getProjectHome(ExtensionProvider it) { projectDir + '/' + projectName }
	static def getLibName(ExtensionProvider it) { providerName.toLowerCase }

	static def getNsClassName(ExtensionProvider it, String separator)
	{
		if (extensionName == "LinearAlgebra")
			className
		else
			namespaceName + separator + className
	}
}