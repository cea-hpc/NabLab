package fr.cea.nabla.ir.generator.n

class DirtyPatchProvider 
{
	def getFileHeader()
	'''
		with ℝ²; // On est en 2D!!!
		
		// Il nous faut ca
		ℝ³ perp(ℝ³ α, ℝ³ β){ return ℝ³(β.y-α.y,-β.x+α.x,0.0);}
		ℝ trace(ℝ³ˣ³ M){return M.x.x+M.y.y+M.z.z;}
		
		// Et ca
		#define tensProduct opProdTens
		#define matVectProduct opProdTensVec
		//#define id3 matrix3x3Id();	
	'''
	
	def getBackendImplicitVariables() { #['deltat'] }
}