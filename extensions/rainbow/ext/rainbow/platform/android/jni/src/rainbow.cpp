#include <rhodes.h>
#include "RhoNativeViewManager.h"

#include <android/log.h>



#include <stdlib.h>

extern "C" jobject JNICALL Java_com_rainbow_Rainbow_getWebViewObject
  (JNIEnv *env, jclass, jint tab_index)
{
    return (jobject)RhoNativeViewManager::getWebViewObject(tab_index);
}


extern "C" void rainbow_open_native_view() {

    JNIEnv *env = jnienv();
    jclass cls = rho_find_class(env, "com/rainbow/Rainbow");
    if (!cls) return;
    jmethodID mid = env->GetStaticMethodID( cls, "openNativeView", "()V");
    if (!mid) return;
    env->CallStaticVoidMethod(cls, mid);
}

extern "C" void rainbow_close_native_view() {
    JNIEnv *env = jnienv();
    jclass cls = rho_find_class(env, "com/rainbow/Rainbow");
    if (!cls) return;
    jmethodID mid = env->GetStaticMethodID( cls, "closeNativeView", "()V");
    if (!mid) return;
    env->CallStaticVoidMethod(cls, mid);
}

extern "C" void rainbow_execute_command_in_native_view(const char* command) {
    JNIEnv *env = jnienv();
    jclass cls = rho_find_class(env, "com/rainbow/Rainbow");
    if (!cls) return;
    jmethodID mid = env->GetStaticMethodID( cls, "executeCommandInNativeView", "(Ljava/lang/String;)V");
    if (!mid) return;
    jstring objCommand = rho_cast<jstring>(command);
    env->CallStaticVoidMethod(cls, mid, objCommand);
    env->DeleteLocalRef(objCommand);
}
