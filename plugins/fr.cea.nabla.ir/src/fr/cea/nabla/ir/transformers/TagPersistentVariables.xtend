package fr.cea.nabla.ir.transformers

import fr.cea.nabla.ir.ir.ConnectivityVariable
import fr.cea.nabla.ir.ir.IrFactory
import fr.cea.nabla.ir.ir.IrModule
import fr.cea.nabla.ir.ir.SimpleVariable
import java.util.HashMap
import org.eclipse.emf.ecore.util.EcoreUtil

/**
 * Attend des propriétés de type <nom_de_variable> = <nom_de_persistence>.
 * Le <nom_de_variable> représente lae nom de la vraible du code.
 * Le <nom_de_persistence> représente un alias qui sera généralement donné en dépouillement. 
 */
class TagPersistentVariables implements IrTransformationStep 
{
	public static val LastDumpVariableName = "lastDump" // Useful for InSituJob

	val String timeVariableName
	val String iterationVariableName
	val HashMap<String, String> dumpedVariables
	val double periodValue
	val String periodVariableName

	new(String timeVariableName, String iterationVariableName, HashMap<String, String> dumpedVariables, double periodValue, String periodVariableName)
	{
		this.timeVariableName = timeVariableName
		this.iterationVariableName = iterationVariableName
		this.dumpedVariables = dumpedVariables
		this.periodValue = periodValue
		this.periodVariableName = periodVariableName
	}

	override getDescription()
	{
		'Tag variables as persistent'
	}

	override transform(IrModule m)
	{
		// Create InSituJob
		val inSituJob = IrFactory.eINSTANCE.createInSituJob
		inSituJob.name = 'dumpVariables'
		inSituJob.periodValue = periodValue
		
		val timeVariable = m.variables.filter(SimpleVariable).findFirst[x | x.name == timeVariableName]
		if (timeVariable === null) return false
		inSituJob.timeVariable = timeVariable

		val iterationVariable = m.variables.filter(SimpleVariable).findFirst[x | x.name == iterationVariableName]
		if (iterationVariable === null) return false
		inSituJob.iterationVariable = iterationVariable

		val periodVariable = m.variables.filter(SimpleVariable).findFirst[x | x.name == periodVariableName]
		if (periodVariable === null) return false
		inSituJob.periodVariable = periodVariable

		val connectivityVariables = m.variables.filter(ConnectivityVariable)
		for (key : dumpedVariables.keySet)
		{
			val v = connectivityVariables.findFirst[x | x.name == key]
			if (v !== null) 
			{
				v.persistenceName = dumpedVariables.get(key)
				inSituJob.dumpedVariables += v
			}
		}
		m.jobs += inSituJob

		// Create a variable to store the last write time
		val twriter = IrFactory.eINSTANCE.createSimpleVariable =>
		[
			name = LastDumpVariableName
			type = EcoreUtil::copy(periodVariable.type)
			defaultValue = IrFactory.eINSTANCE.createArgOrVarRef =>
			[
				target = periodVariable
				type = EcoreUtil.copy(periodVariable.type)
			]
		]
		m.variables += twriter

		return true
	}

	override getOutputTraces()
	{
		#[]
	}
}