/*******************************************************************************
 * Copyright (c) 2021 CEA
 * This program and the accompanying materials are made available under the
 * terms of the Eclipse Public License 2.0 which is available at
 * http://www.eclipse.org/legal/epl-2.0.
 *
 * SPDX-License-Identifier: EPL-2.0
 * Contributors: see AUTHORS file
 *******************************************************************************/
package fr.cea.nabla.ir.generator.cpp

import fr.cea.nabla.ir.transformers.IrTransformationStep

abstract class CppGenerator
{
	protected val Backend backend

	def String getName() { backend.name }
	def IrTransformationStep[] getIrTransformationSteps() { backend.irTransformationSteps }
	def CMakeContentProvider getIrRoot2CMake() { backend.cmakeContentProvider }
	def TypeContentProvider getTypeContentProvider() { backend.typeContentProvider }
	def ExpressionContentProvider getExpressionContentProvider() { backend.expressionContentProvider }
	def InstructionContentProvider getInstructionContentProvider() { backend.instructionContentProvider }
	def FunctionContentProvider getFunctionContentProvider() { backend.functionContentProvider }
	def TraceContentProvider getTraceContentProvider() { backend.traceContentProvider }
	def IncludesContentProvider getIncludesContentProvider() { backend.includesContentProvider }
	def JsonContentProvider getJsonContentProvider() { backend.jsonContentProvider }
	def JobCallerContentProvider getJobCallerContentProvider() { backend.jobCallerContentProvider }
	def JobContentProvider getJobContentProvider() { backend.jobContentProvider }
	def MainContentProvider getMainContentProvider() { backend.mainContentProvider }

	new(Backend backend)
	{
		this.backend = backend
	}
}