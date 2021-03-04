package fr.cea.nabla.ir

import fr.cea.nabla.ir.ir.ExtensionProvider

class ExtensionProviderExtensions
{
	static def getInterfaceName(ExtensionProvider it)
	{
		'I' + extensionName
	}

	static def getClassName(ExtensionProvider it)
	{
		extensionName
	}

	static def getNsPrefix(ExtensionProvider it, String separator)
	{
		if (namespace.nullOrEmpty)
			''
		else
			namespace + separator
	}

	static def String getInstanceName(ExtensionProvider it)
	{
		extensionName.toFirstLower
	}
}
