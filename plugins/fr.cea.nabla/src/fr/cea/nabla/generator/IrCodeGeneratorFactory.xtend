/*******************************************************************************
 * Copyright (c) 2022 CEA
 * This program and the accompanying materials are made available under the
 * terms of the Eclipse Public License 2.0 which is available at
 * http://www.eclipse.org/legal/epl-2.0.
 *
 * SPDX-License-Identifier: EPL-2.0
 * Contributors: see AUTHORS file
 *******************************************************************************/
package fr.cea.nabla.generator

import com.google.inject.Inject
import fr.cea.nabla.ir.generator.IrCodeGenerator
import fr.cea.nabla.ir.generator.arcane.ArcaneGenerator
import fr.cea.nabla.ir.generator.cpp.CppGenerator
import fr.cea.nabla.ir.generator.java.JavaGenerator
import fr.cea.nabla.ir.generator.python.PythonGenerator
import fr.cea.nabla.nablagen.LevelDB
import fr.cea.nabla.nablagen.TargetType
import fr.cea.nabla.nablagen.TargetVar
import java.util.ArrayList

class IrCodeGeneratorFactory
{
	@Inject BackendFactory backendFactory

	def IrCodeGenerator create(String wsPath, TargetType targetType)
	{
		create(wsPath, targetType, #[], null, null, null)
	}

	def IrCodeGenerator create(String wsPath, TargetType targetType, Iterable<TargetVar> targetVars, LevelDB levelDB, String iterationMaxVarName, String timeMaxVarName)
	{
		val hasLevelDB = (levelDB !== null)
		switch targetType
		{
			case JAVA: new JavaGenerator(hasLevelDB)
			case PYTHON:
			{
				val envVars = new ArrayList<Pair<String, String>>
				targetVars.forEach[x | envVars += x.key -> x.value]
				new PythonGenerator(wsPath, hasLevelDB, envVars)
			}
			case ARCANE:
			{
				val cmakeVars = new ArrayList<Pair<String, String>>
				targetVars.forEach[x | cmakeVars += x.key -> x.value]
				new ArcaneGenerator(wsPath, cmakeVars)
			}
			default:
			{
				val backend = backendFactory.getCppBackend(targetType)
				backend.traceContentProvider.maxIterationsVarName = iterationMaxVarName
				backend.traceContentProvider.stopTimeVarName = timeMaxVarName
				val cmakeVars = new ArrayList<Pair<String, String>>
				targetVars.forEach[x | cmakeVars += x.key -> x.value]
				if (hasLevelDB) levelDB.variables.forEach[x | cmakeVars += x.key -> x.value]
				new CppGenerator(backend, wsPath, hasLevelDB, cmakeVars)
			}
		}
	}
}