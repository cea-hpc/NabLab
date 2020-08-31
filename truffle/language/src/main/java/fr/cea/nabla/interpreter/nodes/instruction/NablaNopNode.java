package fr.cea.nabla.interpreter.nodes.instruction;

import com.oracle.truffle.api.frame.VirtualFrame;

public class NablaNopNode extends NablaInstructionNode {

	@Override
	public Object executeGeneric(VirtualFrame frame) {
		return null;
	}
	
}
