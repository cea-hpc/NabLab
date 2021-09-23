/*******************************************************************************
 * Copyright (c) 2021 CEA
 * This program and the accompanying materials are made available under the 
 * terms of the Eclipse Public License 2.0 which is available at
 * http://www.eclipse.org/legal/epl-2.0.
 *
 * SPDX-License-Identifier: EPL-2.0
 * Contributors: see AUTHORS file
 *******************************************************************************/
package fr.cea.nabla.typing

import com.google.inject.Inject
import fr.cea.nabla.BaseTypeSizeEvaluator
import org.eclipse.emf.ecore.util.EcoreUtil

class BinaryOperationsTypeProvider
{
	@Inject extension BaseTypeSizeEvaluator

	def dispatch NablaSimpleType getTypeFor(NablaSimpleType a, NablaSimpleType b, String op)
	{
		null
	}	

	// BOOL: useful for type validator (unused by type provider)
	def dispatch NablaSimpleType getTypeFor(NSTBoolScalar a, NSTBoolScalar b, String op)
	{
		switch op
		{
			case '||', case '&&', case '==', case '!=', case '>=', case '<=', case '>', case'<': b
			default: null
		}
	}

	// INT
	def dispatch NablaSimpleType getTypeFor(NSTIntScalar a, NSTIntScalar b, String op)
	{
		switch op
		{
			// useful for type validator (unused by type provider)
			case '==', case '!=', case '>=', case '<=', case '>', case'<': new NSTBoolScalar
			case '+', case '-', case '*', case '/', case '%': b
			default: null
		}
	}

	def dispatch NablaSimpleType getTypeFor(NSTIntScalar a, NSTRealScalar b, String op)
	{
		getTypeFor(new NSTRealScalar, b, op)
	}

	def dispatch NablaSimpleType getTypeFor(NSTIntScalar a, NSTIntArray1D b, String op)
	{
		switch op
		{
			case '+', case '*': getTypeFor(b, a, op)  // Commutative operations
			default: null
		}
	}

	def dispatch NablaSimpleType getTypeFor(NSTIntScalar a, NSTRealArray1D b, String op)
	{
		getTypeFor(new NSTRealScalar, b, op)
	}

	def dispatch NablaSimpleType getTypeFor(NSTIntScalar a, NSTIntArray2D b, String op)
	{
		switch op
		{
			case '+', case '*': getTypeFor(b, a, op)  // Commutative operations
			default: null
		}
	}

	def dispatch NablaSimpleType getTypeFor(NSTIntScalar a, NSTRealArray2D b, String op)
	{
		getTypeFor(new NSTRealScalar, b, op)
	}

	// REAL
	def dispatch NablaSimpleType getTypeFor(NSTRealScalar a, NSTIntScalar b, String op)
	{
		getTypeFor(a, new NSTRealScalar, op)
	}

	def dispatch NablaSimpleType getTypeFor(NSTRealScalar a, NSTRealScalar b, String op)
	{
		switch op
		{
			// useful for type validator (unused by type provider)
			case '==', case '!=', case '>=', case '<=', case '>', case'<': new NSTBoolScalar
			case '+', case '-', case '*', case '/', case ':': b
			default: null
		}
	}

	def dispatch NablaSimpleType getTypeFor(NSTRealScalar a, NSTIntArray1D b, String op)
	{
		switch op
		{
			case '+', case '*': getTypeFor(b, a, op) // Commutative operations
			default: null
		}
	}

	def dispatch NablaSimpleType getTypeFor(NSTRealScalar a, NSTRealArray1D b, String op)
	{
		switch op
		{
			case '+', case '*': new NSTRealArray1D(b.size, getIntSizeFor(b.size))
			default: null
		}
	}

	def dispatch NablaSimpleType getTypeFor(NSTRealScalar a, NSTIntArray2D b, String op)
	{
		switch op
		{
			case '+', case '*': getTypeFor(b, a, op) // Commutative operations
			default: null
		}
	}
	
	def dispatch NablaSimpleType getTypeFor(NSTRealScalar a, NSTRealArray2D b, String op)
	{
		switch op
		{
			case '+', case '*': getTypeFor(b, a, op) // Commutative operations
			default: null
		}
	}

