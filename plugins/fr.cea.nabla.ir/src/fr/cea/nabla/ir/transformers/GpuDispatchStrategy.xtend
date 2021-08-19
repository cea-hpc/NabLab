package fr.cea.nabla.ir.transformers

import fr.cea.nabla.ir.ir.Affectation
import fr.cea.nabla.ir.ir.ArgOrVarRef
import fr.cea.nabla.ir.ir.BaseTypeConstant
import fr.cea.nabla.ir.ir.BinaryExpression
import fr.cea.nabla.ir.ir.BoolConstant
import fr.cea.nabla.ir.ir.Cardinality
import fr.cea.nabla.ir.ir.ContractedIf
import fr.cea.nabla.ir.ir.ExecuteTimeLoopJob
import fr.cea.nabla.ir.ir.Exit
import fr.cea.nabla.ir.ir.Expression
import fr.cea.nabla.ir.ir.ExternFunction
import fr.cea.nabla.ir.ir.Function
import fr.cea.nabla.ir.ir.FunctionCall
import fr.cea.nabla.ir.ir.If
import fr.cea.nabla.ir.ir.Instruction
import fr.cea.nabla.ir.ir.InstructionBlock
import fr.cea.nabla.ir.ir.IntConstant
import fr.cea.nabla.ir.ir.InternFunction
import fr.cea.nabla.ir.ir.ItemIdDefinition
import fr.cea.nabla.ir.ir.ItemIndexDefinition
import fr.cea.nabla.ir.ir.Job
import fr.cea.nabla.ir.ir.Loop
import fr.cea.nabla.ir.ir.MaxConstant
import fr.cea.nabla.ir.ir.MinConstant
import fr.cea.nabla.ir.ir.Parenthesis
import fr.cea.nabla.ir.ir.RealConstant
import fr.cea.nabla.ir.ir.ReductionInstruction
import fr.cea.nabla.ir.ir.Return
import fr.cea.nabla.ir.ir.SetDefinition
import fr.cea.nabla.ir.ir.UnaryExpression
import fr.cea.nabla.ir.ir.VariableDeclaration
import fr.cea.nabla.ir.ir.VectorConstant
import fr.cea.nabla.ir.ir.While
import fr.cea.nabla.ir.IrUtils

@Data
class GpuDispatchStrategyOptions
{
	boolean permitIfExpressions
}

@Data
abstract class GpuDispatchStrategy
{
	val GpuDispatchStrategyOptions opt
	
	// Used to initialize the strategy before using it if needed
	def void init()

	def boolean couldRunOnGPU(Function it)
	def boolean couldRunOnGPU(Job it)
	def boolean couldRunOnGPU(Instruction it)
	def boolean couldRunOnGPU(Expression it)
}

class OptimistGpuDispatchStrategy extends GpuDispatchStrategy
{
	new(GpuDispatchStrategyOptions opt)
	{
		super(opt)
	}
	
	override void init() { }
	
	override boolean couldRunOnGPU(Function it) {
		switch it {
			ExternFunction: false
			InternFunction: body.couldRunOnGPU
			default: throw new Error("Unexpected function type for " + it.toString)
		}
	}

	override boolean couldRunOnGPU(Expression it)
	{
		switch it
		{
			ArgOrVarRef | Cardinality | VectorConstant | BaseTypeConstant |
			MinConstant | MaxConstant | BoolConstant | RealConstant | IntConstant |
			Parenthesis: true

			ContractedIf: opt.permitIfExpressions
				&& condition.couldRunOnGPU
				&& thenExpression.couldRunOnGPU
				&& elseExpression.couldRunOnGPU

			BinaryExpression: left.couldRunOnGPU
				&& right.couldRunOnGPU

			FunctionCall: function.couldRunOnGPU
			UnaryExpression: expression.couldRunOnGPU

			default: throw new Error("Unexprected expression type for " + it.toString)
		}
	}
	
	override boolean couldRunOnGPU(Instruction it)
	{
		switch it
		{
			While | Return | VariableDeclaration | ItemIndexDefinition |
			ItemIdDefinition | SetDefinition: true

			Exit: false
			
			If: return opt.permitIfExpressions

			InstructionBlock: {
				return (instructions.size != 0) ?
					instructions.map[couldRunOnGPU].reduce[t1, t2 | t1 && t2] : true
			}

			// NOTE: The Affectation inherits the 'GPU-Able' state of its
			// parent! Top level affectations can't be placed on GPU because
			// one affectation can't be run in parallel.
			Affectation: {
				if (null !== IrUtils::getContainerOfType(it, Loop) ||
					null !== IrUtils::getContainerOfType(it, ReductionInstruction))
					return true

				val possibleParentFunction = IrUtils::getContainerOfType(it, Function)
				if (possibleParentFunction !== null)
					return possibleParentFunction.couldRunOnGPU

				return false
			}

			ReductionInstruction: {
				binaryFunction.couldRunOnGPU && lambda.couldRunOnGPU &&
				((innerInstructions.size != 0) ?
					innerInstructions.map[couldRunOnGPU].reduce[t1, t2 | t1 && t2] : true)
			}

			Loop: body.couldRunOnGPU

			default: throw new Error("Unexpected instruction type for " + it.toString)
		}
	}
	
	override boolean couldRunOnGPU(Job it)
	{
		return (timeLoopJob || it instanceof ExecuteTimeLoopJob) ? false : instruction.couldRunOnGPU
	}
	
}