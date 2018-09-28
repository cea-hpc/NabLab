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

class Real3 
{
	@Accessors var double x
	@Accessors var double y	
	@Accessors var double z	

	new(double init)
	{
		this.x = init
		this.y = init
		this.z = init
	}
	
	new(double x, double y, double z)
	{
		this.x = x
		this.y = y
		this.z = z
	}

	def void operator_set(Real3 v)
	{
		this.x = v.x
		this.y = v.y
		this.z = v.z
	}

	def void operator_add(Real3 v)
	{
		this.x += v.x
		this.y += v.y
		this.z += v.z
	}

	def Real3 operator_multiply(int v) { new Real3(x*v, y*v, z*v) }
	def Real3 operator_multiply(double v) { new Real3(x*v, y*v, z*v) }
	def Real3 operator_multiply(Real3 v) { new Real3(x*v.x, y*v.y, z*v.z) }

	def Real3 operator_plus(int v) { new Real3(x+v, y+v, z+v) }
	def Real3 operator_plus(double v) { new Real3(x+v, y+v, z+v) }
	def Real3 operator_plus(Real3 v) { new Real3(x+v.x, y+v.y, z+v.z) }

	def Real3 operator_minus(int v) { new Real3(x-v, y-v, z-v) }
	def Real3 operator_minus(double v) { new Real3(x-v, y-v, z-v) }
	def Real3 operator_minus(Real3 v) { new Real3(x-v.x, y-v.y, z-v.z) }

	def Real3 operator_divide(int v) { new Real3(x/v, y/v, z/v) }
	def Real3 operator_divide(double v) { new Real3(x/v, y/v, z/v) }
	def Real3 operator_divide(Real3 v) { new Real3(x/v.x, y/v.y, z/v.z) }

	def Real3 operator_min(Real3 v) { new Real3(Math::min(x,v.x), Math::min(y,v.y), Math::min(z,v.z)) }
	def Real3 operator_max(Real3 v) { new Real3(Math::max(x,v.x), Math::max(y,v.y), Math::max(z,v.z)) }

	override toString()
	{
		'[' + x + ',' + y + ',' + z + ']'
	}
}