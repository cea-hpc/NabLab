package fr.cea.nabla.interpreter.nodes.instruction;

import com.oracle.truffle.api.Assumption;
import com.oracle.truffle.api.CompilerDirectives;
import com.oracle.truffle.api.Truffle;
import com.oracle.truffle.api.dsl.Cached;
import com.oracle.truffle.api.dsl.NodeChild;
import com.oracle.truffle.api.dsl.Specialization;
import com.oracle.truffle.api.frame.FrameSlot;
import com.oracle.truffle.api.frame.FrameSlotKind;
import com.oracle.truffle.api.frame.VirtualFrame;
import com.oracle.truffle.api.library.CachedLibrary;
import com.oracle.truffle.api.nodes.ExplodeLoop;

import fr.cea.nabla.interpreter.nodes.expression.NablaExpressionNode;
import fr.cea.nabla.interpreter.values.NV0Int;
import fr.cea.nabla.interpreter.values.NV1IntLibrary;

@NodeChild(value = "count", type = NablaExpressionNode.class)
public abstract class NablaLoopNode extends NablaInstructionNode {

	private final FrameSlot indexSlot;
	private final FrameSlot counterSlot;

	@Child
	private NablaInstructionNode body;

	protected final Assumption lengthUnchanged = Truffle.getRuntime().createAssumption();

	public NablaLoopNode(FrameSlot indexSlot, FrameSlot counterSlot, NablaInstructionNode body) {
		this.indexSlot = indexSlot;
		this.counterSlot = counterSlot;
		this.body = body;
	}

	@Specialization(guards = "count.getData() == cachedCount")
	public Object doLoop(VirtualFrame frame, NV0Int count, @Cached("count.getData()") int cachedCount) {
		CompilerDirectives.isPartialEvaluationConstant(cachedCount);
		frame.setObject(indexSlot, new NV0Int(0));
		frame.getFrameDescriptor().setFrameSlotKind(indexSlot, FrameSlotKind.Object);
		if (counterSlot != null) {
			frame.setObject(counterSlot, new NV0Int(0));
			frame.getFrameDescriptor().setFrameSlotKind(counterSlot, FrameSlotKind.Object);
		}
		body.executeGeneric(frame);
		// ============= Loop Tiling =============
//		final int offset = 1;
//		final int iMax = 20;
//		final int iiMax = (cachedCount - 1 - offset) / iMax;
//		
//		int ii = 0;
//		
//		for (; ii < iiMax; ii++) {
//			doLoopInternal(frame, ii * iMax, iMax, offset);
//		}
//		
//		for (int i = ii * iMax + offset; i < cachedCount - 1; i++) {
//			frame.setObject(indexSlot, new NV0Int(i));
//			body.executeGeneric(frame);
//		}
		// =======================================
		for (int i = 1; i < cachedCount - 1; i++) {
			frame.setObject(indexSlot, new NV0Int(i));
			if (counterSlot != null) {
				frame.setObject(counterSlot, new NV0Int(i));
			}
			body.executeGeneric(frame);
		}
		frame.setObject(indexSlot, new NV0Int(cachedCount - 1));
		if (counterSlot != null) {
			frame.setObject(counterSlot, new NV0Int(cachedCount - 1));
		}
		return body.executeGeneric(frame);
	}

	@Specialization
	public Object doLoop(VirtualFrame frame, NV0Int count) {
		final int iterationCount = count.getData();
		CompilerDirectives.isPartialEvaluationConstant(iterationCount);
		frame.setObject(indexSlot, new NV0Int(0));
		frame.getFrameDescriptor().setFrameSlotKind(indexSlot, FrameSlotKind.Object);
		if (counterSlot != null) {
			frame.setObject(counterSlot, new NV0Int(0));
			frame.getFrameDescriptor().setFrameSlotKind(counterSlot, FrameSlotKind.Object);
		}
		body.executeGeneric(frame);
		for (int i = 1; i < iterationCount - 1; i++) {
			frame.setObject(indexSlot, new NV0Int(i));
			if (counterSlot != null) {
				frame.setObject(counterSlot, new NV0Int(i));
			}
			body.executeGeneric(frame);
		}
		frame.setObject(indexSlot, new NV0Int(iterationCount - 1));
		if (counterSlot != null) {
			frame.setObject(counterSlot, new NV0Int(iterationCount - 1));
		}
		return body.executeGeneric(frame);
	}

