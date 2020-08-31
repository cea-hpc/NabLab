package fr.cea.nabla.interpreter.nodes.expression;

import com.oracle.truffle.api.dsl.Specialization;
import com.oracle.truffle.api.frame.VirtualFrame;
import com.oracle.truffle.api.nodes.ExplodeLoop;

import fr.cea.nabla.interpreter.NablaTypesGen;
import fr.cea.nabla.interpreter.values.NV1IntJava;
import fr.cea.nabla.interpreter.values.NV2Int;

public abstract class NablaInt2Node extends NablaExpressionNode {
	
	@Children
	private final NablaExpressionNode[] values;
	@Children
	private final NablaExpressionNode[] dimensions;

	public NablaInt2Node(NablaExpressionNode[] values, NablaExpressionNode[] dimensions) {
		this.values = values;
		this.dimensions = dimensions;
	}

	@Override
	@ExplodeLoop
	@Specialization
	public NV2Int executeNV2Int(VirtualFrame frame) {
		int[] computedDimensions = new int[2];
		for (int i = 0; i < 2; i++) {
			computedDimensions[i] = NablaTypesGen.asNV0Int(dimensions[i].executeGeneric(frame)).getData();
		}
		final int[][] computedValues = new int[computedDimensions[0]][computedDimensions[1]];
		for (int i = 0; i < values.length; i++) {
			computedValues[i] = ((NV1IntJava) NablaTypesGen.asNV1Int(values[i].executeGeneric(frame))).getData();
		}
		return new NV2Int(computedValues);
	}
}
