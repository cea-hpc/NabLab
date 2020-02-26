package fr.cea.nabla.ir.generator.cpp

import fr.cea.nabla.ir.ir.IrModule
import fr.cea.nabla.ir.MandatoryOptions

import static extension fr.cea.nabla.ir.IrModuleExtensions.*

class MainContentProvider 
{
	def getContentFor(IrModule it)
	'''
		auto o = new «name»::Options();
		string output;
		«IF withMesh»
		if (argc == 5)
		{
			o->«MandatoryOptions::X_EDGE_ELEMS» = std::atoi(argv[1]);
			o->«MandatoryOptions::Y_EDGE_ELEMS» = std::atoi(argv[2]);
			o->«MandatoryOptions::X_EDGE_LENGTH» = std::atof(argv[3]);
			o->«MandatoryOptions::Y_EDGE_LENGTH» = std::atof(argv[4]);
		}
		else if (argc == 6)
		{
			o->«MandatoryOptions::X_EDGE_ELEMS» = std::atoi(argv[1]);
			o->«MandatoryOptions::Y_EDGE_ELEMS» = std::atoi(argv[2]);
			o->«MandatoryOptions::X_EDGE_LENGTH» = std::atof(argv[3]);
			o->«MandatoryOptions::Y_EDGE_LENGTH» = std::atof(argv[4]);
			output = argv[5];
		}
		else if (argc != 1)
		{
			std::cerr << "[ERROR] Wrong number of arguments. Expecting 4 or 5 args: X Y Xlength Ylength (output)." << std::endl;
			std::cerr << "(X=100, Y=10, Xlength=0.01, Ylength=0.01 output=current directory with no args)" << std::endl;
		}
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