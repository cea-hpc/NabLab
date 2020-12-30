/*** GENERATED FILE - DO NOT OVERWRITE ***/

#include "batilib_BatiLib.h"
#include "batilib/BatiLib.h"

#ifdef __cplusplus
extern "C" {
#endif

JNIEXPORT jlong JNICALL Java_batilib_BatiLib_nativeNew
(JNIEnv *env, jobject self)
{
	// Here we allocate our new object and return
	// its pointer casted as a jlong;
	batilib::BatiLib *o = new batilib::BatiLib();
	return reinterpret_cast<jlong>(o);
}

// This function is a helper providing the boiler
// plate code to return the native object from
// Java object. The "nativeObjectPointer" is reached
// from this code, casted to People's pointer and
// returned. This will be used in all our native
// methods wrappers to recover the object before
// invoking it's methods.
static batilib::BatiLib* getObject
(JNIEnv *env, jobject self)
{
	jclass cls = env->GetObjectClass(self);
	if (!cls)
		env->FatalError("GetObjectClass failed");

	jfieldID nativeObjectPointerID = env->GetFieldID(cls, "nativeObjectPointer", "J");
	if (!nativeObjectPointerID)
		env->FatalError("GetFieldID failed");

	jlong nativeObjectPointer = env->GetLongField(self, nativeObjectPointerID);
	return reinterpret_cast<batilib::BatiLib*>(nativeObjectPointer);
}

// Here is our native methods wrappers, we simply recover
// native BatiLib's instance invoke the requested method
// and return its return value. jint can be casted to
// Java's int. The string is a case apart. Since String
// is an object and not a primitive type we have to
// return it as reference (not by value). This is safe
// since, as a Java String object the JVM can deallocate
// it when is not being used anymore.
JNIEXPORT void JNICALL Java_batilib_BatiLib_jsonInit
(JNIEnv *env, jobject self, jstring jsonContent)
{
	batilib::BatiLib* _self = getObject(env, self);
	const char *nativeJsonContent = env->GetStringUTFChars(jsonContent, 0);
	_self->jsonInit(nativeJsonContent);
	env->ReleaseStringUTFChars(jsonContent, nativeJsonContent);
}

JNIEXPORT jdouble JNICALL Java_batilib_BatiLib_nextWaveHeight
(JNIEnv *env, jobject self)
{
	batilib::BatiLib* _self = getObject(env, self);
	// native method call
	auto c_ret = _self->nextWaveHeight();
	// c_ret to ret
	jdouble ret = c_ret;
	return ret;
}

JNIEXPORT jdouble JNICALL Java_batilib_BatiLib_nextDepth1
(JNIEnv *env, jobject self, jdouble x0, jdoubleArray x1)
{
	batilib::BatiLib* _self = getObject(env, self);
	// x0 to c_x0
	double c_x0 = x0;
	// x1 to c_x1
	RealArray1D<0> c_x1;
	jsize x1_size = env->GetArrayLength(x1);
	c_x1.resize(x1_size);
	jdouble* x1_body = env->GetDoubleArrayElements(x1, JNI_FALSE);
	for (jsize i0=0; i0<x1_size; i0++)
		c_x1[i0] = x1_body[i0];
	env->ReleaseDoubleArrayElements(x1, x1_body, JNI_FALSE);
	// native method call
	auto c_ret = _self->nextDepth1(c_x0, c_x1);
	// c_ret to ret
	jdouble ret = c_ret;
	return ret;
}

JNIEXPORT jdouble JNICALL Java_batilib_BatiLib_nextDepth2
(JNIEnv *env, jobject self, jdouble x0, jobjectArray x1)
{
	batilib::BatiLib* _self = getObject(env, self);
	// x0 to c_x0
	double c_x0 = x0;
	// x1 to c_x1
	RealArray2D<0,0> c_x1;
	jsize x1_size = env->GetArrayLength(x1);
	c_x1.resize(x1_size);
	for (jsize i1=0; i1<x1_size; i1++)
	{
		auto x1_i0 = reinterpret_cast<jdoubleArray>(env->GetObjectArrayElement(x1, i1));
		jsize x1_i0_size = env->GetArrayLength(x1_i0);
		c_x1[i1].resize(x1_i0_size);
		jdouble* x1_i0_body = env->GetDoubleArrayElements(x1_i0, JNI_FALSE);
		for (jsize i0=0; i0<x1_i0_size; i0++)
			c_x1[i1][i0] = x1_i0_body[i0];
		env->ReleaseDoubleArrayElements(x1_i0, x1_i0_body, JNI_FALSE);
		env->DeleteLocalRef(x1_i0);
	}
	// native method call
	auto c_ret = _self->nextDepth2(c_x0, c_x1);
	// c_ret to ret
	jdouble ret = c_ret;
	return ret;
}

JNIEXPORT jdoubleArray JNICALL Java_batilib_BatiLib_nextDepth3
(JNIEnv *env, jobject self, jdoubleArray x0)
{
	batilib::BatiLib* _self = getObject(env, self);
	// x0 to c_x0
	RealArray1D<0> c_x0;
	jsize x0_size = env->GetArrayLength(x0);
	c_x0.resize(x0_size);
	jdouble* x0_body = env->GetDoubleArrayElements(x0, JNI_FALSE);
	for (jsize i0=0; i0<x0_size; i0++)
		c_x0[i0] = x0_body[i0];
	env->ReleaseDoubleArrayElements(x0, x0_body, JNI_FALSE);
	// native method call
	auto c_ret = _self->nextDepth3(c_x0);
	// c_ret to ret
	size_t s = c_ret.size();
	jdoubleArray ret = env->NewDoubleArray(s);
	if (ret == NULL) return NULL;
	jdouble* tmp = new jdouble[s];
	for (size_t i0=0; i0<s; i0++)
		tmp[i0] = c_ret[i0];
	env->SetDoubleArrayRegion(ret, 0, s, tmp);
	delete tmp;
	return ret;
}

JNIEXPORT jobjectArray JNICALL Java_batilib_BatiLib_nextDepth4
(JNIEnv *env, jobject self, jobjectArray x0)
{
	batilib::BatiLib* _self = getObject(env, self);
	// x0 to c_x0
	RealArray2D<0,0> c_x0;
	jsize x0_size = env->GetArrayLength(x0);
	c_x0.resize(x0_size);
	for (jsize i1=0; i1<x0_size; i1++)
	{
		auto x0_i0 = reinterpret_cast<jdoubleArray>(env->GetObjectArrayElement(x0, i1));
		jsize x0_i0_size = env->GetArrayLength(x0_i0);
		c_x0[i1].resize(x0_i0_size);
		jdouble* x0_i0_body = env->GetDoubleArrayElements(x0_i0, JNI_FALSE);
		for (jsize i0=0; i0<x0_i0_size; i0++)
			c_x0[i1][i0] = x0_i0_body[i0];
		env->ReleaseDoubleArrayElements(x0_i0, x0_i0_body, JNI_FALSE);
		env->DeleteLocalRef(x0_i0);
	}
	// native method call
	auto c_ret = _self->nextDepth4(c_x0);
	// c_ret to ret
	jclass ret_inner_class = env->FindClass("[Ljava/lang/Double");
	if (ret_inner_class == NULL) return NULL;
	jobjectArray ret = env->NewObjectArray(c_ret.size(), ret_inner_class, NULL);
	if (ret == NULL) return NULL;
	for (size_t i1=0; i1<c_ret.size(); i1++)
	{
		size_t s = c_ret[i1].size();
		jdoubleArray ret_i0 = env->NewDoubleArray(s);
		if (ret_i0 == NULL) return NULL;
		jdouble* tmp = new jdouble[s];
		for (size_t i0=0; i0<s; i0++)
			tmp[i0] = c_ret[i1][i0];
		env->SetDoubleArrayRegion(ret_i0, 0, s, tmp);
		delete tmp;
		env->SetObjectArrayElement(ret, i1, ret_i0);
		env->DeleteLocalRef(ret_i0);
	}
	return ret;
}

#ifdef __cplusplus
}
#endif
