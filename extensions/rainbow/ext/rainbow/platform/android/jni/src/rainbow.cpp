#include <rhodes.h>
#include "RhoNativeViewManager.h"

#include <android/log.h>
#include "rubyext/WebView.h"



#include <stdlib.h>

extern "C" jobject JNICALL Java_com_rainbow_Rainbow_getWebViewObject
  (JNIEnv *env, jclass, jint tab_index)
{
    return (jobject)RhoNativeViewManager::getWebViewObject(tab_index);
}

extern "C" void JNICALL Java_com_rainbow_Rainbow_returnToHTML
(JNIEnv *env, jclass)
{
	rho_webview_navigate("/app/NativeView/goto_html", 0);	
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



/*
in Java class com.rainbow.Rainbow :
public static View makeNativeView()
public static void navigateInNativeView(View view, String command)
public static void destroyNativeView(View view)
*/



class RainbowNativeView : public NativeView {
public:
	RainbowNativeView() {
		mView = 0;
	}
	virtual ~RainbowNativeView() {
		if (mView != 0) {
			// destroy
			JNIEnv *env = jnienv();
			jclass cls = rho_find_class(env, "com/rainbow/Rainbow");
			if (!cls) return;
			jmethodID mid = env->GetStaticMethodID( cls, "destroyNativeView", "(Landroid/view/View;)V");
			if (!mid) return;
			env->CallStaticVoidMethod(cls, mid, mView);
			mView = NULL;
		}
	}

	virtual void* getView() {
		//rainbow_open_native_view();
		if (mView == 0) {
			// create
			JNIEnv *env = jnienv();
			jclass cls = rho_find_class(env, "com/rainbow/Rainbow");
			if (!cls) return NULL;
			jmethodID mid = env->GetStaticMethodID( cls, "makeNativeView", "()Landroid/view/View;");
			if (!mid) return NULL;
			mView = env->CallStaticObjectMethod(cls, mid);
		}
		return mView;
	}

	virtual void navigate(const char* url) {
		// navigate
		JNIEnv *env = jnienv();
		jclass cls = rho_find_class(env, "com/rainbow/Rainbow");
		if (!cls) return;
		jmethodID mid = env->GetStaticMethodID( cls, "navigateInNativeView", "(Landroid/view/View;Ljava/lang/String;)V");
		if (!mid) return;
		jstring objCommand = rho_cast<jstring>(url);
		env->CallStaticVoidMethod(cls, mid, mView, objCommand);
		env->DeleteLocalRef(objCommand);
	}

private:
	jobject mView;
};

class RainbowNativeViewFactory;

static RainbowNativeViewFactory* ourFactory = NULL;

class RainbowNativeViewFactory : public NativeViewFactory {
public:

	virtual NativeView* getNativeView(const char* viewType) {
		return new RainbowNativeView();
	}

	virtual void destroyNativeView(NativeView* nativeView) {
		delete nativeView;
	}

	static RainbowNativeViewFactory* instance() {
		if (ourFactory == NULL) {
			ourFactory = new RainbowNativeViewFactory();
		}
		return ourFactory;
	}

};









extern "C" void Init_RainbowRuby(void);	

extern "C" void Init_Rainbow() {
	Init_RainbowRuby();
	RhoNativeViewManager::registerViewType("rainbow_view", RainbowNativeViewFactory::instance());
};

