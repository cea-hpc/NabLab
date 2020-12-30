package fr.cea.nabla.generator.ext

import fr.cea.nabla.generator.NablaGeneratorMessageDispatcher.MessageType
import fr.cea.nabla.generator.StandaloneGeneratorBase
import fr.cea.nabla.ir.generator.Utils
import fr.cea.nabla.ir.generator.cpp.CMakeUtils
import fr.cea.nabla.ir.generator.cpp.SequentialBackend
import fr.cea.nabla.ir.generator.java.FunctionContentProvider
import fr.cea.nabla.ir.ir.Function
import fr.cea.nabla.nabla.NablaExtension
import org.eclipse.core.resources.IProject

class JniProviderGenerator extends StandaloneGeneratorBase
{
	val backend = new SequentialBackend(null, null, null, null)

	def generate(NablaExtension nablaExt, IProject project, Iterable<Function> irFunctions, String cppProviderHome)
	{
		val projectHome = project.location.toString
		dispatcher.post(MessageType::Exec, "Starting JNI extension provider generator in: " + projectHome)
		val fsa = getConfiguredFileSystemAccess(projectHome, false)

		// .java
		val javaFileName = "src/" + nablaExt.name.toLowerCase + "/" + nablaExt.name + ".java"
		dispatcher.post(MessageType::Exec, "    Generating: " + javaFileName)
		fsa.generateFile(javaFileName, getJavaFileContent(nablaExt, projectHome, irFunctions))

		// .cc
		val sourceFileName = "src/" + nablaExt.name.toLowerCase + "_" + nablaExt.name + ".cc"
		dispatcher.post(MessageType::Exec, "    Generating: " + sourceFileName)
		fsa.generateFile(sourceFileName, getCppFileContent(nablaExt, irFunctions))

		// CMakeLists.txt
		val cmakeFileName = "src/CMakeLists.txt"
		dispatcher.post(MessageType::Exec, "    Generating: " + cmakeFileName)
		fsa.generateFile(cmakeFileName, getCmakeFileContent(nablaExt, cppProviderHome))
	}

	private def getJavaFileContent(NablaExtension it, String projectHome, Iterable<Function> irFunctions)
	'''
	«Utils.fileHeader»

	/**
	 * Design Pattern inspired from https://dhilst.github.io/2016/10/15/JNI-CPP.html
	 * Principle: a java long attribute to keep the link to the C++ object
	 */
	package «name.toLowerCase»;

	public class «name»
	{
		static
		{
			// Loads the lib«name.toLowerCase»jni.so. This is the place where our native methods reside.
			// System.loadLibrary can be used but classpath needs to be set to the lib path before execution
			System.load("«projectHome»/lib/lib«name.toLowerCase»jni.so");
		}

		// This is a long here (in Java) but is used as a pointer to hold the
		// address of our native object at "native world".
		private long nativeObjectPointer;

		// This method is used to allocate an instance of this class at native
		// world and return the address of it.
		private native long nativeNew();

		// Our constructor. The nativeNew() method is called to allocate a new
		// instance of our native object and return its address. The address is
		// assigned to nativeObjectPointer. Just as a note, Java forbiddes
		// native constructors, so we need a native method to allocate our
		// native object.
		public «name»()
		{
			nativeObjectPointer = nativeNew();	
		}

		public native void jsonInit(String jsonContent);
		«FOR f : irFunctions»
		public native «FunctionContentProvider.getHeaderContent(f)»;
		«ENDFOR»
	}
	'''

