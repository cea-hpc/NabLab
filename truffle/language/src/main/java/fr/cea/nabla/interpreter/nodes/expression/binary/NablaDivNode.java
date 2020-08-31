package fr.cea.nabla.interpreter.nodes.expression.binary;

import com.oracle.truffle.api.CompilerAsserts;
import com.oracle.truffle.api.dsl.Cached;
import com.oracle.truffle.api.dsl.Specialization;
import com.oracle.truffle.api.library.CachedLibrary;
import com.oracle.truffle.api.nodes.ExplodeLoop;
import com.oracle.truffle.api.nodes.NodeInfo;

import fr.cea.nabla.interpreter.values.NV0Int;
import fr.cea.nabla.interpreter.values.NV0Real;
import fr.cea.nabla.interpreter.values.NV1Int;
import fr.cea.nabla.interpreter.values.NV1IntJava;
import fr.cea.nabla.interpreter.values.NV1IntLibrary;
import fr.cea.nabla.interpreter.values.NV1Real;
import fr.cea.nabla.interpreter.values.NV2Int;
import fr.cea.nabla.interpreter.values.NV2Real;

@NodeInfo(shortName = "/")
public abstract class NablaDivNode extends NablaBinaryExpressionNode {
	
	@Specialization
	protected NV0Int div(NV0Int left, NV0Int right) {
		return new NV0Int(left.getData() / right.getData());
	}

	@Specialization
	protected NV0Real div(NV0Int left, NV0Real right) {
		return new NV0Real(left.getData() / right.getData());
	}

	@ExplodeLoop
	@Specialization(guards = "arrays.isArray(right)", limit = "3")
	protected NV1Int div(NV0Int left, Object right, @CachedLibrary("right") NV1IntLibrary arrays) {
		final int leftData = left.getData();
		final int length = arrays.length(right);

		final int[] result = new int[length];

		for (int i = 0; i < length; i++) {
			result[i] = leftData / arrays.read(right, i);
		}

		return new NV1IntJava(result);
	}

	@ExplodeLoop
	@Specialization
	protected NV1Real div(NV0Int left, NV1Real right) {
		final int leftData = left.getData();
		final double[] rightData = right.getData();

		CompilerAsserts.partialEvaluationConstant(rightData.length);

		final double[] result = new double[rightData.length];

		for (int i = 0; i < rightData.length; i++) {
			result[i] = leftData / rightData[i];
		}

		return new NV1Real(result);
	}

	@ExplodeLoop
	@Specialization
	protected NV2Int div(NV0Int left, NV2Int right) {
		final int leftData = left.getData();
		final int[][] rightData = right.getData();

		CompilerAsserts.partialEvaluationConstant(rightData.length);
		CompilerAsserts.partialEvaluationConstant(rightData[0].length);

		final int[][] result = new int[rightData.length][rightData[0].length];

		for (int i = 0; i < rightData.length; i++) {
			for (int j = 0; j < rightData[0].length; j++) {
				result[i][j] = leftData / rightData[i][j];
			}
		}

		return new NV2Int(result);
	}

	@ExplodeLoop
	@Specialization
	protected NV2Real div(NV0Int left, NV2Real right) {
		final int leftData = left.getData();
		final double[][] rightData = right.getData();

		CompilerAsserts.partialEvaluationConstant(rightData.length);
		CompilerAsserts.partialEvaluationConstant(rightData[0].length);

		final double[][] result = new double[rightData.length][rightData[0].length];

		for (int i = 0; i < rightData.length; i++) {
			for (int j = 0; j < rightData[0].length; j++) {
				result[i][j] = leftData / rightData[i][j];
			}
		}

		return new NV2Real(result);
	}

	@Specialization
	protected NV0Real div(NV0Real left, NV0Int right) {
		return new NV0Real(left.getData() / right.getData());
	}

	@Specialization
	protected NV0Real div(NV0Real left, NV0Real right) {
		return new NV0Real(left.getData() / right.getData());
	}

	@ExplodeLoop
	@Specialization(guards = "arrays.isArray(right)", limit = "3")
	protected NV1Real div(NV0Real left, Object right, @CachedLibrary("right") NV1IntLibrary arrays) {
		final double leftData = left.getData();
		final int length = arrays.length(right);

		final double[] result = new double[length];

		for (int i = 0; i < length; i++) {
			result[i] = leftData / arrays.read(right, i);
		}

		return new NV1Real(result);
	}

	@ExplodeLoop
	@Specialization
	protected NV1Real div(NV0Real left, NV1Real right) {
		final double leftData = left.getData();
		final double[] rightData = right.getData();

		CompilerAsserts.partialEvaluationConstant(rightData.length);

		final double[] result = new double[rightData.length];

		for (int i = 0; i < rightData.length; i++) {
			result[i] = leftData / rightData[i];
		}

		return new NV1Real(result);
	}

