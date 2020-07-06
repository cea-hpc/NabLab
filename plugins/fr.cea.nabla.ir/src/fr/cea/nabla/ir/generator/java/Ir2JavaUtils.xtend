/*******************************************************************************
 * Copyright (c) 2020 CEA
 * This program and the accompanying materials are made available under the 
 * terms of the Eclipse Public License 2.0 which is available at
 * http://www.eclipse.org/legal/epl-2.0.
 *
 * SPDX-License-Identifier: EPL-2.0
 * Contributors: see AUTHORS file
 *******************************************************************************/
package fr.cea.nabla.ir.generator.java

import fr.cea.nabla.ir.Utils
import fr.cea.nabla.ir.ir.BaseType
import fr.cea.nabla.ir.ir.ConnectivityType
import fr.cea.nabla.ir.ir.Function
import fr.cea.nabla.ir.ir.PrimitiveType

class Ir2JavaUtils 
{
	static def getCodeName(Function it)
	{
		if (body === null)
			if (provider == "Math")
			{
				if (name == 'erf')
					// no erf function in java Math
					'org.apache.commons.math3.special.Erf.erf'
				else
					'Math.' + name
			}
			else provider.toFirstLower + Utils::FunctionReductionPrefix + '.' + name
		else name
	}

	static def dispatch String getJavaType(BaseType it)
	{
		if (it === null) return 'null'
		var ret = primitive.javaType
		for (s : sizes) ret += '[]'
		return ret
	}

	static def dispatch String getJavaType(ConnectivityType it)
	{
		if (it === null) return 'null'
		base.javaType + connectivities.map['[]'].join
	}

	static def dispatch String getJavaType(PrimitiveType t)
	{
		if (t === null) return 'null'
		switch t
		{
			case null: 'void'
			case BOOL: 'boolean'
			case INT: 'int'
			case REAL: 'double'
		}
	}
}