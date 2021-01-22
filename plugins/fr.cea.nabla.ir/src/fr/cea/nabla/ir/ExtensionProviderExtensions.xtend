package fr.cea.nabla.ir

import fr.cea.nabla.ir.ir.ExtensionProvider

class ExtensionProviderExtensions
{
	static def getInterfaceName(ExtensionProvider it) { 'I' + facadeClass }

	static def getNsPrefix(ExtensionProvider it, String oldSeparator, String newSeparator)
	{
		if (facadeNamespace.nullOrEmpty)
			facadeClass
		else
			facadeNamespace.replace(oldSeparator, newSeparator) + newSeparator
	}
}