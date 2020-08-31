package fr.cea.nabla.interpreter.values;

import com.oracle.truffle.api.dsl.Specialization;
import com.oracle.truffle.api.interop.InteropException;
import com.oracle.truffle.api.interop.InteropLibrary;
import com.oracle.truffle.api.library.CachedLibrary;
import com.oracle.truffle.api.nodes.Node;

import fr.cea.nabla.interpreter.runtime.NablaInternalError;

public abstract class BoxValueNode extends Node {

		protected final Class<?> type;

		protected BoxValueNode(Class<?> type) {
			this.type = type;
		}

		public abstract Object execute(Object obj);
		
		@Specialization(guards = "isBool()", limit = "3")
		protected Object doBool(Object obj, @CachedLibrary("obj") InteropLibrary objLibrary) {
			try {
				return objLibrary.asBoolean(obj);
			} catch (InteropException e) {
			}
			throw NablaInternalError.shouldNotReachHere();
		}
		
		@Specialization(guards = "isBoolArray1()", limit = "3")
		protected Object doBool1(Object obj, @CachedLibrary("obj") InteropLibrary objLibrary) {
			try {
				final int iSize = (int) objLibrary.getArraySize(obj);
				final boolean[] valArray = new boolean[iSize];
				for (int i = 0; i < iSize; i++) {
					valArray[i] = (boolean) objLibrary.readArrayElement(obj, i);
				}
				return valArray;
			} catch (InteropException e) {
			}
			throw NablaInternalError.shouldNotReachHere();
		}

		@Specialization(guards = "isBoolArray2()", limit = "3")
		protected Object doBool2(Object obj, @CachedLibrary("obj") InteropLibrary objLibrary) {
			try {
				final int iSize = (int) objLibrary.getArraySize(obj);
				final int jSize = (int) objLibrary.getArraySize(objLibrary.readArrayElement(obj, 0));
				final boolean[][] valArray = new boolean[iSize][jSize];
				for (int i = 0; i < iSize; i++) {
					for (int j = 0; j < jSize; j++) {
						valArray[i][j] = (boolean) objLibrary.readArrayElement(objLibrary.readArrayElement(obj, i), j);
					}
				}
				return valArray;
			} catch (InteropException e) {
			}
			throw NablaInternalError.shouldNotReachHere();
		}

		@Specialization(guards = "isBoolArray3()", limit = "3")
		protected Object doBool3(Object obj, @CachedLibrary("obj") InteropLibrary objLibrary) {
			try {
				final int iSize = (int) objLibrary.getArraySize(obj);
				final int jSize = (int) objLibrary.getArraySize(objLibrary.readArrayElement(obj, 0));
				final int kSize = (int) objLibrary.getArraySize(objLibrary.readArrayElement(objLibrary.readArrayElement(obj, 0), 0));
				final boolean[][][] valArray = new boolean[iSize][jSize][kSize];
				for (int i = 0; i < iSize; i++) {
					for (int j = 0; j < jSize; j++) {
						for (int k = 0; k < kSize; k++) {
							valArray[i][j][k] = (boolean) objLibrary.readArrayElement(objLibrary.readArrayElement(objLibrary.readArrayElement(obj, i), j), k);
						}
					}
				}
				return valArray;
			} catch (InteropException e) {
			}
			throw NablaInternalError.shouldNotReachHere();
		}

		@Specialization(guards = "isBoolArray4()", limit = "3")
		protected Object doBool4(Object obj, @CachedLibrary("obj") InteropLibrary objLibrary) {
			try {
				final int iSize = (int) objLibrary.getArraySize(obj);
				final int jSize = (int) objLibrary.getArraySize(objLibrary.readArrayElement(obj, 0));
				final int kSize = (int) objLibrary.getArraySize(objLibrary.readArrayElement(objLibrary.readArrayElement(obj, 0), 0));
				final int lSize = (int) objLibrary.getArraySize(objLibrary.readArrayElement(objLibrary.readArrayElement(objLibrary.readArrayElement(obj, 0), 0), 0));
				final boolean[][][][] valArray = new boolean[iSize][jSize][kSize][lSize];
				for (int i = 0; i < iSize; i++) {
					for (int j = 0; j < jSize; j++) {
						for (int k = 0; k < kSize; k++) {
							for (int l = 0; l < lSize; l++) {
								valArray[i][j][k][l] = (boolean) objLibrary.readArrayElement(objLibrary.readArrayElement(objLibrary.readArrayElement(objLibrary.readArrayElement(obj, i), j), k), l);
							}
						}
					}
				}
				return valArray;
			} catch (InteropException e) {
			}
			throw NablaInternalError.shouldNotReachHere();
		}
		
