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
		«name»::Options* o = nullptr;
		string dataFile, output;

		if (argc == 2)
		{
			dataFile = argv[1];
			o = new «name»::Options(dataFile);
		}
		else if (argc == 6)
		{
			dataFile = argv[1];
			o = new «name»::Options(dataFile);
			o->«MandatoryOptions::X_EDGE_ELEMS» = std::atoi(argv[2]);
			o->«MandatoryOptions::Y_EDGE_ELEMS» = std::atoi(argv[3]);
			o->«MandatoryOptions::X_EDGE_LENGTH» = std::atof(argv[4]);
			o->«MandatoryOptions::Y_EDGE_LENGTH» = std::atof(argv[5]);
		}
		else if (argc == 7)
		{
			dataFile = argv[1];
			o = new «name»::Options(dataFile);
			o->«MandatoryOptions::X_EDGE_ELEMS» = std::atoi(argv[2]);
			o->«MandatoryOptions::Y_EDGE_ELEMS» = std::atoi(argv[3]);
			o->«MandatoryOptions::X_EDGE_LENGTH» = std::atof(argv[4]);
			o->«MandatoryOptions::Y_EDGE_LENGTH» = std::atof(argv[5]);
			output = argv[6];
		}
		else
		{
			std::cerr << "[ERROR] Wrong number of arguments. Expecting 1, 5 or 6 args: dataFile [X Y Xlength Ylength [output]]." << std::endl;
			std::cerr << "(«name»DefaultOptions.json, X=100, Y=10, Xlength=0.01, Ylength=0.01 output=current directory with no args)" << std::endl;
			return -1;
		}
		«IF withMesh»
		auto nm = CartesianMesh2DGenerator::generate(o->«MandatoryOptions::X_EDGE_ELEMS», o->«MandatoryOptions::Y_EDGE_ELEMS», o->«MandatoryOptions::X_EDGE_LENGTH», o->«MandatoryOptions::Y_EDGE_LENGTH»);
		«ENDIF»
		auto c = new «name»(o, «IF withMesh»nm,«ENDIF» output);
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