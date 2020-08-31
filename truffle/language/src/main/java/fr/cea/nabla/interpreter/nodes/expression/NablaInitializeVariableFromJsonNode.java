package fr.cea.nabla.interpreter.nodes.expression;

import com.google.gson.JsonArray;
import com.google.gson.JsonElement;
import com.oracle.truffle.api.dsl.NodeChild;
import com.oracle.truffle.api.dsl.Specialization;
import com.oracle.truffle.api.library.CachedLibrary;

import fr.cea.nabla.interpreter.values.NV0Bool;
import fr.cea.nabla.interpreter.values.NV0Int;
import fr.cea.nabla.interpreter.values.NV0Real;
import fr.cea.nabla.interpreter.values.NV1Bool;
import fr.cea.nabla.interpreter.values.NV1IntJava;
import fr.cea.nabla.interpreter.values.NV1IntLibrary;
import fr.cea.nabla.interpreter.values.NV1Real;
import fr.cea.nabla.interpreter.values.NV2Bool;
import fr.cea.nabla.interpreter.values.NV2Int;
import fr.cea.nabla.interpreter.values.NV2Real;
import fr.cea.nabla.interpreter.values.NV3Bool;
import fr.cea.nabla.interpreter.values.NV3Int;
import fr.cea.nabla.interpreter.values.NV3Real;
import fr.cea.nabla.interpreter.values.NV4Bool;
import fr.cea.nabla.interpreter.values.NV4Int;
import fr.cea.nabla.interpreter.values.NV4Real;

@NodeChild(value = "value", type = NablaExpressionNode.class)
public abstract class NablaInitializeVariableFromJsonNode extends NablaExpressionNode {

	private final JsonElement initialValue;

	public NablaInitializeVariableFromJsonNode(JsonElement initialValue) {
		this.initialValue = initialValue;
	}

	protected NablaInitializeVariableFromJsonNode() {
		this.initialValue = null;
	}

	@Specialization
	protected Object doInitialize(NV0Bool value) {
		return new NV0Bool(initialValue.getAsBoolean());
	}

	@Specialization
	protected Object doInitialize(NV1Bool value) {
		final JsonArray ja = initialValue.getAsJsonArray();
		final boolean[] data = new boolean[value.getData().length];
		for (int i = 0; i < data.length; i++) {
			data[i] = ja.get(i).getAsBoolean();
		}
		return new NV1Bool(data);
	}

	@Specialization
	protected Object doInitialize(NV2Bool value) {
		final JsonArray ja = initialValue.getAsJsonArray();
		final boolean[][] valueData = value.getData();
		final boolean[][] data = new boolean[valueData.length][valueData[0].length];
		for (int i = 0; i < data.length; i++) {
			for (int j = 0; j < data[i].length; j++) {
				data[i][j] = ja.get(i).getAsJsonArray().get(j).getAsBoolean();
			}
		}
		return new NV2Bool(data);
	}

	@Specialization
	protected Object doInitialize(NV3Bool value) {
		final JsonArray ja = initialValue.getAsJsonArray();
		final boolean[][][] valueData = value.getData();
		final boolean[][][] data = new boolean[valueData.length][valueData[0].length][valueData[0][0].length];
		for (int i = 0; i < data.length; i++) {
			for (int j = 0; j < data[i].length; j++) {
				for (int k = 0; k < data[i][j].length; j++) {
					data[i][j][k] = ja.get(i).getAsJsonArray().get(j).getAsJsonArray().get(k).getAsBoolean();
				}
			}
		}
		return new NV3Bool(data);
	}

	@Specialization
	protected Object doInitialize(NV4Bool value) {
		final JsonArray ja = initialValue.getAsJsonArray();
		final boolean[][][][] valueData = value.getData();
		final boolean[][][][] data = new boolean[valueData.length][valueData[0].length][valueData[0][0].length][valueData[0][0][0].length];
		for (int i = 0; i < data.length; i++) {
			for (int j = 0; j < data[i].length; j++) {
				for (int k = 0; k < data[i][j].length; j++) {
					for (int l = 0; l < data[i][j][k].length; j++) {
						data[i][j][k][l] = ja.get(i).getAsJsonArray().get(j).getAsJsonArray().get(k).getAsJsonArray().get(l).getAsBoolean();
					}
				}
			}
		}
		return new NV4Bool(data);
	}

	@Specialization
	protected Object doInitialize(NV0Int value) {
		return new NV0Int(initialValue.getAsInt());
	}

