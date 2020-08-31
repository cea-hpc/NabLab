package fr.cea.nabla.interpreter.nodes.instruction;

import com.oracle.truffle.api.dsl.Specialization;
import com.oracle.truffle.api.frame.VirtualFrame;
import com.oracle.truffle.api.nodes.NodeInfo;
import com.oracle.truffle.api.nodes.UnexpectedResultException;
import com.oracle.truffle.api.profiles.ConditionProfile;

import fr.cea.nabla.interpreter.NablaException;
import fr.cea.nabla.interpreter.nodes.expression.NablaExpressionNode;

@NodeInfo(shortName = "if", description = "The node implementing a condional statement")
public abstract class NablaIfNode extends NablaInstructionNode {

	@Child
	private NablaExpressionNode conditionNode;
	@Child
	private NablaInstructionNode thenPartNode;
	@Child
	protected NablaInstructionNode elsePartNode;

	private final ConditionProfile condition = ConditionProfile.createCountingProfile();

	public NablaIfNode(NablaExpressionNode conditionNode, NablaInstructionNode thenPartNode,
			NablaInstructionNode elsePartNode) {
		this.conditionNode = conditionNode;
		this.thenPartNode = thenPartNode;
		this.elsePartNode = elsePartNode;
	}

	@Specialization(guards = "elsePartNode != null")
	public Object doThenElse(VirtualFrame frame) {
		if (condition.profile(evaluateCondition(frame))) {
			return thenPartNode.executeGeneric(frame);
		} else {
			return elsePartNode.executeGeneric(frame);
		}
	}

	@Specialization(guards = "elsePartNode == null")
	public Object doThen(VirtualFrame frame) {
		if (condition.profile(evaluateCondition(frame))) {
			return thenPartNode.executeGeneric(frame);
		}
		return null;
	}

	private boolean evaluateCondition(VirtualFrame frame) {
		try {
			return conditionNode.executeNV0Bool(frame).isData();
		} catch (UnexpectedResultException ex) {
			throw NablaException.typeError(this, ex.getResult());
		}
	}
}
