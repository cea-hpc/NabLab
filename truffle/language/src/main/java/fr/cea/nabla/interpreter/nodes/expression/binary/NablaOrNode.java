package fr.cea.nabla.interpreter.nodes.expression.binary;

import com.oracle.truffle.api.dsl.Specialization;
import com.oracle.truffle.api.nodes.NodeInfo;

import fr.cea.nabla.interpreter.values.NV0Bool;

@NodeInfo(shortName = "||")
public abstract class NablaOrNode extends NablaBinaryExpressionNode {
	
	@Specialization
	protected NV0Bool add(NV0Bool left, NV0Bool right) {
		return new NV0Bool(left.isData() || right.isData());
	}
	
	
	
	
}
