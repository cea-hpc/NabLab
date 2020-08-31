package fr.cea.nabla.interpreter.nodes.expression.unary;

import com.oracle.truffle.api.CompilerAsserts;
import com.oracle.truffle.api.dsl.NodeChild;
import com.oracle.truffle.api.dsl.Specialization;
import com.oracle.truffle.api.library.CachedLibrary;
import com.oracle.truffle.api.nodes.NodeInfo;

import fr.cea.nabla.interpreter.nodes.expression.NablaExpressionNode;
import fr.cea.nabla.interpreter.values.NV0Int;
import fr.cea.nabla.interpreter.values.NV0Real;
import fr.cea.nabla.interpreter.values.NV1Int;
import fr.cea.nabla.interpreter.values.NV1IntJava;
import fr.cea.nabla.interpreter.values.NV1IntLibrary;
import fr.cea.nabla.interpreter.values.NV1Real;
import fr.cea.nabla.interpreter.values.NV2Int;
import fr.cea.nabla.interpreter.values.NV2Real;

@NodeChild("valueNode")
@NodeInfo(shortName = "-")
public abstract class NablaMinusNode extends NablaExpressionNode {

	@Specialization
	protected NV0Int minus(NV0Int right) {
		return new NV0Int(Math.multiplyExact(-1, right.getData()));
	}

	@Specialization
	protected NV0Real minus(NV0Real value) {
		return new NV0Real(-1 * value.getData());
	}

	@Specialization(guards = "arrays.isArray(value)", limit = "3")
	protected NV1Int minus(Object value, @CachedLibrary("value") NV1IntLibrary arrays) {
		final int length = arrays.length(value);
		final int[] result = new int[length];

		for (int i = 0; i < length; i++) {
			result[i] = Math.multiplyExact(-1, arrays.read(value, i));
		}

		return new NV1IntJava(result);
	}

	@Specialization
	protected NV1Real minus(NV1Real value) {
		final double[] valueData = value.getData();

		CompilerAsserts.compilationConstant(valueData.length);

		final double[] result = new double[valueData.length];

		for (int i = 0; i < valueData.length; i++) {
			result[i] = -1 * valueData[i];
		}

		return new NV1Real(result);
	}

	@Specialization
	protected NV2Int minus(NV2Int value) {
		final int[][] valueData = value.getData();

		CompilerAsserts.compilationConstant(valueData.length);
		CompilerAsserts.compilationConstant(valueData[0].length);

		final int[][] result = new int[valueData.length][valueData[0].length];

		for (int i = 0; i < valueData.length; i++) {
			for (int j = 0; j < valueData[0].length; j++) {
				result[i][j] = Math.multiplyExact(-1, valueData[i][j]);
			}
		}

		return new NV2Int(result);
	}

	@Specialization
	protected NV2Real minus(NV2Real value) {
		final double[][] valueData = value.getData();

		CompilerAsserts.compilationConstant(valueData.length);
		CompilerAsserts.compilationConstant(valueData[0].length);

		final double[][] result = new double[valueData.length][valueData[0].length];

		for (int i = 0; i < valueData.length; i++) {
			for (int j = 0; j < valueData[0].length; j++) {
				result[i][j] = -1 * valueData[i][j];
			}
		}

		return new NV2Real(result);
	}
}
