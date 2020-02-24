/*******************************************************************************
 * Copyright (c) 2020 CEA
 * This program and the accompanying materials are made available under the 
 * terms of the Eclipse Public License 2.0 which is available at
 * http://www.eclipse.org/legal/epl-2.0.
 *
 * SPDX-License-Identifier: EPL-2.0
 * Contributors: see AUTHORS file
 *******************************************************************************/
package fr.cea.nabla.workflow

import fr.cea.nabla.ir.generator.cpp.Ir2Cpp
import fr.cea.nabla.ir.generator.cpp.KokkosBackend
import fr.cea.nabla.ir.generator.cpp.KokkosTeamThreadBackend
import fr.cea.nabla.ir.generator.java.Ir2Java
import fr.cea.nabla.nablagen.Cpp
import fr.cea.nabla.nablagen.Ir2CodeComponent
import fr.cea.nabla.nablagen.Java
import java.io.File

class CodeGeneratorProvider
{
	static def get(Ir2CodeComponent it, String baseDir)
	{
		val l = language
		switch l
		{
			Java: new Ir2Java
			Cpp: new Ir2Cpp(new File(baseDir + outputDir), l.backend)
			default : throw new RuntimeException("Unsupported language " + language.class.name)
		}
	}

	private static def getBackend(Cpp it)
	{
		switch programmingModel
		{
			case SEQUENTIAL: throw new RuntimeException('Not yet implemented')
			case STL_THREAD: throw new RuntimeException('Not yet implemented')
			case OPEN_MP: throw new RuntimeException('Not yet implemented')
			case KOKKOS: new KokkosBackend(maxIterationVar.name , stopTimeVar.name)
			case KOKKOS_TEAM_THREAD: new KokkosTeamThreadBackend(maxIterationVar.name , stopTimeVar.name)
		}
	}
}