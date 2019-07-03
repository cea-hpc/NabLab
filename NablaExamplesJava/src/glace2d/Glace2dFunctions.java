package glace2d;

import fr.cea.nabla.javalib.types.Real2;
import fr.cea.nabla.javalib.types.Real2x2;

import static fr.cea.nabla.javalib.types.MathFunctions.dot;

public class Glace2dFunctions 
{
	public static Real2x2 tensProduct(Real2 a, Real2 b)
	{
		return new Real2x2(b.operator_multiply(a.getX()), b.operator_multiply(a.getY()));
	}

	public static Real2 matVectProduct(Real2x2 a, Real2 b)
	{
		return new Real2(dot(a.getX(), b), dot(a.getY(), b));
	}
	
	public static double det(Real2x2 a)
	{
		return a.getX().getX() * a.getY().getY() - a.getX().getY() * a.getY().getX();
	}
	
	public static double trace(Real2x2 a)
	{
		return a.getX().getX() + a.getY().getY();
	}
	
	public static Real2x2 inverse(Real2x2 m)
	{
		Real2 ra = new Real2(m.getY().getY(), -m.getX().getY());
		Real2 rb = new Real2(-m.getY().getX(), m.getX().getX());
		Real2x2 r = new Real2x2(ra, rb);
		return r.operator_multiply(1.0/det(m));
 	}
  	
	public static Real2 perp(Real2 a)
  	{
		return new Real2(a.getY(), -a.getX());
  	}
}