	@ExplodeLoop
	@Specialization
	protected NV2Real div(NV0Real left, NV2Int right) {
		final double leftData = left.getData();
		final int[][] rightData = right.getData();

		CompilerAsserts.partialEvaluationConstant(rightData.length);
		CompilerAsserts.partialEvaluationConstant(rightData[0].length);

		final double[][] result = new double[rightData.length][rightData[0].length];

		for (int i = 0; i < rightData.length; i++) {
			for (int j = 0; j < rightData[0].length; j++) {
				result[i][j] = leftData / rightData[i][j];
			}
		}

		return new NV2Real(result);
	}

	@ExplodeLoop
	@Specialization
	protected NV2Real div(NV0Real left, NV2Real right) {
		final double leftData = left.getData();
		final double[][] rightData = right.getData();

		CompilerAsserts.partialEvaluationConstant(rightData.length);
		CompilerAsserts.partialEvaluationConstant(rightData[0].length);

		final double[][] result = new double[rightData.length][rightData[0].length];

		for (int i = 0; i < rightData.length; i++) {
			for (int j = 0; j < rightData[0].length; j++) {
				result[i][j] = leftData / rightData[i][j];
			}
		}

		return new NV2Real(result);
	}

	@ExplodeLoop
	@Specialization(guards = "arrays.isArray(left)", limit = "3")
	protected NV1Int div(Object left, NV0Int right, @CachedLibrary("left") NV1IntLibrary arrays) {
		final int length = arrays.length(left);
		final int rightData = right.getData();

		final int[] result = new int[length];

		for (int i = 0; i < length; i++) {
			result[i] = arrays.read(left, i) / rightData;
		}

		return new NV1IntJava(result);
	}

	@ExplodeLoop
	@Specialization(guards = "arrays.isArray(left)", limit = "3")
	protected NV1Real div(Object left, NV0Real right, @CachedLibrary("left") NV1IntLibrary arrays) {
		final int length = arrays.length(left);
		final double rightData = right.getData();

		final double[] result = new double[length];

		for (int i = 0; i < length; i++) {
			result[i] = arrays.read(left, i) / rightData;
		}

		return new NV1Real(result);
	}

	@ExplodeLoop
	@Specialization(guards = { "arraysLeft.isArray(left)", "arraysRight.isArray(right)" }, limit = "3")
	protected NV1Int div(Object left, Object right, //
			@CachedLibrary("left") NV1IntLibrary arraysLeft, //
			@CachedLibrary("right") NV1IntLibrary arraysRight) {
		final int length = arraysLeft.length(left);
		
		final int[] result = new int[length];

		for (int i = 0; i < length; i++) {
			result[i] = arraysLeft.read(left, i) / arraysRight.read(right, i);
		}

		return new NV1IntJava(result);
	}

	@ExplodeLoop
	@Specialization(guards = "arrays.isArray(left)", limit = "3")
	protected NV1Real div(Object left, NV1Real right, //
			@CachedLibrary("left") NV1IntLibrary arrays) {
		final int length = arrays.length(left);
		final double[] rightData = right.getData();

		final double[] result = new double[length];

		for (int i = 0; i < length; i++) {
			result[i] = arrays.read(left, i) / rightData[i];
		}

		return new NV1Real(result);
	}

	@ExplodeLoop
	@Specialization
	protected NV1Real div(NV1Real left, NV0Int right) {
		final double[] leftData = left.getData();
		final int rightData = right.getData();

		CompilerAsserts.partialEvaluationConstant(leftData.length);

		final double[] result = new double[leftData.length];

		for (int i = 0; i < leftData.length; i++) {
			result[i] = leftData[i] / rightData;
		}

		return new NV1Real(result);
	}

	@ExplodeLoop
	@Specialization
	protected NV1Real div(NV1Real left, NV0Real right) {
		final double[] leftData = left.getData();
		final double rightData = right.getData();

		CompilerAsserts.partialEvaluationConstant(leftData.length);

		final double[] result = new double[leftData.length];

		for (int i = 0; i < leftData.length; i++) {
			result[i] = leftData[i] / rightData;
		}

		return new NV1Real(result);
	}

	@ExplodeLoop
	@Specialization(guards = "arrays.isArray(right)", limit = "3")
	protected NV1Real div(NV1Real left, Object right, //
			@CachedLibrary("right") NV1IntLibrary arrays) {
		final double[] leftData = left.getData();

		CompilerAsserts.partialEvaluationConstant(leftData.length);

		final double[] result = new double[leftData.length];

		for (int i = 0; i < leftData.length; i++) {
			result[i] = leftData[i] / arrays.read(right, i);
		}

		return new NV1Real(result);
	}

	@ExplodeLoop
	@Specialization(guards = "left.getData().length == cachedCount")
	protected NV1Real div(NV1Real left, NV1Real right, @Cached("left.getData().length") int cachedCount) {
		final double[] leftData = left.getData();
		final double[] rightData = right.getData();

		CompilerAsserts.partialEvaluationConstant(cachedCount);

		final double[] result = new double[cachedCount];

		for (int i = 0; i < cachedCount; i++) {
			result[i] = leftData[i] / rightData[i];
		}

		return new NV1Real(result);
	}

