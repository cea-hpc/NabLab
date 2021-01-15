package fr.cea.nabla.ir.generator.jni

import fr.cea.nabla.ir.generator.CMakeUtils
import fr.cea.nabla.ir.generator.GenerationContent
import fr.cea.nabla.ir.generator.ProviderGenerator
import fr.cea.nabla.ir.generator.Utils
import fr.cea.nabla.ir.generator.cpp.Backend
import fr.cea.nabla.ir.generator.java.FunctionContentProvider
import fr.cea.nabla.ir.ir.ExtensionProvider
import fr.cea.nabla.ir.ir.Function
import java.util.ArrayList

import static extension fr.cea.nabla.ir.generator.ExtensionProviderExtensions.*

class JniProviderGenerator implements ProviderGenerator
{
	val Backend cppBackend

	new(Backend cppBackend)
	{
		this.cppBackend = cppBackend
	}

	override getName() { 'JNI' }

	override getGenerationContents(ExtensionProvider provider, Iterable<Function> functions)
	{
		val fileContents = new ArrayList<GenerationContent>

		// .java
		val javaFileName = provider.namespaceName + "/" + provider.jniClassName + ".java"
		fileContents += new GenerationContent(javaFileName, getJavaFileContent(provider, functions), false)

		// .cc
		val sourceFileName =  provider.namespaceName + "_" +provider.jniClassName + ".cc"
		fileContents += new GenerationContent(sourceFileName, getCppFileContent(provider, functions), false)

		// CMakeLists.txt
		val cmakeFileName = "CMakeLists.txt"
		fileContents += new GenerationContent(cmakeFileName, getCMakeFileContent(provider), false)

		return fileContents
	}

	private def getJavaFileContent(ExtensionProvider provider, Iterable<Function> functions)
	'''
	«Utils.fileHeader»

	/**
	 * Design Pattern inspired from https://dhilst.github.io/2016/10/15/JNI-CPP.html
	 * Principle: a java long attribute to keep the link to the C++ object
	 */
	package «provider.namespaceName»;

	public class «provider.jniClassName»
	{
		static
		{
			System.loadLibrary("«provider.jniLibName»");
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
		public «provider.jniClassName»()
		{
			nativeObjectPointer = nativeNew();	
		}

		public native void jsonInit(String jsonContent);
		«FOR f : functions»
		public native «FunctionContentProvider.getHeaderContent(f)»;
		«ENDFOR»
	}
	'''

	private def getCppFileContent(ExtensionProvider provider, Iterable<Function> functions)
	'''
	«Utils.fileHeader»

	#include "«provider.namespaceName»_«provider.jniClassName».h"
	#include "«provider.namespaceName»/«provider.className».h"

	#ifdef __cplusplus
	extern "C" {
	#endif

	JNIEXPORT jlong JNICALL Java_«provider.namespaceName»_«provider.jniClassName»_nativeNew
	(JNIEnv *env, jobject self)
	{
		// Here we allocate our new object and return
		// its pointer casted as a jlong;
		«provider.namespaceName»::«provider.className» *o = new «provider.namespaceName»::«provider.className»();
		return reinterpret_cast<jlong>(o);
	}

	// This function is a helper providing the boiler
	// plate code to return the native object from
	// Java object. The "nativeObjectPointer" is reached
	// from this code, casted to People's pointer and
	// returned. This will be used in all our native
	// methods wrappers to recover the object before
	// invoking it's methods.
	static «provider.namespaceName»::«provider.className»* getObject
	(JNIEnv *env, jobject self)
	{
		jclass cls = env->GetObjectClass(self);
		if (!cls)
			env->FatalError("GetObjectClass failed");

		jfieldID nativeObjectPointerID = env->GetFieldID(cls, "nativeObjectPointer", "J");
		if (!nativeObjectPointerID)
			env->FatalError("GetFieldID failed");

		jlong nativeObjectPointer = env->GetLongField(self, nativeObjectPointerID);
		return reinterpret_cast<«provider.namespaceName»::«provider.className»*>(nativeObjectPointer);
	}

	// Here is our native methods wrappers, we simply recover
	// native BatiLib's instance invoke the requested method
	// and return its return value. jint can be casted to
	// Java's int. The string is a case apart. Since String
	// is an object and not a primitive type we have to
	// return it as reference (not by value). This is safe
	// since, as a Java String object the JVM can deallocate
	// it when is not being used anymore.
	JNIEXPORT void JNICALL Java_«provider.namespaceName»_«provider.jniClassName»_jsonInit
	(JNIEnv *env, jobject self, jstring jsonContent)
	{
		«provider.namespaceName»::«provider.className»* _self = getObject(env, self);
		const char *nativeJsonContent = env->GetStringUTFChars(jsonContent, 0);
		_self->jsonInit(nativeJsonContent);
		env->ReleaseStringUTFChars(jsonContent, nativeJsonContent);
	}
	«FOR f : functions»

	«cppBackend.functionContentProvider.getJniDefinitionContent(provider, f)»
	«ENDFOR»

	#ifdef __cplusplus
	}
	#endif
	'''

