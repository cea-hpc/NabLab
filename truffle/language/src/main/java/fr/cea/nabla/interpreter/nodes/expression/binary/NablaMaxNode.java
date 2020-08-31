package fr.cea.nabla.interpreter.nodes.expression.binary;

import com.oracle.truffle.api.dsl.Specialization;
import com.oracle.truffle.api.nodes.NodeInfo;

import fr.cea.nabla.interpreter.values.NV0Int;
import fr.cea.nabla.interpreter.values.NV0Real;

@NodeInfo(shortName = "max")
public abstract class NablaMaxNode extends NablaBinaryExpressionNode {

	@Specialization
	protected NV0Int max(NV0Int left, NV0Int right) {
		return new NV0Int(Math.max(left.getData(), right.getData()));
	}

	@Specialization
	protected NV0Real max(NV0Int left, NV0Real right) {
		return new NV0Real(Math.max(left.getData(), right.getData()));
	}

	@Specialization
	protected NV0Real max(NV0Real left, NV0Int right) {
		return new NV0Real(Math.max(left.getData(), right.getData()));
	}

	@Specialization
	protected NV0Real max(NV0Real left, NV0Real right) {
		return new NV0Real(Math.max(left.getData(), right.getData()));
	}

}