	@Specialization(guards = { "arrays.isArray(elements_)", "arrays.length(elements_) == cachedCount" }, limit = "3")
	public Object doLoop(VirtualFrame frame, Object elements_, //
			@CachedLibrary("elements_") NV1IntLibrary arrays, //
			@Cached("arrays.length(elements_)") int cachedCount) {
		CompilerDirectives.isPartialEvaluationConstant(cachedCount);
		frame.setObject(indexSlot, new NV0Int(0));
		frame.getFrameDescriptor().setFrameSlotKind(indexSlot, FrameSlotKind.Object);
		if (counterSlot != null) {
			frame.setObject(counterSlot, new NV0Int(0));
			frame.getFrameDescriptor().setFrameSlotKind(counterSlot, FrameSlotKind.Object);
		}
		body.executeGeneric(frame);
		// ================================
//		final int offset = 1;
//		final int iMax = 20;
//		final int iiMax = (cachedCount - 1 - offset) / iMax;
//		
//		int ii = 0;
//		
//		for (; ii < iiMax; ii++) {
//			doLoopInternal(frame, ii * iMax, iMax, offset);
//		}
//		
//		for (int i = ii * iMax + offset; i < cachedCount - 1; i++) {
//			frame.setObject(indexSlot, new NV0Int(i));
//			body.executeGeneric(frame);
//		}
		// ================================
		for (int i = 1; i < cachedCount - 1; i++) {
			frame.setObject(indexSlot, new NV0Int(i));
			if (counterSlot != null) {
				frame.setObject(counterSlot, new NV0Int(i));
			}
			body.executeGeneric(frame);
		}
		frame.setObject(indexSlot, new NV0Int(cachedCount - 1));
		if (counterSlot != null) {
			frame.setObject(counterSlot, new NV0Int(cachedCount - 1));
		}
		return body.executeGeneric(frame);
	}

	@Specialization(guards = "arrays.isArray(elements_)", limit = "3")
	public Object doLoop(VirtualFrame frame, Object elements_, //
			@CachedLibrary("elements_") NV1IntLibrary arrays) {
		final int iterationCount = arrays.length(elements_);
		CompilerDirectives.isPartialEvaluationConstant(iterationCount);
		frame.setObject(indexSlot, new NV0Int(0));
		frame.getFrameDescriptor().setFrameSlotKind(indexSlot, FrameSlotKind.Object);
		if (counterSlot != null) {
			frame.setObject(counterSlot, new NV0Int(0));
			frame.getFrameDescriptor().setFrameSlotKind(counterSlot, FrameSlotKind.Object);
		}
		body.executeGeneric(frame);
		for (int i = 1; i < iterationCount - 1; i++) {
			frame.setObject(indexSlot, new NV0Int(i));
			if (counterSlot != null) {
				frame.setObject(counterSlot, new NV0Int(i));
			}
			body.executeGeneric(frame);
		}
		frame.setObject(indexSlot, new NV0Int(iterationCount - 1));
		if (counterSlot != null) {
			frame.setObject(counterSlot, new NV0Int(iterationCount - 1));
		}
		return body.executeGeneric(frame);
	}

	@ExplodeLoop
	private void doLoopInternal(VirtualFrame frame, int ii, int iMax, int offset) {
		for (int i = 0; i < iMax; i++) {
			frame.setObject(indexSlot, new NV0Int(ii + i + offset));
			body.executeGeneric(frame);
		}
	}
}
