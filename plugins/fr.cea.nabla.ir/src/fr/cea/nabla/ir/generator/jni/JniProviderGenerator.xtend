/*******************************************************************************
 * Copyright (c) 2020 CEA
 * This program and the accompanying materials are made available under the 
 * terms of the Eclipse Public License 2.0 which is available at
 * http://www.eclipse.org/legal/epl-2.0.
 *
 * SPDX-License-Identifier: EPL-2.0
 * Contributors: see AUTHORS file
 *******************************************************************************/
package fr.cea.nabla.ir.generator.jni

import fr.cea.nabla.ir.generator.CMakeUtils
import fr.cea.nabla.ir.generator.GenerationContent
import fr.cea.nabla.ir.generator.JniNameMangler
import fr.cea.nabla.ir.generator.Utils
import fr.cea.nabla.ir.generator.cpp.Backend
import fr.cea.nabla.ir.generator.java.FunctionContentProvider
import fr.cea.nabla.ir.interpreter.DefaultExtensionProviderHelper
import fr.cea.nabla.ir.ir.ExtensionProvider
import java.util.ArrayList

import static extension fr.cea.nabla.ir.ExtensionProviderExtensions.*
import fr.cea.nabla.ir.generator.cpp.CMakeContentProvider

/**
 * JniProviderGenerator does not implement ProviderGenerator
 * because it is not called from a provider definition
 * but only during application generation.
 */
class JniProviderGenerator
{
	val Backend cppBackend

	new(Backend cppBackend)
	{
		this.cppBackend = cppBackend
	}

	def getGenerationContents(ExtensionProvider provider)
	{
		val fileContents = new ArrayList<GenerationContent>
		fileContents += new GenerationContent(provider.className + ".java", getJavaFileContent(provider), false)
		fileContents += new GenerationContent(JniNameMangler.getJniClassName(provider) + ".cc", getCppFileContent(provider), false)
		fileContents += new GenerationContent("CMakeLists.txt", getCMakeFileContent(provider), false)

		return fileContents
	}

	private def getJavaFileContent(ExtensionProvider provider)
	'''
	«Utils.fileHeader»

	/**
	 * Design Pattern inspired from https://dhilst.github.io/2016/10/15/JNI-CPP.html
	 * Principle: a java long attribute to keep the link to the C++ object
	 */
	package «provider.packageName»jni;

	public class «provider.className»
	{
		static
		{
			System.load(System.getProperty("«DefaultExtensionProviderHelper.JNI_LIBRARY_PATH»") + "/lib«provider.libName»jni.so");
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
		public «provider.className»()
		{
		nativeObjectPointer = nativeNew();	
		}

		public native void jsonInit(String jsonContent);
		«FOR f : provider.functions»
		public native «FunctionContentProvider.getHeaderContent(f)»;
		«ENDFOR»
	}
	'''

