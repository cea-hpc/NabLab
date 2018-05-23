package fr.cea.nabla.javalib.types

import org.eclipse.xtend.lib.annotations.Accessors

class Real2x2
{
	@Accessors var Real2 x
	@Accessors var Real2 y	

	new(double init)
	{
		this.x = new Real2(init)
		this.y = new Real2(init)
	}

	new(Real2 x, Real2 y)
	{
		this.x = x
		this.y = y
	}

	def void operator_set(Real2x2 v)
	{
		this.x = v.x
		this.y = v.y
	}

	def void operator_add(Real2x2 v)
	{
		this.x += v.x
		this.y += v.y
	}

	def Real2x2 operator_multiply(Real2 v) { new Real2x2(x*v.x, y*v.y) }
	def Real2x2 operator_multiply(double v) { new Real2x2(x*v, y*v) }
	def Real2x2 operator_multiply(int v) { new Real2x2(x*v, y*v) }
	def Real2x2 operator_minus(Real2x2 v) { new Real2x2(x-v.x, y-v.y) }
	def Real2x2 operator_minus(Real2 v) { new Real2x2(x-v.x, y-v.y) }
	def Real2x2 operator_minus(double v) { new Real2x2(x-v, y-v) }
	def Real2x2 operator_minus(int v) { new Real2x2(x-v, y-v) }
	def Real2x2 operator_plus(Real2x2 v) { new Real2x2(x+v.x, y+v.y) }
	def Real2x2 operator_plus(Real2 v) { new Real2x2(x+v.x, y+v.y) }
	def Real2x2 operator_plus(double v) { new Real2x2(x+v, y+v) }
	def Real2x2 operator_plus(int v) { new Real2x2(x+v, y+v) }
	def Real2x2 operator_divide(Real2 v) { new Real2x2(x/v.x, y/v.y) }
	def Real2x2 operator_divide(double v) { new Real2x2(x/v, y/v) }
	def Real2x2 operator_divide(int v) { new Real2x2(x/v, y/v) }
	def Real2x2 operator_min(Real2x2 v) { new Real2x2(x.operator_min(v.x), y.operator_min(v.y)) }
	def Real2x2 operator_max(Real2x2 v) { new Real2x2(x.operator_max(v.x), y.operator_max(v.y)) }

	override toString()
	{
		'[' + x + ',' + y + ']'
	}
}