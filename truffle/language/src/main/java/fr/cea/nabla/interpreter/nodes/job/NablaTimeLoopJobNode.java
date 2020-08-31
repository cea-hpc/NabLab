package fr.cea.nabla.interpreter.nodes.job;

import com.oracle.truffle.api.dsl.NodeChild;
import com.oracle.truffle.api.dsl.Specialization;
import com.oracle.truffle.api.frame.VirtualFrame;
import com.oracle.truffle.api.nodes.LoopNode;

import fr.cea.nabla.interpreter.nodes.instruction.NablaWriteVariableNode;
import fr.cea.nabla.interpreter.values.NV0Int;

@NodeChild(value = "indexInitializer", type = NablaWriteVariableNode.class)
@NodeChild(value = "loopNode", type = LoopNode.class)
public abstract class NablaTimeLoopJobNode extends NablaJobNode {

	public NablaTimeLoopJobNode(String name) {
		super(name);
	}

	protected NablaTimeLoopJobNode() {
	}

	@Specialization
	public final Object execute(VirtualFrame frame, NV0Int index, Object result) {
		return result;
	}

}
