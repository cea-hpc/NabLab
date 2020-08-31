package fr.cea.nabla.interpreter.nodes.expression.constant;

import com.oracle.truffle.api.dsl.Cached;
import com.oracle.truffle.api.dsl.NodeChild;
import com.oracle.truffle.api.dsl.Specialization;
import com.oracle.truffle.api.frame.VirtualFrame;
import com.oracle.truffle.api.nodes.ExplodeLoop;

import fr.cea.nabla.interpreter.nodes.expression.NablaExpressionNode;
import fr.cea.nabla.interpreter.values.NV0Int;
import fr.cea.nabla.interpreter.values.NV1Int;
import fr.cea.nabla.interpreter.values.NV1IntJava;

@NodeChild(value = "value", type = NablaExpressionNode.class)
@NodeChild(value = "size", type = NablaExpressionNode.class)
public abstract class NablaInt1ConstantNode extends NablaExpressionNode {

	@Specialization(guards = {"cachedSize == size.getData()", "isZero(value.getData())"})
	protected NV1Int doDefaultCached(VirtualFrame frame, NV0Int value, NV0Int size, //
			@Cached("size.getData()") int cachedSize, //
			@Cached("getDefaultResult(cachedSize)") NV1Int result) {
		return result;
	}
	
	@Specialization(guards = "cachedSize == size.getData()")
	public NV1Int doCached(VirtualFrame frame, NV0Int value, NV0Int size, //
			@Cached("value.getData()") int cachedValue, //
			@Cached("size.getData()") int cachedSize, //
			@Cached("getResult(cachedValue, cachedSize)") NV1Int result) {
		return result;
	}
	
	protected boolean isZero(int d) { return d == 0; }

	protected NV1Int getDefaultResult(int size) {
		final int[] computedValues = new int[size];
		return new NV1IntJava(computedValues);
	}

	@ExplodeLoop
	protected NV1Int getResult(int value, final int size) {
		final int[] computedValues = new int[size];
		for (int i = 0; i < size; i++) {
			computedValues[i] = value;
		}
		return new NV1IntJava(computedValues);
	}
}
