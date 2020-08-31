package fr.cea.nabla.interpreter.values;

import com.oracle.truffle.api.dsl.NodeChild;
import com.oracle.truffle.api.dsl.Specialization;
import com.oracle.truffle.api.frame.VirtualFrame;
import com.oracle.truffle.api.nodes.Node;

import fr.cea.nabla.interpreter.nodes.expression.NablaExpressionNode;

@NodeChild(value = "value", type = NablaExpressionNode.class)
public abstract class UnboxValueNode extends Node {

	public abstract Object execute(VirtualFrame frame);

	@Specialization
	protected Object unbox(NV0Bool it) {
		return Boolean.valueOf(it.isData());
	}

	@Specialization
	protected Object unbox(NV1Bool it) {
		return it.getData();
	}

	@Specialization
	protected Object unbox(NV2Bool it) {
		return it.getData();
	}

	@Specialization
	protected Object unbox(NV0Int it) {
		return Integer.valueOf(it.getData());
	}

	@Specialization
	protected Object unbox(NV1IntJava it) {
		return it.getData();
	}

	@Specialization
	protected Object unbox(NV2Int it) {
		return it.getData();
	}

	@Specialization
	protected Object unbox(NV0Real it) {
		return Double.valueOf(it.getData());
	}

	@Specialization
	protected Object unbox(NV1Real it) {
		return it.getData();
	}

	@Specialization
	protected Object unbox(NV2Real it) {
		return it.getData();
	}

}
