#include <rhodes.h>
#include "rubyext/WebView.h"
#include <stdlib.h>
#include "ruby/ext/rho/rhoruby.h"

#include "rhodes/JNIRhoRuby.h"

#include <common/rhoparams.h>
#include "common/RhodesApp.h"

RHO_GLOBAL void JNICALL Java_com_nlist_Nlist_callCallback
(JNIEnv *env, jclass, jstring callback_url, jstring body)
{
    rho_net_request_with_data(
                              RHODESAPP().canonicalizeRhoUrl(rho_cast<std::string>(env, callback_url)).c_str(),
                              rho_cast<std::string>(env, body).c_str());
}



extern "C" void nlist_open_list(rho_param* params_hash, const char* callback) {
    JNIEnv *env = jnienv();
    jclass cls = rho_find_class(env, "com/nlist/Nlist");
    if (!cls) return;

    jobject paramsObj = RhoValueConverter(env).createObject(params_hash);
    jstring objStr = env->NewStringUTF(callback);
    
    jmethodID mid = env->GetStaticMethodID( cls, "openView", "(Ljava/lang/Object;Ljava/lang/String;)V");
    if (!mid) return;
    env->CallStaticVoidMethod(cls, mid, paramsObj, objStr);
    
    env->DeleteLocalRef(objStr);
    env->DeleteLocalRef(paramsObj);
}

extern "C" void nlist_close_list() {
    JNIEnv *env = jnienv();
    jclass cls = rho_find_class(env, "com/nlist/Nlist");
    if (!cls) return;
    jmethodID mid = env->GetStaticMethodID( cls, "closeView", "()V");
    if (!mid) return;
    env->CallStaticVoidMethod(cls, mid);
}
