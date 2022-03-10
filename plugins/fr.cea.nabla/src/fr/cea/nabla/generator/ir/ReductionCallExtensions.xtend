/*******************************************************************************
 * Copyright (c) 2022 CEA
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
import fr.cea.nabla.nabla.FunctionOrReduction
import fr.cea.nabla.nabla.Job
import fr.cea.nabla.nabla.NablaModule
import fr.cea.nabla.nabla.ReductionCall
import fr.cea.nabla.overloading.DeclarationProvider
import org.eclipse.emf.ecore.EObject
import org.eclipse.emf.ecore.util.EcoreUtil

@Singleton	// Must be singleton because contains create methods
class ReductionCallExtensions 
{
	@Inject extension DeclarationProvider
	@Inject extension NablaType2IrType
	@Inject extension IrExpressionFactory

	def create IrFactory::eINSTANCE.createVariable toIrLocalVariable(ReductionCall rc)
	{
//		Disabled to distinguish derived variables from user-defined variables
//		annotations += rc.toNabLabFileAnnotation
		name = "reduction" + rc.number
		val d = rc.declaration
		val vType = d.type.toIrBaseType
		type = vType
		const = false
		constExpr = false
		option = false

		val seedExpression = d.model.seed.toIrExpression
		if (vType.sizes.empty) // scalar type
			defaultValue = seedExpression
		else
			defaultValue = IrFactory::eINSTANCE.createBaseTypeConstant =>
			[
				type = EcoreUtil::copy(vType)
				value = seedExpression
			]
	}

	private def getNumber(ReductionCall it)
	{
		container.eAllContents.filter(ReductionCall).toList.indexOf(it)
	}

	private def EObject getContainer(EObject o)
	{
		switch o
		{
			Job, NablaModule, FunctionOrReduction: o
			default: o.eContainer.container
		}
	}
}