
#import <UIKit/UIKit.h>
#import "RainbowView.h"

#import "RainbowViewFactory.h"

#import <strings.h>


class RainbowNativeView : public NativeView {
public:
	RainbowNativeView() {
		mView = [[RainbowView alloc] init];
	}
	virtual ~RainbowNativeView() {
		[mView release];
		mView = nil;
	}
	
	virtual UIView* getView() {
		return mView;
	}
	
	virtual void navigate(const char* url) {
		[mView navigate:url];
	}
private:
	RainbowView* mView;
};



class RainbowNativeViewFactory : public NativeViewFactory {
public:
	
	virtual NativeView* getNativeView(const char* viewType) {
		return new RainbowNativeView();
	}
	
	virtual void destroyNativeView(NativeView* nativeView) {
		delete nativeView;
	}
	
};

static RainbowNativeViewFactory* ourFactory = NULL; 

NativeViewFactory* RainbowViewFactorySingletone::instance() {
	if (ourFactory == NULL) {
		ourFactory = new RainbowNativeViewFactory();
	}
	return ourFactory;
}
