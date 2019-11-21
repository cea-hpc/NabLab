package fr.cea.nabla.ir.interpreter

import fr.cea.nabla.ir.MandatoryMeshOptions
import fr.cea.nabla.ir.MandatorySimulationOptions
import fr.cea.nabla.ir.MandatorySimulationVariables
import fr.cea.nabla.ir.ir.IrFactory
import fr.cea.nabla.ir.ir.IrModule
import fr.cea.nabla.ir.ir.PrimitiveType
import fr.cea.nabla.ir.ir.SimpleVariable
import fr.cea.nabla.javalib.mesh.PvdFileWriter2D

import static fr.cea.nabla.ir.interpreter.ExpressionInterpreter.*
import static fr.cea.nabla.ir.interpreter.VariableValueFactory.*

import static extension fr.cea.nabla.ir.IrModuleExtensions.*

class ModuleInterpreter 
{
	static String iterationVariableName = "InterpreterIteration"

	static def interprete(IrModule it)
	{
		val context = new Context
		val writer = new PvdFileWriter2D(name)
		val jobInterpreter = new JobInterpreter(writer)

		// Add Variable for iteration
		addIterationVariable(context)
		
		// Interprete constant variables
		for (v : variables.filter(SimpleVariable).filter[const])
			context.setVariableValue(v, interprete(v.defaultValue, context))
			
		if (!items.empty)
		{
			// Create mesh
			val nbXQuads = getInt(MandatoryMeshOptions::X_EDGE_ELEMS, context)
			val nbYQuads = getInt(MandatoryMeshOptions::Y_EDGE_ELEMS, context)
			val xSize = getReal(MandatoryMeshOptions::X_EDGE_LENGTH, context)
			val ySize = getReal(MandatoryMeshOptions::Y_EDGE_LENGTH, context)
			context.initMesh(nbXQuads, nbYQuads, xSize, ySize)

			// Create mesh nbElems
			for (c : usedConnectivities)
			if (c.inTypes.empty)
				context.connectivitySizes.put(c, context.meshWrapper.getNbElems(c.name))
			else
				context.connectivitySizes.put(c, context.meshWrapper.getMaxNbElems(c.name))
		}

		// Interprete variables
		for (v : variables.filter[x | !(x instanceof SimpleVariable && x.const)])
			context.setVariableValue(v, createValue(v, context))

		// Copy Node Cooords
		context.setVariableValue(initCoordVariable, new NV2Real(context.meshWrapper.nodes))
		
		// Interprete init jobs
		for (j : jobs.filter[x | x.at < 0].sortBy[at])
			jobInterpreter.interprete(j, context)

		context.showVariables("After init jobs")
	
		// Declare time loop
		var maxIterations = getInt(MandatorySimulationOptions::MAX_ITERATIONS, context)
		var stopTime = getReal(MandatorySimulationOptions::STOP_TIME, context)
		
		while (getIterationValue(context) < maxIterations && getReal(MandatorySimulationVariables::TIME, context) < stopTime)
		{
			for (j : jobs.filter[x | x.at > 0].sortBy[at])
				jobInterpreter.interprete(j, context)
			context.showVariables("At iteration = " + getIterationValue(context))
			incrementIterationValue(context)
		}
		return context
	}

	private static def getInt(IrModule module, String variableName, Context context)
	{
		val v = module.variables.findFirst[name == variableName]
		return (context.getVariableValue(v) as NV0Int).data
	}
	
	private static def getReal(IrModule module, String variableName, Context context)
	{
		val v = module.variables.findFirst[name == variableName]
		return (context.getVariableValue(v) as NV0Real).data
	}

	private static def addIterationVariable(IrModule it, Context context)
	{
		val iteration = IrFactory::eINSTANCE.createSimpleVariable
		iteration.name = iterationVariableName
		iteration.type = IrFactory::eINSTANCE.createScalar =>
		[
			primitive = PrimitiveType::INT
		]
		iteration.const = false
		iteration.defaultValue = IrFactory::eINSTANCE.createConstant =>
		[
			type = IrFactory::eINSTANCE.createScalar =>
			[
				primitive = PrimitiveType::INT
			]
			value = '0'
		]
		variables.add(iteration)
	}

	private static def getIterationValue(IrModule module, Context context)
	{
		getInt(module, iterationVariableName, context)
	}

	private static def incrementIterationValue(IrModule module, Context context)
	{
		val iteration = module.iterationvariable
		val value = (context.getVariableValue(iteration) as NV0Int).data
		context.setVariableValue(iteration, new NV0Int(value + 1))
	}

	static def getIterationvariable(IrModule it)
	{
		variables.findFirst[j | j.name == iterationVariableName]
	}	
}