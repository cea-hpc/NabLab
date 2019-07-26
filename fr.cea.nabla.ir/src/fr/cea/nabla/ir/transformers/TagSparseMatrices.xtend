package fr.cea.nabla.ir.transformers

import fr.cea.nabla.ir.ir.ConnectivityVariable
import fr.cea.nabla.ir.ir.IrModule

class TagSparseMatrices implements IrTransformationStep
{
	val String[] sparseMatrixNames
	
	new(String[] sparseMatrixNames)
	{
		this.sparseMatrixNames = sparseMatrixNames
	}
	
	override getDescription() 
	{
		'Tag matrices as sparse'
	}
	
	override transform(IrModule m) 
	{
		val candidates = m.variables.filter(ConnectivityVariable)
		for (sparseMatrixName : sparseMatrixNames)
		{
			val v = candidates.findFirst[x | x.name == sparseMatrixName]
			if (v !== null) v.sparseMatrix = true
		}
		return true
	}
	
	override getOutputTraces() 
	{
		#[]
	}
}