package fr.cea.nabla.interpreter.nodes.expression.constant;

import com.oracle.truffle.api.dsl.Cached;
import com.oracle.truffle.api.dsl.NodeChild;
import com.oracle.truffle.api.dsl.Specialization;
import com.oracle.truffle.api.frame.VirtualFrame;
import com.oracle.truffle.api.nodes.ExplodeLoop;

import fr.cea.nabla.interpreter.nodes.expression.NablaExpressionNode;
import fr.cea.nabla.interpreter.values.NV0Bool;
import fr.cea.nabla.interpreter.values.NV0Int;
import fr.cea.nabla.interpreter.values.NV1Bool;

@NodeChild(value = "value", type = NablaExpressionNode.class)
@NodeChild(value = "size", type = NablaExpressionNode.class)
public abstract class NablaBool1ConstantNode extends NablaExpressionNode {
	
	@Specialization(guards = {"cachedSize == size.getData()", "!value.isData()"})
	protected NV1Bool doDefaultCached(VirtualFrame frame, NV0Bool value, NV0Int size, //
			@Cached("size.getData()") int cachedSize, //
			@Cached("getDefaultResult(cachedSize)") NV1Bool result) {
		return result;
	}
	
	@Specialization(guards = "cachedSize == size.getData()")
	public NV1Bool doCached(VirtualFrame frame, NV0Bool value, NV0Int size, //
			@Cached("value.isData()") boolean cachedValue, //
			@Cached("size.getData()") int cachedSize, //
			@Cached("getResult(cachedValue, cachedSize)") NV1Bool result) {
		return result;
	}

	protected NV1Bool getDefaultResult(int size) {
		final boolean[] computedValues = new boolean[size];
		return new NV1Bool(computedValues);
	}

	@ExplodeLoop
	protected NV1Bool getResult(boolean value, final int size) {
		final boolean[] computedValues = new boolean[size];
		for (int i = 0; i < size; i++) {
			computedValues[i] = value;
		}
		return new NV1Bool(computedValues);
	}
}
