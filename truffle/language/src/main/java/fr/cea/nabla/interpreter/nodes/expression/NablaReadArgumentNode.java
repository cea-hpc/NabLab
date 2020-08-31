package fr.cea.nabla.interpreter.nodes.expression;

import com.oracle.truffle.api.dsl.Specialization;
import com.oracle.truffle.api.frame.FrameSlot;
import com.oracle.truffle.api.frame.VirtualFrame;

import fr.cea.nabla.interpreter.runtime.NablaNull;

public abstract class NablaReadArgumentNode extends NablaExpressionNode {

	private final int index;
	protected final FrameSlot[] sizeSlots;
	
	public NablaReadArgumentNode(int index) {
		this.index = index;
		this.sizeSlots = null;
	}
	
	public NablaReadArgumentNode(int index, FrameSlot[] sizeSlots) {
		this.index = index;
		this.sizeSlots = sizeSlots;
	}

	@Specialization(guards = "sizeSlots == null")
	public Object doBasic(VirtualFrame frame) {
		Object[] args = frame.getArguments();
		if (index+2 < args.length) {
			return args[index+2];
		} else {
			return NablaNull.SINGLETON;
		}
	}
}