	private def getCppFileContent(NablaExtension it, Iterable<Function> irFunctions)
	'''
	«Utils.fileHeader»

	#include "«name.toLowerCase»_«name».h"
	#include "«name.toLowerCase»/«name».h"

	#ifdef __cplusplus
	extern "C" {
	#endif

	JNIEXPORT jlong JNICALL Java_«name.toLowerCase»_«name»_nativeNew
	(JNIEnv *env, jobject self)
	{
		// Here we allocate our new object and return
		// its pointer casted as a jlong;
		«name.toLowerCase»::«name» *o = new «name.toLowerCase»::«name»();
		return reinterpret_cast<jlong>(o);
	}

	// This function is a helper providing the boiler
	// plate code to return the native object from
	// Java object. The "nativeObjectPointer" is reached
	// from this code, casted to People's pointer and
	// returned. This will be used in all our native
	// methods wrappers to recover the object before
	// invoking it's methods.
	static «name.toLowerCase»::«name»* getObject
	(JNIEnv *env, jobject self)
	{
		jclass cls = env->GetObjectClass(self);
		if (!cls)
			env->FatalError("GetObjectClass failed");

		jfieldID nativeObjectPointerID = env->GetFieldID(cls, "nativeObjectPointer", "J");
		if (!nativeObjectPointerID)
			env->FatalError("GetFieldID failed");

		jlong nativeObjectPointer = env->GetLongField(self, nativeObjectPointerID);
		return reinterpret_cast<«name.toLowerCase»::«name»*>(nativeObjectPointer);
	}

	// Here is our native methods wrappers, we simply recover
	// native BatiLib's instance invoke the requested method
	// and return its return value. jint can be casted to
	// Java's int. The string is a case apart. Since String
	// is an object and not a primitive type we have to
	// return it as reference (not by value). This is safe
	// since, as a Java String object the JVM can deallocate
	// it when is not being used anymore.
	JNIEXPORT void JNICALL Java_«name.toLowerCase»_«name»_jsonInit
	(JNIEnv *env, jobject self, jstring jsonContent)
	{
		«name.toLowerCase»::«name»* _self = getObject(env, self);
		const char *nativeJsonContent = env->GetStringUTFChars(jsonContent, 0);
		_self->jsonInit(nativeJsonContent);
		env->ReleaseStringUTFChars(jsonContent, nativeJsonContent);
	}
	«FOR f : irFunctions»

	«backend.functionContentProvider.getJniDefinitionContent(name, f)»
	«ENDFOR»

	#ifdef __cplusplus
	}
	#endif
	'''

	private def getCmakeFileContent(NablaExtension it, String cppProviderHome)
	'''
	«CMakeUtils::fileHeader»

	set(INCLUDE_DIR ${CMAKE_CURRENT_SOURCE_DIR}/../include)
	set(BIN_DIR ${CMAKE_CURRENT_SOURCE_DIR}/../bin)
	set(«name.toUpperCase»_DIR «cppProviderHome»)

	if(NOT DEFINED JAVA_HOME)
		message(FATAL_ERROR "JAVA_HOME variable undefined")
	endif()

	project(«name»Jni CXX)

	MESSAGE(STATUS "Building library «name.toLowerCase»jni")

	add_subdirectory(${«name.toUpperCase»_DIR}/src ${«name.toUpperCase»_DIR}/lib)

	# The lib«name.toLowerCase»jni.so library
	add_library(«name.toLowerCase»jni SHARED «name.toLowerCase»_«name».cc ${INCLUDE_DIR}/«name.toLowerCase»_«name».h)
	target_include_directories(«name.toLowerCase»jni
		PUBLIC ${INCLUDE_DIR}
		PUBLIC ${JAVA_HOME}/include
		PUBLIC ${JAVA_HOME}/include/linux)
	target_link_libraries(«name.toLowerCase»jni PUBLIC «name.toLowerCase»)

	# Generation of «name».h from «name».java
	add_custom_command(
		OUTPUT ${INCLUDE_DIR}/«name.toLowerCase»_«name».h
		COMMENT "Generate «name».h from «name».java"
		COMMAND ${JAVA_HOME}/bin/javac -h ${INCLUDE_DIR} -d ${BIN_DIR} ${CMAKE_CURRENT_SOURCE_DIR}/«name.toLowerCase»/«name».java
		DEPENDS ${CMAKE_CURRENT_SOURCE_DIR}/«name.toLowerCase»/«name».java)

	# The «name.toLowerCase»jni.jar
	add_custom_target(«name.toLowerCase»jnijar ALL DEPENDS ${CMAKE_CURRENT_BINARY_DIR}/«name.toLowerCase»jni.jar)
	add_custom_command(
		OUTPUT ${CMAKE_CURRENT_BINARY_DIR}/«name.toLowerCase»jni.jar
		COMMENT "Built «name.toLowerCase»jni.jar"
		WORKING_DIRECTORY ${BIN_DIR}
		COMMAND ${JAVA_HOME}/bin/jar cvf ${CMAKE_CURRENT_BINARY_DIR}/«name.toLowerCase»jni.jar «name.toLowerCase»/«name».class
		DEPENDS ${INCLUDE_DIR}/«name.toLowerCase»_«name».h)

	«CMakeUtils.fileFooter»
	'''
}