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

import fr.cea.nabla.ir.IrUtils
import fr.cea.nabla.ir.ir.IrModule
import org.eclipse.xtend.lib.annotations.Data

import static extension fr.cea.nabla.ir.IrModuleExtensions.*
import static extension fr.cea.nabla.ir.IrRootExtensions.*

@Data
class MainContentProvider
{
	val extension JsonContentProvider jsonContentProvider

	def getContentFor(IrModule it, String levelDBPath)
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
			std::cerr << "(«irRoot.name».json)" << std::endl;
			return -1;
		}

		// read json dataFile
		ifstream ifs(dataFile);
		rapidjson::IStreamWrapper isw(ifs);
		rapidjson::Document d;
		d.ParseStream(isw);
		assert(d.IsObject());

		// Mesh instanciation
		«meshClassName» mesh;
		assert(d.HasMember("mesh"));
		rapidjson::StringBuffer strbuf;
		rapidjson::Writer<rapidjson::StringBuffer> writer(strbuf);
		d["mesh"].Accept(writer);
		mesh.jsonInit(strbuf.GetString());

		// Module instanciation(s)
		«FOR m : irRoot.modules»
			«m.instanciation»
		«ENDFOR»

		// Start simulation
		// Simulator must be a pointer when a finalize is needed at the end (Kokkos, omp...)
		«name»->simulate();
		«IF !levelDBPath.nullOrEmpty»

			«val nrName = IrUtils.NonRegressionNameAndValue.key»
			«val dbName = irRoot.name + "DB"»
			// Non regression testing
			if («name»Options.«nrName» == "«IrUtils.NonRegressionValues.CreateReference.toString»")
				«name»->createDB("«dbName».ref");
			if («name»Options.«nrName» == "«IrUtils.NonRegressionValues.CompareToReference.toString»") {
				«name»->createDB("«dbName».current");
				if (!compareDB("«dbName».current", "«dbName».ref"))
					ret = 1;
				leveldb::DestroyDB("«dbName».current", leveldb::Options());
			}
		«ENDIF»

		«FOR m : irRoot.modules.reverseView»
			delete «m.name»;
		«ENDFOR»
	'''

	private def getInstanciation(IrModule it)
	'''
		«className»::Options «name»Options;
		if (d.HasMember("«name»"))
		{
			rapidjson::StringBuffer strbuf;
			rapidjson::Writer<rapidjson::StringBuffer> writer(strbuf);
			d["«name»"].Accept(writer);
			«name»Options.jsonInit(strbuf.GetString());
		}
		«className»* «name» = new «className»(mesh, «name»Options);
		«IF !main»«name»->setMainModule(«irRoot.mainModule.name»);«ENDIF»
	'''
}

@Data
class KokkosMainContentProvider extends MainContentProvider
{
	override getContentFor(IrModule it, String levelDBPath)
	'''
		Kokkos::initialize(argc, argv);
		«super.getContentFor(it, levelDBPath)»
		// simulator must be deleted before calling finalize
		Kokkos::finalize();
	'''
}
