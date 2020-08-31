package fr.cea.nabla.interpreter.nodes.expression;

import com.oracle.truffle.api.CompilerDirectives;
import com.oracle.truffle.api.CompilerDirectives.CompilationFinal;
import com.oracle.truffle.api.dsl.NodeChild;
import com.oracle.truffle.api.dsl.Specialization;
import com.oracle.truffle.api.frame.Frame;
import com.oracle.truffle.api.frame.FrameSlot;
import com.oracle.truffle.api.frame.FrameSlotTypeException;
import com.oracle.truffle.api.frame.VirtualFrame;
import com.oracle.truffle.api.instrumentation.GenerateWrapper;
import com.oracle.truffle.api.instrumentation.ProbeNode;

import fr.cea.nabla.interpreter.runtime.NablaInitializationPerformedException;
import fr.cea.nabla.interpreter.runtime.NablaInternalError;
import fr.cea.nabla.interpreter.utils.GetFrameNode;

@GenerateWrapper
@NodeChild(value = "frameToRead", type = GetFrameNode.class)
public abstract class NablaReadVariableNode extends NablaExpressionNode {

	@CompilationFinal
	protected FrameSlot slot;
	private final String slotName;

	protected NablaReadVariableNode(String name) {
		this.slotName = name;
	}
	
	protected NablaReadVariableNode() {
		this.slotName = "";
	}
	
	@Specialization(guards = "slot == null", //
			rewriteOn = NablaInitializationPerformedException.class)
	protected Frame initialize(VirtualFrame frame, Frame toRead) throws NablaInitializationPerformedException {
		CompilerDirectives.transferToInterpreterAndInvalidate();
		slot = toRead.getFrameDescriptor().findFrameSlot(slotName);
		throw new NablaInitializationPerformedException();
	}

	@Specialization
	protected Object doRead(VirtualFrame frame, Frame toRead) {
		try {
			return toRead.getObject(slot);
		} catch (FrameSlotTypeException e) {
			e.printStackTrace();
			throw NablaInternalError.shouldNotReachHere();
		}
	}
	
	public FrameSlot getSlot() {
		return slot;
	}
	
	@Override
	public WrapperNode createWrapper(ProbeNode probe) {
		return new NablaReadVariableNodeWrapper(this, probe);
	}
}
