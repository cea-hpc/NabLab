package fr.cea.nabla.interpreter.nodes.expression.binary;

import com.oracle.truffle.api.dsl.Specialization;
import com.oracle.truffle.api.nodes.NodeInfo;

import fr.cea.nabla.interpreter.values.NV0Bool;
import fr.cea.nabla.interpreter.values.NV0Int;
import fr.cea.nabla.interpreter.values.NV0Real;

@NodeInfo(shortName = "==")
public abstract class NablaEqNode extends NablaBinaryExpressionNode {
	
	@Specialization
	protected NV0Bool add(NV0Bool left, NV0Bool right) {
		return new NV0Bool(left.isData() == right.isData());
	}
	
	@Specialization
	protected NV0Bool eq(NV0Int left, NV0Int right) {
		return new NV0Bool(left.getData() == right.getData());
	}
	
	@Specialization
	protected NV0Bool eq(NV0Int left, NV0Real right) {
		return new NV0Bool(left.getData() == right.getData());
	}
	
	
	@Specialization
	protected NV0Bool eq(NV0Real left, NV0Int right) {
		return new NV0Bool(left.getData() == right.getData());
	}
	
	@Specialization
	protected NV0Bool eq(NV0Real left, NV0Real right) {
		return new NV0Bool(left.getData() == right.getData());
	}
	
}
