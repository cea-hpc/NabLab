/*******************************************************************************
 * Copyright (c) 2021 CEA
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
import fr.cea.nabla.BaseTypeSizeEvaluator
import fr.cea.nabla.ConstExprServices
import fr.cea.nabla.LinearAlgebraUtils
import fr.cea.nabla.ir.ir.IrFactory
import fr.cea.nabla.nabla.DefaultExtension
import fr.cea.nabla.nabla.Function
import fr.cea.nabla.nabla.Reduction
import org.eclipse.xtext.EcoreUtil2

@Singleton
class IrFunctionFactory
{
	@Inject extension NabLabFileAnnotationFactory
	@Inject extension IrBasicFactory
	@Inject extension IrArgOrVarFactory
	@Inject extension IrInstructionFactory
	@Inject extension IrExpressionFactory
	@Inject extension LinearAlgebraUtils
	@Inject extension BaseTypeSizeEvaluator
	@Inject ConstExprServices constExprServices

	def toIrFunction(Function f)
	{
		if (f.external) f.toIrExternFunction
		else f.toIrInternFunction
	}

	def create IrFactory::eINSTANCE.createInternFunction toIrFunction(Reduction f)
	{
		val t = f.typeDeclaration.type
		annotations += f.toNabLabFileAnnotation
		// build a unique name with name and type
		name = f.name.toFirstLower + t.primitive.getName().charAt(0) + t.sizes.size
		f.variables.forEach[x | variables += x.toIrVariable]
		f.inArgs.forEach[x | inArgs += toIrArg(x)]
		returnType = t.toIrBaseType
		body = f.body.toIrInstruction
		constExpr = false
	}

	def create IrFactory::eINSTANCE.createInternFunction toIrInternFunction(Function f)
	{
		annotations += f.toNabLabFileAnnotation
		name = f.name
		f.variables.forEach[x | variables += x.toIrVariable]
		// f is internal, it has a inArgs and a body
		f.inArgs.forEach[x | inArgs += toIrArg(x)]
		body = f.body.toIrInstruction
		returnType = f.toIrReturnType
		constExpr = constExprServices.isConstExpr(f)
	}

	def create IrFactory::eINSTANCE.createExternFunction toIrExternFunction(Function f)
	{
		annotations += f.toNabLabFileAnnotation
		name = f.name
		val ext = EcoreUtil2.getContainerOfType(f, DefaultExtension)
		provider = ext.toIrDefaultExtensionProvider
		f.variables.forEach[x | variables += x.toIrVariable]
		// f is external. No inArgs only inArgTypes
		for (i : 0..<f.typeDeclaration.inTypes.size)
			inArgs += toIrArg(f.typeDeclaration.inTypes.get(i), "x" + i)
		returnType = f.toIrReturnType
	}

	private def toIrReturnType(Function f)
	{
		val la = f.linearAlgebraExtension
		if (la === null)
		{
			f.typeDeclaration.returnType.toIrBaseType
		}
		else
		{
			IrFactory.eINSTANCE.createLinearAlgebraType =>
			[
				provider = la.toIrDefaultExtensionProvider
				for (s : f.typeDeclaration.returnType.sizes)
				{
					sizes += s.toIrExpression
					intSizes += getIntSizeFor(s)
				}
				isStatic = intSizes.forall[x | x != -1]
			]
		}
	}
}