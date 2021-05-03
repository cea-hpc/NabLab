package fr.cea.nabla.ir.interpreter

import fr.cea.nabla.ir.ir.ExtensionProvider

import static extension fr.cea.nabla.ir.ExtensionProviderExtensions.*

class ExtensionProviderNotFound extends Exception
{
	new(ExtensionProvider p, ClassNotFoundException innerException)
	{
		super(innerException.message + '\n' + p.buildMessage)
	}

	private def static String buildMessage(ExtensionProvider p)
	{
		"Class " + p.className + " not found for provider " + p.providerName + ": if JNI compile and install (make; make install)"
	}
}

class ExtensionProviderJarNotExist extends Exception
{
	new(ExtensionProvider p, String jarFileName)
	{
		super("Jar file not found for provider " + p.providerName + ": " + jarFileName)
	}
}