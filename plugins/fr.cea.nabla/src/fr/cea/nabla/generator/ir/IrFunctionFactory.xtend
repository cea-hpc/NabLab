/*******************************************************************************
 * Copyright (c) 2020 CEA
 * This program and the accompanying materials are made available under the 
 * terms of the Eclipse Public License 2.0 which is available at
 * http://www.eclipse.org/legal/epl-2.0.
 *
 * SPDX-License-Identifier: EPL-2.0
 * Contributors: see AUTHORS file
 *******************************************************************************/
package fr.cea.nabla.generator.ir

import com.google.inject.Inject
import com.google.inject.Singleton
import fr.cea.nabla.ir.ir.IrFactory
import fr.cea.nabla.ir.ir.SimpleVariable
import fr.cea.nabla.nabla.Function
import fr.cea.nabla.nabla.FunctionOrReduction
import fr.cea.nabla.nabla.NablaModule
import fr.cea.nabla.nabla.Reduction
import org.eclipse.xtext.EcoreUtil2

@Singleton
class IrFunctionFactory 
{
	@Inject extension IrAnnotationHelper
	@Inject extension BaseType2IrType
	@Inject extension IrArgOrVarFactory
	@Inject extension IrInstructionFactory

	def dispatch create IrFactory::eINSTANCE.createFunction toIrFunction(Function f)
	{
		annotations += f.toIrAnnotation
		name = f.name
		provider = f.nablaModuleName
		f.variables.forEach[x | variables += x.toIrVariable as SimpleVariable]
		if (f.external)
		{
			// f is external. No inArgs only inArgTypes
			for (i : 0..<f.typeDeclaration.inTypes.size)
				inArgs += toIrArg(f.typeDeclaration.inTypes.get(i), "x" + i)
		}
		else
		{
			// f is internal, it has a inArgs and a body
			f.inArgs.forEach[x | inArgs += toIrArg(x, x.name)]
			body = f.body.toIrInstruction
		}
		returnType = f.typeDeclaration.returnType.toIrBaseType
	}

	def dispatch create IrFactory::eINSTANCE.createFunction toIrFunction(Reduction f)
	{
		val t = f.typeDeclaration.type
		annotations += f.toIrAnnotation
		// build a unique name with name and type
		name = f.name.toFirstLower + t.primitive.getName().charAt(0) + t.sizes.size
		provider = f.nablaModuleName
		f.variables.forEach[x | variables += x.toIrVariable as SimpleVariable]
		f.inArgs.forEach[x | inArgs += toIrArg(x, x.name)]
		returnType = t.toIrBaseType
		body = f.body.toIrInstruction
	}

	private def getNablaModuleName(FunctionOrReduction it) 
	{
		val module = EcoreUtil2.getContainerOfType(it, NablaModule)
		return module.name
	}
}