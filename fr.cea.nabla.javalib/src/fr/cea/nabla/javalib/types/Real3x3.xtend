package fr.cea.nabla.javalib.types

import org.eclipse.xtend.lib.annotations.Accessors

class Real3x3
{
	@Accessors var Real3 x
	@Accessors var Real3 y	
	@Accessors var Real3 z	

	new(double init)
	{
		this.x = new Real3(init)
		this.y = new Real3(init)
		this.z = new Real3(init)
	}

	new(Real3 x, Real3 y, Real3 z)
	{
		this.x = x
		this.y = y
		this.z = z
	}

	def void operator_set(Real3x3 v)
	{
		this.x = v.x
		this.y = v.y
		this.z = v.z
	}

	def void operator_add(Real3x3 v)
	{
		this.x += v.x
		this.y += v.y
		this.z += v.z
	}

	def Real3x3 operator_multiply(int v) { new Real3x3(x*v, y*v, z*v) }
	def Real3x3 operator_multiply(double v) { new Real3x3(x*v, y*v, z*v) }
	def Real3x3 operator_multiply(Real3x3 v) { new Real3x3(x*v.x, y*v.y, z*v.z) }

	def Real3x3 operator_divide(int v) { new Real3x3(x/v, y/v, z/v) }
	def Real3x3 operator_divide(double v) { new Real3x3(x/v, y/v, z/v) }

	def Real3x3 operator_plus(Real3x3 v) { new Real3x3(x+v.x, y+v.y, z+v.z) }

	def Real3x3 operator_minus(Real3x3 v) { new Real3x3(x-v.x, y-v.y, z-v.z) }

	def Real3x3 operator_min(Real3x3 v) { new Real3x3(x.operator_min(v.x), y.operator_min(v.y), z.operator_min(v.z)) }
	def Real3x3 operator_max(Real3x3 v) { new Real3x3(x.operator_max(v.x), y.operator_max(v.y), z.operator_max(v.z)) }

	override toString()
	{
		'[' + x + ',' + y + ',' + z + ']'
	}
}