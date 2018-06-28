package glace2d

import fr.cea.nabla.javalib.types.Real2
import fr.cea.nabla.javalib.types.Real2x2

import static fr.cea.nabla.javalib.types.MathFunctions.*

class Glace2dFunctions 
{
	def static Real2x2 tensProduct(Real2 a, Real2 b)
	{
		new Real2x2(b*a.x, b*a.y)
	}

	def static Real2 matVectProduct(Real2x2 a, Real2 b)
	{
		new Real2(dot(a.x, b), dot(a.y, b))
	}
	
	def static double det(Real2x2 a)
	{
		a.x.x * a.y.y - a.x.y * a.y.x
	}
	
	def static double trace(Real2x2 a)
	{
		a.x.x + a.y.y
	}
	
	def static Real2x2 inverse(Real2x2 m)
	{
		val r = new Real2x2(new Real2(m.y.y, -m.x.y), new Real2(-m.y.x, m.x.x))
		r * (1.0/det(m))
 	}
  	
  	def static Real2 perp(Real2 a)
  	{
		new Real2(a.y, -a.x)
  	}
}