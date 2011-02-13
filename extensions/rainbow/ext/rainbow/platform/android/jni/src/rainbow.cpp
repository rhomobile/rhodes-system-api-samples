#include <rhodes.h>
#include "RhoNativeViewManager.h"

#include <android/log.h>
#include "rubyext/WebView.h"



#include <stdlib.h>

#define logging_enable false


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
    jstring objCommand = env->NewStringUTF(command);//rho_cast<jstring>(command);
    env->CallStaticVoidMethod(cls, mid, objCommand);
    env->DeleteLocalRef(objCommand);
}




class RainbowNativeView : public NativeView {
public:
	RainbowNativeView() {
		mView = -1;
	}
	virtual ~RainbowNativeView() {
		if (mView >= 0) {
			// destroy
			if (logging_enable) __android_log_write(ANDROID_LOG_INFO, "Rainbow", "~RainbowNativeView() START");
			JNIEnv *env = jnienv();
			jclass cls = env->FindClass("com/rainbow/Rainbow");//rho_find_class(env, "com/rainbow/Rainbow");
			if (!cls) return;
			jmethodID mid = env->GetStaticMethodID( cls, "destroyNativeView", "(I)V");
			if (!mid) return;

			if (logging_enable) {
				char ttt[256];
				sprintf(ttt, "mView = %X", (unsigned int)mView);
				__android_log_write(ANDROID_LOG_INFO, "Rainbow", ttt);
			}

			env->CallStaticVoidMethod(cls, mid, mView);
			mView = NULL;
			if (logging_enable) __android_log_write(ANDROID_LOG_INFO, "Rainbow", "~RainbowNativeView() FINISH");
		}
	}

	virtual void* getView() {
		if (logging_enable) __android_log_write(ANDROID_LOG_INFO, "Rainbow", "NativeView::getView() START");
		//rainbow_open_native_view();
		if (mView < 0) {
			if (logging_enable) __android_log_write(ANDROID_LOG_INFO, "Rainbow", "NativeView::getView() view should be create");
			// create
			JNIEnv *env = jnienv();
			jclass cls = env->FindClass("com/rainbow/Rainbow");//rho_find_class(env, "com/rainbow/Rainbow");
			if (!cls) {
				if (logging_enable) __android_log_write(ANDROID_LOG_INFO, "Rainbow", "Can not found com/rainbow/Rainbow class !!!");
				return NULL;
			}
			if (logging_enable) __android_log_write(ANDROID_LOG_INFO, "Rainbow", "NativeView::getView() Rainbow class founded");
			jmethodID mid = env->GetStaticMethodID( cls, "makeNativeView", "()I");
			if (!mid) return NULL;
			if (logging_enable) __android_log_write(ANDROID_LOG_INFO, "Rainbow", "NativeView::getView() makeNativeView founded");
			mView = env->CallStaticIntMethod(cls, mid);
			if (mView < 0) {
				if (logging_enable) __android_log_write(ANDROID_LOG_INFO, "Rainbow", "Rainbow native view not created !!!");
			}
			else {
				__android_log_write(ANDROID_LOG_INFO, "Rainbow", "Rainbow native view created OK !!!");
			}
		}
		if (logging_enable) {
			char ttt[256];
			sprintf(ttt, "mView = %X", (unsigned int)mView);
			__android_log_write(ANDROID_LOG_INFO, "Rainbow", ttt);
		}
		if (logging_enable) __android_log_write(ANDROID_LOG_INFO, "Rainbow", "NativeView::getView() FINISH");
		return getViewByID(mView);
	}

	virtual void navigate(const char* url) {
		// navigate
		if (mView >= 0) {
			if (logging_enable) {
				char ttt[256];
				sprintf(ttt, "navigate(%s)", url);
				__android_log_write(ANDROID_LOG_INFO, "Rainbow", ttt);
			}
			JNIEnv *env = jnienv();
			jclass cls = env->FindClass("com/rainbow/Rainbow");//rho_find_class(env, "com/rainbow/Rainbow");
			if (!cls) {
				if (logging_enable) __android_log_write(ANDROID_LOG_INFO, "Rainbow", "Can not found com/rainbow/Rainbow class. !!!");
				return;
			}
			jmethodID mid = env->GetStaticMethodID( cls, "navigateInNativeView", "(ILjava/lang/String;)V");
			if (!mid) return;
			jstring objCommand = env->NewStringUTF(url);//rho_cast<jstring>("red");//rho_cast<jstring>(url);
			__android_log_write(ANDROID_LOG_INFO, "Rainbow", "call java navigate in view ");
			if (logging_enable) {
				char ttt[256];
				sprintf(ttt, "mView = %X", (unsigned int)mView);
				__android_log_write(ANDROID_LOG_INFO, "Rainbow", ttt);
			}
			if (objCommand == NULL) {
				if (logging_enable) __android_log_write(ANDROID_LOG_INFO, "Rainbow", "objCommand == NULL !!!");
			}
			env->CallStaticVoidMethod(cls, mid, mView, objCommand);
			env->DeleteLocalRef(objCommand);
		}
		else {
			if (logging_enable) __android_log_write(ANDROID_LOG_INFO, "Rainbow", "navigate with NULL view !!!");
		}
	}

private:
        jobject getViewByID(int id) {   //getViewById
		if (logging_enable) __android_log_write(ANDROID_LOG_INFO, "Rainbow", "NativeView::getViewByID START");
		JNIEnv *env = jnienv();
		jclass cls = env->FindClass("com/rainbow/Rainbow");//rho_find_class(env, "com/rainbow/Rainbow");
		if (!cls) {
			if (logging_enable) __android_log_write(ANDROID_LOG_INFO, "Rainbow", "Can not found com/rainbow/Rainbow class. !!!");
			return NULL;
		}
		jmethodID mid = env->GetStaticMethodID( cls, "getViewById", "(I)Landroid/view/View;");
		if (!mid) return NULL;
		jobject view = env->CallStaticObjectMethod(cls, mid, id);
		if (view == NULL) {
			if (logging_enable) __android_log_write(ANDROID_LOG_INFO, "Rainbow", "not found jobject view !!!");
		}
		if (logging_enable) __android_log_write(ANDROID_LOG_INFO, "Rainbow", "NativeView::getViewByID FINISH");
		return view;

	}

private:

	int mView;
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