		@Specialization(guards = "isInt()", limit = "3")
		protected Object doInt(Object obj, @CachedLibrary("obj") InteropLibrary objLibrary) {
			try {
				return objLibrary.asInt(obj);
			} catch (InteropException e) {
			}
			throw NablaInternalError.shouldNotReachHere();
		}

		@Specialization(guards = "isIntArray1()", limit = "3")
		protected Object doInt1(Object obj, @CachedLibrary("obj") InteropLibrary objLibrary) {
			try {
				final int iSize = (int) objLibrary.getArraySize(obj);
				final int[] valArray = new int[iSize];
				for (int i = 0; i < iSize; i++) {
					valArray[i] = (int) objLibrary.readArrayElement(obj, i);
				}
				return valArray;
			} catch (InteropException e) {
			}
			throw NablaInternalError.shouldNotReachHere();
		}

		@Specialization(guards = "isIntArray2()", limit = "3")
		protected Object doInt2(Object obj, @CachedLibrary("obj") InteropLibrary objLibrary) {
			try {
				final int iSize = (int) objLibrary.getArraySize(obj);
				final int jSize = (int) objLibrary.getArraySize(objLibrary.readArrayElement(obj, 0));
				final int[][] valArray = new int[iSize][jSize];
				for (int i = 0; i < iSize; i++) {
					for (int j = 0; j < jSize; j++) {
						valArray[i][j] = (int) objLibrary.readArrayElement(objLibrary.readArrayElement(obj, i), j);
					}
				}
				return valArray;
			} catch (InteropException e) {
			}
			throw NablaInternalError.shouldNotReachHere();
		}

		@Specialization(guards = "isIntArray3()", limit = "3")
		protected Object doInt3(Object obj, @CachedLibrary("obj") InteropLibrary objLibrary) {
			try {
				final int iSize = (int) objLibrary.getArraySize(obj);
				final int jSize = (int) objLibrary.getArraySize(objLibrary.readArrayElement(obj, 0));
				final int kSize = (int) objLibrary.getArraySize(objLibrary.readArrayElement(objLibrary.readArrayElement(obj, 0), 0));
				final int[][][] valArray = new int[iSize][jSize][kSize];
				for (int i = 0; i < iSize; i++) {
					for (int j = 0; j < jSize; j++) {
						for (int k = 0; k < kSize; k++) {
							valArray[i][j][k] = (int) objLibrary.readArrayElement(objLibrary.readArrayElement(objLibrary.readArrayElement(obj, i), j), k);
						}
					}
				}
				return valArray;
			} catch (InteropException e) {
			}
			throw NablaInternalError.shouldNotReachHere();
		}

		@Specialization(guards = "isIntArray4()", limit = "3")
		protected Object doInt4(Object obj, @CachedLibrary("obj") InteropLibrary objLibrary) {
			try {
				final int iSize = (int) objLibrary.getArraySize(obj);
				final int jSize = (int) objLibrary.getArraySize(objLibrary.readArrayElement(obj, 0));
				final int kSize = (int) objLibrary.getArraySize(objLibrary.readArrayElement(objLibrary.readArrayElement(obj, 0), 0));
				final int lSize = (int) objLibrary.getArraySize(objLibrary.readArrayElement(objLibrary.readArrayElement(objLibrary.readArrayElement(obj, 0), 0), 0));
				final int[][][][] valArray = new int[iSize][jSize][kSize][lSize];
				for (int i = 0; i < iSize; i++) {
					for (int j = 0; j < jSize; j++) {
						for (int k = 0; k < kSize; k++) {
							for (int l = 0; l < lSize; l++) {
								valArray[i][j][k][l] = (int) objLibrary.readArrayElement(objLibrary.readArrayElement(objLibrary.readArrayElement(objLibrary.readArrayElement(obj, i), j), k), l);
							}
						}
					}
				}
				return valArray;
			} catch (InteropException e) {
			}
			throw NablaInternalError.shouldNotReachHere();
		}
		
		@Specialization(guards = "isDouble()", limit = "3")
		protected Object doDouble(Object obj, @CachedLibrary("obj") InteropLibrary objLibrary) {
			try {
				return objLibrary.asDouble(obj);
			} catch (InteropException e) {
			}
			throw NablaInternalError.shouldNotReachHere();
		}

		@Specialization(guards = "isDoubleArray1()", limit = "3")
		protected Object doDouble1(Object obj, @CachedLibrary("obj") InteropLibrary objLibrary) {
			try {
				final int iSize = (int) objLibrary.getArraySize(obj);
				final double[] valArray = new double[iSize];
				for (int i = 0; i < iSize; i++) {
					valArray[i] = (double) objLibrary.readArrayElement(obj, i);
				}
				return valArray;
			} catch (InteropException e) {
			}
			throw NablaInternalError.shouldNotReachHere();
		}

