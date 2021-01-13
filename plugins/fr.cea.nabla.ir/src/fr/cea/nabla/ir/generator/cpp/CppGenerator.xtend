package fr.cea.nabla.ir.generator.cpp

import fr.cea.nabla.ir.transformers.IrTransformationStep

abstract class CppGenerator
{
	protected val Backend backend
	protected val String libCppNablaDir

	def String getName() { backend.name }
	def IrTransformationStep getIrTransformationStep() { backend.irTransformationStep }
	def IrRoot2Cmake getIrRoot2CMake() { backend.getIrRoot2CMake }
	def TypeContentProvider getTypeContentProvider() { backend.typeContentProvider }
	def ExpressionContentProvider getExpressionContentProvider() { backend.expressionContentProvider }
	def ArgOrVarContentProvider getArgOrVarContentProvider() { backend.argOrVarContentProvider }
	def InstructionContentProvider getInstructionContentProvider() { backend.instructionContentProvider }
	def FunctionContentProvider getFunctionContentProvider() { backend.functionContentProvider }
	def TraceContentProvider getTraceContentProvider() { backend.traceContentProvider }
	def IncludesContentProvider getIncludesContentProvider() { backend.includesContentProvider }
	def JsonContentProvider getJsonContentProvider() { backend.jsonContentProvider }
	def JobCallerContentProvider getJobCallerContentProvider() { backend.jobCallerContentProvider }
	def JobContentProvider getJobContentProvider() { backend.jobContentProvider }
	def MainContentProvider getMainContentProvider() { backend.mainContentProvider }

	new(Backend backend, String libCppNablaDir)
	{
		this.backend = backend
		this.libCppNablaDir = libCppNablaDir
	}
}