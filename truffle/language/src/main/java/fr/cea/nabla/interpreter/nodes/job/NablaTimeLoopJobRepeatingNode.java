package fr.cea.nabla.interpreter.nodes.job;

import java.util.List;

import com.oracle.truffle.api.CompilerDirectives;
import com.oracle.truffle.api.CompilerDirectives.CompilationFinal;
import com.oracle.truffle.api.dsl.NodeChild;
import com.oracle.truffle.api.dsl.Specialization;
import com.oracle.truffle.api.frame.Frame;
import com.oracle.truffle.api.frame.FrameSlot;
import com.oracle.truffle.api.frame.FrameSlotTypeException;
import com.oracle.truffle.api.frame.VirtualFrame;
import com.oracle.truffle.api.instrumentation.GenerateWrapper;
import com.oracle.truffle.api.instrumentation.InstrumentableNode;
import com.oracle.truffle.api.instrumentation.ProbeNode;
import com.oracle.truffle.api.instrumentation.StandardTags;
import com.oracle.truffle.api.instrumentation.Tag;
import com.oracle.truffle.api.nodes.ExplodeLoop;
import com.oracle.truffle.api.nodes.Node;
import com.oracle.truffle.api.nodes.RepeatingNode;

import fr.cea.nabla.interpreter.nodes.expression.NablaExpressionNode;
import fr.cea.nabla.interpreter.nodes.instruction.NablaWriteVariableNode;
import fr.cea.nabla.interpreter.utils.GetFrameNode;
import fr.cea.nabla.interpreter.values.NV0Bool;
import fr.cea.nabla.interpreter.values.NV0Int;

@GenerateWrapper
@NodeChild(value = "indexUpdate", type = NablaWriteVariableNode.class)
@NodeChild(value = "frameToWrite", type = GetFrameNode.class)
@NodeChild(value = "innerJobBlock", type = NablaJobBlockNode.class)
@NodeChild(value = "conditionNode", type = NablaExpressionNode.class)
public abstract class NablaTimeLoopJobRepeatingNode extends Node implements RepeatingNode, InstrumentableNode {

	@CompilationFinal(dimensions = 2)
	private FrameSlot[][] copies;

	public NablaTimeLoopJobRepeatingNode(List<FrameSlot[]> copies) {
		this.copies = copies.toArray(new FrameSlot[0][0]);
	}

	protected NablaTimeLoopJobRepeatingNode() {
		this.copies = null;
	}

	/**
	 * Necessary to avoid errors in generated class.
	 */
	@Override
	public final Object executeRepeatingWithValue(VirtualFrame frame) {
		if (executeRepeating(frame)) {
			return CONTINUE_LOOP_STATUS;
		} else {
			return BREAK_LOOP_STATUS;
		}
	}

	@ExplodeLoop
	@Specialization
	public boolean doLoop(VirtualFrame frame, NV0Int index, Frame toWrite, Object blockResult, NV0Bool shouldContinue) {
		final boolean continueLoop = shouldContinue.isData();
		if (CompilerDirectives.injectBranchProbability(0.9, continueLoop)) {
			for (int j = 0; j < copies.length; j++) {
				try {
					FrameSlot[] copy = copies[j];
					final Object left = toWrite.getObject(copy[1]);
					final Object right = toWrite.getObject(copy[0]);
					toWrite.setObject(copy[0], left);
					toWrite.setObject(copy[1], right);
				} catch (FrameSlotTypeException e) {
					e.printStackTrace();
				}
			}
		}
		return continueLoop;
	}

	@Override
	public boolean isInstrumentable() {
		return true;
	}

	@Override
	public boolean hasTag(Class<? extends Tag> tag) {
		return tag.equals(StandardTags.RootBodyTag.class);
	}

	@Override
	public WrapperNode createWrapper(ProbeNode probe) {
		return new NablaTimeLoopJobRepeatingNodeWrapper(this, probe);
	}
}
