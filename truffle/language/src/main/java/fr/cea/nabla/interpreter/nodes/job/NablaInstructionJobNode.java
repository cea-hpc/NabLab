package fr.cea.nabla.interpreter.nodes.job;

import com.oracle.truffle.api.dsl.NodeChild;
import com.oracle.truffle.api.dsl.Specialization;
import com.oracle.truffle.api.frame.VirtualFrame;

import fr.cea.nabla.interpreter.nodes.instruction.NablaInstructionBlockNode;

@NodeChild(value = "instructionBlock", type = NablaInstructionBlockNode.class)
public abstract class NablaInstructionJobNode extends NablaJobNode {

	protected NablaInstructionJobNode(String name) {
		super(name);
	}

	protected NablaInstructionJobNode() {
	}

	@Specialization
	public Object execute(VirtualFrame frame, Object result) {
		return result;
	}
	
}
