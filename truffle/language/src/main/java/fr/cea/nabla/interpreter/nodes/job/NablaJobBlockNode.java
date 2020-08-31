package fr.cea.nabla.interpreter.nodes.job;

import com.oracle.truffle.api.Truffle;
import com.oracle.truffle.api.frame.MaterializedFrame;
import com.oracle.truffle.api.frame.VirtualFrame;
import com.oracle.truffle.api.instrumentation.GenerateWrapper;
import com.oracle.truffle.api.instrumentation.InstrumentableNode;
import com.oracle.truffle.api.instrumentation.ProbeNode;
import com.oracle.truffle.api.instrumentation.StandardTags;
import com.oracle.truffle.api.instrumentation.Tag;
import com.oracle.truffle.api.nodes.BlockNode;
import com.oracle.truffle.api.nodes.DirectCallNode;
import com.oracle.truffle.api.source.SourceSection;

import fr.cea.nabla.interpreter.nodes.NablaNode;
import fr.cea.nabla.interpreter.nodes.NablaRootNode;
import fr.cea.nabla.interpreter.nodes.job.NablaJobBlockNode.JobCallNode;

public class NablaJobBlockNode extends NablaNode implements BlockNode.ElementExecutor<JobCallNode> {

	@Child
	private BlockNode<JobCallNode> block;

	public NablaJobBlockNode(NablaRootNode[] jobNodes) {
		final JobCallNode[] jobCallNodes = new JobCallNode[jobNodes.length];
		for (int i = 0; i < jobCallNodes.length; i++) {
			final JobCallNode jobCallNode = new JobCallNode(Truffle.getRuntime()
					.createDirectCallNode(Truffle.getRuntime().createCallTarget(jobNodes[i])));
			jobCallNodes[i] = jobCallNode;
		}
		this.block = jobNodes.length > 0 ? BlockNode.create(jobCallNodes, this) : null;
	}

	@Override
	public Object executeGeneric(VirtualFrame frame) {
		if (this.block != null) {
			final MaterializedFrame materializedFrame = frame.materialize();
			return this.block.executeGeneric(materializedFrame, BlockNode.NO_ARGUMENT);
		}
		return null;
	}

	@Override
	public void executeVoid(VirtualFrame frame, JobCallNode node, int index, int argument) {
		node.executeGeneric(frame);
	}
	
	@GenerateWrapper
	protected static class JobCallNode extends NablaNode implements InstrumentableNode {
		
		@Child
		private DirectCallNode callNode;
		
		public JobCallNode(DirectCallNode callNode) {
			this.callNode = callNode;
		}
		
		public Object executeGeneric(VirtualFrame frame) {
			return callNode.call(frame, this.getRootNode());
		}
		
		@Override
		public boolean hasTag(Class<? extends Tag> tag) {
			return super.hasTag(tag) || tag.equals(StandardTags.CallTag.class) || tag.equals(StandardTags.StatementTag.class);
		}
		
		protected JobCallNode(JobCallNode other) {
			this.callNode = other.callNode;
		}
		
		@Override
		public boolean isInstrumentable() {
			return true;
		}

		@Override
		public WrapperNode createWrapper(ProbeNode probe) {
			return new JobCallNodeWrapper(this, this, probe);
		}
		
		@Override
		public SourceSection getSourceSection() {
			return callNode.getCurrentRootNode().getSourceSection();
		}
		
	}
}
