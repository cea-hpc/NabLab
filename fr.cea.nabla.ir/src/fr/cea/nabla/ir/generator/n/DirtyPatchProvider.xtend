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
package fr.cea.nabla.ir.generator.n

class DirtyPatchProvider 
{
	def getFileHeader()
	'''
		with ℝ²; // On est en 2D!!!
		
		// Il nous faut ca
		//ℝ³ perp(ℝ³ α, ℝ³ β){ return ℝ³(β.y-α.y,-β.x+α.x,0.0);}
		ℝ³ perp(ℝ³ a){ return ℝ³(a.y,-a.x,0.0);}
		ℝ trace(ℝ³ˣ³ M){return M.x.x+M.y.y+M.z.z;}
		ℝ³ˣ³ inverse(ℝ³ˣ³ M) { 
			ℝ det = matrixDeterminant(M);
			//assert(det!=0.0);
			return inverseMatrix(M,det);
		}

		// Et ca
		#define tensProduct opProdTens
		#define matVectProduct opProdTensVec
		//#define id3 matrix3x3Id();	
	'''
}