package fr.cea.nabla.ir.transformers

import fr.cea.nabla.ir.ir.ConnectivityVariable
import fr.cea.nabla.ir.ir.IrFactory
import fr.cea.nabla.ir.ir.IrModule
import fr.cea.nabla.ir.ir.PrimitiveType
import fr.cea.nabla.ir.ir.SimpleVariable
import java.util.HashMap
import org.eclipse.emf.ecore.util.EcoreUtil
import org.eclipse.xtend.lib.annotations.Accessors

/**
 * Attend des propriétés de type <nom_de_variable> = <nom_de_persistence>.
 * Le <nom_de_variable> représente lae nom de la vraible du code.
 * Le <nom_de_persistence> représente un alias qui sera généralement donné en dépouillement. 
 */
class TagPersistentVariables implements IrTransformationStep 
{
	val HashMap<String, String> variables
	@Accessors int iterationPeriod = -1;
	@Accessors double timeStep = -1;
	
	new(HashMap<String, String> variables)
	{
		this.variables = variables
	}
	
	override getDescription() 
	{
		'Tag variables as persistent'
	}
	
	override transform(IrModule m) 
	{
		val candidates = m.variables.filter(ConnectivityVariable)
		
		// Create InSituJob
		val inSituJob = IrFactory.eINSTANCE.createInSituJob
		inSituJob.name = 'dumpVariables'
		inSituJob.iterationPeriod = iterationPeriod
		inSituJob.timeStep = timeStep
		for (key : variables.keySet)
		{
			val v = candidates.findFirst[x | x.name == key]
			if (v !== null) 
			{
				v.persistenceName = variables.get(key)
				inSituJob.variables += v
			}
		}
		m.jobs += inSituJob
		
		if (timeStep > 0)
		{
			// Create a variable to store the last write time
			val tVariable = m.variables.filter(SimpleVariable).findFirst[x | x.name == 't']
			if (tVariable !== null)
			{
				val realType = IrFactory.eINSTANCE.createScalar => [ primitive = PrimitiveType::REAL ]
				val twriter = IrFactory.eINSTANCE.createSimpleVariable =>
				[
					name = 'lastWriteTime'
					type = realType
					defaultValue = IrFactory.eINSTANCE.createVarRef =>
					[
						variable = tVariable
						type = EcoreUtil.copy(realType)
					]
				]
				m.variables += twriter
			}
		}

		return true
	}
	
	override getOutputTraces() 
	{
		#[]
	}
}