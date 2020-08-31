package fr.cea.nabla.interpreter.nodes.expression;

import com.oracle.truffle.api.frame.VirtualFrame;
import com.oracle.truffle.api.nodes.UnexpectedResultException;
import com.oracle.truffle.api.profiles.ConditionProfile;

import fr.cea.nabla.interpreter.NablaException;

public class NablaContractedIfNode extends NablaExpressionNode {

	@Child
	private NablaExpressionNode conditionNode;
	@Child
	private NablaExpressionNode thenNode;
	@Child
	private NablaExpressionNode elseNode;

	private final ConditionProfile condition = ConditionProfile.createCountingProfile();

	public NablaContractedIfNode(NablaExpressionNode conditionNode, NablaExpressionNode thenNode,
			NablaExpressionNode elseNode) {
		this.conditionNode = conditionNode;
		this.thenNode = thenNode;
		this.elseNode = elseNode;
	}

	@Override
	public Object executeGeneric(VirtualFrame frame) {
		if (condition.profile(evaluateCondition(frame))) {
			return thenNode.executeGeneric(frame);
		} else {
			return elseNode.executeGeneric(frame);
		}
	}

	private boolean evaluateCondition(VirtualFrame frame) {
		try {
			return conditionNode.executeNV0Bool(frame).isData();
		} catch (UnexpectedResultException ex) {
			throw NablaException.typeError(this, ex.getResult());
		}
	}
}
