/*******************************************************************************
 * Copyright (c) 2022 CEA
 * This program and the accompanying materials are made available under the
 * terms of the Eclipse Public License 2.0 which is available at
 * http://www.eclipse.org/legal/epl-2.0.
 *
 * SPDX-License-Identifier: EPL-2.0
 * Contributors: see AUTHORS file
 *******************************************************************************/
package fr.cea.nabla.ir.transformers

import fr.cea.nabla.ir.ir.BinaryExpression
import fr.cea.nabla.ir.ir.DefaultExtensionProvider
import fr.cea.nabla.ir.ir.IrRoot
import fr.cea.nabla.ir.ir.UnaryExpression

class SetPythonOperatorNames extends IrTransformationStep
{
	public static val PythonOperatorNames = #{
		'&&' -> ' and ',
		'||' -> ' or ',
		'!' -> 'not '
	}

	override getDescription()
	{
		"Replace0 &&, ||, ! by and, or, not"
	}

	override transform(IrRoot ir, (String)=>void traceNotifier)
	{
		for (e : ir.eAllContents.filter(BinaryExpression).toIterable)
			for (opName : PythonOperatorNames.entrySet)
				if (e.operator == opName.key)
					e.operator = opName.value

		for (e : ir.eAllContents.filter(UnaryExpression).toIterable)
			for (opName : PythonOperatorNames.entrySet)
				if (e.operator == opName.key)
					e.operator = opName.value
	}

	override transform(DefaultExtensionProvider dep, (String)=>void traceNotifier)
	{
		// nothing to do
	}
}
