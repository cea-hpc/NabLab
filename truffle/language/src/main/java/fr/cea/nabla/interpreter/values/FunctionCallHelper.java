/**
 * Copyright (c) 2020 CEA
 * This program and the accompanying materials are made available under the
 * terms of the Eclipse Public License 2.0 which is available at
 * http://www.eclipse.org/legal/epl-2.0.
 * 
 * SPDX-License-Identifier: EPL-2.0
 * Contributors: see AUTHORS file
 */
package fr.cea.nabla.interpreter.values;

import fr.cea.nabla.ir.ir.PrimitiveType;
import fr.cea.nabla.interpreter.runtime.NablaContext;
import fr.cea.nabla.interpreter.values.NV0Bool;
import fr.cea.nabla.interpreter.values.NV0Int;
import fr.cea.nabla.interpreter.values.NV0Real;
import fr.cea.nabla.interpreter.values.NV1Bool;
import fr.cea.nabla.interpreter.values.NV1Int;
import fr.cea.nabla.interpreter.values.NV1Real;
import fr.cea.nabla.interpreter.values.NV2Bool;
import fr.cea.nabla.interpreter.values.NV2Int;
import fr.cea.nabla.interpreter.values.NV2Real;
import fr.cea.nabla.interpreter.values.NablaValue;
import java.io.Serializable;
import java.util.Arrays;

@SuppressWarnings("all")
public class FunctionCallHelper {
	public static Class<?> getJavaType(final PrimitiveType primitive, final int dimension) {
		Class<? extends Serializable> _switchResult = null;
		if (primitive != null) {
			switch (primitive) {
			case BOOL:
				Class<? extends Serializable> _switchResult_1 = null;
				switch (dimension) {
				case 0:
					_switchResult_1 = boolean.class;
					break;
				case 1:
					_switchResult_1 = boolean[].class;
					break;
				case 2:
					_switchResult_1 = boolean[][].class;
					break;
				default:
					throw new RuntimeException(("Dimension not implemented: " + Integer.valueOf(dimension)));
				}
				_switchResult = _switchResult_1;
				break;
			case INT:
				Class<? extends Serializable> _switchResult_2 = null;
				switch (dimension) {
				case 0:
					_switchResult_2 = int.class;
					break;
				case 1:
					_switchResult_2 = int[].class;
					break;
				case 2:
					_switchResult_2 = int[][].class;
					break;
				default:
					throw new RuntimeException(("Dimension not implemented: " + Integer.valueOf(dimension)));
				}
				_switchResult = _switchResult_2;
				break;
			case REAL:
				Class<? extends Serializable> _switchResult_3 = null;
				switch (dimension) {
				case 0:
					_switchResult_3 = double.class;
					break;
				case 1:
					_switchResult_3 = double[].class;
					break;
				case 2:
					_switchResult_3 = double[][].class;
					break;
				default:
					throw new RuntimeException(("Dimension not implemented: " + Integer.valueOf(dimension)));
				}
				_switchResult = _switchResult_3;
				break;
			default:
				break;
			}
		}
		return _switchResult;
	}

//	protected static Object _getJavaValue(final NV0Bool it) {
//		return Boolean.valueOf(it.isData());
//	}
//
//	protected static Object _getJavaValue(final NV1Bool it) {
//		return it.getData();
//	}
//
//	protected static Object _getJavaValue(final NV2Bool it) {
//		return it.getData();
//	}
//
//	protected static Object _getJavaValue(final NV0Int it) {
//		return Integer.valueOf(it.getData());
//	}
//
//	protected static Object _getJavaValue(final NV1Int it) {
//		return it.getData();
//	}
//
//	protected static Object _getJavaValue(final NV2Int it) {
//		return it.getData();
//	}
//
//	protected static Object _getJavaValue(final NV0Real it) {
//		return Double.valueOf(it.getData());
//	}
//
//	protected static Object _getJavaValue(final NV1Real it) {
//		return it.getData();
//	}
//
//	protected static Object _getJavaValue(final NV2Real it) {
//		return it.getData();
//	}

//	protected static NablaValue _createNablaValue(final Object x) {
//		return (NablaValue) NablaContext.getCurrent().getEnv().asGuestValue(x);
//	}
//
//	protected static NablaValue _createNablaValue(final Boolean x) {
//		return new NV0Bool((x).booleanValue());
//	}
//
//	protected static NablaValue _createNablaValue(final boolean[] x) {
//		return new NV1Bool(x);
//	}
//
//	protected static NablaValue _createNablaValue(final boolean[][] x) {
//		return new NV2Bool(x);
//	}
//
//	protected static NablaValue _createNablaValue(final Integer x) {
//		return new NV0Int((x).intValue());
//	}
//
//	protected static NablaValue _createNablaValue(final int[] x) {
//		return new NV1Int(x);
//	}
//
//	protected static NablaValue _createNablaValue(final int[][] x) {
//		return new NV2Int(x);
//	}
//
//	protected static NablaValue _createNablaValue(final Double x) {
//		return new NV0Real((x).doubleValue());
//	}
//
//	protected static NablaValue _createNablaValue(final double[] x) {
//		return new NV1Real(x);
//	}
//
//	protected static NablaValue _createNablaValue(final double[][] x) {
//		return new NV2Real(x);
//	}

//	public static Object getJavaValue(final NablaValue it) {
//		if (it instanceof NV0Bool) {
//			return _getJavaValue((NV0Bool) it);
//		} else if (it instanceof NV0Int) {
//			return _getJavaValue((NV0Int) it);
//		} else if (it instanceof NV0Real) {
//			return _getJavaValue((NV0Real) it);
//		} else if (it instanceof NV1Bool) {
//			return _getJavaValue((NV1Bool) it);
//		} else if (it instanceof NV1Int) {
//			return _getJavaValue((NV1Int) it);
//		} else if (it instanceof NV1Real) {
//			return _getJavaValue((NV1Real) it);
//		} else if (it instanceof NV2Bool) {
//			return _getJavaValue((NV2Bool) it);
//		} else if (it instanceof NV2Int) {
//			return _getJavaValue((NV2Int) it);
//		} else if (it instanceof NV2Real) {
//			return _getJavaValue((NV2Real) it);
//		} else {
//			throw new IllegalArgumentException("Unhandled parameter types: " + Arrays.<Object>asList(it).toString());
//		}
//	}

//	public static NablaValue createNablaValue(final Object x) {
//		if (x instanceof Double) {
//			return _createNablaValue((Double) x);
//		} else if (x instanceof Integer) {
//			return _createNablaValue((Integer) x);
//		} else if (x instanceof Boolean) {
//			return _createNablaValue((Boolean) x);
//		} else if (x instanceof boolean[]) {
//			return _createNablaValue((boolean[]) x);
//		} else if (x instanceof boolean[][]) {
//			return _createNablaValue((boolean[][]) x);
//		} else if (x instanceof double[]) {
//			return _createNablaValue((double[]) x);
//		} else if (x instanceof double[][]) {
//			return _createNablaValue((double[][]) x);
//		} else if (x instanceof int[]) {
//			return _createNablaValue((int[]) x);
//		} else if (x instanceof int[][]) {
//			return _createNablaValue((int[][]) x);
//		} else if (x != null) {
//			return _createNablaValue(x);
//		} else {
//			throw new IllegalArgumentException("Unhandled parameter types: " + Arrays.<Object>asList(x).toString());
//		}
//	}
}
