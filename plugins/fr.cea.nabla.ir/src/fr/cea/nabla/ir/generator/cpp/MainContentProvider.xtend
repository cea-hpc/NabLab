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

		«name»::Options options(dataFile);
		// simulator must be a pointer if there is a finalize at the end (Kokkos, omp...)
		auto simulator = new «name»(options);
		simulator->simulate();
		// simulator must be deleted before calling finalize
		delete simulator;
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