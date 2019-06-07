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
package fr.cea.nabla.javalib.types

import org.eclipse.xtend.lib.annotations.Accessors

/** Stockage par ligne (1 Real2 par ligne) */
class Real2 
{
	@Accessors var double x
	@Accessors var double y	

	new(double init)
	{
		this.x = init
		this.y = init
	}
	
	new(double x, double y)
	{
		this.x = x
		this.y = y
	}

	def void operator_set(Real2 v)
	{
		this.x = v.x
		this.y = v.y
	}
	
	def void operator_add(Real2 v)
	{
		this.x += v.x
		this.y += v.y
	}

	def Real2 operator_multiply(int v) { new Real2(x*v, y*v) }
	def Real2 operator_multiply(double v) { new Real2(x*v, y*v) }
	def Real2 operator_multiply(Real2 v) { new Real2(x*v.x, y*v.y) }
	
	def Real2 operator_plus(int v) { new Real2(x+v, y+v) }
	def Real2 operator_plus(double v) { new Real2(x+v, y+v) }
	def Real2 operator_plus(Real2 v) { new Real2(x+v.x, y+v.y) }

	def Real2 operator_minus(int v) { new Real2(x-v, y-v) }
	def Real2 operator_minus(double v) { new Real2(x-v, y-v) }
	def Real2 operator_minus(Real2 v) { new Real2(x-v.x, y-v.y) }
	def Real2 operator_minus() { new Real2(0-x, 0-y) }
	
	def Real2 operator_divide(int v) { new Real2(x/v, y/v) }
	def Real2 operator_divide(double v) { new Real2(x/v, y/v) }
	def Real2 operator_divide(Real2 v) { new Real2(x/v.x, y/v.y) }

	def Real2 operator_min(Real2 v) { new Real2(Math::min(x,v.x), Math::min(y,v.y)) }
	def Real2 operator_max(Real2 v) { new Real2(Math::max(x,v.x), Math::max(y,v.y)) }

	override toString()
	{
		'[' + x + ',' + y + ']'
	}	
}