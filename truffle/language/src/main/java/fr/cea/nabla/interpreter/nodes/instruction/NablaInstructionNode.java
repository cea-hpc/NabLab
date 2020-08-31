package fr.cea.nabla.interpreter.nodes.instruction;

import com.oracle.truffle.api.instrumentation.GenerateWrapper;
import com.oracle.truffle.api.instrumentation.ProbeNode;

import fr.cea.nabla.interpreter.nodes.NablaNode;

@GenerateWrapper
public abstract class NablaInstructionNode extends NablaNode {

	@Override
	public WrapperNode createWrapper(ProbeNode probe) {
		return new NablaInstructionNodeWrapper(this, probe);
	}
}
