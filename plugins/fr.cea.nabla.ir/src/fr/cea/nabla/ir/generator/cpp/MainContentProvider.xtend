/*******************************************************************************
 * Copyright (c) 2020 CEA
 * This program and the accompanying materials are made available under the 
 * terms of the Eclipse Public License 2.0 which is available at
 * http://www.eclipse.org/legal/epl-2.0.
 *
 * SPDX-License-Identifier: EPL-2.0
 * Contributors: see AUTHORS file
 *******************************************************************************/
package fr.cea.nabla.ir.generator.cpp

import fr.cea.nabla.ir.Utils
import fr.cea.nabla.ir.ir.IrModule
import org.eclipse.xtend.lib.annotations.Data

import static extension fr.cea.nabla.ir.IrModuleExtensions.*

@Data
class MainContentProvider
{
	val String levelDBPath
	val extension JsonContentProvider jsonContentProvider

	def getContentFor(IrModule it)
	'''
		string dataFile;
		int ret = 0;

		if (argc == 2)
		{
			dataFile = argv[1];
		}
		else
		{
			std::cerr << "[ERROR] Wrong number of arguments. Expecting 1 arg: dataFile." << std::endl;
			std::cerr << "(«name»Default.json)" << std::endl;
			return -1;
		}

		// read json dataFile
		ifstream ifs(dataFile);
		rapidjson::IStreamWrapper isw(ifs);
		rapidjson::Document d;
		d.ParseStream(isw);
		assert(d.IsObject());

		// mesh
		assert(d.HasMember("mesh"));
		«meshClassName»Factory meshFactory;
		meshFactory.jsonInit(d["mesh"]);
		«meshClassName»* mesh = meshFactory.create();

		// «name.toFirstLower»
		«name»::Options «name»_options;
		if (d.HasMember("«name.toFirstLower»"))
			«name»_options.jsonInit(d["«name.toFirstLower»"]);

		// simulator must be a pointer if there is a finalize at the end (Kokkos, omp...)
		auto simulator = new «name»(mesh, «name»_options);
		simulator->simulate();
		«IF !levelDBPath.nullOrEmpty»

		«val nrName = Utils.NonRegressionNameAndValue.key»
		// Non regression testing
		if («name»_options.«nrName» == "«Utils.NonRegressionValues.CreateReference.toString»")
			simulator->createDB("«name»DB.ref");
		if («name»_options.«nrName» == "«Utils.NonRegressionValues.CompareToReference.toString»") {
			simulator->createDB("«name»DB.current");
			if (!compareDB("«name»DB.current", "«name»DB.ref"))
				ret = 1;
			leveldb::DestroyDB("«name»DB.current", leveldb::Options());
		}
		«ENDIF»

		// simulator must be deleted before calling finalize
		delete simulator;
		delete mesh;
	'''
}

@Data
class KokkosMainContentProvider extends MainContentProvider
{
	override getContentFor(IrModule it)
	'''
		Kokkos::initialize(argc, argv);
		«super.getContentFor(it)»
		Kokkos::finalize();
	'''
}