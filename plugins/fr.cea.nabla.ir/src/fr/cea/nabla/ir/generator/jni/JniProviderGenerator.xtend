/*******************************************************************************
 * Copyright (c) 2022 CEA
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
import fr.cea.nabla.ir.generator.Utils
import fr.cea.nabla.ir.generator.java.FunctionContentProvider
import fr.cea.nabla.ir.ir.DefaultExtensionProvider
import java.util.ArrayList

import static extension fr.cea.nabla.ir.ExtensionProviderExtensions.*
import static extension fr.cea.nabla.ir.generator.JniNameMangler.*

/**
 * JniProviderGenerator does not implement ProviderGenerator
 * because it is not called from a provider definition
 * but only during application generation.
 */
class JniProviderGenerator
{
	static val userDir = System.getProperty("user.home")
	val Jniable jniContentProvider

	new(Jniable jniContentProvider)
	{
		this.jniContentProvider = jniContentProvider
	}

	def getGenerationContents(DefaultExtensionProvider jniProvider, DefaultExtensionProvider cppProvider, String wsPath)
	{
		val fileContents = new ArrayList<GenerationContent>
		fileContents += new GenerationContent(jniProvider.className + ".java", getJavaFacadeClassContent(jniProvider, wsPath), false)
		fileContents += new GenerationContent("CMakeLists.txt", getCMakeFileContent(jniProvider, cppProvider), false)
		fileContents += new GenerationContent(jniProvider.jniFileName + ".cc", getCppFacadeClassContent(jniProvider), false)

		if (jniProvider.linearAlgebra)
		{
			fileContents += new GenerationContent("Vector.java", getJavaVectorClassContent(jniProvider), false)
			fileContents += new GenerationContent("Matrix.java", getJavaMatrixClassContent(jniProvider), false)
		}

		return fileContents
	}

	private def getJavaFacadeClassContent(DefaultExtensionProvider provider, String wsPath)
	'''
	/* «Utils::doNotEditWarning» */

	/**
	 * Design Pattern inspired from https://dhilst.github.io/2016/10/15/JNI-CPP.html
	 * Principle: a java long attribute to keep the link to the C++ object
	 */
	package «provider.packageName»;

	public class «provider.className»
	{
		private final static String «wsPath.formatWsPath»;

		static
		{
			System.load(N_WS_PATH + "«provider.installPath»/lib«provider.libName».so");
		}

		private long nativeObjectPointer;

		private native long nativeNew();
		private native void nativeDelete(final long nativeObjectPointer);

		public «provider.className»()
		{
			nativeObjectPointer = nativeNew();	
		}

		@Override
		public void finalize()
		{
			nativeDelete(nativeObjectPointer);
		}

		public native void jsonInit(String jsonContent);
		«FOR f : provider.functions»
		public native «FunctionContentProvider.getHeaderContent(f)»;
		«ENDFOR»
	}
	'''

	def getJavaVectorClassContent(DefaultExtensionProvider provider)
	'''
	/* «Utils::doNotEditWarning» */

	package «provider.packageName»;

	public class Vector
	{
		private String name;
		private int size;
		private long nativeObjectPointer;

		private Vector(final int size, final long nativeObjectPointer)
		{
			this.name = "";
			this.size = size;
			this.nativeObjectPointer = nativeObjectPointer;
		}

		private native long nativeNew(final String name, final int size);
		private native void nativeDelete(final long nativeObjectPointer);

		public Vector(final String name, final int size)
		{
			this.name = name;
			this.size = size;
			nativeObjectPointer = nativeNew(name, size);
		}

		public String getName()
		{
			return name;
		}

		public int getSize()
		{
			return size;
		}

		@Override
		public void finalize()
		{
			nativeDelete(nativeObjectPointer);
		}

		public native double getValue(int i);
		public native void setValue(int i, double value);
	}
	'''

