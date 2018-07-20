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
package fr.cea.nabla.javalib.types

class MathFunctions 
{
	def static double fabs(double v) { Math::abs(v) }
	def static double sqrt(double v) { Math::sqrt(v) }
	def static double min(double a, double b) { Math::min(a, b) }
	def static double max(double a, double b) { Math::max(a, b) }
	def static double reduceMin(double a, double b) { Math::min(a, b) }
	def static double reduceMax(double a, double b) { Math::max(a, b) }
	def static double sin(double v) { Math::sin(v) }
	def static double cos(double v) { Math::cos(v) }
	def static double asin(double v) { Math::asin(v) }
	def static double acos(double v) { Math::acos(v) }

	def static double dot(Real2 a, Real2 b)
	{
		(a.x*b.x) + (a.y*b.y)
	}

	def static double dot(Real3 a, Real3 b)
	{
		(a.x*b.x) + (a.y*b.y) + (a.z*b.z)
	}

	def static double norm(Real2 a)
	{
		Math::sqrt(dot(a,a))
	}
	
	def static double norm(Real3 a)
	{
		Math::sqrt(dot(a,a))
	}
	
	def static double det(Real2 a, Real2 b)
	{
		a.x*b.y - a.y*b.x
	}
}