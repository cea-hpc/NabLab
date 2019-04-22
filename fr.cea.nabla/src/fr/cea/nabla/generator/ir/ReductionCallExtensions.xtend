/*******************************************************************************
 * Copyright (c) 2018 CEA
 * This program and the accompanying materials are made available under the 
 * terms of the Eclipse Public License 2.0 which is available at
 * http://www.eclipse.org/legal/epl-2.0.
 *
 * SPDX-License-Identifier: EPL-2.0
 *
 * Contributors:
 * 	Benoit Lelandais - initial implementation
 * 	Marie-Pierre Oudot - initial implementation
 * 	Jean-Sylvain Camier - Nabla generation support
 *******************************************************************************/
package fr.cea.nabla.generator.ir

import com.google.inject.Inject
import com.google.inject.Singleton
import fr.cea.nabla.FunctionCallExtensions
import fr.cea.nabla.ir.Utils
import fr.cea.nabla.ir.ir.IrFactory
import fr.cea.nabla.nabla.ReductionCall

/**
 * Attention : cette classe doit être un singleton car elle utilise des méthodes create.
 * Si elle n'est pas singleton, plusieurs instances d'un même objet seront créées (voir la documentation Xtext).
 */
@Singleton
class ReductionCallExtensions 
{
	@Inject extension FunctionCallExtensions
	@Inject extension Nabla2IrUtils
	@Inject extension IrExpressionFactory
	
	def create IrFactory::eINSTANCE.createScalarVariable toIrLocalVariable(ReductionCall rc)
	{
		name = rc.reduction.name + Utils::hashString(rc)
		type = rc.declaration.returnType.toIrBasicType
		defaultValue = rc.declaration.seed.toIrExpression
	}
}