package fr.cea.nabla.workflow

import fr.cea.nabla.nablagen.Ir2CodeComponent
import fr.cea.nabla.nablagen.Language
import fr.cea.nabla.ir.generator.java.Ir2Java
import fr.cea.nabla.ir.generator.kokkos.Ir2Kokkos
import fr.cea.nabla.ir.generator.kokkos.defaultparallelism.DefaultJobContentProvider
import fr.cea.nabla.ir.generator.kokkos.hierarchicalparallelism.HierarchicalJobContentProvider

class CodeGeneratorProvider 
{
	static def get(Ir2CodeComponent it)
	{
		switch (language)
		{
			case Language::JAVA : new Ir2Java
			case Language::KOKKOS : new Ir2Kokkos(new DefaultJobContentProvider)
			case Language::KOKKOS_HIERARCHICAL_PARALLELISM : new Ir2Kokkos(new HierarchicalJobContentProvider)
			default : throw new RuntimeException("Unsupported language " + language.literal)
		}
	}
}