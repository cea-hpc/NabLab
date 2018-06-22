package fr.cea.nabla.ir.transformers

import fr.cea.nabla.ir.ir.IrModule

class OptimizeConnectivities implements IrTransformationStep 
{
	static val ConnectivitiesToOptimize = #['cells', 'nodes', 'faces']
	
	override getDescription() 
	{
		'Annotate connectivities when Id and Index are equals (ex: cells)'
	}
	
	override transform(IrModule m) 
	{
		m.connectivities.forEach[c | if (ConnectivitiesToOptimize.contains(c.name)) c.indexEqualId = true]
	}
}