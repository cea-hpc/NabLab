package fr.cea.nabla.ir.generator.cpp.arcane

import fr.cea.nabla.ir.ir.IrModule

class ArcaneUtils
{
	static def getModuleName(IrModule it)
	{
		name.toFirstUpper + "Module"
	}
}