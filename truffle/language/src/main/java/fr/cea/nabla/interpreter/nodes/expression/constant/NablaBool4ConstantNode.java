package fr.cea.nabla.interpreter.nodes.expression.constant;

import com.oracle.truffle.api.CompilerDirectives;
import com.oracle.truffle.api.CompilerDirectives.CompilationFinal;
import com.oracle.truffle.api.dsl.Specialization;
import com.oracle.truffle.api.frame.VirtualFrame;
import com.oracle.truffle.api.nodes.ExplodeLoop;

import fr.cea.nabla.interpreter.NablaTypesGen;
import fr.cea.nabla.interpreter.nodes.expression.NablaExpressionNode;
import fr.cea.nabla.interpreter.values.NV4Bool;

public abstract class NablaBool4ConstantNode extends NablaExpressionNode {

	@CompilationFinal
	private NV4Bool cachedValue;

	@Child
	private NablaExpressionNode value;
	@Children
	private final NablaExpressionNode[] dimensions;

	public NablaBool4ConstantNode(NablaExpressionNode value, NablaExpressionNode[] dimensions) {
		this.value = value;
		this.dimensions = dimensions;
	}

	@ExplodeLoop
	@Specialization
	public NV4Bool executeNV4Bool(VirtualFrame frame) {
		if (cachedValue == null) {
			CompilerDirectives.transferToInterpreterAndInvalidate();
			assert(dimensions.length == 3);
			final int[] computedDimensions = new int[] { //
					NablaTypesGen.asNV0Int(dimensions[0].executeGeneric(frame)).getData(),
					NablaTypesGen.asNV0Int(dimensions[1].executeGeneric(frame)).getData(),
					NablaTypesGen.asNV0Int(dimensions[2].executeGeneric(frame)).getData(),
					NablaTypesGen.asNV0Int(dimensions[3].executeGeneric(frame)).getData()
			};
			final boolean[][][][] computedValues = new boolean[computedDimensions[0]][computedDimensions[1]][computedDimensions[2]][computedDimensions[3]];
			final boolean val = NablaTypesGen.asNV0Bool(value.executeGeneric(frame)).isData();
			for (int i = 0; i < computedDimensions[0]; i++) {
				for (int j = 0; j < computedDimensions[1]; j++) {
					for (int k = 0; k < computedDimensions[2]; k++) {
						for (int l = 0; l < computedDimensions[3]; l++) {
							computedValues[i][j][k][l] = val;
						}
					}
				}
			}
			cachedValue = new NV4Bool(computedValues);
		}

		return cachedValue;
	}
}
