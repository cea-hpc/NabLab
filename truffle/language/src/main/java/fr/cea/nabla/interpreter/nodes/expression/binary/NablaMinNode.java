package fr.cea.nabla.interpreter.nodes.expression.binary;

import com.oracle.truffle.api.dsl.Specialization;
import com.oracle.truffle.api.nodes.NodeInfo;

import fr.cea.nabla.interpreter.values.NV0Int;
import fr.cea.nabla.interpreter.values.NV0Real;

@NodeInfo(shortName = "min")
public abstract class NablaMinNode extends NablaBinaryExpressionNode {

	@Specialization
	protected NV0Int min(NV0Int left, NV0Int right) {
		return new NV0Int(Math.min(left.getData(), right.getData()));
	}

	@Specialization
	protected NV0Real min(NV0Int left, NV0Real right) {
		return new NV0Real(Math.min(left.getData(), right.getData()));
	}

	@Specialization
	protected NV0Real min(NV0Real left, NV0Int right) {
		return new NV0Real(Math.min(left.getData(), right.getData()));
	}

	@Specialization
	protected NV0Real min(NV0Real left, NV0Real right) {
		return new NV0Real(Math.min(left.getData(), right.getData()));
	}

}
