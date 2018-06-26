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
	
	def static double matrixDeterminant(Real2x2 m)
	{
		0.0
	}
	
	def static Real2x2 inverseMatrix(Real2x2 m, double d)
	{
		new Real2x2(0.0)
  	}
  	
  	def static Real2 perp(Real2 a, Real2 b)
  	{
		new Real2(0.0)
  	}
}