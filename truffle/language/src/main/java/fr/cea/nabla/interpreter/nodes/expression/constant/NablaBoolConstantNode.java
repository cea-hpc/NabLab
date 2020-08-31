package fr.cea.nabla.interpreter.nodes.expression.constant;

import com.oracle.truffle.api.dsl.Specialization;
import com.oracle.truffle.api.frame.VirtualFrame;

import fr.cea.nabla.interpreter.nodes.expression.NablaExpressionNode;
import fr.cea.nabla.interpreter.values.NV0Bool;

public abstract class NablaBoolConstantNode extends NablaExpressionNode {

	private final NV0Bool value;
	
	public NablaBoolConstantNode(boolean value) {
		this.value = new NV0Bool(value);
	}
	
	@Override
	@Specialization
	public NV0Bool executeNV0Bool(VirtualFrame frame) {
		return this.value;
	}
}
