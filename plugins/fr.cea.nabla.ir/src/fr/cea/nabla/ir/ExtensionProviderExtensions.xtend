package fr.cea.nabla.ir

import fr.cea.nabla.ir.ir.ExtensionProvider

class ExtensionProviderExtensions
{
	static def getInterfaceName(ExtensionProvider it)
	{
		'I' + facadeClass
	}

	static def getNsPrefix(ExtensionProvider it, String separator)
	{
		if (facadeNamespace.nullOrEmpty)
			facadeClass
		else
			facadeNamespace + separator
	}
}