/*******************************************************************************
 * Copyright (c) 2020 CEA
 * This program and the accompanying materials are made available under the 
 * terms of the Eclipse Public License 2.0 which is available at
 * http://www.eclipse.org/legal/epl-2.0.
 *
 * SPDX-License-Identifier: EPL-2.0
 * Contributors: see AUTHORS file
 *******************************************************************************/
package fr.cea.nabla.ir.interpreter

import fr.cea.nabla.ir.ir.PrimitiveType
import fr.cea.nabla.javalib.types.Matrix
import fr.cea.nabla.javalib.types.Vector
import fr.cea.nabla.ir.ir.BaseType
import fr.cea.nabla.ir.ir.ConnectivityType
import fr.cea.nabla.ir.ir.LinearAlgebraType

class FunctionCallHelper
{
	static def dispatch Class<?> getJavaType(BaseType it) { getJavaType(primitive, sizes.size, false )}
	static def dispatch Class<?> getJavaType(ConnectivityType it) { getJavaType(base.primitive, (connectivities+base.sizes).size, false )}
	static def dispatch Class<?> getJavaType(LinearAlgebraType it) { getJavaType(PrimitiveType::REAL, sizes.size, true )}

	private static def Class<?> getJavaType(PrimitiveType primitive, int dimension, boolean linearAlgebra)
	{
		switch (primitive)
		{
			case BOOL: 
			{
				switch dimension
				{
					case 0: typeof(boolean)
					case 1: typeof(boolean[])
					case 2: typeof(boolean[][])
					default: throw new RuntimeException("Dimension not implemented: " + dimension) 
				}
			}
			case INT:
			{
				switch dimension
				{
					case 0: typeof(int)
					case 1: typeof(int[])
					case 2: typeof(int[][])
					default: throw new RuntimeException("Dimension not implemented: " + dimension) 
				}
			}
			case REAL:
			{
				switch dimension
				{
					case 0: typeof(double)
					case 1: if (linearAlgebra) typeof(Vector) else typeof(double[])
					case 2: if (linearAlgebra) typeof(Matrix) else typeof(double[][])
					default: throw new RuntimeException("Dimension not implemented: " + dimension) 
				}
			}
		}
	}

	static def dispatch Object getJavaValue(NV0Bool it) { data }
	static def dispatch Object getJavaValue(NV1Bool it) { data }
	static def dispatch Object getJavaValue(NV2Bool it) { data }
	static def dispatch Object getJavaValue(NV0Int it) { data }
	static def dispatch Object getJavaValue(NV1Int it) { data }
	static def dispatch Object getJavaValue(NV2Int it) { data }
	static def dispatch Object getJavaValue(NV0Real it) { data }
	static def dispatch Object getJavaValue(NV1Real it) { data }
	static def dispatch Object getJavaValue(NVVector it) { data }
	static def dispatch Object getJavaValue(NV2Real it) { data }
	static def dispatch Object getJavaValue(NVMatrix it) { data }

	static def dispatch createNablaValue(Object x) { throw new RuntimeException('Not yet implemented') }
	static def dispatch createNablaValue(Boolean x) { new NV0Bool(x) }
	static def dispatch createNablaValue(boolean[] x) { new NV1Bool(x) }
	static def dispatch createNablaValue(boolean[][] x) { new NV2Bool(x) }
	static def dispatch createNablaValue(Integer x) { new NV0Int(x) }
	static def dispatch createNablaValue(int[] x) { new NV1Int(x) }
	static def dispatch createNablaValue(int[][] x) { new NV2Int(x) }
	static def dispatch createNablaValue(Double x) { new NV0Real(x) }
	static def dispatch createNablaValue(double[] x) { new NV1Real(x) }
	static def dispatch createNablaValue(Vector x) { new NVVector(x) }
	static def dispatch createNablaValue(double[][] x) { new NV2Real(x) }
	static def dispatch createNablaValue(Matrix x) { new NVMatrix(x) }
}