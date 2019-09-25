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

	static def dispatch Object[] getJavaValue(NV0Bool it) { throw new RuntimeException('Not yet implemented') }
	static def dispatch Object[] getJavaValue(NV1Bool it) { throw new RuntimeException('Not yet implemented') }
	static def dispatch Object[] getJavaValue(NV2Bool it) { throw new RuntimeException('Not yet implemented') }
	static def dispatch Object[] getJavaValue(NV0Int it) { throw new RuntimeException('Not yet implemented') }
	static def dispatch Object[] getJavaValue(NV1Int it) { throw new RuntimeException('Not yet implemented') }
	static def dispatch Object[] getJavaValue(NV2Int it) { throw new RuntimeException('Not yet implemented') }
	static def dispatch Object[] getJavaValue(NV0Real it) { throw new RuntimeException('Not yet implemented') }
	static def dispatch Object[] getJavaValue(NV1Real it) { throw new RuntimeException('Not yet implemented') }
	static def dispatch Object[] getJavaValue(NV2Real it) { throw new RuntimeException('Not yet implemented') }

	static def dispatch createNablaValue(Object x) { throw new RuntimeException('Not yet implemented') }
	static def dispatch createNablaValue(Boolean x) { new NV0Bool(x) }
	static def dispatch createNablaValue(Boolean[] x) { throw new RuntimeException('Not yet implemented') }
	static def dispatch createNablaValue(Boolean[][] x) { throw new RuntimeException('Not yet implemented') }
	static def dispatch createNablaValue(Integer x) { new NV0Int(x) }
	static def dispatch createNablaValue(Integer[] x) { throw new RuntimeException('Not yet implemented') }
	static def dispatch createNablaValue(Integer[][] x) { throw new RuntimeException('Not yet implemented') }
	static def dispatch createNablaValue(Double x) { new NV0Real(x) }
	static def dispatch createNablaValue(Double[] x) { throw new RuntimeException('Not yet implemented') }
	static def dispatch createNablaValue(Double[][] x) { throw new RuntimeException('Not yet implemented') }
}