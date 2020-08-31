package fr.cea.nabla.interpreter.nodes.expression.constant;

import com.oracle.truffle.api.CompilerDirectives;
import com.oracle.truffle.api.CompilerDirectives.CompilationFinal;
import com.oracle.truffle.api.dsl.Specialization;
import com.oracle.truffle.api.frame.VirtualFrame;
import com.oracle.truffle.api.nodes.ExplodeLoop;

import fr.cea.nabla.interpreter.NablaTypesGen;
import fr.cea.nabla.interpreter.nodes.expression.NablaExpressionNode;
import fr.cea.nabla.interpreter.values.NV2Bool;

public abstract class NablaBool2ConstantNode extends NablaExpressionNode {

	@CompilationFinal
	private NV2Bool cachedValue;

	@Child
	private NablaExpressionNode value;
	@Children
	private final NablaExpressionNode[] dimensions;

	public NablaBool2ConstantNode(NablaExpressionNode value, NablaExpressionNode[] dimensions) {
		this.value = value;
		this.dimensions = dimensions;
	}

	@ExplodeLoop
	@Specialization
	public NV2Bool executeNV2Bool(VirtualFrame frame) {
		if (cachedValue == null) {
			CompilerDirectives.transferToInterpreterAndInvalidate();
			assert(dimensions.length == 2);
			final int[] computedDimensions = new int[] {NablaTypesGen.asNV0Int(dimensions[0].executeGeneric(frame)).getData(),
					NablaTypesGen.asNV0Int(dimensions[1].executeGeneric(frame)).getData()
			};
			final boolean[][] computedValues = new boolean[computedDimensions[0]][computedDimensions[1]];
			final boolean val = NablaTypesGen.asNV0Bool(value.executeGeneric(frame)).isData();
			for (int i = 0; i < computedDimensions[0]; i++) {
				for (int j = 0; j < computedDimensions[1]; j++) {
					computedValues[i][j] = val;
				}
			}
			cachedValue = new NV2Bool(computedValues);
		}

		return cachedValue;
	}
}
