package fr.cea.nabla.interpreter.nodes.expression.constant;

import com.oracle.truffle.api.dsl.Specialization;
import com.oracle.truffle.api.frame.VirtualFrame;

import fr.cea.nabla.interpreter.nodes.expression.NablaExpressionNode;
import fr.cea.nabla.interpreter.values.NV0Int;

public abstract class NablaIntConstantNode extends NablaExpressionNode {

	private final NV0Int value;
	
	public NablaIntConstantNode(int value) {
		this.value = new NV0Int(value);
	}
	
	@Override
	@Specialization
	public NV0Int executeNV0Int(VirtualFrame frame) {
		return this.value;
	}
}
