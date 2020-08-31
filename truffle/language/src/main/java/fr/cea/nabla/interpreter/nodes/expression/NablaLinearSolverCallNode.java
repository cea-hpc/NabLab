package fr.cea.nabla.interpreter.nodes.expression;

import org.apache.commons.math3.linear.AbstractRealMatrix;
import org.apache.commons.math3.linear.RealVector;

import com.oracle.truffle.api.CompilerDirectives.TruffleBoundary;
import com.oracle.truffle.api.dsl.NodeChild;
import com.oracle.truffle.api.dsl.Specialization;
import com.oracle.truffle.api.frame.VirtualFrame;
import com.oracle.truffle.api.instrumentation.StandardTags;
import com.oracle.truffle.api.instrumentation.Tag;

import fr.cea.nabla.interpreter.values.NV1Real;
import fr.cea.nabla.interpreter.values.NV2Real;
import fr.cea.nabla.interpreter.values.NablaValue;
import fr.cea.nabla.javalib.types.LinearAlgebraFunctions;

@NodeChild(value = "matrix", type = NablaExpressionNode.class)
@NodeChild(value = "vector", type = NablaExpressionNode.class)
public abstract class NablaLinearSolverCallNode extends NablaExpressionNode {

	private final LinearAlgebraFunctions solver;

	protected NablaLinearSolverCallNode(LinearAlgebraFunctions solver) {
		this.solver = solver;
	}

	@Specialization
	public final NablaValue solve(VirtualFrame frame, NV2Real matrix, NV1Real vector) {
		return new NV1Real(solve(matrix.asMatrix(), vector.asVector()));
	}
	
	@TruffleBoundary
	private double[] solve(AbstractRealMatrix matrix, RealVector vector) {
		return solver.solveLinearSystem(matrix, vector).toArray();
	}

	@Override
	public boolean hasTag(Class<? extends Tag> tag) {
		if (tag == StandardTags.CallTag.class) {
			return true;
		}
		return super.hasTag(tag);
	}
}
