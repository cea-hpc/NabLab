package fr.cea.nabla.interpreter.nodes.expression;

import com.oracle.truffle.api.Truffle;
import com.oracle.truffle.api.frame.VirtualFrame;
import com.oracle.truffle.api.instrumentation.StandardTags;
import com.oracle.truffle.api.instrumentation.Tag;
import com.oracle.truffle.api.nodes.DirectCallNode;
import com.oracle.truffle.api.nodes.ExplodeLoop;

import fr.cea.nabla.interpreter.nodes.NablaRootNode;
import fr.cea.nabla.interpreter.values.NablaValue;

public class NablaFunctionCallNode extends NablaExpressionNode {

	@Children
	private final NablaExpressionNode[] argumentNodes;
	@Child
	private DirectCallNode callNode;

	public NablaFunctionCallNode(NablaRootNode functionNode, NablaExpressionNode[] argumentNodes) {
		this.argumentNodes = argumentNodes;
		this.callNode = Truffle.getRuntime().createDirectCallNode(Truffle.getRuntime().createCallTarget(functionNode));
	}

	@Override
	@ExplodeLoop
	public final NablaValue executeGeneric(VirtualFrame frame) {
		Object[] argumentValues = new Object[argumentNodes.length+2];
		if (frame.getArguments().length == 0) {
			argumentValues[0] = frame;
			argumentValues[1] = this.getRootNode();
		} else {
			argumentValues[0] = frame.getArguments()[0];
			argumentValues[1] = this.getRootNode();
		}
		for (int i = 0; i < argumentNodes.length; i++) {
			argumentValues[i+2] = argumentNodes[i].executeGeneric(frame);
		}
		return (NablaValue) callNode.call(argumentValues);
	}

	@Override
	public boolean hasTag(Class<? extends Tag> tag) {
		if (tag == StandardTags.CallTag.class) {
			return true;
		}
		return super.hasTag(tag);
	}
}
