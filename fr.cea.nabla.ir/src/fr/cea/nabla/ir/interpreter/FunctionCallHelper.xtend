package fr.cea.nabla.ir.interpreter

class FunctionCallHelper 
{
	static def dispatch Class<?> getJavaType(NV0Bool it) { typeof(boolean) }
	static def dispatch Class<?> getJavaType(NV1Bool it) { typeof(boolean[]) }
	static def dispatch Class<?> getJavaType(NV2Bool it) { typeof(boolean[][]) }
	static def dispatch Class<?> getJavaType(NV0Int it) { typeof(int) }
	static def dispatch Class<?> getJavaType(NV1Int it) { typeof(int[]) }
	static def dispatch Class<?> getJavaType(NV2Int it) { typeof(int[][]) }
	static def dispatch Class<?> getJavaType(NV0Real it) { typeof(double) }
	static def dispatch Class<?> getJavaType(NV1Real it) { typeof(double[]) }
	static def dispatch Class<?> getJavaType(NV2Real it) { typeof(double[][]) }

	static def dispatch Object getJavaValue(NV0Bool it) { data }
	static def dispatch Object getJavaValue(NV1Bool it) { data }
	static def dispatch Object getJavaValue(NV2Bool it) { data }
	static def dispatch Object getJavaValue(NV0Int it) { data }
	static def dispatch Object getJavaValue(NV1Int it) { data }
	static def dispatch Object getJavaValue(NV2Int it) { data }
	static def dispatch Object getJavaValue(NV0Real it) { data }
	static def dispatch Object getJavaValue(NV1Real it) { data }
	static def dispatch Object getJavaValue(NV2Real it) { data }

	static def dispatch createNablaValue(Object x) { throw new RuntimeException('Not yet implemented') }
	static def dispatch createNablaValue(Boolean x) { new NV0Bool(x) }
	static def dispatch createNablaValue(boolean[] x) { new NV1Bool(x) }
	static def dispatch createNablaValue(boolean[][] x) { new NV2Bool(x) }
	static def dispatch createNablaValue(Integer x) { new NV0Int(x) }
	static def dispatch createNablaValue(int[] x) { new NV1Int(x) }
	static def dispatch createNablaValue(int[][] x) { new NV2Int(x) }
	static def dispatch createNablaValue(Double x) { new NV0Real(x) }
	static def dispatch createNablaValue(double[] x) { new NV1Real(x) }
	static def dispatch createNablaValue(double[][] x) { new NV2Real(x) }
}