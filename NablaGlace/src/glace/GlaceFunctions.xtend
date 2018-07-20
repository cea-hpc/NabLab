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
 * 	Jean-Sylvan Camier - Nabla generation support
 *******************************************************************************/
package glace

import fr.cea.nabla.javalib.types.Real3
import fr.cea.nabla.javalib.types.Real3x3

import static fr.cea.nabla.javalib.types.MathFunctions.*

class GlaceFunctions 
{
	def static double trace(Real3x3 r)
	{
		r.x.x + r.y.y + r.z.z
	}
	
	def static Real3 perp(Real3 a, Real3 b)
	{
		new Real3(b.y-a.y, b.x+a.x, 0.0)
	}
	
	def static Real3x3 matrix3x3Id()
	{
		val x = new Real3(1.0, 0.0, 0.0);
		val y = new Real3(0.0, 1.0, 0.0);
		val z = new Real3(0.0, 0.0, 1.0);
		new Real3x3(x, y, z);
	}
	
	def static Real3x3 tensProduct(Real3 a, Real3 b)
	{
		new Real3x3(b*a.x, b*a.y, b*a.z)
	}
	
	def static Real3 matVectProduct(Real3x3 a, Real3 b)
	{
		new Real3(dot(a.x, b), dot(a.y, b), dot(a.z, b))
	}
	
	def static double matrixDeterminant(Real3x3 m)
	{
		m.x.x * (m.y.y*m.z.z - m.y.z*m.z.y) +
		m.x.y * (m.y.z*m.z.x - m.y.x*m.z.z) +
		m.x.z * (m.y.x*m.z.y - m.y.y*m.z.x)
	}
	
	def static Real3x3 inverseMatrix(Real3x3 m, double d)
	{
		val x = new Real3(m.y.y*m.z.z-m.y.z*m.z.y,
                    -m.x.y*m.z.z+m.x.z*m.z.y,
                    m.x.y*m.y.z-m.x.z*m.y.y)
        val y = new Real3(m.z.x*m.y.z-m.y.x*m.z.z,
                    -m.z.x*m.x.z+m.x.x*m.z.z,
                    m.y.x*m.x.z-m.x.x*m.y.z)
        val z = new Real3(-m.z.x*m.y.y+m.y.x*m.z.y,
                    m.z.x*m.x.y-m.x.x*m.z.y,
                    -m.y.x*m.x.y+m.x.x*m.y.y)  
  		val inv = new Real3x3(x,y,z)
  		
  		return inv / d
  	}
}