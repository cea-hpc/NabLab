/*******************************************************************************
 * Copyright (c) 2020 CEA
 * This program and the accompanying materials are made available under the
 * terms of the Eclipse Public License 2.0 which is available at
 * http://www.eclipse.org/legal/epl-2.0.
 *
 * SPDX-License-Identifier: EPL-2.0
 * Contributors: see AUTHORS file
 *******************************************************************************/
#include "waveheight_WaveHeightJni.h"
#include "waveheight/WaveHeight.h"

#ifdef __cplusplus
extern "C" {
#endif


extern "C"
JNIEXPORT jlong JNICALL Java_waveheight_WaveHeightJni_nativeNew
(JNIEnv *env, jobject self)
{
	// Here we allocate our new object and return
	// its pointer casted as a jlong;
	waveheight::WaveHeight *wh = new waveheight::WaveHeight();
	return reinterpret_cast<jlong>(wh);
}

// This function is a helper providing the boiler
// plate code to return the native object from
// Java object. The "nativeObjectPointer" is reached
// from this code, casted to People's pointer and
// returned. This will be used in all our native
// methods wrappers to recover the object before
// invoking it's methods.
static waveheight::WaveHeight* getObject
(JNIEnv *env, jobject self)
{
	jclass cls = env->GetObjectClass(self);
	if (!cls)
		env->FatalError("GetObjectClass failed");

	jfieldID nativeObjectPointerID = env->GetFieldID(cls, "nativeObjectPointer", "J");
	if (!nativeObjectPointerID)
		env->FatalError("GetFieldID failed");

	jlong nativeObjectPointer = env->GetLongField(self, nativeObjectPointerID);
	return reinterpret_cast<waveheight::WaveHeight*>(nativeObjectPointer);
}

// Here is our native methods wrappers, we simply recover
// native WaveHeight's instance invoke the requested method
// and return its return value. jint can be casted to
// Java's int. The string is a case apart. Since String
// is an object and not a primitive type we have to
// return it as reference (not by value). This is safe
// since, as a Java String object the JVM can deallocate
// it when is not being used anymore.
extern "C"
JNIEXPORT void JNICALL Java_waveheight_WaveHeightJni_jsonInit
(JNIEnv *env, jobject self, jstring jsonContent)
{
	waveheight::WaveHeight* _self = getObject(env, self);
	const char *nativeJsonContent = env->GetStringUTFChars(jsonContent, 0);
	_self->jsonInit(nativeJsonContent);
	env->ReleaseStringUTFChars(jsonContent, nativeJsonContent);
}

extern "C"
JNIEXPORT jdouble JNICALL Java_waveheight_WaveHeightJni_nextWaveHeight
(JNIEnv *env, jobject self)
{
	waveheight::WaveHeight* _self = getObject(env, self);
	return _self->nextWaveHeight();
}

#ifdef __cplusplus
}
#endif
