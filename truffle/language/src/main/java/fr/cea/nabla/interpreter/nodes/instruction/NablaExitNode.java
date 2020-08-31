package fr.cea.nabla.interpreter.nodes.instruction;

import com.oracle.truffle.api.dsl.Cached;
import com.oracle.truffle.api.dsl.Specialization;
import com.oracle.truffle.api.frame.VirtualFrame;
import com.oracle.truffle.api.profiles.BranchProfile;

public abstract class NablaExitNode extends NablaInstructionNode {

	private final String message;
	
	public NablaExitNode(String message) {
		this.message = message;
	}
	
	@Specialization
	public Object doDefault(VirtualFrame frame, @Cached BranchProfile exception) {
		exception.enter();
		throw new RuntimeException(message);
	}
	
}
