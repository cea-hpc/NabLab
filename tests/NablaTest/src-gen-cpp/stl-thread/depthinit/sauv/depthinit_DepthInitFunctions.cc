#include "depthinit/depthinit_DepthInitFunctions.h"
#include "depthinit/DepthInitFunctions.h"

#ifdef __cplusplus
extern "C" {
#endif

DepthInitFunctions f;

JNIEXPORT void JNICALL Java_depthinit_DepthInitFunctions_jsonInit
	(JNIEnv *env, jobject o, jstring jsonContent)
{
	std::cout << "coucou 1" << std::endl;
	rapidjson::Document d;
	const char *nativeJsonContent = env->GetStringUTFChars(jsonContent, 0);
	d.Parse<0>(nativeJsonContent);
	env->ReleaseStringUTFChars(jsonContent, nativeJsonContent);
	f.jsonInit(d);
}

JNIEXPORT jdouble JNICALL Java_depthinit_DepthInitFunctions_nextWaveHeight
	(JNIEnv *env, jobject o)
{
	std::cout << "toto 1" << std::endl;
	return f.nextWaveHeight();
}

#ifdef __cplusplus
}
#endif