		@Specialization(guards = "isDoubleArray2()", limit = "3")
		protected Object doDouble2(Object obj, @CachedLibrary("obj") InteropLibrary objLibrary) {
			try {
				final int iSize = (int) objLibrary.getArraySize(obj);
				final int jSize = (int) objLibrary.getArraySize(objLibrary.readArrayElement(obj, 0));
				final double[][] valArray = new double[iSize][jSize];
				for (int i = 0; i < iSize; i++) {
					for (int j = 0; j < jSize; j++) {
						valArray[i][j] = (double) objLibrary.readArrayElement(objLibrary.readArrayElement(obj, i), j);
					}
				}
				return valArray;
			} catch (InteropException e) {
			}
			throw NablaInternalError.shouldNotReachHere();
		}

		@Specialization(guards = "isDoubleArray3()", limit = "3")
		protected Object doDouble3(Object obj, @CachedLibrary("obj") InteropLibrary objLibrary) {
			try {
				final int iSize = (int) objLibrary.getArraySize(obj);
				final int jSize = (int) objLibrary.getArraySize(objLibrary.readArrayElement(obj, 0));
				final int kSize = (int) objLibrary.getArraySize(objLibrary.readArrayElement(objLibrary.readArrayElement(obj, 0), 0));
				final double[][][] valArray = new double[iSize][jSize][kSize];
				for (int i = 0; i < iSize; i++) {
					for (int j = 0; j < jSize; j++) {
						for (int k = 0; k < kSize; k++) {
							valArray[i][j][k] = (double) objLibrary.readArrayElement(objLibrary.readArrayElement(objLibrary.readArrayElement(obj, i), j), k);
						}
					}
				}
				return valArray;
			} catch (InteropException e) {
			}
			throw NablaInternalError.shouldNotReachHere();
		}

		@Specialization(guards = "isDoubleArray4()", limit = "3")
		protected Object doDouble4(Object obj, @CachedLibrary("obj") InteropLibrary objLibrary) {
			try {
				final int iSize = (int) objLibrary.getArraySize(obj);
				final int jSize = (int) objLibrary.getArraySize(objLibrary.readArrayElement(obj, 0));
				final int kSize = (int) objLibrary.getArraySize(objLibrary.readArrayElement(objLibrary.readArrayElement(obj, 0), 0));
				final int lSize = (int) objLibrary.getArraySize(objLibrary.readArrayElement(objLibrary.readArrayElement(objLibrary.readArrayElement(obj, 0), 0), 0));
				final double[][][][] valArray = new double[iSize][jSize][kSize][lSize];
				for (int i = 0; i < iSize; i++) {
					for (int j = 0; j < jSize; j++) {
						for (int k = 0; k < kSize; k++) {
							for (int l = 0; l < lSize; l++) {
								valArray[i][j][k][l] = (double) objLibrary.readArrayElement(objLibrary.readArrayElement(objLibrary.readArrayElement(objLibrary.readArrayElement(obj, i), j), k), l);
							}
						}
					}
				}
				return valArray;
			} catch (InteropException e) {
			}
			throw NablaInternalError.shouldNotReachHere();
		}

		protected boolean isBool() {
			return type.equals(boolean.class);
		}

		protected boolean isBoolArray1() {
			return type.equals(boolean[].class);
		}

		protected boolean isBoolArray2() {
			return type.equals(boolean[][].class);
		}

		protected boolean isBoolArray3() {
			return type.equals(boolean[][][].class);
		}

		protected boolean isBoolArray4() {
			return type.equals(boolean[][][][].class);
		}

		protected boolean isInt() {
			return type.equals(int.class);
		}

		protected boolean isIntArray1() {
			return type.equals(int[].class);
		}

		protected boolean isIntArray2() {
			return type.equals(int[][].class);
		}

		protected boolean isIntArray3() {
			return type.equals(int[][][].class);
		}

		protected boolean isIntArray4() {
			return type.equals(int[][][][].class);
		}

		protected boolean isDouble() {
			return type.equals(double.class);
		}

		protected boolean isDoubleArray1() {
			return type.equals(double[].class);
		}

		protected boolean isDoubleArray2() {
			return type.equals(double[][].class);
		}

		protected boolean isDoubleArray3() {
			return type.equals(double[][][].class);
		}

		protected boolean isDoubleArray4() {
			return type.equals(double[][][][].class);
		}
	}