	private def getCppFileContent(ExtensionProvider provider)
	'''
	«Utils.fileHeader»

	#include "«JniNameMangler.getJniClassName(provider)».h"
	#include "«provider.className».h"
	
	#ifdef __cplusplus
	extern "C" {
	#endif

	JNIEXPORT jlong JNICALL «JniNameMangler.getJniFunctionName(provider, 'nativeNew')»
	(JNIEnv *env, jobject self)
	{
		// Here we allocate our new object and return
		// its pointer casted as a jlong;
		«provider.className» *o = new «provider.className»();
		return reinterpret_cast<jlong>(o);
	}

	static jlong getLongField
	(JNIEnv *env, jobject self)
	{
		jclass cls = env->GetObjectClass(self);
		if (!cls)
			env->FatalError("GetObjectClass failed");
	
		jfieldID nativeObjectPointerID = env->GetFieldID(cls, "nativeObjectPointer", "J");
		if (!nativeObjectPointerID)
			env->FatalError("GetFieldID failed");

		return env->GetLongField(self, nativeObjectPointerID);
	}

	«IF provider.linearAlgebra»
	static jobject newJObject
	(JNIEnv *env, jobject self, jlong cppPtr, const char* javaClassName)
	{
		jclass cls = env->FindClass(javaClassName);
		if (!cls)
			env->FatalError("FindClass failed");

	jmethodID cid = env->GetMethodID(cls, "<init>", "(J)V");
	if (!cid)
		env->FatalError("Cstr failed");

	return env->NewObject(cls, cid, cppPtr);
	}

	static Vector* getVector
	(JNIEnv *env, jobject self)
	{
		jlong nativeObjectPointer = getLongField(env, self);
		return reinterpret_cast<Vector*>(nativeObjectPointer);
	}

	static jobject newJavaVector
	(JNIEnv *env, jobject self, Vector* cppVector)
	{
		jlong cppPtr = reinterpret_cast<jlong>(cppVector);
		return newJObject(env, self, cppPtr, "Vector");
	}

	static Matrix* getMatrix
	(JNIEnv *env, jobject self)
	{
		jlong nativeObjectPointer = getLongField(env, self);
		return reinterpret_cast<Matrix*>(nativeObjectPointer);
	}

	static jobject newJavaMatrix
	(JNIEnv *env, jobject self, Matrix* cppMatrix)
	{
		jlong cppPtr = reinterpret_cast<jlong>(cppMatrix);
		return newJObject(env, self, cppPtr, "Matrix");
	}

	«ENDIF»
	// This function is a helper providing the boiler
	// plate code to return the native object from
	// Java object. The "nativeObjectPointer" is reached
	// from this code, casted to People's pointer and
	// returned. This will be used in all our native
	// methods wrappers to recover the object before
	// invoking it's methods.
	static «provider.className»* getObject
	(JNIEnv *env, jobject self)
	{
		jlong nativeObjectPointer = getLongField(env, self);
		return reinterpret_cast<«provider.className»*>(nativeObjectPointer);
	}

	// Here is our native methods wrappers, we simply recover
	// native BatiLib's instance invoke the requested method
	// and return its return value. jint can be casted to
	// Java's int. The string is a case apart. Since String
	// is an object and not a primitive type we have to
	// return it as reference (not by value). This is safe
	// since, as a Java String object the JVM can deallocate
	// it when is not being used anymore.
	JNIEXPORT void JNICALL «JniNameMangler.getJniFunctionName(provider, 'jsonInit')»
	(JNIEnv *env, jobject self, jstring jsonContent)
	{
		«provider.className»* _self = getObject(env, self);
		const char *nativeJsonContent = env->GetStringUTFChars(jsonContent, 0);
		_self->jsonInit(nativeJsonContent);
		env->ReleaseStringUTFChars(jsonContent, nativeJsonContent);
	}
	«FOR f : provider.functions»

		«cppBackend.functionContentProvider.getJniDefinitionContent(f, provider)»
	«ENDFOR»

	#ifdef __cplusplus
	}
	#endif
	'''

	private def getCMakeFileContent(ExtensionProvider provider)
	'''
	«CMakeUtils::getFileHeader(true)»

	«CMakeUtils.checkVariables(#[CMakeContentProvider.WS_PATH, 'JAVA_HOME'])»

	«CMakeUtils.setVariables(#[], #[provider])»

	«CMakeUtils.addSubDirectories(true, #[provider])»
	«val jniClassName = JniNameMangler.getJniClassName(provider)»

	# LIBRARY «provider.libName»jni
	add_library(«provider.libName»jni SHARED «jniClassName».cc «jniClassName».h)
	target_include_directories(«provider.libName»jni
		PUBLIC ${INCLUDE_DIR}
		PUBLIC ${JAVA_HOME}/include
		PUBLIC ${JAVA_HOME}/include/linux)
	target_link_libraries(«provider.libName»jni PUBLIC «provider.libName»)

	# GENERATE «jniClassName».h FROM «provider.className».java
	add_custom_command(
		OUTPUT ${CMAKE_CURRENT_SOURCE_DIR}/«jniClassName».h «provider.packageName»jni/«provider.className».class
		COMMENT "Generate «jniClassName».h from «provider.className».java"
		COMMAND ${JAVA_HOME}/bin/javac -h ${CMAKE_CURRENT_SOURCE_DIR} -d ${CMAKE_CURRENT_BINARY_DIR} ${CMAKE_CURRENT_SOURCE_DIR}/*.java
		DEPENDS ${CMAKE_CURRENT_SOURCE_DIR}/«provider.className».java)

	# JAR «provider.libName»
	add_custom_target(«provider.libName»jnijar ALL DEPENDS «provider.libName»jni.jar)
	add_custom_command(
		OUTPUT «provider.libName»jni.jar
		COMMENT "Built «provider.libName»jni.jar"
		WORKING_DIRECTORY ${CMAKE_CURRENT_BINARY_DIR}
		COMMAND ${JAVA_HOME}/bin/jar cvf «provider.libName»jni.jar «provider.packageName»jni/*.class
		DEPENDS ${CMAKE_CURRENT_SOURCE_DIR}/«jniClassName».h)

	INSTALL(TARGETS «provider.libName»jni DESTINATION ${CMAKE_CURRENT_SOURCE_DIR}/lib)
	INSTALL(FILES ${CMAKE_CURRENT_BINARY_DIR}/«provider.libName»jni.jar DESTINATION ${CMAKE_CURRENT_SOURCE_DIR}/lib)

	«CMakeUtils.fileFooter»
	'''
}