	@Specialization
	protected NV1Real div(NV1Real left, NV1Real right) {
		final double[] leftData = left.getData();
		final double[] rightData = right.getData();

		CompilerAsserts.partialEvaluationConstant(leftData.length);

		final double[] result = new double[leftData.length];

		for (int i = 0; i < leftData.length; i++) {
			result[i] = leftData[i] / rightData[i];
		}

		return new NV1Real(result);
	}

	@ExplodeLoop
	@Specialization
	protected NV2Int div(NV2Int left, NV0Int right) {
		final int[][] leftData = left.getData();
		final int rightData = right.getData();

		CompilerAsserts.partialEvaluationConstant(leftData.length);
		CompilerAsserts.partialEvaluationConstant(leftData[0].length);

		final int[][] result = new int[leftData.length][leftData[0].length];

		for (int i = 0; i < leftData.length; i++) {
			for (int j = 0; j < leftData[0].length; j++) {
				result[i][j] = leftData[i][j] / rightData;
			}
		}

		return new NV2Int(result);
	}

	@ExplodeLoop
	@Specialization
	protected NV2Real div(NV2Int left, NV0Real right) {
		final int[][] leftData = left.getData();
		final double rightData = right.getData();

		CompilerAsserts.partialEvaluationConstant(leftData.length);
		CompilerAsserts.partialEvaluationConstant(leftData[0].length);

		final double[][] result = new double[leftData.length][leftData[0].length];

		for (int i = 0; i < leftData.length; i++) {
			for (int j = 0; j < leftData[0].length; j++) {
				result[i][j] = leftData[i][j] / rightData;
			}
		}

		return new NV2Real(result);
	}

	@ExplodeLoop
	@Specialization
	protected NV2Int div(NV2Int left, NV2Int right) {
		final int[][] leftData = left.getData();
		final int[][] rightData = right.getData();

		CompilerAsserts.partialEvaluationConstant(leftData.length);
		CompilerAsserts.partialEvaluationConstant(leftData[0].length);

		final int[][] result = new int[leftData.length][leftData[0].length];

		for (int i = 0; i < leftData.length; i++) {
			for (int j = 0; j < leftData[0].length; j++) {
				result[i][j] = leftData[i][j] / rightData[i][j];
			}
		}

		return new NV2Int(result);
	}

	@ExplodeLoop
	@Specialization
	protected NV2Real div(NV2Real left, NV0Int right) {
		final double[][] leftData = left.getData();
		final int rightData = right.getData();

		CompilerAsserts.partialEvaluationConstant(leftData.length);
		CompilerAsserts.partialEvaluationConstant(leftData[0].length);

		final double[][] result = new double[leftData.length][leftData[0].length];

		for (int i = 0; i < leftData.length; i++) {
			for (int j = 0; j < leftData[0].length; j++) {
				result[i][j] = leftData[i][j] / rightData;
			}
		}

		return new NV2Real(result);
	}

	@ExplodeLoop
	@Specialization
	protected NV2Real div(NV2Real left, NV0Real right) {
		final double[][] leftData = left.getData();
		final double rightData = right.getData();

		CompilerAsserts.partialEvaluationConstant(leftData.length);
		CompilerAsserts.partialEvaluationConstant(leftData[0].length);

		final double[][] result = new double[leftData.length][leftData[0].length];

		for (int i = 0; i < leftData.length; i++) {
			for (int j = 0; j < leftData[0].length; j++) {
				result[i][j] = leftData[i][j] / rightData;
			}
		}

		return new NV2Real(result);
	}

	@ExplodeLoop
	@Specialization(guards = { "left.getData().length == cachedCountI", "getInnerArrayLength(left.getData()) == cachedCountJ" })
	protected NV2Real div(NV2Real left, NV2Real right, @Cached("left.getData().length") int cachedCountI, @Cached("getInnerArrayLength(left.getData())") int cachedCountJ) {
		final double[][] leftData = left.getData();
		final double[][] rightData = right.getData();

		final double[][] result = new double[cachedCountI][cachedCountJ];

		for (int i = 0; i < cachedCountI; i++) {
			for (int j = 0; j < cachedCountJ; j++) {
				result[i][j] = leftData[i][j] / rightData[i][j];
			}
		}

		return new NV2Real(result);
	}

	@Specialization
	protected NV2Real div(NV2Real left, NV2Real right) {
		final double[][] leftData = left.getData();
		final double[][] rightData = right.getData();

		final double[][] result = new double[leftData.length][leftData[0].length];

		for (int i = 0; i < leftData.length; i++) {
			for (int j = 0; j < leftData[0].length; j++) {
				result[i][j] = leftData[i][j] / rightData[i][j];
			}
		}

		return new NV2Real(result);
	}
}
