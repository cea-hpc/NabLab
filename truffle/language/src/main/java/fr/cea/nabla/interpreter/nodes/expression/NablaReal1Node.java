package fr.cea.nabla.interpreter.nodes.expression;

import com.oracle.truffle.api.dsl.Specialization;
import com.oracle.truffle.api.frame.VirtualFrame;
import com.oracle.truffle.api.nodes.ExplodeLoop;

import fr.cea.nabla.interpreter.NablaTypesGen;
import fr.cea.nabla.interpreter.values.NV1Real;

public abstract class NablaReal1Node extends NablaExpressionNode {

	@Children
	private final NablaExpressionNode[] values;
	
	public NablaReal1Node(NablaExpressionNode[] values) {
		this.values = values;
	}

	@Override
	@ExplodeLoop
	@Specialization
	public NV1Real executeNV1Real(VirtualFrame frame) {
		final double[] computedValues = new double[values.length];
		for (int i = 0; i < values.length; i++) {
			computedValues[i] = NablaTypesGen.asNV0Real(values[i].executeGeneric(frame)).getData();
		}
		return new NV1Real(computedValues);
	}
}
