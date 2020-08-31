package fr.cea.nabla.interpreter.nodes.expression;

import com.oracle.truffle.api.dsl.NodeChild;
import com.oracle.truffle.api.dsl.Specialization;
import com.oracle.truffle.api.frame.VirtualFrame;
import com.oracle.truffle.api.library.CachedLibrary;

import fr.cea.nabla.interpreter.values.NV0Int;
import fr.cea.nabla.interpreter.values.NV1IntLibrary;

@NodeChild("arrayNode")
@NodeChild("value")
public abstract class NablaIndexOfNode extends NablaExpressionNode {
	
	@Specialization(guards = "arrays.isArray(array)", limit = "3")
	protected NV0Int readNV1Int1Index(VirtualFrame frame, Object array, NV0Int value, @CachedLibrary("array") NV1IntLibrary arrays) {
		final int length = arrays.length(array);
		final int actualValue = value.getData();
		for (int i = 0; i < length; i++) {
			if (arrays.read(array, i) == actualValue) {
				return new NV0Int(i);
			}
		}
		return new NV0Int(-1);
	}
}
