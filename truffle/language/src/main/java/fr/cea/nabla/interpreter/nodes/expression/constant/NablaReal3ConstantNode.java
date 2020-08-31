package fr.cea.nabla.interpreter.nodes.expression.constant;

import com.oracle.truffle.api.CompilerDirectives;
import com.oracle.truffle.api.CompilerDirectives.CompilationFinal;
import com.oracle.truffle.api.dsl.Specialization;
import com.oracle.truffle.api.frame.VirtualFrame;
import com.oracle.truffle.api.nodes.ExplodeLoop;

import fr.cea.nabla.interpreter.NablaTypesGen;
import fr.cea.nabla.interpreter.nodes.expression.NablaExpressionNode;
import fr.cea.nabla.interpreter.values.NV3Real;

public abstract class NablaReal3ConstantNode extends NablaExpressionNode {

	@CompilationFinal
	private NV3Real cachedValue;

	@Child
	private NablaExpressionNode value;
	@Children
	private final NablaExpressionNode[] dimensions;

	public NablaReal3ConstantNode(NablaExpressionNode value, NablaExpressionNode[] dimensions) {
		this.value = value;
		this.dimensions = dimensions;
	}

	@ExplodeLoop
	@Specialization
	public NV3Real executeNV3Real(VirtualFrame frame) {
		if (cachedValue == null) {
			CompilerDirectives.transferToInterpreterAndInvalidate();
			assert(dimensions.length == 3);
			final int[] computedDimensions = new int[] {NablaTypesGen.asNV0Int(dimensions[0].executeGeneric(frame)).getData(),
					NablaTypesGen.asNV0Int(dimensions[1].executeGeneric(frame)).getData(),
					NablaTypesGen.asNV0Int(dimensions[2].executeGeneric(frame)).getData()
			};
			final double[][][] computedValues = new double[computedDimensions[0]][computedDimensions[1]][computedDimensions[2]];
			final double val = NablaTypesGen.asNV0Real(value.executeGeneric(frame)).getData();
			for (int i = 0; i < computedDimensions[0]; i++) {
				for (int j = 0; j < computedDimensions[1]; j++) {
					for (int k = 0; k < computedDimensions[2]; k++) {
						computedValues[i][j][k] = val;
					}
				}
			}
			cachedValue = new NV3Real(computedValues);
		}

		return cachedValue;
	}
}
