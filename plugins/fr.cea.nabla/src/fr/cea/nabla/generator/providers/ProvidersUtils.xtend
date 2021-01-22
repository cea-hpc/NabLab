package fr.cea.nabla.generator.providers

import com.google.inject.Inject
import fr.cea.nabla.generator.ir.IrFunctionFactory
import fr.cea.nabla.ir.ir.IrFactory
import fr.cea.nabla.ir.transformers.ReplaceUtf8Chars
import fr.cea.nabla.nabla.NablaExtension
import fr.cea.nabla.nablaext.ExtensionProvider

class ProvidersUtils
{
	@Inject IrFunctionFactory irFunctionFactory

	def toIrExtensionProvider(ExtensionProvider provider, String wsDir, String installationDir)
	{
		IrFactory::eINSTANCE.createExtensionProvider =>
		[
			extensionName = provider.extension.name
			providerName = provider.name
			projectDir = wsDir + provider.projectDir
			installDir = installationDir
			facadeClass= provider.facadeClass
			facadeNamespace = provider.facadeNamespace
			libName = provider.libName
		]
	}

	def getIrFunctions(NablaExtension it)
	{
		functions.map[x | 
			val irFunction = irFunctionFactory.toIrFunction(x)
			irFunction.name = ReplaceUtf8Chars.getNoUtf8(irFunction.name)
			return irFunction
		]
	}
}