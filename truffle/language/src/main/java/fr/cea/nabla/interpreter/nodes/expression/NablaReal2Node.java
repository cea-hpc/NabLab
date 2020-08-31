package fr.cea.nabla.interpreter.nodes.expression;

import com.oracle.truffle.api.dsl.Specialization;
import com.oracle.truffle.api.frame.VirtualFrame;
import com.oracle.truffle.api.nodes.ExplodeLoop;

import fr.cea.nabla.interpreter.NablaTypesGen;
import fr.cea.nabla.interpreter.values.NV2Real;

public abstract class NablaReal2Node extends NablaExpressionNode {

	@Children
	private final NablaExpressionNode[] values;
	@Children
	private final NablaExpressionNode[] dimensions;

	public NablaReal2Node(NablaExpressionNode[] values, NablaExpressionNode[] dimensions) {
		this.values = values;
		this.dimensions = dimensions;
	}

	@Override
	@ExplodeLoop
	@Specialization
	public NV2Real executeNV2Real(VirtualFrame frame) {
		int[] computedDimensions = new int[2];
		for (int i = 0; i < 2; i++) {
			computedDimensions[i] = NablaTypesGen.asNV0Int(dimensions[i].executeGeneric(frame)).getData();
		}
		final double[][] computedValues = new double[computedDimensions[0]][computedDimensions[1]];
		for (int i = 0; i < values.length; i++) {
			computedValues[i] = NablaTypesGen.asNV1Real(values[i].executeGeneric(frame)).getData();
		}
		return new NV2Real(computedValues);
	}
}
