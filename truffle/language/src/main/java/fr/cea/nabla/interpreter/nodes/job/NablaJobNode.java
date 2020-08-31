package fr.cea.nabla.interpreter.nodes.job;

import java.util.Map;

import com.oracle.truffle.api.instrumentation.StandardTags;
import com.oracle.truffle.api.instrumentation.Tag;

import fr.cea.nabla.interpreter.nodes.instruction.NablaInstructionNode;

public abstract class NablaJobNode extends NablaInstructionNode {

	protected final String name;

	protected NablaJobNode(String name) {
		this.name = name;
	}

	protected NablaJobNode() {
		this.name = "";
	}

	@Override
	public boolean hasTag(Class<? extends Tag> tag) {
		return tag.equals(StandardTags.RootTag.class) || tag.equals(StandardTags.StatementTag.class) || super.hasTag(tag);
	}

	@Override
	public Map<String, Object> getDebugProperties() {
		Map<String, Object> debugProperties = super.getDebugProperties();
		if (this.name != null && !this.name.isEmpty()) {
			debugProperties.put("jobName", this.name);
		}
		return debugProperties;
	}

}