	def getJavaMatrixClassContent(DefaultExtensionProvider provider)
	'''
	/* «Utils::doNotEditWarning» */

	package «provider.packageName»;

	public class Matrix
	{
		private String name;
		private int nbRows;
		private int nbCols;
		private long nativeObjectPointer;

		private Matrix(final int nbRows, final int nbCols, final long nativeObjectPointer)
		{
			this.name = "";
			this.nbRows = nbRows;
			this.nbCols = nbCols;
			this.nativeObjectPointer = nativeObjectPointer;
		}

		private native long nativeNew(final String name, final int nbRows, int nbCols);
		private native void nativeDelete(final long nativeObjectPointer);

		public Matrix(final String name, final int nbRows, final int nbCols)
		{
			this.name = name;
			this.nbRows = nbRows;
			this.nbCols = nbCols;
			nativeObjectPointer = nativeNew(name, nbRows, nbCols);
		}

		public String getName()
		{
			return name;
		}

		public int getNbRows()
		{
			return nbRows;
		}

		public int getNbCols()
		{
			return nbCols;
		}

		@Override
		public void finalize()
		{
			nativeDelete(nativeObjectPointer);
		}

		public native double getValue(int i, int j);
		public native void setValue(int i, int j, double value);
	}
	'''

	private def getCMakeFileContent(DefaultExtensionProvider jniProvider, DefaultExtensionProvider cppProvider)
	'''
	«CMakeUtils::getFileHeader(true)»

	«CMakeUtils.checkVariables(true, #['JAVA_HOME'])»

	«CMakeUtils.setVariables(#[], #[cppProvider])»

	«CMakeUtils.addSubDirectories(true, #[cppProvider])»

	# LIBRARY «jniProvider.libName»
	add_library(«jniProvider.libName» SHARED «jniProvider.jniFileName + '.cc'»)
	target_include_directories(«jniProvider.libName»
		PUBLIC ${INCLUDE_DIR}
		PUBLIC ${JAVA_HOME}/include
		PUBLIC ${JAVA_HOME}/include/linux)
	target_link_libraries(«jniProvider.libName» PUBLIC «cppProvider.libName»)

	# GENERATE «jniProvider.jniFileName».h FROM «jniProvider.className».java
	add_custom_command(
		OUTPUT «jniProvider.outputFileList.join(' ')»
		COMMENT "Generate «jniProvider.jniFileName».h from «jniProvider.className».java"
		COMMAND ${JAVA_HOME}/bin/javac -h ${CMAKE_CURRENT_SOURCE_DIR} -d ${CMAKE_CURRENT_BINARY_DIR} ${CMAKE_CURRENT_SOURCE_DIR}/*.java
		DEPENDS ${CMAKE_CURRENT_SOURCE_DIR}/«jniProvider.className».java«IF jniProvider.linearAlgebra» ${CMAKE_CURRENT_SOURCE_DIR}/Vector.java ${CMAKE_CURRENT_SOURCE_DIR}/Matrix.java«ENDIF»)

	# JAR «jniProvider.libName»
	add_custom_target(«jniProvider.libName»jar ALL DEPENDS «jniProvider.libName».jar)
	add_custom_command(
		OUTPUT «jniProvider.libName».jar
		COMMENT "Built «jniProvider.libName».jar"
		WORKING_DIRECTORY ${CMAKE_CURRENT_BINARY_DIR}
		COMMAND ${JAVA_HOME}/bin/jar cvf «jniProvider.libName».jar «jniProvider.packageName»/*.class
		DEPENDS ${CMAKE_CURRENT_SOURCE_DIR}/«jniProvider.jniFileName».h«IF jniProvider.linearAlgebra» ${CMAKE_CURRENT_SOURCE_DIR}/«jniProvider.jniPrefix»Vector.h  ${CMAKE_CURRENT_SOURCE_DIR}/«jniProvider.jniPrefix»Matrix.h«ENDIF»)

	INSTALL(TARGETS «jniProvider.libName» DESTINATION ${CMAKE_CURRENT_SOURCE_DIR}/lib)
	INSTALL(FILES ${CMAKE_CURRENT_BINARY_DIR}/«jniProvider.libName».jar DESTINATION ${CMAKE_CURRENT_SOURCE_DIR}/lib)

	«CMakeUtils.fileFooter»
	'''

