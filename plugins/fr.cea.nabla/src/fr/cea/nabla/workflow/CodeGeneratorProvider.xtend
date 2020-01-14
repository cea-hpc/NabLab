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

import fr.cea.nabla.ir.generator.java.Ir2Java
import fr.cea.nabla.ir.generator.kokkos.Ir2Kokkos
import fr.cea.nabla.ir.generator.kokkos.TraceContentProvider
import fr.cea.nabla.ir.generator.kokkos.defaultparallelism.DefaultJobContentProvider
import fr.cea.nabla.ir.generator.kokkos.hierarchicalparallelism.HierarchicalJobContentProvider
import fr.cea.nabla.nablagen.CppKokkos
import fr.cea.nabla.nablagen.Ir2CodeComponent
import fr.cea.nabla.nablagen.Java

class CodeGeneratorProvider
{
	static def get(Ir2CodeComponent it)
	{
		val l = language
		switch l
		{
			Java: new Ir2Java
			CppKokkos:
			{
				val tcp = new TraceContentProvider(l.maxIterationVar.name , l.stopTimeVar.name)
				if (l.teamOfThreads)
					new Ir2Kokkos(outputDir, new HierarchicalJobContentProvider(tcp))
				else
					new Ir2Kokkos(outputDir, new DefaultJobContentProvider(tcp))
			}
			default : throw new RuntimeException("Unsupported language " + language.class.name)
		}
	}
}