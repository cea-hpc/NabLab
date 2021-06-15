/*******************************************************************************
 * Copyright (c) 2021 CEA
 * This program and the accompanying materials are made available under the 
 * terms of the Eclipse Public License 2.0 which is available at
 * http://www.eclipse.org/legal/epl-2.0.
 *
 * SPDX-License-Identifier: EPL-2.0
 * Contributors: see AUTHORS file
 *******************************************************************************/
package fr.cea.nabla.generator.application

import com.google.inject.Inject
import fr.cea.nabla.generator.BackendFactory
import fr.cea.nabla.ir.generator.ApplicationGenerator
import fr.cea.nabla.ir.generator.cpp.arcane.ArcaneApplicationGenerator
import fr.cea.nabla.ir.generator.cpp.backends.CppApplicationGenerator
import fr.cea.nabla.ir.generator.java.JavaApplicationGenerator
import fr.cea.nabla.nablagen.NablagenApplication
import fr.cea.nabla.nablagen.Target

class ApplicationGeneratorFactory
{
	@Inject BackendFactory backendFactory

	def ApplicationGenerator create(Target target, NablagenApplication application, String wsPath)
	{
		val levelDBPath = if (application.levelDB === null) null else application.levelDB.levelDBPath

		switch target.type
		{
			case JAVA: new JavaApplicationGenerator(levelDBPath !== null)
			case ARCANE: new ArcaneApplicationGenerator(target.variables.findFirst[x | x.key == "Arcane_DIR"].value)
			default:
			{
				val backend = backendFactory.getCppBackend(target.type)
				backend.traceContentProvider.maxIterationsVarName = application.mainModule.iterationMax.name
				backend.traceContentProvider.stopTimeVarName = application.mainModule.timeMax.name
				new CppApplicationGenerator(backend, wsPath, levelDBPath, target.variables.map[key -> value])
			}
		}
	}
}