package fr.cea.nabla.ir.transformers

import fr.cea.nabla.ir.ir.IrModule
import fr.cea.nabla.ir.ir.ReductionInstruction
import fr.cea.nabla.ir.ir.ScalarVarDefinition

class ReplaceUtf8 implements IrTransformationStage 
{
	override getDescription() 
	{
		'Replace UTF8 characters in function, variable and job names by ASCII characters'
	}
	
	override transform(IrModule m) 
	{
		m.variables.forEach[x | x.name = x.name.noUtf8]
		for (svd : m.eAllContents.filter(ScalarVarDefinition).toIterable)
			svd.variables.forEach[x | x.name = x.name.noUtf8]
		m.eAllContents.filter(ReductionInstruction).forEach[x | x.variable.name = x.variable.name.noUtf8]
		m.connectivities.forEach[x | x.name = x.name.noUtf8]
		m.functions.forEach[x | x.name = x.name.noUtf8]
		m.reductions.forEach[x | x.name = x.name.noUtf8]
		m.jobs.forEach[x | x.name = x.name.noUtf8]
	}
	
	private def getNoUtf8(String name)
	{
		name.replace('\u03B1', 'alpha')
		.replace('\u03B2', 'beta')
		.replace('\u03B3', 'gamma')
		.replace('\u03B4', 'delta')
		.replace('\u03F5', 'epsilon')
		.replace('\u03BB', 'lambda')
		.replace('\u03C1', 'rho')
		.replace('\u2126', 'omega')
		.replace('\u221A', 'sqrt')
		.replace('\u2211', 'sum')
	}
}