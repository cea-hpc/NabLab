package fr.cea.nabla.interpreter.nodes.expression;

import com.oracle.truffle.api.dsl.Specialization;
import com.oracle.truffle.api.frame.VirtualFrame;
import com.oracle.truffle.api.nodes.ExplodeLoop;

import fr.cea.nabla.interpreter.NablaTypesGen;
import fr.cea.nabla.interpreter.values.NV1Int;
import fr.cea.nabla.interpreter.values.NV1IntJava;

public abstract class NablaInt1Node extends NablaExpressionNode {

	@Children
	private final NablaExpressionNode[] values;
	
	public NablaInt1Node(NablaExpressionNode[] values) {
		this.values = values;
	}

	@Override
	@ExplodeLoop
	@Specialization
	public NV1Int executeNV1Int(VirtualFrame frame) {
		final int[] computedValues = new int[values.length];
		for (int i = 0; i < values.length; i++) {
			computedValues[i] = NablaTypesGen.asNV0Int(values[i].executeGeneric(frame)).getData();
		}
		return new NV1IntJava(computedValues);
	}
}
