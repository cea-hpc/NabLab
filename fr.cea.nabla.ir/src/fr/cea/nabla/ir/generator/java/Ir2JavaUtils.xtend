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
package fr.cea.nabla.ir.generator.java

import fr.cea.nabla.ir.ir.BasicType

class Ir2JavaUtils 
{
	def getJavaType(BasicType t)
	{
		switch t
		{
			case VOID : 'void'
			case BOOL: 'boolean'
			case INT: 'int'
			case REAL: 'double'
			case REAL2: 'Real2'
			case REAL2X2: 'Real2x2'
			case REAL3: 'Real3'
			case REAL3X3: 'Real3x3'
		}
	}

	def isJavaBasicType(BasicType t)
	{
		switch t
		{
			case BOOL, case INT, case REAL: true
			default: false
		}
	}

	def getJavaOperator(String op) 
	{
		switch op
		{
			case '+': 'operator_plus'
			case '-': 'operator_minus'
			case '*': 'operator_multiply'
			case '/': 'operator_divide'
			case '+=': 'operator_add'
			case '=': 'operator_set'
			default: throw new RuntimeException("Pas d'équivalent Java pour l'opérateur : " + op)
		} 
	}
}