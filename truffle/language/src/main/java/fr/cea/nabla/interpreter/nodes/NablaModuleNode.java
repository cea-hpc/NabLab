package fr.cea.nabla.interpreter.nodes;

import com.oracle.truffle.api.dsl.TypeSystemReference;
import com.oracle.truffle.api.frame.FrameSlot;
import com.oracle.truffle.api.frame.FrameSlotKind;
import com.oracle.truffle.api.frame.MaterializedFrame;
import com.oracle.truffle.api.frame.VirtualFrame;
import com.oracle.truffle.api.instrumentation.GenerateWrapper;
import com.oracle.truffle.api.instrumentation.InstrumentableNode;
import com.oracle.truffle.api.instrumentation.ProbeNode;
import com.oracle.truffle.api.instrumentation.StandardTags;
import com.oracle.truffle.api.instrumentation.Tag;
import com.oracle.truffle.api.nodes.ExplodeLoop;

import fr.cea.nabla.interpreter.NablaTypes;
import fr.cea.nabla.interpreter.nodes.expression.NablaExpressionNode;
import fr.cea.nabla.interpreter.nodes.instruction.NablaInstructionNode;
import fr.cea.nabla.interpreter.nodes.instruction.NablaWriteVariableNode;
import fr.cea.nabla.interpreter.nodes.job.NablaJobBlockNode;
import fr.cea.nabla.interpreter.runtime.NablaContext;
import fr.cea.nabla.interpreter.runtime.NablaNull;
import fr.cea.nabla.interpreter.values.NV2Real;

@GenerateWrapper
@TypeSystemReference(NablaTypes.class)
public class NablaModuleNode extends NablaInstructionNode implements InstrumentableNode {

	private final FrameSlot coordinatesSlot;
	
	@Child
	private NablaModulePrologNode prologNode;
	
	@Child
	private NablaJobBlockNode jobBlock;

	public NablaModuleNode(NablaExpressionNode[] mandatoryVariables, FrameSlot coordinatesSlot,
			NablaWriteVariableNode[] connectivityVariables, NablaWriteVariableNode[] variableDeclarations,
			NablaWriteVariableNode[] variableDefinitions, NablaRootNode[] jobs, String pathToMeshLibrary) {
		this.prologNode = new NablaModulePrologNode(mandatoryVariables, connectivityVariables, variableDeclarations, variableDefinitions, pathToMeshLibrary);
//		this.mandatoryVariables = mandatoryVariables;
		this.coordinatesSlot = coordinatesSlot;
//		this.variableDeclarations = variableDeclarations;
//		this.variableDefinitions = variableDefinitions;
//		this.connectivityVariables = connectivityVariables;
		this.jobBlock = new NablaJobBlockNode(jobs);
	}

	protected NablaModuleNode() {
		this.coordinatesSlot = null;
	}

	@ExplodeLoop
	@Override
	public Object executeGeneric(VirtualFrame frame) {

		final MaterializedFrame globalFrame = frame.materialize();
		NablaContext.getCurrent().setGlobalFrame(this, globalFrame);

		prologNode.executeGeneric(globalFrame);

		globalFrame.setObject(coordinatesSlot, new NV2Real(NablaContext.getNodes().asHostObject()));
		globalFrame.getFrameDescriptor().setFrameSlotKind(coordinatesSlot, FrameSlotKind.Object);

		jobBlock.executeGeneric(globalFrame);

		return NablaNull.SINGLETON;
	}

	@Override
	public WrapperNode createWrapper(ProbeNode probe) {
		return new NablaModuleNodeWrapper(this, probe);
	}

	@Override
	public boolean hasTag(Class<? extends Tag> tag) {
		return tag.equals(StandardTags.RootTag.class) || super.hasTag(tag);
	}

}
