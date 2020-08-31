package fr.cea.nabla.interpreter.nodes.instruction;

import java.util.Map;

import com.oracle.truffle.api.dsl.NodeChild;
import com.oracle.truffle.api.dsl.Specialization;
import com.oracle.truffle.api.frame.Frame;
import com.oracle.truffle.api.frame.FrameSlot;
import com.oracle.truffle.api.instrumentation.GenerateWrapper;
import com.oracle.truffle.api.instrumentation.InstrumentableNode;
import com.oracle.truffle.api.instrumentation.ProbeNode;
import com.oracle.truffle.api.instrumentation.StandardTags;
import com.oracle.truffle.api.instrumentation.Tag;
import com.oracle.truffle.api.interop.TruffleObject;

import fr.cea.nabla.interpreter.nodes.expression.NablaExpressionNode;
import fr.cea.nabla.interpreter.nodes.interop.NodeObjectDescriptor;
import fr.cea.nabla.interpreter.utils.GetFrameNode;
import fr.cea.nabla.interpreter.values.NV0Bool;
import fr.cea.nabla.interpreter.values.NV0Int;
import fr.cea.nabla.interpreter.values.NV0Real;
import fr.cea.nabla.interpreter.values.NV1Bool;
import fr.cea.nabla.interpreter.values.NV1Int;
import fr.cea.nabla.interpreter.values.NV1IntJava;
import fr.cea.nabla.interpreter.values.NV1Real;
import fr.cea.nabla.interpreter.values.NV2Bool;
import fr.cea.nabla.interpreter.values.NV2Int;
import fr.cea.nabla.interpreter.values.NV2Real;
import fr.cea.nabla.interpreter.values.NV3Bool;
import fr.cea.nabla.interpreter.values.NV3Int;
import fr.cea.nabla.interpreter.values.NV3Real;
import fr.cea.nabla.interpreter.values.NV4Bool;
import fr.cea.nabla.interpreter.values.NV4Int;
import fr.cea.nabla.interpreter.values.NV4Real;

@GenerateWrapper
@NodeChild(value = "value", type = NablaExpressionNode.class)
@NodeChild(value = "frameToWrite", type = GetFrameNode.class)
public abstract class NablaWriteVariableNode extends NablaInstructionNode implements InstrumentableNode, TruffleObject {

	private final FrameSlot slot;
	
	public NablaWriteVariableNode(FrameSlot slot) {
		this.slot = slot;
	}

	protected NablaWriteVariableNode() {
		this.slot = null;
	}

	@Specialization
	protected Object doWrite(NV0Bool value, Frame toWrite) {
		toWrite.setObject(slot, new NV0Bool(value.isData()));
		return value;
	}

	@Specialization
	protected Object doWrite(NV1Bool value, Frame toWrite) {
		toWrite.setObject(slot, new NV1Bool(value.getData().clone()));
		return value;
	}

	@Specialization
	protected Object doWrite(NV2Bool value, Frame toWrite) {
		toWrite.setObject(slot, new NV2Bool(value.getData().clone()));
		return value;
	}

	@Specialization
	protected Object doWrite(NV3Bool value, Frame toWrite) {
		toWrite.setObject(slot, new NV3Bool(value.getData().clone()));
		return value;
	}

	@Specialization
	protected Object doWrite(NV4Bool value, Frame toWrite) {
		toWrite.setObject(slot, new NV4Bool(value.getData().clone()));
		return value;
	}

	@Specialization
	protected Object doWrite(NV0Int value, Frame toWrite) {
		toWrite.setObject(slot, new NV0Int(value.getData()));
		return value;
	}

	@Specialization
	protected Object doWrite(NV1Int value, Frame toWrite) {
		toWrite.setObject(slot, new NV1IntJava(((NV1IntJava)value).getData().clone()));
		return value;
	}

	@Specialization
	protected Object doWrite(NV2Int value, Frame toWrite) {
		toWrite.setObject(slot, new NV2Int(value.getData().clone()));
		return value;
	}

	@Specialization
	protected Object doWrite(NV3Int value, Frame toWrite) {
		toWrite.setObject(slot, new NV3Int(value.getData().clone()));
		return value;
	}

	@Specialization
	protected Object doWrite(NV4Int value, Frame toWrite) {
		toWrite.setObject(slot, new NV4Int(value.getData().clone()));
		return value;
	}

	@Specialization
	protected Object doWrite(NV0Real value, Frame toWrite) {
		toWrite.setObject(slot, new NV0Real(value.getData()));
		return value;
	}

	@Specialization
	protected Object doWrite(NV1Real value, Frame toWrite) {
		final double[] src = value.getData();
		final double[] dest = new double[src.length];
		System.arraycopy(src, 0, dest, 0, src.length);
		toWrite.setObject(slot, new NV1Real(dest));
		return value;
	}

	@Specialization
	protected Object doWrite(NV2Real value, Frame toWrite) {
		toWrite.setObject(slot, new NV2Real(value.getData().clone()));
		return value;
	}

	@Specialization
	protected Object doWrite(NV3Real value, Frame toWrite) {
		toWrite.setObject(slot, new NV3Real(value.getData().clone()));
		return value;
	}

	@Specialization
	protected Object doWrite(NV4Real value, Frame toWrite) {
		toWrite.setObject(slot, new NV4Real(value.getData().clone()));
		return value;
	}

	public FrameSlot getSlot() {
		return slot;
	}

	@Override
	public Map<String, Object> getDebugProperties() {
		Map<String, Object> debugProperties = super.getDebugProperties();
		debugProperties.put("variableSlot", slot);
		return debugProperties;
	}

	@Override
	public boolean isInstrumentable() {
		return true;
	}
	
	@Override
	public boolean hasTag(Class<? extends Tag> tag) {
		return tag.equals(StandardTags.WriteVariableTag.class) || super.hasTag(tag);
	}

	@Override
	public WrapperNode createWrapper(ProbeNode probeNode) {
		return new NablaWriteVariableNodeWrapper(this, probeNode);
	}
	
	@Override
    public Object getNodeObject() {
        return NodeObjectDescriptor.writeVariable(getSlot().getIdentifier().toString());
    }

}