	/** Single .cc file to get access to getVector/getMatrix functions */
	private def getCppFacadeClassContent(DefaultExtensionProvider provider)
	'''
	/* «Utils::doNotEditWarning» */

	#include "«provider.jniFileName».h"
	#include "«provider.className».h"
	«IF provider.linearAlgebra»
	#include "«provider.jniPrefix»Vector.h"
	#include "«provider.jniPrefix»Matrix.h"
	#include "Vector.h"
	#include "Matrix.h"
	«ENDIF»

	#ifdef __cplusplus
	extern "C" {
	#endif
	«IF provider.linearAlgebra»

	/********** VECTOR **********/

	«getCppVectorClassContent(provider)»

	/********** MATRIX **********/

	«getCppMatrixClassContent(provider)»
	«ENDIF»

	/********** «provider.className.toUpperCase» **********/

	«getObjectFunctionContent(provider.className)»

	int JNI_OnLoad(JavaVM *vm, void *reserved)
	{
		std::cout << "lib«provider.libName».so loaded" << std::endl;
		return JNI_VERSION_1_1;
	}

	void JNI_OnUnload(JavaVM *vm, void *reserved)
	{
		std::cout << "lib«provider.libName».so unloaded" << std::endl;
	}

	«getNativeNewFunctionContent(provider, provider.className, #[])»

	«getNativeDeleteFunctionContent(provider, provider.className)»

	JNIEXPORT void JNICALL «getJniFunctionName(provider, 'jsonInit')»
	(JNIEnv *env, jobject self, jstring jsonContent)
	{
		«provider.className»* _self = get«provider.className»(env, self);
		const char *nativeJsonContent = env->GetStringUTFChars(jsonContent, 0);
		_self->jsonInit(nativeJsonContent);
		env->ReleaseStringUTFChars(jsonContent, nativeJsonContent);
	}
	«FOR f : provider.functions»

		«jniContentProvider.getJniDefinitionContent(f, provider)»
	«ENDFOR»

	#ifdef __cplusplus
	}
	#endif
	'''

	private def getCppVectorClassContent(DefaultExtensionProvider provider)
	'''
	«getObjectFunctionContent('Vector')»

	static jobject newJavaVector
	(JNIEnv *env, jobject self, Vector* _self)
	{
		jlong cppPtr = reinterpret_cast<jlong>(_self);
		jint size = _self->getSize();

		jclass cls = env->FindClass("«provider.packageName»/Vector");
		if (!cls)
			env->FatalError("FindClass failed");

		jmethodID cid = env->GetMethodID(cls, "<init>", "(IJ)V");
		if (!cid)
			env->FatalError("Cstr failed");

		return env->NewObject(cls, cid, size, cppPtr);
	}

	«getNativeNewFunctionContent(provider, 'Vector', #['size'])»

	«getNativeDeleteFunctionContent(provider, 'Vector')»

	JNIEXPORT jdouble JNICALL «getJniFunctionName(provider, 'Vector', 'getValue')»
	(JNIEnv *env, jobject self, jint i)
	{
		Vector* _self = getVector(env, self);
		return _self->getValue(i);
	}

	JNIEXPORT void JNICALL «getJniFunctionName(provider, 'Vector', 'setValue')»
	(JNIEnv *env, jobject self, jint i, jdouble value)
	{
		Vector* _self = getVector(env, self);
		return _self->setValue(i, value);
	}
	'''

