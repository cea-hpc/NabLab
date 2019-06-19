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
package fr.cea.nabla

import com.google.inject.Inject
import fr.cea.nabla.nabla.BaseType
import fr.cea.nabla.nabla.Expression
import fr.cea.nabla.nabla.FunctionArg
import fr.cea.nabla.nabla.FunctionCall
import fr.cea.nabla.nabla.ReductionArg
import fr.cea.nabla.nabla.ReductionCall
import fr.cea.nabla.typing.ExpressionTypeProvider
import java.util.List

class FunctionCallExtensions 
{
	@Inject extension ExpressionTypeProvider
	
	def FunctionArg getDeclaration(FunctionCall it)
	{
		function.argGroups.findFirst[x | match(x.inTypes, args)]
	}

	def ReductionArg getDeclaration(ReductionCall it)
	{
		reduction.argGroups.findFirst[x | match(x.collectionType, arg)]
	}

	private def boolean match(List<BaseType> a, List<Expression> b) 
	{
		if (a.size != b.size) return false
		for (i : 0..<a.size)
			if (!match(a.get(i), b.get(i))) return false
		return true
	}
	
	private def boolean match(BaseType a, Expression b)
	{
		a.typeFor == b.typeFor
	}
}