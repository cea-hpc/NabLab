package fr.cea.nabla.interpreter.nodes.expression;

import com.oracle.truffle.api.dsl.NodeChild;
import com.oracle.truffle.api.dsl.Specialization;
import com.oracle.truffle.api.frame.VirtualFrame;

import fr.cea.nabla.interpreter.values.NV0Bool;
import fr.cea.nabla.interpreter.values.NV0Int;
import fr.cea.nabla.interpreter.values.NV0Real;
import fr.cea.nabla.interpreter.values.NV1Bool;
import fr.cea.nabla.interpreter.values.NV1Int;
import fr.cea.nabla.interpreter.values.NV1Real;
import fr.cea.nabla.interpreter.values.NV2Bool;
import fr.cea.nabla.interpreter.values.NV2Int;
import fr.cea.nabla.interpreter.values.NV2Real;
import fr.cea.nabla.interpreter.values.NV3Int;
import fr.cea.nabla.interpreter.values.NV3Real;
import fr.cea.nabla.interpreter.values.NV4Int;
import fr.cea.nabla.interpreter.values.NV4Real;

@NodeChild(value = "expression", type = NablaExpressionNode.class)
public abstract class NablaParenthesisNode extends NablaExpressionNode {
    
    @Specialization
    public NV0Bool executeNV0Bool(VirtualFrame frame, NV0Bool value) {
    	return value;
    }

	@Specialization
	public NV0Int executeNV0Int(VirtualFrame frame, NV0Int value) {
    	return value;
	}

	@Specialization
	public NV0Real executeNV0Real(VirtualFrame frame, NV0Real value) {
    	return value;
	}

	@Specialization
	public NV1Bool executeNV1Bool(VirtualFrame frame, NV1Bool value) {
    	return value;
	}

	@Specialization
	public NV1Int executeNV1Int(VirtualFrame frame, NV1Int value) {
    	return value;
	}

	@Specialization
	public NV1Real executeNV1Real(VirtualFrame frame, NV1Real value) {
    	return value;
	}

	@Specialization
	public NV2Bool executeNV2Bool(VirtualFrame frame, NV2Bool value) {
    	return value;
	}

	@Specialization
	public NV2Int executeNV2Int(VirtualFrame frame, NV2Int value) {
    	return value;
	}

	@Specialization
	public NV2Real executeNV2Real(VirtualFrame frame, NV2Real value) {
    	return value;
	}

	@Specialization
	public NV3Int executeNV3Int(VirtualFrame frame, NV3Int value) {
    	return value;
	}

	@Specialization
	public NV3Real executeNV3Real(VirtualFrame frame, NV3Real value) {
    	return value;
	}

	@Specialization
	public NV4Int executeNV4Int(VirtualFrame frame, NV4Int value) {
    	return value;
	}

	@Specialization
	public NV4Real executeNV4Real(VirtualFrame frame, NV4Real value) {
    	return value;
	}
}
