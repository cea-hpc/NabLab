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

import fr.cea.nabla.ir.ir.IrModule
import fr.cea.nabla.ir.MandatoryOptions

import static extension fr.cea.nabla.ir.IrModuleExtensions.*

class MainContentProvider 
{
	def getContentFor(IrModule it)
	'''
		string dataFile;

		if (argc == 2)
		{
			dataFile = argv[1];
		}
		else
		{
			std::cerr << "[ERROR] Wrong number of arguments. Expecting 1 arg: dataFile." << std::endl;
			std::cerr << "(«name»DefaultOptions.json)" << std::endl;
			return -1;
		}

		auto o = new «name»::Options(dataFile);
		«IF withMesh»
		auto nm = CartesianMesh2DGenerator::generate(o->«MandatoryOptions::X_EDGE_ELEMS», o->«MandatoryOptions::Y_EDGE_ELEMS», o->«MandatoryOptions::X_EDGE_LENGTH», o->«MandatoryOptions::Y_EDGE_LENGTH»);
		«ENDIF»
		auto c = new «name»(o«IF withMesh», nm«ENDIF»);
		c->simulate();
		delete c;
		«IF withMesh»
		delete nm;
		«ENDIF»
		delete o;
	'''
}

class KokkosMainContentProvider extends MainContentProvider
{
	override getContentFor(IrModule it)
	'''
		Kokkos::initialize(argc, argv);
		«super.getContentFor(it)»
		Kokkos::finalize();
	'''
}