package fr.cea.nabla.interpreter.parser

import fr.cea.nabla.ir.ir.Connectivity
import fr.cea.nabla.ir.ir.IrModule

class MeshWrapperGenerator {

	def private getFunctionSignature(Connectivity c) {
		'''«IF c.multiple»vector<Id>«ELSE»Id«ENDIF» get«c.name.toFirstUpper»(MeshWrapper* receiver«FOR a : c.inTypes BEFORE ', ' SEPARATOR ', '»const Id& «a.name»«ENDFOR»)'''
	}

	def getHeader(IrModule it) {
		'''
			#include "mesh/CartesianMesh2DGenerator.h"
			#include "mesh/CartesianMesh2D.h"
			
			class MeshWrapper {
			public:
				
				void* get_wrapper(size_t nbXQuads, size_t nbYQuads, double xSize, double ySize);
				
				«FOR c : it.connectivities»
				«c.functionSignature»;
				«IF c.multiple && c.inTypes.empty»
				size_t getNb«c.name.toFirstUpper»(MeshWrapper* receiver) const noexcept;
				«ENDIF»
				«ENDFOR»
				
				CartesianMesh2D* cartesianMesh2D;
			};
		'''
	}

	def getSource(IrModule it) {
		'''
			#include "MeshWrapper.h"
			
			extern "C" {
				void* get_wrapper(size_t nbXQuads, size_t nbYQuads, double xSize, double ySize) {
					MeshWrapper* wrapper = new MeshWrapper();
					
					wrapper->cartesianMesh2D = CartesianMesh2DGenerator::generate(nbXQuads, nbYQuads, xSize, ySize);
					
					return wrapper;
				}
				
				«FOR c : it.connectivities»
				«c.functionSignature» {
					return receiver->cartesianMesh2D->get«c.name.toFirstUpper»(«FOR a : c.inTypes SEPARATOR ', '»«a.name»«ENDFOR»);
				}
				«IF c.multiple && c.inTypes.empty»
				size_t getNb«c.name.toFirstUpper»(MeshWrapper* receiver) const noexcept {
					return receiver->cartesianMesh2D->getNb«c.name.toFirstUpper»();
				}
				«ENDIF»
				«ENDFOR»
			}
		'''
	}
}
