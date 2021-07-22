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
import fr.cea.nabla.ir.generator.arcane.ArcaneApplicationGenerator
import fr.cea.nabla.ir.generator.cpp.CppApplicationGenerator
import fr.cea.nabla.ir.generator.java.JavaApplicationGenerator
import fr.cea.nabla.nablagen.NablagenApplication
import fr.cea.nabla.nablagen.Target
import java.util.ArrayList

class ApplicationGeneratorFactory
{
	@Inject BackendFactory backendFactory

	def ApplicationGenerator create(Target target, NablagenApplication application, String wsPath)
	{
		switch target.type
		{
			case JAVA: new JavaApplicationGenerator(application.levelDB !== null)
			case ARCANE:
			{
				val cmakeVars = new ArrayList<Pair<String, String>>
				target.variables.forEach[x | cmakeVars += x.key -> x.value]
				new ArcaneApplicationGenerator(wsPath, cmakeVars)
			}
			default:
			{
				val backend = backendFactory.getCppBackend(target.type)
				backend.traceContentProvider.maxIterationsVarName = application.mainModule.iterationMax.name
				backend.traceContentProvider.stopTimeVarName = application.mainModule.timeMax.name
				val cmakeVars = new ArrayList<Pair<String, String>>
				target.variables.forEach[x | cmakeVars += x.key -> x.value]
				if (application.levelDB !== null) application.levelDB.variables.forEach[x | cmakeVars += x.key -> x.value]
				new CppApplicationGenerator(backend, wsPath, (application.levelDB !== null), cmakeVars)
			}
		}
	}
}