package fr.cea.nabla.interpreter.nodes.expression.constant;

import com.oracle.truffle.api.dsl.Cached;
import com.oracle.truffle.api.dsl.NodeChild;
import com.oracle.truffle.api.dsl.Specialization;
import com.oracle.truffle.api.frame.VirtualFrame;
import com.oracle.truffle.api.nodes.ExplodeLoop;

import fr.cea.nabla.interpreter.nodes.expression.NablaExpressionNode;
import fr.cea.nabla.interpreter.values.NV0Int;
import fr.cea.nabla.interpreter.values.NV0Real;
import fr.cea.nabla.interpreter.values.NV1Real;

@NodeChild(value = "value", type = NablaExpressionNode.class)
@NodeChild(value = "size", type = NablaExpressionNode.class)
public abstract class NablaReal1ConstantNode extends NablaExpressionNode {

	@Specialization(guards = {"cachedSize == size.getData()", "isZero(value.getData())"})
	protected NV1Real doDefaultCached(VirtualFrame frame, NV0Real value, NV0Int size, //
			@Cached("size.getData()") int cachedSize, //
			@Cached("getDefaultResult(cachedSize)") NV1Real result) {
		return result;
	}
	
	@Specialization(guards = "cachedSize == size.getData()")
	public NV1Real doCached(VirtualFrame frame, NV0Real value, NV0Int size, //
			@Cached("value.getData()") double cachedValue, //
			@Cached("size.getData()") int cachedSize, //
			@Cached("getResult(cachedValue, cachedSize)") NV1Real result) {
		return result;
	}
	
	protected boolean isZero(double d) { return d == 0.0; }

	protected NV1Real getDefaultResult(int size) {
		final double[] computedValues = new double[size];
		return new NV1Real(computedValues);
	}

	@ExplodeLoop
	protected NV1Real getResult(double value, final int size) {
		final double[] computedValues = new double[size];
		for (int i = 0; i < size; i++) {
			computedValues[i] = value;
		}
		return new NV1Real(computedValues);
	}
}