	@Specialization(guards = "arrays.isArray(value)", limit = "3")
	protected Object doInitialize(Object value, @CachedLibrary("value") NV1IntLibrary arrays) {
		final JsonArray ja = initialValue.getAsJsonArray();
		final int[] data = new int[arrays.length(value)];
		for (int i = 0; i < data.length; i++) {
			data[i] = ja.get(i).getAsInt();
		}
		return new NV1IntJava(data);
	}

	@Specialization
	protected Object doInitialize(NV2Int value) {
		final JsonArray ja = initialValue.getAsJsonArray();
		final int[][] valueData = value.getData();
		final int[][] data = new int[valueData.length][valueData[0].length];
		for (int i = 0; i < data.length; i++) {
			for (int j = 0; j < data[i].length; j++) {
				data[i][j] = ja.get(i).getAsJsonArray().get(j).getAsInt();
			}
		}
		return new NV2Int(data);
	}

	@Specialization
	protected Object doInitialize(NV3Int value) {
		final JsonArray ja = initialValue.getAsJsonArray();
		final int[][][] valueData = value.getData();
		final int[][][] data = new int[valueData.length][valueData[0].length][valueData[0][0].length];
		for (int i = 0; i < data.length; i++) {
			for (int j = 0; j < data[i].length; j++) {
				for (int k = 0; k < data[i][j].length; j++) {
					data[i][j][k] = ja.get(i).getAsJsonArray().get(j).getAsJsonArray().get(k).getAsInt();
				}
			}
		}
		return new NV3Int(data);
	}

	@Specialization
	protected Object doInitialize(NV4Int value) {
		final JsonArray ja = initialValue.getAsJsonArray();
		final int[][][][] valueData = value.getData();
		final int[][][][] data = new int[valueData.length][valueData[0].length][valueData[0][0].length][valueData[0][0][0].length];
		for (int i = 0; i < data.length; i++) {
			for (int j = 0; j < data[i].length; j++) {
				for (int k = 0; k < data[i][j].length; j++) {
					for (int l = 0; l < data[i][j][k].length; j++) {
						data[i][j][k][l] = ja.get(i).getAsJsonArray().get(j).getAsJsonArray().get(k).getAsJsonArray().get(l).getAsInt();
					}
				}
			}
		}
		return new NV4Int(data);
	}

	@Specialization
	protected Object doInitialize(NV0Real value) {
		value.setData(initialValue.getAsDouble());
		return value;
	}

	@Specialization
	protected Object doInitialize(NV1Real value) {
		final JsonArray ja = initialValue.getAsJsonArray();
		final double[] data = new double[value.getData().length];
		for (int i = 0; i < data.length; i++) {
			data[i] = ja.get(i).getAsDouble();
		}
		return new NV1Real(data);
	}

	@Specialization
	protected Object doInitialize(NV2Real value) {
		final JsonArray ja = initialValue.getAsJsonArray();
		final double[][] valueData = value.getData();
		final double[][] data = new double[valueData.length][valueData[0].length];
		for (int i = 0; i < data.length; i++) {
			for (int j = 0; j < data[i].length; j++) {
				data[i][j] = ja.get(i).getAsJsonArray().get(j).getAsDouble();
			}
		}
		return new NV2Real(data);
	}

	@Specialization
	protected Object doInitialize(NV3Real value) {
		final JsonArray ja = initialValue.getAsJsonArray();
		final double[][][] valueData = value.getData();
		final double[][][] data = new double[valueData.length][valueData[0].length][valueData[0][0].length];
		for (int i = 0; i < data.length; i++) {
			for (int j = 0; j < data[i].length; j++) {
				for (int k = 0; k < data[i][j].length; j++) {
					data[i][j][k] = ja.get(i).getAsJsonArray().get(j).getAsJsonArray().get(k).getAsDouble();
				}
			}
		}
		return new NV3Real(data);
	}

	@Specialization
	protected Object doInitialize(NV4Real value) {
		final JsonArray ja = initialValue.getAsJsonArray();
		final double[][][][] valueData = value.getData();
		final double[][][][] data = new double[valueData.length][valueData[0].length][valueData[0][0].length][valueData[0][0][0].length];
		for (int i = 0; i < data.length; i++) {
			for (int j = 0; j < data[i].length; j++) {
				for (int k = 0; k < data[i][j].length; j++) {
					for (int l = 0; l < data[i][j][k].length; j++) {
						data[i][j][k][l] = ja.get(i).getAsJsonArray().get(j).getAsJsonArray().get(k).getAsJsonArray().get(l).getAsDouble();
					}
				}
			}
		}
		return new NV4Real(data);
	}

}
