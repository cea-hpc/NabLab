package fr.cea.nabla.interpreter.nodes.expression;

import com.oracle.truffle.api.dsl.Specialization;
import com.oracle.truffle.api.frame.VirtualFrame;
import com.oracle.truffle.api.nodes.ExplodeLoop;

import fr.cea.nabla.interpreter.NablaTypesGen;
import fr.cea.nabla.interpreter.values.NV1Bool;

public abstract class NablaBool1Node extends NablaExpressionNode {

	@Children
	private final NablaExpressionNode[] values;
	
	public NablaBool1Node(NablaExpressionNode[] values) {
		this.values = values;
	}

	@Override
	@ExplodeLoop
	@Specialization
	public NV1Bool executeNV1Bool(VirtualFrame frame) {
		final boolean[] computedValues = new boolean[values.length];
		for (int i = 0; i < values.length; i++) {
			computedValues[i] = NablaTypesGen.asNV0Bool(values[i].executeGeneric(frame)).isData();
		}
		return new NV1Bool(computedValues);
	}
}
