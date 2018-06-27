package fr.cea.nabla.ir.transformers

import fr.cea.nabla.ir.ir.IrModule

class ConfigureNablaConnectivities implements IrTransformationStep 
{
	static val NablaConnectivities = #{'cellsOfNode' -> 'cells', 
		'nodesOfCell' -> 'nodes', 
		'nodesOfFace' -> 'nodes', 
		'innerNodes' -> 'inner nodes',
		'outerFaces' -> 'outer faces'}

	override getDescription() 
	{
		'Configure Nabla connectivities: ' + NablaConnectivities.values.join(', ') 
	}
	
	override transform(IrModule m) 
	{
		m.connectivities.forEach[c | c.name = NablaConnectivities.getOrDefault(c.name, c.name)]
		return true
	}
}