	// INT ARRAYS 1D
	def dispatch NablaSimpleType getTypeFor(NSTIntArray1D a, NSTIntScalar b, String op)
	{
		switch op
		{
			case '+', case '-', case '*', case '/': a
			default: null
		}
	}

	def dispatch NablaSimpleType getTypeFor(NSTIntArray1D a, NSTRealScalar b, String op)
	{
		switch op
		{
			case '+', case '-', case '*', case '/': new NSTRealArray1D(a.size, getIntSizeFor(a.size))
			default: null
		}
	}

	def dispatch NablaSimpleType getTypeFor(NSTIntArray1D a, NSTIntArray1D b, String op)
	{
		switch op
		{
			case !haveSameDimensions(a, b) : null
			case '+', case '-', case '*', case '/': b
			default: null
		}
	}
	
	def dispatch NablaSimpleType getTypeFor(NSTIntArray1D a, NSTRealArray1D b, String op)
	{
		switch op
		{
			case !haveSameDimensions(a, b) : null
			case '+', case '-', case '*', case '/': b
			default: null
		}
	}
		
	// REAL ARRAYS 1D
	def dispatch NablaSimpleType getTypeFor(NSTRealArray1D a, NSTIntScalar b, String op)
	{
		getTypeFor(a, new NSTRealScalar, op)
	}

	def dispatch NablaSimpleType getTypeFor(NSTRealArray1D a, NSTRealScalar b, String op)
	{
		switch op
		{
			case '+', case '-', case '*', case '/': a
			default: null
		}
	}

	def dispatch NablaSimpleType getTypeFor(NSTRealArray1D a, NSTIntArray1D b, String op)
	{
		switch op
		{
			case !haveSameDimensions(a, b) :  null
			case '+', case '-', case '*', case '/': a
			default: null
		}
	}

	def dispatch NablaSimpleType getTypeFor(NSTRealArray1D a, NSTRealArray1D b, String op)
	{
		switch op
		{
			case !haveSameDimensions(a, b) :  null
			case '+', case '-', case '*', case '/': a
			default: null
		}
	}
	
	// INT ARRAYS 2D
	def dispatch NablaSimpleType getTypeFor(NSTIntArray2D a, NSTIntScalar b, String op)
	{
		switch op
		{
			case '+', case '-', case '*', case '/': a
			default: null
		}
	}

	def dispatch NablaSimpleType getTypeFor(NSTIntArray2D a, NSTRealScalar b, String op)
	{
		switch op
		{
			case '+', case '-', case '*', case '/': new NSTRealArray2D(a.nbRows, a.nbCols, getIntSizeFor(a.nbRows), getIntSizeFor(a.nbCols))
			default: null
		}
	}

	def dispatch NablaSimpleType getTypeFor(NSTIntArray2D a, NSTIntArray2D b, String op)
	{
		switch op
		{
			case !haveSameDimensions(a, b) :  null
			case '+', case '-', case '*': a
			default: null
		}
	}

	// REAL ARRAYS 2D
	def dispatch NablaSimpleType getTypeFor(NSTRealArray2D a, NSTIntScalar b, String op)
	{
		getTypeFor(a, new NSTRealScalar, op)
	}

	def dispatch NablaSimpleType getTypeFor(NSTRealArray2D a, NSTRealScalar b, String op)
	{
		switch op
		{
			case '+', case '-', case '*', case '/': a
			default: null
		}
	}

	def dispatch NablaSimpleType getTypeFor(NSTRealArray2D a, NSTRealArray2D b, String op)
	{
		switch op
		{
			case !haveSameDimensions(a, b) :  null
			case '+', case '-', case '*': a
			default: null
		}
	}

	private def haveSameDimensions(NSTArray1D a, NSTArray1D b)
	{
		EcoreUtil::equals(a.size, b.size)
	}

	private def haveSameDimensions(NSTArray2D a, NSTArray2D b)
	{
		EcoreUtil::equals(a.nbRows, b.nbRows) 
		&& EcoreUtil::equals(a.nbCols, b.nbCols)
	}
}