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
import org.eclipse.xtend.lib.annotations.Accessors

@Data
class GpuDispatchStrategyOptions
{
	@Accessors boolean permitIfExpressions
}

abstract class GpuDispatchStrategy
{
	protected val GpuDispatchStrategyOptions opt
	
	protected new(GpuDispatchStrategyOptions opt)
	{
		this.opt = opt
	}
	
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
			ExternFunction: return false
			InternFunction: return body.couldRunOnGPU
			default: throw new Error("Unexpected function type for " + it.toString)
		}
	}

	override boolean couldRunOnGPU(Expression it)
	{
		switch it
		{
			ArgOrVarRef | Cardinality | VectorConstant | BaseTypeConstant |
			MinConstant | MaxConstant | BoolConstant | RealConstant | IntConstant |
			Parenthesis: return true

			ContractedIf: return opt.permitIfExpressions
				&& condition.couldRunOnGPU
				&& thenExpression.couldRunOnGPU
				&& elseExpression.couldRunOnGPU

			BinaryExpression: return left.couldRunOnGPU
				&& right.couldRunOnGPU

			FunctionCall: return function.couldRunOnGPU
			UnaryExpression: return expression.couldRunOnGPU

			default: throw new Error("Unexprected expression type for " + it.toString)
		}
	}
	
	override boolean couldRunOnGPU(Instruction it)
	{
		switch it
		{
			While | Return: return true
			Exit: return false
			ItemIndexDefinition | ItemIdDefinition | SetDefinition: true // FIXME: For now
			
			If: return opt.permitIfExpressions

			InstructionBlock: {
				return (instructions.size != 0) ?
					instructions.map[couldRunOnGPU].reduce[t1, t2 | t1 && t2] : true
			}

			VariableDeclaration: {
				// FIXME: Only permit constexpr variables for now. We should
				// manually check if the generated variables will be
				// compatible with GPU (avoid std::vector...)
				return variable.constExpr
			}

			Affectation: {
				// FIXME: Get the height of the affectation...
				return true
			}

			ReductionInstruction: {
				return binaryFunction.couldRunOnGPU
					&& lambda.couldRunOnGPU
					&& ((innerInstructions.size != 0) ?
						innerInstructions.map[couldRunOnGPU].reduce[t1, t2 | t1 && t2] : true)
			}

			Loop: return body.couldRunOnGPU

			default: throw new Error("Unexpected instruction type for " + it.toString)
		}
	}
	
	override boolean couldRunOnGPU(Job it)
	{
		return (timeLoopJob || it instanceof ExecuteTimeLoopJob) ? false : instruction.couldRunOnGPU
	}
	
}