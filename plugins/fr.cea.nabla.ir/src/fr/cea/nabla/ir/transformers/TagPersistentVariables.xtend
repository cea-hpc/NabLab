package fr.cea.nabla.ir.transformers

import fr.cea.nabla.ir.ir.IrFactory
import fr.cea.nabla.ir.ir.IrModule
import fr.cea.nabla.ir.ir.SimpleVariable
import java.util.ArrayList
import java.util.HashMap
import org.eclipse.emf.ecore.util.EcoreUtil

import static fr.cea.nabla.ir.Utils.getCurrentIrVariable

/**
 * Attend des propriétés de type <nom_de_variable> = <nom_de_persistence>.
 * Le <nom_de_variable> représente lae nom de la vraible du code.
 * Le <nom_de_persistence> représente un alias qui sera généralement donné en dépouillement. 
 */
class TagPersistentVariables implements IrTransformationStep 
{
	val String iterationVariableName
	val HashMap<String, String> dumpedVariables
	val double periodValue
	val String periodVariableName
	val ArrayList<String> traces

	new(String iterationVariableName, HashMap<String, String> dumpedVariables, double periodValue, String periodVariableName)
	{
		this.iterationVariableName = iterationVariableName
		this.dumpedVariables = dumpedVariables
		this.periodValue = periodValue
		this.periodVariableName = periodVariableName
		this.traces = new ArrayList<String>
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

		val iterationVariable = getCurrentIrVariable(m, iterationVariableName)
		if (iterationVariable === null) return false
		inSituJob.iterationVariable = iterationVariable as SimpleVariable

		val periodVariable = getCurrentIrVariable(m, periodVariableName)
		if (periodVariable === null) return false
		inSituJob.periodVariable = periodVariable as SimpleVariable

		for (key : dumpedVariables.keySet)
		{
			val v = getCurrentIrVariable(m, key)
			if (v !== null) 
			{
				v.persistenceName = dumpedVariables.get(key)
				inSituJob.dumpedVariables += v
			}
		}
		m.jobs += inSituJob

		// Create a variable to store the last write time
		val periodVariableType = (periodVariable as SimpleVariable).type
		val twriter = IrFactory.eINSTANCE.createSimpleVariable =>
		[
			name = "lastDump"
			type = EcoreUtil::copy(periodVariableType)
			defaultValue = IrFactory.eINSTANCE.createArgOrVarRef =>
			[
				target = periodVariable
				type = EcoreUtil.copy(periodVariableType)
			]
		]
		m.variables += twriter
		inSituJob.lastDumpVariable = twriter

		return true
	}

	override getOutputTraces() 
	{
		traces
	}
}