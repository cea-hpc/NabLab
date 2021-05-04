package fr.cea.nabla.ir.interpreter

import fr.cea.nabla.ir.ir.ExtensionProvider

import static extension fr.cea.nabla.ir.ExtensionProviderExtensions.*

class ExtensionProviderNotFound extends Exception
{
	new(ExtensionProvider p, ClassNotFoundException innerException)
	{
		super(innerException.message + '\n' + buildMessage(p))
	}

	private def static String buildMessage(ExtensionProvider p)
	{
		"Class " + p.className + " not found for provider: " + p.providerName 
		+ "\nIn case of C++ providers, do not forget to compile and install it: make; make install"
	}
}

class ExtensionProviderJarNotExist extends Exception
{
	new(ExtensionProvider p, String jarFileName)
	{
		super(buildMessage(p, jarFileName))
	}

	private def static String buildMessage(ExtensionProvider p, String jarFileName)
	{
		"Jar file not found for provider " + p.providerName + ": " + jarFileName
		+ "\nIn case of C++ providers, do not forget to compile and install it: make; make install"
	}
}