package fr.cea.nabla.ir

import fr.cea.nabla.ir.ir.Affectation
import fr.cea.nabla.ir.ir.InstructionJob
import fr.cea.nabla.ir.ir.IrModule
import fr.cea.nabla.ir.ir.Job
import fr.cea.nabla.ir.ir.TimeIterationCopyJob
import fr.cea.nabla.ir.ir.VarRef
import fr.cea.nabla.ir.ir.Variable
import java.util.HashSet

import static extension fr.cea.nabla.ir.VariableExtensions.*

class JobExtensions 
{
	static def getNextJobs(Job from)
	{
		val fromTargetJobs = new HashSet<Job>
		val irFile = from.eContainer as IrModule
		val fromOutVars = from.outVars
		for (to : irFile.jobs.filter[x|x!=from])
			for (outVar : fromOutVars)
				if (to.inVars.exists[x|x === outVar])
					fromTargetJobs += to
		return fromTargetJobs
	}
	
	static def dispatch Iterable<Variable> getOutVars(TimeIterationCopyJob it)
	{
		#[left].toSet
	}

	static def dispatch Iterable<Variable> getOutVars(InstructionJob it)
	{
		eAllContents.filter(Affectation).map[left.variable].filter[global].toSet
	}
	
	static def dispatch Iterable<Variable> getInVars(TimeIterationCopyJob it)
	{
		#[right].toSet
	}

	static def dispatch Iterable<Variable> getInVars(InstructionJob it)
	{
		val allVars = eAllContents.filter(VarRef).map[variable].filter[global].toSet
		allVars.removeAll(outVars)
		return allVars
	}
}