	private def getCMakeFileContent(ExtensionProvider provider)
	'''
	«CMakeUtils::fileHeader»

	set(«provider.extensionName.toUpperCase»_DIR «provider.projectHome»)

	if(NOT DEFINED JAVA_HOME)
		message(FATAL_ERROR "JAVA_HOME variable undefined.\n"
			"You can launch cmake with -D option, for example: "
			"cmake -D JAVA_HOME=/usr/lib/jvm/java-11-openjdk-amd64 ../src")
	endif()

	project(«provider.jniProjectName» CXX)

	MESSAGE(STATUS "Building library «provider.jniLibName»")

	«CMakeUtils.setCompiler»

	add_subdirectory(${«provider.extensionName.toUpperCase»_DIR}/src ${CMAKE_BINARY_DIR}/«provider.projectName»)

	# The lib«provider.jniLibName».so library
	add_library(«provider.jniLibName» SHARED «provider.namespaceName»_«provider.jniClassName».cc «provider.namespaceName»_«provider.jniClassName».h)
	target_include_directories(«provider.jniLibName»
		PUBLIC ${INCLUDE_DIR}
		PUBLIC ${JAVA_HOME}/include
		PUBLIC ${JAVA_HOME}/include/linux)
	target_link_libraries(«provider.jniLibName» PUBLIC «provider.libName»)

	# Generation of «provider.jniClassName».h from «provider.jniClassName».java
	add_custom_command(
		OUTPUT ${CMAKE_CURRENT_SOURCE_DIR}/«provider.namespaceName»_«provider.jniClassName».h
		COMMENT "Generate «provider.jniClassName».h from «provider.jniClassName».java"
		COMMAND ${JAVA_HOME}/bin/javac -h ${CMAKE_CURRENT_SOURCE_DIR} -d ${CMAKE_CURRENT_BINARY_DIR} ${CMAKE_CURRENT_SOURCE_DIR}/«provider.namespaceName»/«provider.jniClassName».java
		DEPENDS ${CMAKE_CURRENT_SOURCE_DIR}/«provider.namespaceName»/«provider.jniClassName».java)

	# The «provider.jniLibName».jar
	add_custom_target(«provider.jniLibName»jar ALL DEPENDS «provider.jniLibName».jar)
	add_custom_command(
		OUTPUT «provider.jniLibName».jar
		COMMENT "Built «provider.jniLibName».jar"
		WORKING_DIRECTORY ${CMAKE_CURRENT_BINARY_DIR}
		COMMAND ${JAVA_HOME}/bin/jar cvf «provider.jniLibName».jar «provider.namespaceName»/«provider.jniClassName».class
		DEPENDS ${CMAKE_CURRENT_SOURCE_DIR}/«provider.namespaceName»_«provider.jniClassName».h)

	«CMakeUtils.fileFooter»
	'''

	private def getJniClassName(ExtensionProvider it) { className + 'Jni' }
	private def getJniProjectName(ExtensionProvider it) { projectName + 'Jni' }
	private def getJniLibName(ExtensionProvider it) { libName + 'jni' }
}