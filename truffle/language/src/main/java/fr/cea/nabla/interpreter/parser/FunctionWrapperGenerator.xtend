package fr.cea.nabla.interpreter.parser

import fr.cea.nabla.ir.generator.cpp.StlTypeContentProvider
import fr.cea.nabla.ir.ir.IrModule
import java.util.List
import java.util.Map

import static extension fr.cea.nabla.ir.IrModuleExtensions.*
import fr.cea.nabla.ir.ir.Function
import fr.cea.nabla.ir.Utils

class FunctionWrapperGenerator {

	extension StlTypeContentProvider typeContentProvider = new StlTypeContentProvider

	val Map<String, List<Function>> functions = newHashMap

	def private initFunctions(IrModule it) {
		it.functions.forEach[f|
			val functionList = functions.computeIfAbsent(f.name, [newArrayList])
			if (!functionList.contains(f)) {
				functionList.add(f)
			}
		]
	}
	
	def getExternalFunctions(IrModule it) {
		it.functions.filter[f|allProviders.contains(f.provider + Utils::FunctionReductionPrefix) && f.body === null].toList
	}
	
	def private getFunctionSignature(Function it, IrModule m) {
		'''«returnType.cppType» «name»_wrapper«functions.get(name).indexOf(it)»(«m.name»Wrapper* receiver«FOR a : inArgs BEFORE ', ' SEPARATOR ', '»«a.type.cppType» «a.name»«ENDFOR»)'''
	}

	def getHeader(IrModule it) {
		initFunctions
		
		'''
			«FOR s : allProviders»
			#include "«s».h"
			«ENDFOR»
			
			class «name»Wrapper {
			public:
				void* get_wrapper(char* optionsFile);
				«FOR f : externalFunctions»
				«f.getFunctionSignature(it)»;
				«ENDFOR»
				
				«FOR s : allProviders»
				«s»* «s.toFirstLower»;
				«ENDFOR»
			};
		'''
	}

	def getSource(IrModule it) {
		initFunctions
		
		'''
			#include "«name»Wrapper.h"
			#include "rapidjson/istreamwrapper.h"
			#include <fstream>
			#include <string>
			
			extern "C" {
				void* get_wrapper(char* optionsFile) {
					std::string dataFileString = optionsFile;
					std::ifstream ifs(dataFileString);
					rapidjson::IStreamWrapper isw(ifs);
					rapidjson::Document d;
					d.ParseStream(isw);
					assert(d.IsObject());
					
					«name»Wrapper* wrapper = new «name»Wrapper();
					
					«FOR s : allProviders»
					// «s.toFirstLower»
					wrapper->«s.toFirstLower» = new «s»();
					if (d.HasMember("«s.toFirstLower»"))
					{
						const rapidjson::Value& valueof_«s.toFirstLower» = d["«s.toFirstLower»"];
						assert(valueof_«s.toFirstLower».IsObject());
						wrapper->«s.toFirstLower».jsonInit(valueof_«s.toFirstLower».GetObject());
					}
					«ENDFOR»
					return wrapper;
				}
				
				«FOR f : externalFunctions»
				«f.getFunctionSignature(it)» {
					return receiver->«f.provider.toFirstLower»->«f.name»(«FOR a : f.inArgs SEPARATOR ', '»«a.name»«ENDFOR»);
				}
				«ENDFOR»
			}
		'''
	}
}