	private def getCppMatrixClassContent(DefaultExtensionProvider provider)
	'''
	«getObjectFunctionContent('Matrix')»

	static jobject newJavaMatrix
	(JNIEnv *env, jobject self, Matrix* _self)
	{
		jlong cppPtr = reinterpret_cast<jlong>(_self);
		jint nbRows = _self->getNbRows();
		jint nbCols = _self->getNbCols();

		jclass cls = env->FindClass("«provider.packageName»/Matrix");
		if (!cls)
			env->FatalError("FindClass failed");

		jmethodID cid = env->GetMethodID(cls, "<init>", "(IIJ)V");
		if (!cid)
			env->FatalError("Cstr failed");

		return env->NewObject(cls, cid, nbRows, nbCols, cppPtr);
	}

	«getNativeNewFunctionContent(provider, 'Matrix', #['nbRows', 'nbCols'])»

	«getNativeDeleteFunctionContent(provider, 'Matrix')»

	JNIEXPORT jdouble JNICALL «getJniFunctionName(provider, 'Matrix', 'getValue')»
	(JNIEnv *env, jobject self, jint i, jint j)
	{
		Matrix* _self = getMatrix(env, self);
		return _self->getValue(i, j);
	}

	JNIEXPORT void JNICALL «getJniFunctionName(provider, 'Matrix', 'setValue')»
	(JNIEnv *env, jobject self, jint i, jint j, jdouble value)
	{
		Matrix* _self = getMatrix(env, self);
		return _self->setValue(i, j, value);
	}
	'''

	private def getOutputFileList(DefaultExtensionProvider it)
	{
		if (linearAlgebra)
			#[
				'${CMAKE_CURRENT_SOURCE_DIR}/' + jniPrefix + 'Vector.h', packageName + '/Vector.class',
				'${CMAKE_CURRENT_SOURCE_DIR}/' + jniPrefix + 'Matrix.h', packageName + '/Matrix.class',
				'${CMAKE_CURRENT_SOURCE_DIR}/' + jniFileName + '.h', packageName + '/' + className + '.class'
			]
		else
			#['${CMAKE_CURRENT_SOURCE_DIR}/' + jniFileName + '.h', packageName + '/' + className + '.class']
	}

	private def getObjectFunctionContent(String objectType)
	'''
	static «objectType»* get«objectType»
	(JNIEnv *env, jobject self)
	{
		jclass cls = env->GetObjectClass(self);
		if (!cls)
			env->FatalError("GetObjectClass failed");

		jfieldID nativeObjectPointerID = env->GetFieldID(cls, "nativeObjectPointer", "J");
		if (!nativeObjectPointerID)
			env->FatalError("GetFieldID failed");

		jlong nativeObjectPointer = env->GetLongField(self, nativeObjectPointerID);
		return reinterpret_cast<«objectType»*>(nativeObjectPointer);
	}
	'''

	private def getNativeNewFunctionContent(DefaultExtensionProvider provider, String objectType, Iterable<String> cstrArgs)
	'''
	JNIEXPORT jlong JNICALL «getJniFunctionName(provider, objectType, 'nativeNew')»
	(JNIEnv *env, jobject self«FOR a : cstrArgs BEFORE ", jstring name"», jint «a»«ENDFOR»)
	{
		«IF !cstrArgs.empty»
		const char *nativeName = env->GetStringUTFChars(name, 0);
		«ENDIF»
		«objectType» *_self = new «objectType»(«FOR a : cstrArgs BEFORE '"nativeName"'», «a»«ENDFOR»);
		«IF !cstrArgs.empty»
		env->ReleaseStringUTFChars(name, nativeName);
		«ENDIF»
		return reinterpret_cast<jlong>(_self);
	}
	'''

	private def getNativeDeleteFunctionContent(DefaultExtensionProvider provider, String objectType)
	'''
	JNIEXPORT void JNICALL «getJniFunctionName(provider, objectType, 'nativeDelete')»
	(JNIEnv *env, jobject self, jlong nativeObjectPointer)
	{
		«objectType»* _self = reinterpret_cast<«objectType»*>(nativeObjectPointer);
		delete _self;
	}
	'''

	private def formatWsPath(String wsPath)
	{
		if (wsPath.startsWith(userDir))
			'''N_WS_PATH = System.getProperty("user.home") + "«wsPath.replace(userDir, "")»"'''
		else
			'''N_WS_PATH = "«wsPath»"'''
	}
}
