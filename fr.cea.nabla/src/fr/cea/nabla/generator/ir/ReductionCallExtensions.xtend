/*******************************************************************************
 * Copyright (c) 2018 CEA
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
import fr.cea.nabla.ir.Utils
import fr.cea.nabla.ir.ir.IrFactory
import fr.cea.nabla.ir.ir.Scalar
import fr.cea.nabla.nabla.ReductionCall
import fr.cea.nabla.typing.DeclarationProvider
import org.eclipse.emf.ecore.util.EcoreUtil

/**
 * Attention : cette classe doit être un singleton car elle utilise des méthodes create.
 * Si elle n'est pas singleton, plusieurs instances d'un même objet seront créées (voir la documentation Xtext).
 */
@Singleton
class ReductionCallExtensions 
{
	@Inject extension DeclarationProvider
	@Inject extension NablaType2IrType
	@Inject extension IrExpressionFactory
	
	def create IrFactory::eINSTANCE.createSimpleVariable toIrLocalVariable(ReductionCall rc)
	{
		name = 'reduction' + Utils::hashString(rc)
		val d = rc.declaration
		val vType = d.returnType.toIrBaseType
		type = vType
		
		val seedExpression = d.model.seed.toIrExpression
		if (vType instanceof Scalar)
			defaultValue = seedExpression
		else
			defaultValue = IrFactory::eINSTANCE.createBaseTypeConstant =>
			[
				type = EcoreUtil::copy(vType)
				value = seedExpression
			]	
	}
}