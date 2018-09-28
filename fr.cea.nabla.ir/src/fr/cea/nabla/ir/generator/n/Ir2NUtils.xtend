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
package fr.cea.nabla.ir.generator.n

import fr.cea.nabla.ir.ir.BasicType
import fr.cea.nabla.ir.ir.Iterator

class Ir2NUtils 
{	
	def getNType(BasicType t)
	{
		switch t
		{
			case VOID : 'void'
			case BOOL: '\u213E'
			case INT: '\u2115'
			case REAL: '\u211D'
			case REAL2: '\u211D\u00B2'
			case REAL2X2: '\u211D\u00B2\u02E3\u00B2'
			case REAL3: '\u211D\u00B3'
			case REAL3X3: '\u211D\u00B3\u02E3\u00B3'
		}
	}

	def getContent(Iterator it)
	'''«IF it!==null»∀ «range.connectivity.name»«ENDIF»'''
}