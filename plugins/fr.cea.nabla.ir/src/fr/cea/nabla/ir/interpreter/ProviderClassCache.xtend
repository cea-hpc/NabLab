package fr.cea.nabla.ir.interpreter

import fr.cea.nabla.ir.ir.ExtensionProvider
import java.util.HashMap

import static extension fr.cea.nabla.ir.generator.ExtensionProviderExtensions.*

/**
 * Native library (.so) can only be loaded once.
 * Consequently, JNI classes, containing the static loadLibrary instruction,
 * must not be load more than once to prevent IllegalAccessException.
 * This class is a singleton cache for provider classes.
 */
class ProviderClassCache
{
	val classByProviderNames = new HashMap<String, Class<?>>
	public static val Instance = new ProviderClassCache

	private new()
	{
	}

	def Class<?> getClass(ExtensionProvider p, ClassLoader cl)
	{
		var c = classByProviderNames.get(p.extensionName)
		if (c === null)
		{
			c = Class.forName(p.providerClassName, true, cl)
			classByProviderNames.put(p.extensionName, c)
		}
		return c
	}

	private def getProviderClassName(ExtensionProvider it)
	{
		if (extensionName == "LinearAlgebra") "fr.cea.nabla.javalib.types.LinearAlgebraFunctions" 
		else namespaceName + '.' + className
	}
}