/*******************************************************************************
 * Copyright (c) 2022 CEA
 * This program and the accompanying materials are made available under the
 * terms of the Eclipse Public License 2.0 which is available at
 * http://www.eclipse.org/legal/epl-2.0.
 *
 * SPDX-License-Identifier: EPL-2.0
 * Contributors: see AUTHORS file
 *******************************************************************************/
package fr.cea.nabla.ir.interpreter

import fr.cea.nabla.ir.ir.ExecuteTimeLoopJob
import fr.cea.nabla.ir.ir.IrRoot
import fr.cea.nabla.ir.ir.Job
import fr.cea.nabla.javalib.mesh.PvdFileWriter2D
import java.util.Locale

import static fr.cea.nabla.ir.interpreter.ExpressionInterpreter.*
import static fr.cea.nabla.ir.interpreter.InstructionInterpreter.*

import static extension fr.cea.nabla.ir.IrTypeExtensions.*
import static extension fr.cea.nabla.ir.JobCallerExtensions.*
import static extension fr.cea.nabla.ir.interpreter.NablaValueGetter.*

class JobInterpreter
{
	// Switch to more efficient dispatch (also clearer for profiling)
	static def void interprete(Job j, Context context)
	{
		switch j
		{
			ExecuteTimeLoopJob: interpreteExecuteTimeLoopJob(j, context)
			default: interpreteJob(j, context)
		}
	}

	private static def void interpreteJob(Job it, Context context)
	{
		context.logFiner("Interprete Job " + name + " @ " + at)
		val innerContext = new Context(context)
		interprete(instruction, innerContext)
	}

	private static def void interpreteExecuteTimeLoopJob(ExecuteTimeLoopJob it, Context context)
	{
		context.logFiner("Interprete TimeLoopJob " + name + " @ " + at)
		val ppInfo = context.ir.postProcessing
		var iteration = 0
		context.logVariables("Before timeLoop " + iterationCounter.name)
		context.addVariableValue(iterationCounter, new NV0Int(iteration))
		var continueLoop = true
		do
		{
			iteration ++
			context.setVariableValue(iterationCounter, new NV0Int(iteration))

			if (caller.main)
			{
				val log = String.format(Locale::ENGLISH, "START ITERATION %1$s: %2$5d - t: %3$.5f - delta_t: %4$.5f",
						iterationCounter.name,
						iteration,
						context.getReal(context.ir.currentTimeVariable),
						context.getReal(context.ir.timeStepVariable))
				context.logFine(log)

				if (ppInfo !== null)
				{
					val periodValue = context.getNumber(ppInfo.periodValue)
					val periodReference = context.getNumber(ppInfo.periodReference)
					val lastDump = context.getNumber(ppInfo.lastDumpVariable)
					if (periodReference >= lastDump + periodValue)
						dumpVariables(context.ir, iteration, context, periodReference);
				}
			}
			else
			{
				val log = String.format(Locale::ENGLISH, "Start iteration %1$s: %2$5d",
						iterationCounter.name,
						iteration)
				context.logFine(log)
			}

			for (j : calls)
				interprete(j, context)

			context.logVariables("After iteration = " + iteration)

			continueLoop = (interprete(whileCondition, context) as NV0Bool).data

			interprete(instruction, context)

			context.checkInterrupted
		}
		while (continueLoop)

		if (caller.main)
		{
			// force a last trace and output at the end
			val log = String.format(Locale::ENGLISH, "FINAL TIME: %1$.5f - delta_t: %2$.5f",
					context.getReal(context.ir.currentTimeVariable),
					context.getReal(context.ir.timeStepVariable))
			context.logFine(log)

			if (ppInfo !== null)
			{
				val periodReference = context.getNumber(ppInfo.periodReference)
				dumpVariables(context.ir, iteration + 1, context, periodReference);
			}
		}

		val log = String.format("Nb iteration %1$s = %2$d", iterationCounter.name, iteration)
		context.logInfo(log)
		val msg = String.format("After timeLoop %1$s %2$d", iterationCounter.name, iteration)
		context.logVariables(msg)
	}

	private static def void dumpVariables(IrRoot ir, int iteration, Context context, double periodReference)
	{
		val ppInfo = ir.postProcessing
		val w = context.writer
		if (w !== null && !w.disabled)
		{
			val time = context.getReal(ir.currentTimeVariable)
			val coords = (context.getVariableValue(ir.nodeCoordVariable) as NV2Real).data
			val quads = context.mesh.quads
			w.startVtpFile(iteration, time, coords, quads);
			val outputVars = ppInfo.outputVariables

			w.openNodeData();
			for (v : outputVars.filter(v | v.support.name == "node"))
			{
				w.openNodeArray(v.outputName, v.target.type.baseSizes.size)
				val value = context.getVariableValue(v.target)
				for (i : 0..<coords.length)
					w.write(value.getValue(#[i]))
				w.closeNodeArray();
			}
			w.closeNodeData();
			w.openCellData();
			for (v : outputVars.filter(v | v.support.name == "cell"))
			{
				w.openCellArray(v.outputName, v.target.type.baseSizes.size)
				val value = context.getVariableValue(v.target)
				for (i : 0..<quads.length)
					w.write(value.getValue(#[i]))
				w.closeCellArray();
			}
			w.closeCellData();
			w.closeVtpFile();
			context.setVariableValue(ppInfo.lastDumpVariable, new NV0Real(periodReference))
		}
	}

	private static def void write(PvdFileWriter2D writer, NablaValue v)
	{
		switch v
		{
			NV0Real: writer.write(v.data)
			NV1Real: writer.write(v.data)
			default: throw new RuntimeException("VTK writer does not manage data value type: " + v.toString)
		}
	}
}
