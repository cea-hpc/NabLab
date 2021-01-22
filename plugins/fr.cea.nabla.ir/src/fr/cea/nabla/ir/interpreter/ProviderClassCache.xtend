package fr.cea.nabla.ir.interpreter

import fr.cea.nabla.ir.ir.ExtensionProvider
import java.util.HashMap

import static fr.cea.nabla.ir.ExtensionProviderExtensions.*

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
	public static val JNI_LIBRARY_PATH = "nabla.jni.library.path"

	private new()
	{
	}

	def Class<?> getClass(ExtensionProvider p, ClassLoader cl)
	{
		var c = classByProviderNames.get(p.extensionName)
		if (c === null)
		{
			System.setProperty(JNI_LIBRARY_PATH, p.installDir)
			c = Class.forName(getNsPrefix(p, '.', '.') + p.facadeClass, true, cl)
			classByProviderNames.put(p.extensionName, c)
		}
		return c
	}
}