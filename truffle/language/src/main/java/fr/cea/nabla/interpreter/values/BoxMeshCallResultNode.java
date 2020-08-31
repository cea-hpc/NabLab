package fr.cea.nabla.interpreter.values;

import org.graalvm.polyglot.Value;

import com.oracle.truffle.api.CompilerDirectives.CompilationFinal;
import com.oracle.truffle.api.dsl.Specialization;
import com.oracle.truffle.api.nodes.Node;

public abstract class BoxMeshCallResultNode extends Node {

	@CompilationFinal
	protected int nbDimensions = -1;

	public abstract Object execute(Object obj);

	@Specialization(guards = "value.fitsInInt()")
	protected Object doInt(Value value) {
		return value.asInt();
	}

	@Specialization(guards = "value.isHostObject()")
	protected Object doHostObject(Value value) {
		return value.asHostObject();
	}

	@Specialization(guards = {"value.isNativePointer()", "value.hasArrayElements()"})
	protected Object doNativeArray(Value value) {
		return value;
	}

//	@Specialization(guards = "getNbDimensions(value) == 0")
//	protected Object doInt(Value value) {
//		return value.asInt();
//	}
//
//	@Specialization(guards = "getNbDimensions(value) >= 1")
//	protected Object doIntArray(Value value) {
//		return value.asHostObject();
//	}
//
//	@Specialization(guards = "getNbDimensions(value) == 1")
//	protected Object doInt1(Value value) {
//		final int iSize = (int) value.getArraySize();
//		final int[] valArray = new int[iSize];
//		for (int i = 0; i < iSize; i++) {
//			valArray[i] = value.getArrayElement(i).asInt();
//		}
//		return valArray;
//	}
//
//	@Specialization(guards = "getNbDimensions(value) == 2")
//	protected Object doInt2(Value value) {
//		final int iSize = (int) value.getArraySize();
//		final int jSize = (int) value.getArrayElement(0).getArraySize();
//		final int[][] valArray = new int[iSize][jSize];
//		for (int i = 0; i < iSize; i++) {
//			for (int j = 0; j < jSize; j++) {
//				valArray[i][j] = value.getArrayElement(i).getArrayElement(j).asInt();
//			}
//		}
//		return valArray;
//	}
//
//	@Specialization(guards = "getNbDimensions(value) == 3")
//	protected Object doInt3(Value value) {
//		final int iSize = (int) value.getArraySize();
//		final int jSize = (int) value.getArrayElement(0).getArraySize();
//		final int kSize = (int) value.getArrayElement(0).getArrayElement(0).getArraySize();
//		final int[][][] valArray = new int[iSize][jSize][kSize];
//		for (int i = 0; i < iSize; i++) {
//			for (int j = 0; j < jSize; j++) {
//				for (int k = 0; k < kSize; k++) {
//					valArray[i][j][k] = value.getArrayElement(i).getArrayElement(j).getArrayElement(k).asInt();
//				}
//			}
//		}
//		return valArray;
//	}
//
//	@Specialization(guards = "getNbDimensions(value) == 4")
//	protected Object doInt4(Value value) {
//		final int iSize = (int) value.getArraySize();
//		final int jSize = (int) value.getArrayElement(0).getArraySize();
//		final int kSize = (int) value.getArrayElement(0).getArrayElement(0).getArraySize();
//		final int lSize = (int) value.getArrayElement(0).getArrayElement(0).getArrayElement(0).getArraySize();
//		final int[][][][] valArray = new int[iSize][jSize][kSize][lSize];
//		for (int i = 0; i < iSize; i++) {
//			for (int j = 0; j < jSize; j++) {
//				for (int k = 0; k < kSize; k++) {
//					for (int l = 0; l < lSize; l++) {
//						valArray[i][j][k][l] = value.getArrayElement(i).getArrayElement(j).getArrayElement(k).getArrayElement(l).asInt();
//					}
//				}
//			}
//		}
//		return valArray;
//	}

//	protected int getNbDimensions(Value value) {
//		if (nbDimensions == -1) {
//			CompilerDirectives.transferToInterpreterAndInvalidate();
//			nbDimensions++;
//			while (value.hasArrayElements()) {
//				value = value.getArrayElement(0);
//				nbDimensions++;
//			}
//		}
//		return nbDimensions;
//	}

}