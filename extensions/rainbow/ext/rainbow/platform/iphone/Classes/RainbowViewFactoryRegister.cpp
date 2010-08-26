
// rhodes/platform/iphone/Classes/RhoNativeViewManager.h
#include "RhoNativeViewManager.h"

#include "RainbowViewFactory.h"

extern "C"
{

void Init_Rainbow() {
    NativeViewFactory* factory = RainbowViewFactorySingletone::instance();
    RhoNativeViewManager::registerViewType("rainbow_view", factory);
};
	
}
