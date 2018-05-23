package fr.cea.nabla.javalib.types

import org.eclipse.xtend.lib.annotations.Accessors

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

	def Real2 operator_multiply(Real2 v) { new Real2(x*v.x, y*v.y) }
	def Real2 operator_multiply(double v) { new Real2(x*v, y*v) }
	def Real2 operator_multiply(int v) { new Real2(x*v, y*v) }
	def Real2 operator_minus(Real2 v) { new Real2(x-v.x, y-v.y) }
	def Real2 operator_minus(double v) { new Real2(x-v, y-v) }
	def Real2 operator_minus(int v) { new Real2(x-v, y-v) }
	def Real2 operator_plus(Real2 v) { new Real2(x+v.x, y+v.y) }
	def Real2 operator_plus(double v) { new Real2(x+v, y+v) }
	def Real2 operator_plus(int v) { new Real2(x+v, y+v) }
	def Real2 operator_divide(Real2 v) { new Real2(x/v.x, y/v.y) }
	def Real2 operator_divide(double v) { new Real2(x/v, y/v) }
	def Real2 operator_divide(int v) { new Real2(x/v, y/v) }
	def Real2 operator_min(Real2 v) { new Real2(Math::min(x,v.x), Math::min(y,v.y)) }
	def Real2 operator_max(Real2 v) { new Real2(Math::max(x,v.x), Math::max(y,v.y)) }

	override toString()
	{
		'[' + x + ',' + y + ']'
	}	
}