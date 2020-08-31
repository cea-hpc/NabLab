package fr.cea.nabla.interpreter.nodes.instruction;

import com.oracle.truffle.api.dsl.NodeChild;
import com.oracle.truffle.api.dsl.Specialization;

import fr.cea.nabla.interpreter.nodes.expression.NablaExpressionNode;
import fr.cea.nabla.interpreter.values.NV0Bool;
import fr.cea.nabla.interpreter.values.NV0Int;
import fr.cea.nabla.interpreter.values.NV0Real;
import fr.cea.nabla.interpreter.values.NV1Bool;
import fr.cea.nabla.interpreter.values.NV1Int;
import fr.cea.nabla.interpreter.values.NV1Real;
import fr.cea.nabla.interpreter.values.NV2Bool;
import fr.cea.nabla.interpreter.values.NV2Int;
import fr.cea.nabla.interpreter.values.NV2Real;

@NodeChild(value = "value", type = NablaExpressionNode.class)
public abstract class NablaReturnNode extends NablaInstructionNode {

	@Specialization
	protected NV0Real doReal(NV0Real value) {
		return value;
	}
	
	@Specialization
	protected NV1Real doReal1(NV1Real value) {
		return value;
	}
	
	@Specialization
	protected NV0Bool doBool(NV0Bool value) {
		return value;
	}
	
	@Specialization
	protected NV1Bool doBool1(NV1Bool value) {
		return value;
	}
	
	@Specialization
	protected NV2Bool doBool2(NV2Bool value) {
		return value;
	}
	
	@Specialization
	protected NV0Int doInt(NV0Int value) {
		return value;
	}
	
	@Specialization
	protected NV1Int doInt1(NV1Int value) {
		return value;
	}
	
	@Specialization
	protected NV2Int doInt2(NV2Int value) {
		return value;
	}
	
	@Specialization
	protected NV2Real doReal2(NV2Real value) {
		return value;
	}
}
